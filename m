Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753723Ab1EEKS5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 06:18:57 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38054 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753171Ab1EEKS4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 06:18:56 -0400
Date: Thu, 5 May 2011 12:18:42 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>, werner <w.landgraf@ru.ru>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [block IO crash] Re: 2.6.39-rc5-git2 boot crashs
Message-ID: <20110505101842.GA25761@elte.hu>
References: <BANLkTinLn-59oisLrvwyCvyUuNyDKVHP0g@mail.gmail.com>
 <alpine.DEB.2.00.1105041341550.5495@router.home>
 <BANLkTikEgDGt+KrBsZcinKVom5E63Ma6gg@mail.gmail.com>
 <alpine.DEB.2.00.1105041421280.5495@router.home>
 <BANLkTi=efcVkGb+DReZ+i1p5j4QXJYjKjQ@mail.gmail.com>
 <alpine.DEB.2.00.1105041454190.5495@router.home>
 <BANLkTik7AHGr7+BG8nE16j-ayctD0LOH=w@mail.gmail.com>
 <BANLkTimvxOMuPJ0W0npo5i3gwFqdRw74Pw@mail.gmail.com>
 <alpine.LFD.2.02.1105042325500.3005@ionos>
 <20110505095421.GD30950@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110505095421.GD30950@htj.dyndns.org>
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


* Tejun Heo <tj@kernel.org> wrote:

> 2. Make irq toggling as cheap as preemption toggling.  This can be
>    achieved by implementing IRQ masking in software.  I played with it
>    a bit on x86 last year.  I didn't get to finish it and it would
>    have taken me some time to iron out weird failures but it didn't
>    seem too difficult and as irq on/off is quite expensive on a lot of
>    CPUs, this might bring overall performance benefit.
> 
> For many archs, #2 would be the only choice and if we're gonna do that I 
> think it would be best to do it on x86 too.  It involves changes to common 
> code too and x86 has the highest test/development coverage.

We played with this in -rt on and off but note that -rt doesnt do this right 
now. Interestingly, most of the irq-disable wrappery and state tracking code 
for that is upstream already, via the lockdep irq state tracking patches. 
(Surprise! :-)

The disadvantages:

 - register pressure increases, the pushf+cli+popf sequence has no register
   side-effects, while soft flags inevitably disturb register allocations. 
   *possibly* quite low with the modern percpu implementation, but this has
   to be measured very carefuly, with disassembly.

 - icache size increases - the percpu ops are larger than the minimal 
   pushf+cli+popfl sequence. Again, this too has to be measured both via 
   vmlinux size analysis and via perf stat --repeat icache pressure runs.

   [ This is also an assymetric cost: it increases the cost of the cache-cold
     case, while most of the benefits are in the cache-hot case. ]

 - irq replay becomes common and there's extra cost due to that. Also we are
   not ready to replay some types of irqs (lapic timer), at least with current
   code. So there's some ongoing maintenance cost there.

The benefits are:

 - lockdep is already tracking irqs on/off sections rather carefully, so we know
   all the places that play with irqs and the ongoing maintenance cost is 
   shared with what we'd have to do with lockdep anyway.

 - on Nehalem a "PUSHF; CLI; POPF" sequence is 18 cycles, a soft sequence would
   be more like 2 cycles. So we win around 15 cycles per sequence in the fast
   path - minus collateral slowpath cost above ... which are not directly 
   comparable.

 - Stock mainline would become a truly hard RT irq handlers kernel which never
   ever disables hardirqs. Big wow factor and precision guided, laser mounted 
   sharks!

I probably missed a few factors, but these are the main concerns.

My firm judgement: "Dunno".

Thanks,

	Ingo
