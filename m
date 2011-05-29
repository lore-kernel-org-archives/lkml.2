Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756225Ab1E2Tns (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 15:43:48 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52568 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752563Ab1E2Tnr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 15:43:47 -0400
Date: Sun, 29 May 2011 21:43:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Lutomirski <luto@mit.edu>
Cc: Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] x86-64: Replace vsyscall gettimeofday fallback with
 int 0xcc
Message-ID: <20110529194330.GB13539@elte.hu>
References: <cover.1306517576.git.luto@mit.edu>
 <452208dbdf79d4c821d701d5973621bf7546419a.1306517576.git.luto@mit.edu>
 <20110529191055.GC9835@elte.hu>
 <BANLkTin=nCdEjA3Fgj6jH5TrSryit8K_XQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTin=nCdEjA3Fgj6jH5TrSryit8K_XQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Lutomirski <luto@mit.edu> wrote:

> On Sun, May 29, 2011 at 3:10 PM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > * Andy Lutomirski <luto@MIT.EDU> wrote:
> >
> >> --- a/arch/x86/kernel/entry_64.S
> >> +++ b/arch/x86/kernel/entry_64.S
> >> @@ -1121,6 +1121,8 @@ zeroentry spurious_interrupt_bug do_spurious_interrupt_bug
> >>  zeroentry coprocessor_error do_coprocessor_error
> >>  errorentry alignment_check do_alignment_check
> >>  zeroentry simd_coprocessor_error do_simd_coprocessor_error
> >> +zeroentry intcc do_intcc
> >> +
> >>
> >>       /* Reload gs selector with exception handling */
> >>       /* edi:  new selector */
> >> diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
> >
> > I forgot to reply to your prior question about zeroentry vs.
> > paranoidzeroentry.
> >
> > That distinction is an undocumented x86-64-ism.
> 
> Is this an erratum or just the undocumented fact that
> swapgs twice puts usergs back and confuses the kernel?

There's no erratum needed for this to be unreliable: if an NMI hits like this:


	SYSENTER

	<=== ... NMI entry ...

	SWAPGS

then the CS check of the entry frame will show 'we interrupted kernel 
mode code', but in reality the SWAPGS has not been done yet.

Regular interrupts (and pagefaults, etc.) can never interrupt the 
above sequence 'in the middle', where the CS check is unreliable.

So yes, it's about not confusing the kernel into the wrong SWAPGS 
state.

I suspect you could trigger badness very quickly: mark the NMI entry 
zeroentry and run some more extreme NMI load like:

        # 100 KHz NMI with precise (no skid) cycles PEBS profiling:

	perf record -a -e cycles:pp -F 100000 sleep 60

and i guess you'll see a nasty crash very quickly.

Thanks,

	Ingo
