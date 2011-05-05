Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753608Ab1EEKpm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 06:45:42 -0400
Received: from www.linutronix.de ([62.245.132.108]:60820 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753502Ab1EEKpl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 06:45:41 -0400
Date: Thu, 5 May 2011 12:45:14 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Tejun Heo <tj@kernel.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>, werner <w.landgraf@ru.ru>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [block IO crash] Re: 2.6.39-rc5-git2 boot crashs
In-Reply-To: <20110505095421.GD30950@htj.dyndns.org>
Message-ID: <alpine.LFD.2.02.1105051210490.3005@ionos>
References: <BANLkTimdL_tAONUWxZ4sQn1AiPDdbdYqpw@mail.gmail.com> <BANLkTinLn-59oisLrvwyCvyUuNyDKVHP0g@mail.gmail.com> <alpine.DEB.2.00.1105041341550.5495@router.home> <BANLkTikEgDGt+KrBsZcinKVom5E63Ma6gg@mail.gmail.com> <alpine.DEB.2.00.1105041421280.5495@router.home>
 <BANLkTi=efcVkGb+DReZ+i1p5j4QXJYjKjQ@mail.gmail.com> <alpine.DEB.2.00.1105041454190.5495@router.home> <BANLkTik7AHGr7+BG8nE16j-ayctD0LOH=w@mail.gmail.com> <BANLkTimvxOMuPJ0W0npo5i3gwFqdRw74Pw@mail.gmail.com> <alpine.LFD.2.02.1105042325500.3005@ionos>
 <20110505095421.GD30950@htj.dyndns.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 May 2011, Tejun Heo wrote:
> 2. Make irq toggling as cheap as preemption toggling.  This can be
>    achieved by implementing IRQ masking in software.  I played with it
>    a bit on x86 last year.  I didn't get to finish it and it would
>    have taken me some time to iron out weird failures but it didn't
>    seem too difficult and as irq on/off is quite expensive on a lot of
>    CPUs, this might bring overall performance benefit.
> 
> For many archs, #2 would be the only choice and if we're gonna do that
> I think it would be best to do it on x86 too.  It involves changes to
> common code too and x86 has the highest test/development coverage.
> 
> I don't feel brave enough to remove preemption protected ones without
> first somehow taking care of non-x86 archs.  The preemption disabled
> ones are used for statistics in net, block, irq and fs and simply
> switching to irq protected ones is likely to noticeably hurt many
> non-x86 archs.  Maybe the ones which really matter can implement at
> least _add() and we can get away without doing soft irq masking.

There it's fine when we have certain use cases which just need
preemption protection, but the function name should be clear about it
and we should only have the functions which are actually required
instead of every possible flavour of _OP.
 
> Anyways, that's what I've been thinking.  I'll get to it in the next
> devel cycle or the one after that.  What do you guys think about soft
> irq masking idea?

It's doable, we played around with that in rt already and put it aside
again :)

You need to do the check at the vector entry and then reinject the
vector on local_irq_enable/restore(), so that's mostly hackery in the
ASM entry code which includes to fixup the pushed flags so the reti
wont reeneable interrupts.

That's halfways easy to do on x86, not sure about other architectures,
and you have to carefully weigh the actual benefit against the
overhead in the slow path case plus the inevitable hackery you need in
each architecture implementation.

No strong opinion, but definitely worthwhile to toy with it :)

Thanks,

	tglx
