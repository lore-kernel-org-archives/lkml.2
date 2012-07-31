Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755997Ab2GaSXU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 14:23:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64999 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753623Ab2GaSXS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 14:23:18 -0400
Date: Tue, 31 Jul 2012 19:38:54 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@redhat.com>, Roland McGrath <roland@hack.frob.com>
Subject: Re: [PATCH] uprobes: don't enable/disable signle step if the user
	did it
Message-ID: <20120731173854.GA14576@redhat.com>
References: <1343316043-13475-1-git-send-email-bigeasy@linutronix.de> <20120730110658.GC11147@in.ibm.com> <20120730141638.GA5306@redhat.com> <20120731052226.GA5087@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120731052226.GA5087@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31, Srikar Dronamraju wrote:
>
> * Oleg Nesterov <oleg@redhat.com> [2012-07-30 16:16:38]:
>
> > So I think we need arch_uprobe_*able_step(struct uprobe_task *utask).
> > Ignoring all problems except the one this patch tries to fix, x86
> > can simply do:
> >
> > 	arch_uprobe_enble_step(utask, struct arch_uprobe *auprobe)
> > 	{
> > 		utask->clear_tf =
> > 			!(regs->flags & X86_EFLAGS_TF) &&
> > 			(auprobe->insn != "popf");
> > 		regs->flags |= X86_EFLAGS_TF;
> > 	}
> >
> > 	arch_uprobe_disable_step(utask)
> > 	{
> > 		if (utask->clear_tf)
> > 			regs->flags &= ~X86_EFLAGS_TF;
> > 	}
> >
>
> We were using something similar to this approach. [though we were still
> using TIF_SINGLESTEP flag].

(and afaics the code was wrong)

> However this was all changed based on
> feedback from Roland and Peter.
>
> Here is the pointer to the discussion.
>
> https://lkml.org/lkml/2011/1/27/283

Looking at this discussion now, I am not sure that Roland was against
the per-arch uprobe_enable_step() implementation.

And when I read you message I do not understand your opinion ;)

And just in case, the pseudo code above is only for illustration,
note also "Ignoring all problems except the one".

In any case I agree, this needs more discussion. Personally I think
it doesn't make sense to try to teach user_enable_single_step() to
work correctly with ptrace and uprobes at the same time, I can be
wrong of-course.

Oleg.

