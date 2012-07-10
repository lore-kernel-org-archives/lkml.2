Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754333Ab2GJIVR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 04:21:17 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:61366 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753299Ab2GJIVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 04:21:10 -0400
Date: Tue, 10 Jul 2012 10:21:04 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, hpa@zytor.com,
        eranian@google.com, linux-kernel@vger.kernel.org, fweisbec@gmail.com,
        akpm@linux-foundation.org, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org,
        Robert Richter <robert.richter@amd.com>
Subject: Re: [tip:perf/core] perf/x86: Fix USER/KERNEL tagging of samples
Message-ID: <20120710082104.GA11187@gmail.com>
References: <tip-xxrt0a1zronm1sm36obwc2vy@git.kernel.org>
 <CA+55aFxY7SqwSQWuRXSg+W=ftp9FtCT1MMEqMiCi1H279Fis-A@mail.gmail.com>
 <1341598329.7709.57.camel@twins>
 <CA+55aFzqoz7dcUCQfSrXxX2T8=2wgWdb1H2vaBhk7V-r0uaogw@mail.gmail.com>
 <CA+55aFw+vE4zMe1bJohLuoMDaFpqGCz6sBNRE8gkV7JOvtro0g@mail.gmail.com>
 <1341832997.3462.41.camel@twins>
 <20120709184145.GA7666@gmail.com>
 <1341906848.3462.92.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341906848.3462.92.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Mon, 2012-07-09 at 20:41 +0200, Ingo Molnar wrote:
> > > +static unsigned long get_segment_base(unsigned int segment)
> > > +{
> > > +     struct desc_struct *desc;
> > > +     int idx = segment >> 3;
> > > +
> > > +     if ((segment & SEGMENT_TI_MASK) == SEGMENT_LDT) {
> > > +             if (idx > LDT_ENTRIES)
> > > +                     return 0;
> > > +
> > > +             desc = current->active_mm->context.ldt;
> > > +     } else {
> > > +             if (idx > GDT_ENTRIES)
> > > +                     return 0;
> > > +
> > > +             desc = __this_cpu_ptr(&gdt_page.gdt[0]);
> > > +     }
> > > +
> > > +     return get_desc_base(desc + idx);
> > 
> > Shouldn't idx be checked against active_mm->context.ldt.size, 
> > not LDT_ENTRIES (which is really just an upper limit)?
> 
> Ah indeed, fixed that.

Another boundary condition would be when we intentionally 
twiddle the GDT: such as during suspend or during BIOS upcalls. 
Can we then get a PMU interrupt? If yes then this will probably 
result in garbage:

> > > +             desc = __this_cpu_ptr(&gdt_page.gdt[0]);

it won't outright crash, we don't ever deallocate our GDT - but 
it will return a garbage RIP.

Then there's also all the Xen craziness with segments ...

Both ought to be rare an uninteresting - but then again, 
segmented execution is already rare and uninteresting to begin 
with.

So, instead of trying to discover all these weird x86 cases - 
with little to no testing done after that - I thought that it 
might be more future proof to just handle the cases we are 
explicitly interested in: flat code, and pounce in some well 
defined way in all the other situations by returning the RIP to 
an empty __X86_LEGACY_SEGMENTED_CODE() symbol.

That way we will at least give *some* useful information to the 
poor segmented code user, if the profile says:

    21.32%  [kernel]      [k] __X86_LEGACY_SEGMENTED_CODE
    11.01%  [kernel]      [k] kallsyms_expand_symbol     
     8.29%  [kernel]      [k] vsnprintf                  
     7.37%  libc-2.15.so  [.] __strcmp_sse42             
     6.93%  perf          [.] symbol_filter              
     4.20%  perf          [.] kallsyms__parse            
     3.92%  [kernel]      [k] format_decode              
     3.62%  [kernel]      [k] string.isra.4              
     3.59%  [kernel]      [k] memcpy                     
     3.11%  [kernel]      [k] strnlen                    

then the user at least knows that there's 21% of overhead in 
some sort of segmented x86 code. Or if they *really* want to 
resolve that, they can take your patch and add symbol decoding 
to user-space and test it all.

KISS and such.

Linus?

Thanks,

	Ingo
