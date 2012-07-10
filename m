Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752928Ab2GJHyW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 03:54:22 -0400
Received: from casper.infradead.org ([85.118.1.10]:35663 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534Ab2GJHyV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 03:54:21 -0400
Message-ID: <1341906848.3462.92.camel@twins>
Subject: Re: [tip:perf/core] perf/x86: Fix USER/KERNEL tagging of samples
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, hpa@zytor.com,
        eranian@google.com, linux-kernel@vger.kernel.org, fweisbec@gmail.com,
        akpm@linux-foundation.org, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org,
        Robert Richter <robert.richter@amd.com>
Date: Tue, 10 Jul 2012 09:54:08 +0200
In-Reply-To: <20120709184145.GA7666@gmail.com>
References: <tip-xxrt0a1zronm1sm36obwc2vy@git.kernel.org>
	 <CA+55aFxY7SqwSQWuRXSg+W=ftp9FtCT1MMEqMiCi1H279Fis-A@mail.gmail.com>
	 <1341598329.7709.57.camel@twins>
	 <CA+55aFzqoz7dcUCQfSrXxX2T8=2wgWdb1H2vaBhk7V-r0uaogw@mail.gmail.com>
	 <CA+55aFw+vE4zMe1bJohLuoMDaFpqGCz6sBNRE8gkV7JOvtro0g@mail.gmail.com>
	 <1341832997.3462.41.camel@twins> <20120709184145.GA7666@gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-07-09 at 20:41 +0200, Ingo Molnar wrote:
> > +static unsigned long get_segment_base(unsigned int segment)
> > +{
> > +     struct desc_struct *desc;
> > +     int idx = segment >> 3;
> > +
> > +     if ((segment & SEGMENT_TI_MASK) == SEGMENT_LDT) {
> > +             if (idx > LDT_ENTRIES)
> > +                     return 0;
> > +
> > +             desc = current->active_mm->context.ldt;
> > +     } else {
> > +             if (idx > GDT_ENTRIES)
> > +                     return 0;
> > +
> > +             desc = __this_cpu_ptr(&gdt_page.gdt[0]);
> > +     }
> > +
> > +     return get_desc_base(desc + idx);
> 
> Shouldn't idx be checked against active_mm->context.ldt.size, 
> not LDT_ENTRIES (which is really just an upper limit)?

Ah indeed, fixed that.

> > +static unsigned long code_segment_base(struct pt_regs *regs)
> > +{
> > +#ifdef CONFIG_32BIT
> > +     if (user_mode(regs) && regs->cs != __USER_CS)
> > +             return get_segment_base(regs->cs);
> > +#else
> > +     if (test_thread_flag(TIF_IA32)) {
> > +             if (user_mode(regs) && regs->cs != __USER32_CS)
> > +                     return get_segment_base(regs->cs);
> > +     }
> > +#endif
> > +     return 0;
> > +}
> 
> Will this do the right thing for x32 mode? 

hpa? It looks like x32 has TIF_X32, but from the kernel's POV its really
just another 64bit process, so as long as we don't trigger the TIF_IA32
case we'll just return 0. 

set_personality_ia32() looks like TIF_IA32 and TIF_X32 are mutually
exclusive, so I think we do the right thing.
