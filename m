Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758056Ab2EJQ4v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 12:56:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33272 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756224Ab2EJQ4u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 12:56:50 -0400
Date: Thu, 10 May 2012 18:55:38 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: torvalds@linux-foundation.org, hpa@zytor.com, mingo@elte.hu,
        linux-kernel@vger.kernel.org, suresh@aristanetworks.com
Subject: Re: [PATCH 1/3] coredump: flush the fpu exit state for proper
	multi-threaded core dump
Message-ID: <20120510165538.GA20931@redhat.com>
References: <1336421341.19423.4.camel@sbsiddha-desk.sc.intel.com> <1336519085-27450-1-git-send-email-suresh.b.siddha@intel.com> <1336519085-27450-2-git-send-email-suresh.b.siddha@intel.com> <20120509210551.GB334@redhat.com> <1336599123.4634.42.camel@sbsiddha-desk.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336599123.4634.42.camel@sbsiddha-desk.sc.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/09, Suresh Siddha wrote:
>
> On Wed, 2012-05-09 at 23:05 +0200, Oleg Nesterov wrote:
> > On 05/08, Suresh Siddha wrote:
> > >
> > > --- a/kernel/exit.c
> > > +++ b/kernel/exit.c
> > > @@ -656,6 +656,11 @@ static void exit_mm(struct task_struct * tsk)
> > >  		struct core_thread self;
> > >  		up_read(&mm->mmap_sem);
> > >
> > > +		/*
> > > +		 * Flush the live extended register state to memory.
> > > +		 */
> > > +		prepare_to_copy(tsk);
> >
> > This doesn't look very nice imho, but I guess you understand this...
> >
> > Perhaps we need an arch-dependent helper which saves the FPU regs
> > if needed.
> >
> > I can be easily wrong, but I did the quick grep and I am not sure
> > we can rely on prepare_to_copy(). For example, it is a nop in
> > arch/sh/include/asm/processor_64.h. But at the same time it has
> > save_fpu().
> >
> > OTOH, I am not sure it is safe to use prepare_to_copy() in exit_mm(),
> > at least in theory. God knows what it can do...
>
> There is an explicit schedule() just few lines below. And the schedule()
> also will do the same thing. The thing is we want the user-specific
> extended registers to be flushed to memory (used also in the fork path)
> before we notify the core dumping thread that we reached the serializing
> point, for the dumping thread to continue the dump process.

I understand.

My point was, there is no any guarantee prepare_to_copy() does the flush.
An architecture can do this in copy_thread() or arch_dup_task_struct(),
for example. In fact I do not understand why x86 doesn't do this.

prepare_to_copy() doesn't have any documented semantics, it looks "strange"
in exit_mm().

But let me repeat, I do not see a better solution for now.

may be we can add wait_task_inactive() in fill_thread_core_info() though,
not sure.

Oleg.

