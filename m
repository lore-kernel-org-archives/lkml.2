Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758573Ab1CCRm5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 12:42:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58376 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756708Ab1CCRmz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 12:42:55 -0500
Date: Thu, 3 Mar 2011 18:34:22 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Roland McGrath <roland@redhat.com>, jan.kratochvil@redhat.com,
        Denys Vlasenko <vda.linux@googlemail.com>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
Subject: Re: [RFC] Proposal for ptrace improvements
Message-ID: <20110303173422.GA27960@redhat.com>
References: <20110301152457.GE26074@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110301152457.GE26074@htj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

I didn't read the whole thread yet... perhaps this was already
discussed in more details. IOW, please ignore "I don't understand"
parts, I'll ask the questions later.

On 03/01, Tejun Heo wrote:
>
> I3. Not well-defined job control behaviors while traced
>
> In general, jctl behaviors while ptraced aren't well defined.

I'd say it is not defined at all ;) And to me this is the root of
all problems.

So, many thanks for this RFC. This is the first time someone tries
to define the rules.

> * PTRACE_CONT and other requests which resume the tracee overrides, or
>   rather works below, jctl stop.  If jctl stop takes place on the task
>   group a tracee belongs to, the tracee will eventually participate in
>   the group stop and its tracer will be notified; however, when
>   PTRACE_CONT or other resuming request is made, the tracee will
>   resume execution regardless of and without affecting the jctl stop.
>
> I don't know whether these are by design or just happened as
> by-products of the evolution of task group implementation in the
> kernel, but regardless, in my opinion, both rules are sound and
> useful.  They might not be immediately intuitive and the resulting
> behavior might seem quirky but to me it seems to be one of those
> things which looks awkward at first but is ultimately right in its
> usefulness and relative simplicity.
>
> More importantly, it doesn't matter what I or, for that matter, anyone
> else thinks about them.  They're tightly ingrained into the
> userland-visible behavior and actively exploited by the current users
> - for example, dynamic evalution in tracee context in gdb(1).
> Changing behaviors as fundamental as these would impact the current
> applications and debugging behaviors expected by (human) users.

OK. I have to agree. Lets forget the PTRACE_CONT-needs-SIGCONT idea.
Nobody like it, including Jan (even if he didn't nack it explicitly).
Forget.

> PROPOSAL
> --------
>
> P1. Always TASK_TRACED while ptraced

OK.

> P2. Fix notifications to the real parent
>
> This pleasantly proved to be the least contentious change to make.
> The usual group stop / continued notifications should be propagated to
> the real parent whether the children are ptraced or not.

Agreed.

> P3. Keep ptrace resume separate from and beneath jctl stop

This is not exactly clear to me... Probably I understand what
you mean, but I am not sure about details.

> P4. PTRACE_SEIZE

This is the new request. You know, I'd like to discuss the details
later and separately. Actually, I think the user-space developers
should participate and tell what they need. As for me, I certainly
agree that SIGSTOP from PTRACE_ATTACH is very wrong, and it is very
bad that gdb has to send SIGSTOP if it wants to stop the tracee.
IOW, I agree that something like this is needed and useful. In
particular,

> In both cases, jctl state is unaffected.

Agreed.

> P5. "^Z" and "fg" for tracees
>
> As proposed, when a tracee enters jctl stop, it enters TASK_TRACED
> from which emission of SIGCONT can't resume the tracee.  This makes it
> impossible for a tracer to become transparent with respect to jctl.
> For example, after strace(1) is attached to a task, the task can be
> ^Z'd but then can't be fg'd.
>
> A better way to solve this is simply giving the tracer the capability
> to listen for the end of jctl stop.

Hmm. I don't understand what "the end of jctl stop" actually means.

Since you are talking about WCONTINUED below, I guess it means that
the process is not group-stopped any longer, say, SIGCONT comes.
OK. If the tracer is notified about the end of jctl stop, it can
resume the tracee if it wants. end-of-jctl-stop is per-process, but
I guess the debugger will be notified per-thread. Looks reasonable
to me.

> WCONTINUED is the obvious candidate but I think it is
> better to use STOPPED notification because the task is not really
> resumed.  Only its mode of stop changes.

OK.

> What state the tracee is in
> can be determined by retriving siginfo using PTRACE_GETSIGINFO.

I don't understand this this details right now... But I guess this
doesn't matter right now.

Either way, debugger should have the ability to know the tracee's
state wrt group-stop. To oversimplify, it should know the state of
SIGNAL_STOP_STOPPED bit. Correct?

Oleg.

