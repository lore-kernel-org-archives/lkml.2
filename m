Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756066Ab2ADPbp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 10:31:45 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63216 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754Ab2ADPbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 10:31:42 -0500
Date: Wed, 4 Jan 2012 07:31:34 -0800
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Denys Vlasenko <vda.linux@googlemail.com>,
        Denys Vlasenko <dvlasenk@redhat.com>, linux-kernel@vger.kernel.org,
        =?utf-8?Q?=C5=81ukasz?= Michalik <lmi@ift.uni.wroc.pl>,
        "Dmitry V. Levin" <ldv@altlinux.org>
Subject: Re: ptrace fixes for 3.2
Message-ID: <20120104153134.GL31746@google.com>
References: <201112281955.55200.vda.linux@googlemail.com>
 <20111229113245.GA18062@redhat.com>
 <20111229120506.GA23653@redhat.com>
 <20120103142941.GA25488@redhat.com>
 <20120103154404.GA28930@redhat.com>
 <20120103163023.GA31746@google.com>
 <20120103170927.GA31795@redhat.com>
 <20120103191808.GF31746@google.com>
 <20120104113534.GA15307@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120104113534.GA15307@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Jan 04, 2012 at 12:35:34PM +0100, Oleg Nesterov wrote:
> Can't understand how did we miss this, but WARN_ON_ONCE(!ptrace)
> in do_signal_stop() is not right. Debugger can resume the stopped
> task, and it can clone the _untraced_ thread running in the stopped
> group.

Right, we should be setting JOBCTL_STOP_PENDING for newly cloned tasks
if sigstop is in effect.

> And even if the new thread is auto-attached, we have the problems
> with JOBCTL_STOP_SIGMASK.
> 
> I do not want to discuss the "proper" solution here. I think the
> necessary changes are simple, but I do not think this is the 3.1
> material, and 3.1 needs some trivial fix.

Yeah, sure thing.

> What do you think about the patch below? I am going to send it to
> Linus unless you see something wrong.
> 
> And I'd like to explain why I prefer to add the (temporary) hack
> into __ptrace_unlink() instead of adding
> 
> 	if (unlikely(ptrace) && current->ptrace) {
> 		...
> 		child->jobctl = current->jobctl & JOBCTL_STOP_SIGMASK;
> 		...
> 	}
> 
> into ptrace_init_task(). I think that jobctl & JOBCTL_STOP_SIGMASK"
> should be cleanuped. Look, once we set JOBCTL_STOP_SIGMASK we never
> clear it. Yes, this doesn't really matter but this can hide an error,
> for example this can "fool" the WARN_ON(!signr) in do_jobctl_trap().
> Imho, at least SIGCONT should clear this part of ->jobctl. IOW, it
> should be non-zero only if/when it has effect.

I don't recall the details but there was somewhing convoluted about
clearing the signal number.  There's some non-obvious case where the
signr is used after what appears to be the apparent lifespan.  I
*think* we already talked about this but could be imagining things.
But, yeah, sure, if we can do it without complicating stuff, why not?

> That is why I do not want to change ptrace_init_task() until we
> decide what should we do with CLONE_THREAD && SIGNAL_STOP_STOPPED,
> to avoid the bogus (jobctl & JOBCTL_STOP_SIGMASK) != 0. IOW I prefer
> the change in __ptrace_unlink() to catch the other possible problems
> like this.

As long as it gets fixed properly in the next devel cycle, I don't
have any objection.

> Also, I'd like to defend 6634ae10
> "ptrace_init_task: initialize child->jobctl explicitly" which can
> be blamed for the 2nd problem. Afaics, this change is really needed
> and it fixes the bug. The changelog says "Currently this is harmless"
> but this is not right, dup_task_struct() can happen between SIGSTOP and
> SIGCONT, in this case the child can have the wrong JOBCTL_STOP_PENDING.
> 
> So, what do you think?

Looks good to me, provided proper fix is coming soon. :p

> -------------------------------------------------------------------------------
> [PATCH for 3.1] ptrace_unlink: ensure JOBCTL_STOP_SIGMASK is not zero
> 
> This is the temporary simple fix for 3.1, we need more changes in this
> area.
> 
> 1. do_signal_stop() assumes that the running untraced thread in the
>    stopped thread group is not possible. This was our goal but it is
>    not yet achieved: a stopped-but-resumed tracee can clone the running
>    thread which can initiate another group-stop.
> 
>    Remove WARN_ON_ONCE(!current->ptrace).
> 
> 2. A new thread always starts with ->jobctl = 0. If it is auto-attached
>    and this group is stopped, __ptrace_unlink() sets JOBCTL_STOP_PENDING
>    but JOBCTL_STOP_SIGMASK part is zero, this triggers WANR_ON(!signr)
>    in do_jobctl_trap() if another debugger attaches.
> 
>    Change __ptrace_unlink() to set the artificial SIGSTOP for report.
> 
>    Alternatively we could change ptrace_init_task() to copy signr from
>    current, but this means we can copy it for no reason and hide the
>    possible similar problems.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

 Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
