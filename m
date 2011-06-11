Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758561Ab1FKOhW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jun 2011 10:37:22 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:42321 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757689Ab1FKOhS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jun 2011 10:37:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Ft73eG7DmSQrB82GZrOnu1uDnDHh7i6m50OY2Ay+JNwA3t1fAN5zO+XooY1lbi+WiO
         +Mef0L5G/UDADrU1BHpjn1DqJ38pus6VycsueGMOYdPW9Em9C4Tk2SiWy2Qvvn+BhLrh
         re286pl96OfTO6Ru/8qisrB1q1J/Q6+0XplSY=
MIME-Version: 1.0
In-Reply-To: <1307545036.9218.36.camel@gandalf.stny.rr.com>
References: <BANLkTim9cr6H9fTik8-yQ4E0j1yFAOt-7g@mail.gmail.com>
	<20110608125855.GE27245@home.goodmis.org>
	<BANLkTi=0hmKeg_dj-x4osX3N_b-cKjyqcw@mail.gmail.com>
	<1307545036.9218.36.camel@gandalf.stny.rr.com>
Date: Sat, 11 Jun 2011 22:37:16 +0800
Message-ID: <BANLkTi=_k25Hqj0Q+vydVQhqR9d0kBm8MQ@mail.gmail.com>
Subject: Re: [PATCH] sched: remove unreliable pointer in mutex_spin_on_owner()
From: Hillf Danton <dhillf@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 8, 2011 at 10:57 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Wed, 2011-06-08 at 21:28 +0800, Hillf Danton wrote:
>
>> > We don't want to spin if the owner of the lock sleeps. If it sleeps,
>> > then the owner's on_cpu will be zero. That's the point of checking it.
>> >
>> not understand the point of checking owner->on_cpu, and the code's
>> icy beauty blows me down again.
>
> It's better to ask these questions than to send patches. You can send
> code changes like below, with a question. But avoid official patches if
> you don't understand why the code does what it does. An official patch
> (with [PATCH] in subject and a Signed-off-by) states that you basically
> know what you are doing, and it will frustrate maintainers if you do
> not.
>
> Now, I'll explain the owner->on_cpu.
>
> When a task is running, it's on_cpu (in task_struct) is set to 1. When
> it is scheduled away, it is zero. This is important.
>
> A mutex is a lock that a task will schedule out in a sleep state if
> there's contention. And the owner will wake up that task when it
> releases the lock. This is the basic method of mutexes. But the problem
> is, it can be very expensive, especially, if the mutexes are held for a
> short period of time.
>
> What happens then, is when there is contention, a process will start to
> schedule out, and then be woken up again. But we already went into the
> scheduler, and may have even scheduled another task. This can be very
> expensive, especially if we flush the TLB in the mean time.
>
> What this code does is to try not to sleep. But we need to very careful
> in doing this, because the code that uses the mutex expects that this
> may sleep. So, instead of just scheduling away when there's contention,
> the task checks if the owner is running on another CPU. If it is, then
> there's a good chance that it will soon release the mutex and we can
> grab it. Instead of scheduling away, this task now waits and spins,
> waiting for the owner to release the mutex. This now acts like the more
> efficient (but limited) spin locks.
>
> Because we are now spinning, we must be very careful, as the code that
> uses the mutex is not made to handle spinners. The spinning must stop
> under certain circumstances. One is, if the task that is spinning should
> give up the CPU (which is why we check NEED_RESCEHD for current).
>
> The other time to stop spinning is if the owner of the mutex is no
> longer running on the CPU. That is, the owner scheduled away. If the
> owner scheduled away, then there's no reason to spin anymore, and it
> will be better schedule away the task instead. Why spin? The owner may
> not wake up for a long time. No need to wait anymore.
>
> Got it?
>

Got, a lot thanks.

Unlike spinner and owner that are well considered, there are waiters, please
see the following homework.

Another question about CONFIG_MUTEX_SPIN_ON_OWNER, from the view angle of
spinners, as you mentioned above, looks like that they are crowding on a bus
as violently as they could, in contrast to the Japanese people in earthquake.

Then the result could be, out of our image, not as optimistic as it is, since
a thread of lower priority could out-compete another of higher priority,
when a bunch of spinners are simultaneously trying hard to acquire the mutex,
though only one is allowed to get award.

thanks   /Hillf
---
 kernel/mutex.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/kernel/mutex.c b/kernel/mutex.c
index d607ed5..3a5606c 100644
--- a/kernel/mutex.c
+++ b/kernel/mutex.c
@@ -162,6 +162,10 @@ __mutex_lock_common(struct mutex *lock, long
state, unsigned int subclass,
 	for (;;) {
 		struct task_struct *owner;

+		/* skip over spin if there are pending waiters */
+		if (atomic_cmpxchg(&lock->count, -1, -1) == -1)
+			break;
+
 		/*
 		 * If there's an owner, wait for it to either
 		 * release the lock or go to sleep.
