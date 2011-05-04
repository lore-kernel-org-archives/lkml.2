Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755241Ab1EDTIg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 15:08:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39177 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754387Ab1EDTIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 15:08:34 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1105041341550.5495@router.home>
References: <BANLkTi=6_oXX1BM5O3kJ6bVevh9=ydjj3g@mail.gmail.com>
 <20110504083559.GB25724@elte.hu> <alpine.LFD.2.02.1105041124080.3005@ionos>
 <20110504101932.GA3392@elte.hu> <alpine.LFD.2.02.1105041233280.3005@ionos>
 <BANLkTinxe=gSERoOHOohb1V-CZ0c9BSy2Q@mail.gmail.com> <20110504112746.GE8007@htj.dyndns.org>
 <alpine.LFD.2.02.1105041417330.3005@ionos> <20110504132022.GA17294@htj.dyndns.org>
 <alpine.LFD.2.02.1105041539050.3005@ionos> <20110504142532.GC17294@htj.dyndns.org>
 <alpine.LFD.2.02.1105041640020.3005@ionos> <alpine.DEB.2.00.1105040958570.5495@router.home>
 <BANLkTikiAqcJVoJRJ6oy+LwPJPz+mHNj_w@mail.gmail.com> <alpine.DEB.2.00.1105041023070.5495@router.home>
 <BANLkTik52Fi=vHY-TiK6SAYrWjaSN=PB+g@mail.gmail.com> <BANLkTimdL_tAONUWxZ4sQn1AiPDdbdYqpw@mail.gmail.com>
 <BANLkTinLn-59oisLrvwyCvyUuNyDKVHP0g@mail.gmail.com> <alpine.DEB.2.00.1105041341550.5495@router.home>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 4 May 2011 12:07:42 -0700
Message-ID: <BANLkTikEgDGt+KrBsZcinKVom5E63Ma6gg@mail.gmail.com>
Subject: Re: [block IO crash] Re: 2.6.39-rc5-git2 boot crashs
To: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>, werner <w.landgraf@ru.ru>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 4, 2011 at 11:49 AM, Christoph Lameter <cl@linux.com> wrote:
>
> The unprotected version is the __this_cpu_cmpxchg_double? That currently
> has no user and could be removed. But all other functions also have __
> variants so it was put there for symmetries sake.

No, I'm talking about the regular "this_cpu_cmpxchg_double" with no underscores.

Why the f*!@ does that exist?

Why the f*%^ do you have to write "irqsafe", when the whole concept
DOES NOT MAKE SENSE without the "irqsafe"?

Why did we have this bug in the first place, in other words? The whole
interface was mis-designed, and pretty much designed to cause bugs.

I think we should remove every single version of
"this_cpu_cmpxchg_double" except for two: the per-cpu one and the
SMP-safe one.

And the per-cpu one doesn't mention "irqsafe" or "preempt" or anything
like that, because the whole function makes no sense except when it is
irq-safe and preempt-safe.

So I think the fact that we need to say "irqsafe" is a bug. Plain and simple.

The whole (and ONLY) point of "cmpxchg" is atomicity.

This is not like "add one to something". That's an operation that
makes sense outside of atomicity issues. But "cmpxchg" is all about
being atomic.

                                       Linus
