Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755230Ab1EDTab (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 15:30:31 -0400
Received: from smtp107.prem.mail.ac4.yahoo.com ([76.13.13.46]:24950 "HELO
	smtp107.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753973Ab1EDTaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 15:30:30 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: mlPxpz0VM1k2pLz0ZJST277Haz8CycH1mHKKNeYt8wNh1TI
 uwJ9wtWpwwL_7cBtEYaWkmohxKriqP24VKmWhuusKvU563rr1uDabZ7mylBu
 ysXe0lOcpZO0jL0z_P.TN9nfF19SNS9Rb2Vmllp4_98pq_xqRNXALsO9Y8Px
 jfFv05eEnnB287Qr32jOrt12woDRXNB7OOfSUeeH0q3MovhypxA0mn_mXrum
 n22aS.i937C8V0kVvvcf5F1t7Is9_yheL3p.eqCaUE8WMDkARlf0gTZaCSs9
 Ev9sD1KhNyyoepKHjda5pGH5iQQKxJ9Grqrf13WwEGaGQS24FjcYFZmHBGj4
 q9R9B5WRCfmJ8goIV2Yg8u.QB
X-Yahoo-Newman-Property: ymail-3
Date: Wed, 4 May 2011 14:30:26 -0500 (CDT)
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
In-Reply-To: <BANLkTikEgDGt+KrBsZcinKVom5E63Ma6gg@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1105041421280.5495@router.home>
References: <BANLkTi=6_oXX1BM5O3kJ6bVevh9=ydjj3g@mail.gmail.com> <20110504083559.GB25724@elte.hu> <alpine.LFD.2.02.1105041124080.3005@ionos> <20110504101932.GA3392@elte.hu> <alpine.LFD.2.02.1105041233280.3005@ionos> <BANLkTinxe=gSERoOHOohb1V-CZ0c9BSy2Q@mail.gmail.com>
 <20110504112746.GE8007@htj.dyndns.org> <alpine.LFD.2.02.1105041417330.3005@ionos> <20110504132022.GA17294@htj.dyndns.org> <alpine.LFD.2.02.1105041539050.3005@ionos> <20110504142532.GC17294@htj.dyndns.org> <alpine.LFD.2.02.1105041640020.3005@ionos>
 <alpine.DEB.2.00.1105040958570.5495@router.home> <BANLkTikiAqcJVoJRJ6oy+LwPJPz+mHNj_w@mail.gmail.com> <alpine.DEB.2.00.1105041023070.5495@router.home> <BANLkTik52Fi=vHY-TiK6SAYrWjaSN=PB+g@mail.gmail.com> <BANLkTimdL_tAONUWxZ4sQn1AiPDdbdYqpw@mail.gmail.com>
 <BANLkTinLn-59oisLrvwyCvyUuNyDKVHP0g@mail.gmail.com> <alpine.DEB.2.00.1105041341550.5495@router.home> <BANLkTikEgDGt+KrBsZcinKVom5E63Ma6gg@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 May 2011, Linus Torvalds wrote:

> On Wed, May 4, 2011 at 11:49 AM, Christoph Lameter <cl@linux.com> wrote:
> >
> > The unprotected version is the __this_cpu_cmpxchg_double? That currently
> > has no user and could be removed. But all other functions also have __
> > variants so it was put there for symmetries sake.
>
> No, I'm talking about the regular "this_cpu_cmpxchg_double" with no underscores.
>
> Why the f*!@ does that exist?

Because it is useful if the per cpu serialization only requires
safety from preemption during the cmpxchg.

> Why the f*%^ do you have to write "irqsafe", when the whole concept
> DOES NOT MAKE SENSE without the "irqsafe"?

Because that is how the other irq safe this_cpu_xxx functions are named
and I tried to keep it consistent.

> I think we should remove every single version of
> "this_cpu_cmpxchg_double" except for two: the per-cpu one and the
> SMP-safe one.

The smp safe one would be cmpxchg_double() then. This is part of a future
patchset and would be named like other fully atomic ops. Would not be part
of include/linux/percpu.h because it is not a per cpu related function.

> And the per-cpu one doesn't mention "irqsafe" or "preempt" or anything
> like that, because the whole function makes no sense except when it is
> irq-safe and preempt-safe.

It does make sense because arches that do not have the hardware
capabilities must use fallback implementations that can be faster if f.e.
irqs must not be disabled. And this_cpu_xxx ops are usually used in
performance critical paths.

> So I think the fact that we need to say "irqsafe" is a bug. Plain and simple.
>
> The whole (and ONLY) point of "cmpxchg" is atomicity.
>
> This is not like "add one to something". That's an operation that
> makes sense outside of atomicity issues. But "cmpxchg" is all about
> being atomic.

The naming convention came about from the existing this_cpu_xxx
operations (and yes those starting with the problem of the increment). To
do it differently now just for this function would make it more difficult
to comprehend for someone already familiar with  this_cpu
operations on per cpu data.

