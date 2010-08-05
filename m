Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759765Ab0HEHTi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 03:19:38 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:48124 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758296Ab0HEHTf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 03:19:35 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH 2/2] CRED: Fix __task_cred()'s lockdep check and banner  comment
References: <20100729114549.29508.44899.stgit@warthog.procyon.org.uk>
	<20100729114555.29508.4525.stgit@warthog.procyon.org.uk>
	<20100802204000.GH2405@linux.vnet.ibm.com>
	<201008030055.o730tgXK091413@www262.sakura.ne.jp>
	<30552.1280828047@redhat.com>
	<AANLkTikwM0+cxJqgQ+N_svzyyc+FKreO8XPr8oYNh6OU@mail.gmail.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Thu, 05 Aug 2010 00:19:25 -0700
In-Reply-To: <AANLkTikwM0+cxJqgQ+N_svzyyc+FKreO8XPr8oYNh6OU@mail.gmail.com> (Linus Torvalds's message of "Tue\, 3 Aug 2010 09\:07\:55 -0700")
Message-ID: <m1d3txzfuq.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=67.188.4.80;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.188.4.80
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> Added Oleg and Thomas to the participants.
>
> Oleg/Thomas: the whole thread is on lkml, but I'm quoting most of the
> relevant parts..
>
> On Tue, Aug 3, 2010 at 2:34 AM, David Howells <dhowells@redhat.com> wrote:
>>
>> A previous patch:
>>
>>        commit 8f92054e7ca1d3a3ae50fb42d2253ac8730d9b2a
>>        Author: David Howells <dhowells@redhat.com>
>>        Date:   Thu Jul 29 12:45:55 2010 +0100
>>        Subject: CRED: Fix __task_cred()'s lockdep check and banner comment
>>
>> fixed the lockdep checks on __task_cred().  This has shown up a place in the
>> signalling code where a lock should be held - namely that
>> check_kill_permission() requires its callers to hold the RCU lock.
>
> It's not just check_kill_permission(), is it? I thought we could do
> the "for_each_process()" loops with just RCU, rather than holding the
> whole tasklist_lock? So I _think_ that getting the RCU read-lock would
> make it possible to get rid of the tasklist_lock in there too? At
> least in kill_something_info().
>
> Yes/no? What am I missing? This is an Oleg question, mainly.

No.  When we send a signal to multiple processes it needs to be an
atomic operation so that kill -KILL -pgrp won't let processes escape.
It is what posix specifies, it is what real programs expect, and it
is the useful semantic in userspace.

Just using rcu_read_lock() breaks that atomicity of sending a signal
to a process group, which means we can have new processes that escape
the signal.  Even with the tasklist_lock we have to have a special
case in fork to ensure we don't add a process to a process group
while a signal is being delivered to it.

I have scratched my head a few times wondering if there is a way to
preserve the atomic guarantee without taking a global lock, but I
haven't found one I can wrap my head around yet.

>>        success = 0;
>>        retval = -ESRCH;
>> +       rcu_read_lock();
>>        do_each_pid_task(pgrp, PIDTYPE_PGID, p) {
>>                int err = group_send_sig_info(sig, info, p);
>>                success |= !err;
>>                retval = err;
>>        } while_each_pid_task(pgrp, PIDTYPE_PGID, p);
>> +       rcu_read_unlock();
>
> Ok, makes sense. At the same time, I do wonder if we shouldn't perhaps
> do this in the caller. The callers would seem to all want it - look at
> kill_something_info(), for example, where it really looks like it
> would be nicer to put that _whole_ function under rcu_read_lock() (in
> the caller itself). Or in kernel/exit.c, we have two calls
> back-to-back, so doing it in the caller would clean that up and do it
> just once.

Likely.  At one point read_lock(&tasklist_lock) implied having the
rcu_read_lock().  As it no longer does in some cases we have a small
pile of places with outdated assumptions.  I know I have been guilty a
few times of forgetting about the new rule that we have to take rcu_read_lock()
everywhere.

> Look here:
>
>> @@ -1261,6 +1263,7 @@ static int kill_something_info(int sig, struct siginfo *info, pid_t pid)
>>                int retval = 0, count = 0;
>>                struct task_struct * p;
>>
>> +               rcu_read_lock();
>>                for_each_process(p) {
>>                        if (task_pid_vnr(p) > 1 &&
>>                                        !same_thread_group(p, current)) {
>> @@ -1270,6 +1273,7 @@ static int kill_something_info(int sig, struct siginfo *info, pid_t pid)
>>                                        retval = err;
>>                        }
>>                }
>> +               rcu_read_unlock();
>>                ret = count ? retval : -ESRCH;
>>        }
>>        read_unlock(&tasklist_lock);
>
> with those fragments, we now end up having rcu_read_lock() for _all_
> the three cases in kill_something_info(), but rather than do it once,
> we do it explicitly, and we do it in two different ways (two cases do
> it explicitly, the middle one does it implicitly when it calls
> __kill_pgrp_info().
>
> So I think the patch is correct, but at the same time I do get the
> feeling that we should just do it slightly differently.
>
> Comments?

With the tasklist_lock the rule in these functions is that the caller
will take the lock, so we probably make the rule the caller should
take the lock in the same scenarios for the rcu_read_lock(). Aka just
say:

read_lock(&tasklist_lock);
rcu_read_lock();

everywhere, that today we say just:

read_lock(&tasklist_lock);

It is what was meant when the code was written and the rcu-ized, and
it will certainly preserve my human intuition and general practical
reality that when you have the tasklist_lock you have the
rcu_read_lock.

*Shrug*  I don't think it matters a whole lot.

Eric
