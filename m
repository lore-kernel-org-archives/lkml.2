Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752914Ab1JLMUU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 08:20:20 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:38788 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752703Ab1JLMUS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 08:20:18 -0400
Date: Wed, 12 Oct 2011 17:31:12 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>, Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Christoph Hellwig <hch@infradead.org>,
        Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
        Jonathan Corbet <corbet@lwn.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 3.1.0-rc4-tip 26/26]   uprobes: queue signals while
 thread is singlestepping.
Message-ID: <20111012120112.GB11831@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20110920120517.25326.57657.sendpatchset@srdronam.in.ibm.com>
 <1317128626.15383.61.camel@twins>
 <20110927131213.GE3685@linux.vnet.ibm.com>
 <20111005180139.GA5704@redhat.com>
 <20111006054710.GB17591@linux.vnet.ibm.com>
 <20111007165828.GA32319@redhat.com>
 <20111010122556.GB16268@linux.vnet.ibm.com>
 <20111010182535.GA6934@redhat.com>
 <20111011172603.GD16268@linux.vnet.ibm.com>
 <20111011185653.GA10215@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20111011185653.GA10215@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> Yes, yes, I see. But, once again, this can only protect from kill().
> 
> The task can stop even if you block all signals, another thread
> can initiate the group stop and set JOBCTL_STOP_PENDING + TIF_SIGPENDING.
> And note that it can stop _before_ it returns to user mode to step
> over the xol insn.
> 
> In theory the tasks like this can consume all slots, and if we have
> yet another thread waiting in xol_wait_event(), we deadlock. Although
> in this case SIGCONT helps, but this group stop can never finish.
> 

Okay. 

> > > Another problem is that it is not possible to block the "implicit"
> > > SIGKILL sent by exec/exit_group/etc. This mean the task can exit
> > > without sstep_complete/xol_free_insn_slot/etc. Mostly this is fine,
> > > we have free_uprobe_utask()->xol_free_insn_slot(). But in theory
> > > this can deadlock afaics. Suppose that the coredumping is in progress,
> > > the killed UTASK_SSTEP task hangs in exit_mm() waiting for other
> > > threads. If we have enough threads like this, we can deadlock with
> > > another thread sleeping in xol_wait_event().
> >
> > Shouldnt the behaviour be the same as threads that did a
> > select,sigsuspend?
> 
> Hmm. I don't understand... Could you explain?
> 
> Firstly, select/sigsuspend can't block SIGKILL, but this doesn't matter.
> My point was, the task can exit in UTASK_SSTEP state, and without
> xol_free_insn_slot(). And this (in theory) can lead to the "real"
> deadlock.

I think we should be okay if the test exits in UTASK_SSTEP state.
All I thought we needed to do was block it from doing anything except
exit or singlestep. Our exit hook should cleanup any references that we
hold.

> 
> > > However the first problem looks nasty, even if it is not very serious.
> > > And, otoh, it doesn't look right to block SIGKILL, the task can loop
> > > forever executing the xol insn (see below).
> > >
> > >
> > >
> > > What do you think about the patch below? On top of 25/26, uncompiled,
> > > untested. With this patch the task simply refuses to react to
> > > TIF_SIGPENDING until sstep_complete().
> > >
> >
> > Your patch looks very simple and clean.
> > Will test this patch and revert.
> 
> Great. I'll think a bit more and send you the "final" version tomorrow.
> Assuming we can change sstep_complete() as we discussed, it doesn't need
> fatal_signal_pending().

Okay. 

> 
> HOWEVER. There is yet another problem. Another thread can, say, unmap()
> xol_vma. In this case we should ensure that the task can't fault in an
> endless loop.
> 

Hmm should we add a check in unmap() to see if the vma that we are
trying to unmap is the xol_vma and if so return?
Our assumption has been that once an xol_vma has been created, it should
be around till the process gets killed.

> > > And, unless I missed something, this makes
> > > free_uprobe_utask()->xol_free_insn_slot() unnecessary.
> >
> > What if a fatal (SIGKILL) signal was delivered only to that thread
> 
> this is not possible, in this case all threads are killed. But,
> 
> > or a fatal signal for a thread-group but more
> > than one thread-group share the mm?
> 
> Yes, this is possible.
> 
> Sorry for confusion. Yes, if we have the fatal_signal_pending() check
> in sstep_complete(), then we do need
> free_uprobe_utask()->xol_free_insn_slot(). But this check was added
> only to illustrate another problem with the self-repeating insns.
> 
> And. With "HOWEVER" above, we probably need this xol_free anyway.
> 
> > you have already commented why blocking signals is a problem, but I
> > still thought I will post the patch that I had to let you know what I
> > was thinking before I saw your patch.
> >
> > While task is processing a singlestep due to uprobes breakpoint hit,
> > block signals from the time it enables singlestep to the time it disables
> > singlestep.
> 
> OK, it is too late for me today, I'll take a look tomorrow.
> 
> This approach has some advantages too, perhaps we should make something
> "in between".
> 

Okay.

-- 
Thanks and Regards
Srikar
