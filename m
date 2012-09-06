Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757327Ab2IFPDE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 11:03:04 -0400
Received: from am1ehsobe001.messaging.microsoft.com ([213.199.154.204]:24167
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757137Ab2IFPC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 11:02:59 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -9
X-BigFish: VPS-9(zz98dI936eI154dM1432I4015Izz1202hzzz2dh668h839h944hd25hf0ah11b5h121eh1220h1155h)
X-WSS-ID: 0M9XOGP-01-67A-02
X-M-MSG: 
Date: Thu, 6 Sep 2012 17:02:46 +0200
From: Robert Richter <robert.richter@amd.com>
To: Steven Rostedt <rostedt@goodmis.org>
CC: wyang1 <Wei.Yang@windriver.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <oprofile-list@lists.sourceforge.net>
Subject: Re: [PATCH] x86, 32-bit: Fix invalid stack address while in softirq
Message-ID: <20120906150246.GZ8285@erda.amd.com>
References: <1346031133-12756-1-git-send-email-Wei.Yang@windriver.com>
 <20120904102439.GS8285@erda.amd.com>
 <5047FCBD.9000205@windriver.com>
 <20120906100434.GX8285@erda.amd.com>
 <1346937282.1680.15.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1346937282.1680.15.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06.09.12 09:14:42, Steven Rostedt wrote:
> On Thu, 2012-09-06 at 12:04 +0200, Robert Richter wrote:
> 
> > please take a look at this. Not sure if Linus want to look at this too
> > and if we need more optimization here.
> 
> It could probably go either way. Although the function has several
> lines, it looks like the actual assembly produced wouldn't be much. I
> took a quick look at where kernel_stack_pointer() is used, and I didn't
> find any hot paths. This is why I think it can either be a called
> function or static inline without much difference.

The main reason for putting it into ptrace.c was struct thread_info
which requires the inclusion of linux/thread_info.h. I didn't want to
add this to ptrace.h.

> 
> >  
> >  #define GET_IP(regs) ((regs)->ip)
> >  #define GET_FP(regs) ((regs)->bp)
> > diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
> > index c4c6a5c..5a9a8c9 100644
> > --- a/arch/x86/kernel/ptrace.c
> > +++ b/arch/x86/kernel/ptrace.c
> > @@ -165,6 +165,27 @@ static inline bool invalid_selector(u16 value)
> >  
> >  #define FLAG_MASK		FLAG_MASK_32
> >  
> > +/*
> > + * X86_32 CPUs don't save ss and esp if the CPU is already in kernel mode
> > + * when it traps.  The previous stack will be directly underneath the saved
> > + * registers, and 'sp/ss' won't even have been saved. Thus the '&regs->sp'.
> > + *
> > + * This is valid only for kernel mode traps.
> > + */
> > +unsigned long kernel_stack_pointer(struct pt_regs *regs)
> > +{
> > +	unsigned long context = (unsigned long)regs & ~(THREAD_SIZE - 1);
> > +	unsigned long sp = (unsigned long)&regs->sp;
> > +	struct thread_info *tinfo;
> > +
> 
> Please add some comments to why you did this. Having this info in just
> the change log is not enough. Reading it with the code makes much more
> sense.

Yes, will update the comment here.

> 
> > +	if (context == (sp & ~(THREAD_SIZE - 1)))
> > +		return sp;
> > +
> > +	tinfo = (struct thread_info *)context;
> > +
> > +	return tinfo->previous_esp;
> > +}
> > +
> >  static unsigned long *pt_regs_access(struct pt_regs *regs, unsigned long regno)
> >  {
> >  	BUILD_BUG_ON(offsetof(struct pt_regs, bx) != 0);
> > diff --git a/arch/x86/oprofile/backtrace.c b/arch/x86/oprofile/backtrace.c
> > index d6aa6e8..5b5741e 100644
> > --- a/arch/x86/oprofile/backtrace.c
> > +++ b/arch/x86/oprofile/backtrace.c
> > @@ -113,7 +113,7 @@ x86_backtrace(struct pt_regs * const regs, unsigned int depth)
> >  
> >  	if (!user_mode_vm(regs)) {
> >  		unsigned long stack = kernel_stack_pointer(regs);
> > -		if (depth)
> > +		if (depth & stack)
> 
> Can other users of kernel_stack_pointer() be nailed by a return of NULL?

It would be save here too, but dump_trace() falls back to the current
stack in case there is no stack address given which we don't want with
oprofile.

I was looking at all users of kernel_stack_pointer() and could not
find any direct pointer dereference of the sp. The only potential
problems I found could arise here:

 arch/x86/kernel/kprobes.c:resume_execution()
 arch/x86/kernel/time.c:profile_pc()

It is not quite clear if we really need code here that checks the
pointer. Since a NULL pointer access has the same effect as if the
stack address would be wrong which would be the case without the
patch, I rather tend not to change the code here.

Thanks,

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

