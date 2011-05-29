Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756652Ab1E2UBq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 16:01:46 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36095 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756532Ab1E2UBo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 16:01:44 -0400
Date: Sun, 29 May 2011 22:01:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Lutomirski <luto@mit.edu>
Cc: Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] x86-64: Replace vsyscall gettimeofday fallback with
 int 0xcc
Message-ID: <20110529200131.GA23390@elte.hu>
References: <cover.1306517576.git.luto@mit.edu>
 <452208dbdf79d4c821d701d5973621bf7546419a.1306517576.git.luto@mit.edu>
 <20110529191055.GC9835@elte.hu>
 <BANLkTin=nCdEjA3Fgj6jH5TrSryit8K_XQ@mail.gmail.com>
 <20110529194922.GC13539@elte.hu>
 <BANLkTi=w37QWARQCOTLVXQq6EiW0rdDfcw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTi=w37QWARQCOTLVXQq6EiW0rdDfcw@mail.gmail.com>
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

> On Sun, May 29, 2011 at 3:49 PM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > * Andrew Lutomirski <luto@mit.edu> wrote:
> >
> >> > Ok, i suspect you marked it 0xCC because that's the INT3 instruction
> >> > - not very useful for exploits?
> >>
> >> Exactly.
> >>
> >> The comments in irq_vectors.h make it sound like vectors 0x81..0xed
> >> are used for device interrupts but AFAICT it's only 0x20..0x39 that
> >> are used, so the precise choice of vector doesn't matter that much.
> >
> > No, we use almost all of the vector space for device interrupts. Why
> > do you think only 0x20..0x39 is used?
> 
> Possibility my inability to understand all the IRQ mapping code in 
> just half an hour of trying.

Hey, you managed to find all the scattered pieces in just half an 
hour, i'm impressed ;-)

> In arch/x86/kernel/irq.c, arch_probe_nr_irqs returns 
> NR_IRQS_LEGACY, which I think means that the genirq code allocates 
> will only expect IRQs on that many vectors.
> 
> If I'm wrong then my patch could be bad: if something tries to use 
> vector 0xcc for a device interrupt, then the vsyscall emulation 
> code will eat that interrupt.

I saw the used_vector trick you did and it looked safe to me: we set 
up these gates very early on, when there's no device interrupts yet.

If you want to be really sure you could do a BUG_ON(test_bit()) 
before setting it.

> (0xcc is barely below the maximum.  INVALIDATE_TLB_VECTOR_START 
> could be as low as 0xcf.)

Yeah - 0xcc could be fine even if it's in the middle - we are able to 
skip over used ones.

Thanks,

	Ingo
