Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754872Ab1EDStP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 14:49:15 -0400
Received: from smtp108.prem.mail.ac4.yahoo.com ([76.13.13.47]:29316 "HELO
	smtp108.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752992Ab1EDStO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 14:49:14 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: p258ytQVM1nEpxDF5fE8pD5TgoBq00FWZE202w.IzZu4A1H
 dL9qlUI8Qfg.9vjj6VoeHced6k.pRFN0KZWXP1jc_WaCQRQYs4hkzHRLhjhe
 nFN4nRc97BwfwuI.CN2b6gFNo0oOBkshoOsdG1XbPQDCwsi1EjoK4cgCUy_e
 qjJrsK7T4eGyNKZZdwA5.2M7gvpGXsfYqXKt2d3yQqVrZ904pJpS82AEj9US
 MuHsvOX98cbygNrF7WsCTzKJEqoMYOKlEbMiELBGAXiD0CQ3VpnbCFaUSu2o
 OnseqN7gcjk2sDITeESqsQTyPU2wU58IlIKVEp7mGH4v.e5CH
X-Yahoo-Newman-Property: ymail-3
Date: Wed, 4 May 2011 13:49:09 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Pekka Enberg <penberg@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>, werner <w.landgraf@ru.ru>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [block IO crash] Re: 2.6.39-rc5-git2 boot crashs
In-Reply-To: <BANLkTinLn-59oisLrvwyCvyUuNyDKVHP0g@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1105041341550.5495@router.home>
References: <BANLkTi=6_oXX1BM5O3kJ6bVevh9=ydjj3g@mail.gmail.com> <20110504083559.GB25724@elte.hu> <alpine.LFD.2.02.1105041124080.3005@ionos> <20110504101932.GA3392@elte.hu> <alpine.LFD.2.02.1105041233280.3005@ionos> <BANLkTinxe=gSERoOHOohb1V-CZ0c9BSy2Q@mail.gmail.com>
 <20110504112746.GE8007@htj.dyndns.org> <alpine.LFD.2.02.1105041417330.3005@ionos> <20110504132022.GA17294@htj.dyndns.org> <alpine.LFD.2.02.1105041539050.3005@ionos> <20110504142532.GC17294@htj.dyndns.org> <alpine.LFD.2.02.1105041640020.3005@ionos>
 <alpine.DEB.2.00.1105040958570.5495@router.home> <BANLkTikiAqcJVoJRJ6oy+LwPJPz+mHNj_w@mail.gmail.com> <alpine.DEB.2.00.1105041023070.5495@router.home> <BANLkTik52Fi=vHY-TiK6SAYrWjaSN=PB+g@mail.gmail.com> <BANLkTimdL_tAONUWxZ4sQn1AiPDdbdYqpw@mail.gmail.com>
 <BANLkTinLn-59oisLrvwyCvyUuNyDKVHP0g@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 May 2011, Linus Torvalds wrote:

>
> So I'm still waiting for the tested-by, but in the meantime I wrote a
> changelog. And part of that changelog reads:
>
> [ Btw, that whole "generic code defaults to no protection" design just
>   sounds stupid - if the code needs no protection, there is no reason to
>   use "cmpxchg_double" to begin with.  So we should probably just remove
>   the unprotected version entirely as pointless.   - Linus ]

The unprotected version is the __this_cpu_cmpxchg_double? That currently
has no user and could be removed. But all other functions also have __
variants so it was put there for symmetries sake.

> which really sums up the whole thing.
>
> The current "this_cpu_cmpxchg_double()" implementation is just
> incredibly idiotic. There is absolutely _no_ point to having that
> function at all. Why does it exist?

this_cpu_cmpxchg_double() affords protection against preemption but not
irqs. In the allocator case we have to deal with interrupts so its not
useful there. Other code that can guarantee that nothing runs from irq
context can use this function and then the fallback handling on other
arches can avoid disabling and enabling interrupts which is required by
irqsafe_cpu_cmpxchg_double().

> I can kind of see the point of the "preempt" version, although I'm not
> entirely convinced of that either. But the notion of having a
> "cmpxchg" function that isn't atomic even on a single CPU just makes
> me go "f*ck that, whoever wrote that is just a moron".
>
> If the function doesn't need atomicity, you're really better off just
> writing it out.  It's going to be faster on pretty much all
> architectures using just regular load/store instructions.

The unlocked cmpxchg8b/16b is quite fast on x86. The __ function allows
the use of cmpxchg8b on x86 and the fallback (and therefore longer) code
on other archs.

But I see the point that __this_cpu_cmpxchg double is pretty useless.
There is no user and so it could be removed.
