Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754557Ab0CYBR6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 21:17:58 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:36376 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754400Ab0CYBR4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 21:17:56 -0400
Date: Wed, 24 Mar 2010 18:17:53 -0700
From: Matt Helsley <matthltc@us.ibm.com>
To: Matt Helsley <matthltc@us.ibm.com>
Cc: Christoffer Dall <christofferdall@christofferdall.dk>,
       Oren Laadan <orenl@cs.columbia.edu>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       containers <containers@lists.linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Roland McGrath <roland@redhat.com>
Subject: Re: [C/R ARM][PATCH 1/3] ARM: Rudimentary syscall interfaces
Message-ID: <20100325011753.GF5704@count0.beaverton.ibm.com>
References: <1269219965-23923-1-git-send-email-christofferdall@christofferdall.dk>
 <1269219965-23923-2-git-send-email-christofferdall@christofferdall.dk>
 <20100323205342.GA19572@n2100.arm.linux.org.uk>
 <20100324020342.GB5704@count0.beaverton.ibm.com>
 <Pine.LNX.4.64.1003240055050.5867@takamine.ncl.cs.columbia.edu>
 <20100324140252.GC5704@count0.beaverton.ibm.com>
 <4BAA3586.1020604@cs.columbia.edu>
 <7d08b87d1003241236n2b45e6f4ife36da841351df9d@mail.gmail.com>
 <20100325011132.GE5704@count0.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100325011132.GE5704@count0.beaverton.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 24, 2010 at 06:11:32PM -0700, Matt Helsley wrote:
> On Wed, Mar 24, 2010 at 08:36:39PM +0100, Christoffer Dall wrote:
<snip>
> > Re-using the assembly code or factoring it out so that it can be used
> > from multiple places doesn't seem very pleasing to me, as the assembly
> > code is in the critical path and written specifically for the context
> > of a process entering the kernel. Please correct me if I'm wrong.
> > 
> > I imagine simply a function in C, more or less re-implementing the
> > logic that's already in entry-common.S, might do the trick. I wouldn't
> > worry much about the performance in this case as it will not be used
> > often. The following _untested_ snippet illustrates my idea:
> > 
> > ---
> >  arch/arm/include/asm/syscall.h |   93 +++++++++++++++++++++++++++++++++++++++-
> >  1 files changed, 92 insertions(+), 1 deletions(-)
> > 
> > diff --git a/arch/arm/include/asm/syscall.h b/arch/arm/include/asm/syscall.h
> > index 3b3248f..a7f2615 100644
> > --- a/arch/arm/include/asm/syscall.h
> > +++ b/arch/arm/include/asm/syscall.h
> > @@ -10,10 +10,101 @@
> >  #ifndef _ASM_ARM_SYSCALLS_H
> >  #define _ASM_ARM_SYSCALLS_H
> > 
> > +static inline int get_swi_instruction(struct task_struct *task,
> > +				      struct pt_regs *regs,
> > +				      unsigned long *instr)
> > +{
> > +	struct page *page = NULL;
> > +	unsigned long instr_addr;
> > +	unsigned long *ptr;
> > +	int ret;
> > +
> > +	instr_addr = regs->ARM_pc - 4;
> > +
> > +	down_read(&task->mm->mmap_sem);
> > +	ret = get_user_pages(task, task->mm, instr_addr,
> > +			     1, 0, 0, &page, NULL);
> > +	up_read(&task->mm->mmap_sem);
> > +
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	ptr = (unsigned long *)kmap_atomic(page, KM_USER1);
> > +	memcpy(instr,
> > +	       ptr + (instr_addr >> PAGE_SHIFT),
> 			^shouldn't this be:
> 		      instr_addr & PAGE_MASK

Oops, made my own mistake. I think the address of the kmap'd instruction
would be:

	ptr + (instr_addr & ~PAGE_MASK)

Cheers,
	-Matt Helsley
