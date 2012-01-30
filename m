Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752541Ab2A3Q1d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 11:27:33 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:51924 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751551Ab2A3Q1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 11:27:31 -0500
MIME-Version: 1.0
In-Reply-To: <20120129185949.GA27192@redhat.com>
References: <20120117174031.3118.E1E9C6FF@jp.fujitsu.com> <tip-b5740f4b2cb3503b436925eb2242bc3d75cd3dfe@git.kernel.org>
 <CA+55aFyO0KxGQxYYUqmVrNqG6qVFnRT2g-kYYKtH5QG3vTnO=A@mail.gmail.com>
 <20120129160711.GA20803@redhat.com> <CA+55aFz20=H0ZubZEAmEbv0gL8j3C5Kgt4m2+5MU63uVipZt0Q@mail.gmail.com>
 <20120129185949.GA27192@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 30 Jan 2012 08:27:11 -0800
X-Google-Sender-Auth: cVZBxBiJf8NtbT57YEtISrjjoh8
Message-ID: <CA+55aFzavWN3gGSRtd3Lp6mzY4ndg1af4DhXy1QOCy4HQ8CA9w@mail.gmail.com>
Subject: Re: [tip:sched/core] sched: Fix ancient race in do_exit()
To: Oleg Nesterov <oleg@redhat.com>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, y-goto@jp.fujitsu.com,
        akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu,
        linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 29, 2012 at 10:59 AM, Oleg Nesterov <oleg@redhat.com> wrote:
>
> If we remove set_task_state() from the main waiting loop we can never race
> with __rwsem_do_wake()->try_to_wake_up() seeing us in UNINTERRUPTIBLE state.
> rwsem_down_failed_common() simply can't return until UNINTERRUPTIBLE->RUNNING
> transition is finished (__rwsem_do_wake does wakeup first).
>
> And since we do not play with current->state after spin_unlock(), it is
> fine to "race" with waiter->task clearing, just we can do the unnecessary
> but harmless schedule() in TASK_RUNNING.

So the more I think about this code, the more nervous I get.

I did a version that got the sem->wait_lock if it hit the race case
("task" still non-NULL after the schedule), and I could convince
myself that it was race-free and safe. But I couldn't actually really
convince myself that it was better than the old code, because I worry
that we'd actually hit that case much too often (ie another CPU woke
us up, but hasn't cleared "task" yet, so spin on the spinlock etc).

So I do hate the bug in rwsem, but I'm now willing to entertain the
possibility that the bug actually means that unlocking of an rwsem is
"nicely decoupled" from the process that got the semaphore, and may be
a performance advantage.

To be honest, I don't *really* believe that, but changing the rwsem.c
code at this point just scares me enough that without lots and lots of
people looking at it and actually doing some performance analysis, I'm
willing to just say "screw it, I'll take Yasunori Goto's solution".

I'm definitely still not a huge fan of that patch, but I'm not a huge
fan of the alternative either. So Ack on the patch, and I'll just try
to think about this all some more.

                         Linus
