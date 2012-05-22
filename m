Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932669Ab2EVAQy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 20:16:54 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:57746 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932093Ab2EVAQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 20:16:52 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Louis Rilling <louis.rilling@kerlabs.com>,
        Mike Galbraith <efault@gmx.de>
In-Reply-To: <20120521124414.GA20391@redhat.com> (Oleg Nesterov's message of
	"Mon, 21 May 2012 14:44:14 +0200")
References: <m1zk9rmyh4.fsf@fess.ebiederm.org>
	<20120501134214.f6b44f4a.akpm@linux-foundation.org>
	<87havs7rvv.fsf_-_@xmission.com> <8762c87rrd.fsf_-_@xmission.com>
	<20120516183920.GA19975@redhat.com> <878vgrsv7q.fsf@xmission.com>
	<20120517170015.GA12436@redhat.com> <87d3628oqa.fsf@xmission.com>
	<20120518123911.GA417@redhat.com> <87zk95kper.fsf@xmission.com>
	<20120521124414.GA20391@redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
Date: Mon, 21 May 2012 18:16:37 -0600
Message-ID: <87ipfp5au2.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=208.38.5.102;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19uOFW6bk/DgG1o/XYfk4ZPc9ABRmZBLzM=
X-SA-Exim-Connect-IP: 208.38.5.102
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.2 SARE_LWSHORTT BODY: SARE_LWSHORTT
	*  0.0 TVD_RCVD_IP TVD_RCVD_IP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4725]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;Oleg Nesterov <oleg@redhat.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 2/3] pidns: Guarantee that the pidns init will be the last pidns process reaped.
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> writes:

> On 05/18, Eric W. Biederman wrote:
>>
>> Oleg Nesterov <oleg@redhat.com> writes:
>>
>> >> I think there is something very compelling about your solution,
>> >> we do need my bit about making the init process ignore SIGCHLD
>> >> so all of init's children self reap.
>> >
>> > Not sure I understand. This can work with or without 3/3 which
>> > changes zap_pid_ns_processes() to ignore SIGCHLD. And just in
>> > case, I think 3/3 is fine.
>>
>> The only issue I see is that without 3/3 we might have processes that
>> on one wait(2)s for and so will never have release_task called on.
>>
>> We do have the wait loop
>
> Yes, and we need this loop anyway, even if SIGCHLD is ignored.
> It is possible that we already have a EXIT_ZOMBIE child(s) when
> zap_pid_ns_processes().
>
>> but I think there is a race possible there.
>
> Hmm. I do not see any race, but perhaps I missed something.
> I think we can trust -ECHILD, or do_wait() is buggy.

Think about it some more you are right.  For some reason
I had forgotten that without WNOHANG we don't block forever
until a child exits.

> Hmm. But there is another (off-topic) problem, security_task_wait()
> can return an error if there are some security policy problems...
> OK, this shouldn't happen I hope.

Agreed.  We might be able to address that problem but that is indeed
another issue.

>> > And once again, this wait_event() + __wake_up_parent() is very
>> > simple and straightforward, we can cleanup this code later if
>> > needed.
>>
>> Yes, and it doesn't when you do an UNINTERRUPTIBLE sleep with
>> an INTERRUPTIBLE wake up unless I misread the code.
>
> Yes. so we need wait_event_interruptible() or __unhash_process()
> should use __wake_up_sync_key(wait_chldexit).
>
>> > Yes. This is the known oddity. We always notify the tracer if the
>> > leader exits, even if !thread_group_empty(). But after that the
>> > tracer can't detach, and it can't do do_wait(WEXITED).
>> >
>> > The problem is not that we can't "fix" this. Just any discussed
>> > fix adds the subtle/incompatible user-visible change.
>>
>> Yes and that is nasty.
>
> Agreed. ptrace API is nasty ;)
>
>> and moving detach_pid so we don't have to be super careful about
>> where we call task_active_pid_ns.
>
> Yes, I was thinking about this change too,
>
>> --- a/kernel/pid_namespace.c
>> +++ b/kernel/pid_namespace.c
>> @@ -189,6 +189,17 @@ void zap_pid_ns_processes(struct pid_namespace *pid_ns)
>>  		rc = sys_wait4(-1, NULL, __WALL, NULL);
>>  	} while (rc != -ECHILD);
>>
>> +	read_lock(&tasklist_lock);
>> +	for (;;) {
>> +		__set_current_state(TASK_INTERRUPTIBLE);
>> +		if (list_empty(&current->children))
>> +			break;
>> +		read_unlock(&tasklist_lock);
>> +		schedule();
>
> OK, but then it makes sense to add clear_thread_flag(TIF_SIGPENDING)
> before schedule, to avoid the busy-wait loop (like the sys_wait4 loop
> does). Or simply use TASK_UNINTERRUPTIBLE, I do not think it is that
> important to "fool" /proc/loadavg. But I am fine either way.

It can get darn strange when you hold a thread in stopped with ptrace
and your load mysteriously jumps.  But we already have this problem
with de_thread and people aren't yelling so shrug.

So at a practical level Idon't think it is fooling /proc/loadavg but at
this point if we want more accuraccy from /proc/loadavg we need to fix
the computation and distinguish short term disk sleeps from other
uninterruptible sleeps and thus fix how /proc/loadavg is computed,
rather than hacking around with code like this.

> Maybe you can also add "ifdef CONFIG_PID_NS" into __unhash_process(),
> but this is minor too.

An #ifdef just leads to weird build failures that in weird rare
configurations.  If we can hide it all away in a header fine, but
putting a bare #ifdef in the core of the code simply as a performance
optimization is ugly and a a major testing challenge.  Keeping track of
all of the flying pieces with this patch has been tricky enough as it
is.

Eric
