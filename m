Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755105Ab0KZSGT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 13:06:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52710 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751507Ab0KZSGS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 13:06:18 -0500
Date: Fri, 26 Nov 2010 18:59:45 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: roland@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        "rjw@sisk.plpavel"@ucw.cz
Subject: Re: [PATCH 06/14] signal: use GROUP_STOP_PENDING to avoid stopping
	multiple times for a single group stop
Message-ID: <20101126175945.GE28177@redhat.com>
References: <1290768569-16224-1-git-send-email-tj@kernel.org> <1290768569-16224-7-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290768569-16224-7-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am stucked at this point ;)

On 11/26, Tejun Heo wrote:
>
> Currently task->signal->group_stop_count is used to decide whether to
> stop for group stop.  However, if there is a task in the group which
> is taking a long time to stop, other tasks which are continued by
> ptrace would repeatedly stop for the same group stop until the group
> stop is complete.

Yes. but the tracee won't abuse ->group_stop_count, this was fixed
by the previous patch.

But, otoh, what if debugger resumes the tracee when the group stop
was completed by other sub-threads ?

The tracee will run with GROUP_STOP_PENDING set. ->group_stop_count
is zero. If this tracee recieves a signal (or spurious TIF_SIGPENDING),
suddenly it will notice GROUP_STOP_PENDING and report the stop to
debugger.

This looks a bit strange. OK, perhaps it makes sense to report the
stop to "ack" the group stop which wasn't acked in ptrace_stop().
Or, if it was untraced after resume, it makes sense to "silently"
stop as well.

But, in this case it shouldn't wait until signal_pending() is true?


> @@ -1742,8 +1745,8 @@ static int do_signal_stop(int signr)
>  	struct signal_struct *sig = current->signal;
>  	int notify = 0;
>
> -	if (!sig->group_stop_count) {
> -		unsigned int gstop = GROUP_STOP_CONSUME;
> +	if (!(current->group_stop & GROUP_STOP_PENDING)) {
> +		unsigned int gstop = GROUP_STOP_PENDING | GROUP_STOP_CONSUME;
>  		struct task_struct *t;

Hmm. This means, the ptraced task can initiate the group stop
while it is already in progress...

Debugger can constantly resume a tracee while the group stop
is not finished. Finally this tracee can dequeue SIGSTOP without
GROUP_STOP_PENDING.

At first glance, nothing bad can happen, but I am not sure.
We can have other ptraced threads which were resumed after
ptrace_stop()/do_signal_stop().



> This will change with future patches.

Yes. I tried to study this series patch-by-patch. I think I should
read the whole series to really understand the intermediate changes.
I'll try to return on Monday.

Cough. I didn't expect I forgot this code that much ;)

Oleg.

