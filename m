Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752339Ab1HMOlQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Aug 2011 10:41:16 -0400
Received: from smtp4-g21.free.fr ([212.27.42.4]:55390 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752034Ab1HMOlO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Aug 2011 10:41:14 -0400
Message-ID: <4E468CFC.8050901@free.fr>
Date: Sat, 13 Aug 2011 16:41:00 +0200
From: Daniel Lezcano <daniel.lezcano@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110516 Thunderbird/3.1.10
MIME-Version: 1.0
To: Matt Helsley <matthltc@us.ibm.com>
CC: akpm@linux-foundation.org, containers@lists.linux-foundation.org,
        bonbons@linux-vserver.org, oleg@tv-sign.ru,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Notify container-init parent a 'reboot' occured
References: <1313094241-3674-1-git-send-email-daniel.lezcano@free.fr> <1313094241-3674-3-git-send-email-daniel.lezcano@free.fr> <20110813001959.GB5777@count0.beaverton.ibm.com>
In-Reply-To: <20110813001959.GB5777@count0.beaverton.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/13/2011 02:19 AM, Matt Helsley wrote:
> On Thu, Aug 11, 2011 at 10:24:01PM +0200, Daniel Lezcano wrote:
>> When the reboot syscall is called and the pid namespace where the calling
>> process belongs to is not from the init pidns, we send a SIGCHLD with CLD_REBOOTED
>> to the parent of this pid namespace.
> Shouldn't we honor the exit_signal set via clone() here rather than
> hardcode SIGCHLD? More below...

Hmm,  I don't think so, that does not really make sense.

[ ... ]

>> +void do_notify_parent_cldreboot(struct task_struct *tsk, int why, char *buffer)
>> +{
>> +	struct siginfo info = { };
>> +	struct task_struct *parent;
>> +	struct sighand_struct *sighand;
>> +	unsigned long flags;
>> +
>> +	if (tsk->ptrace)
>> +		parent = tsk->parent;
>> +	else {
>> +		tsk = tsk->group_leader;
>> +		parent = tsk->real_parent;
>> +	}
>> +
>> +	info.si_signo = SIGCHLD;
> should this be:
>
> info.si_signo = tsk->exit_signal == -1 ? SIGCHLD : tsk->exit_signal;


No, because this code is always called for SIGHLD.
The userspace will receive this signal with CLD_REBOOT if it sets the
SA_CLDREBOOT flag option which is not set by default.

>> +	info.si_errno = 0;
>> +	info.si_status = why;
>> +
>> +	rcu_read_lock();
>> +	info.si_pid = task_pid_nr_ns(tsk, parent->nsproxy->pid_ns);
>> +	info.si_uid = __task_cred(tsk)->uid;
>> +	rcu_read_unlock();
>> +
>> +	info.si_utime = cputime_to_clock_t(tsk->utime);
>> +	info.si_stime = cputime_to_clock_t(tsk->stime);
>> +
>> +	info.si_code = CLD_REBOOTED;
>> +
>> +	sighand = parent->sighand;
>> +	spin_lock_irqsave(&sighand->siglock, flags);
>> +	if (sighand->action[SIGCHLD-1].sa.sa_handler != SIG_IGN &&
>> +	    sighand->action[SIGCHLD-1].sa.sa_flags & SA_CLDREBOOT)
>> +		__group_send_sig_info(SIGCHLD, &info, parent);
> (with corresponding changes above...)
>
>> +	/*
>> +	 * Even if SIGCHLD is not generated, we must wake up wait4 calls.
>> +	 */

