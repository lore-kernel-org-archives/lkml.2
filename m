Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754189Ab1EDOVh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 10:21:37 -0400
Received: from www.linutronix.de ([62.245.132.108]:51955 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753883Ab1EDOVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 10:21:35 -0400
Date: Wed, 4 May 2011 16:21:10 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Christoph Lameter <cl@linux.com>
cc: Pekka Enberg <penberg@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>, werner <w.landgraf@ru.ru>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [block IO crash] Re: 2.6.39-rc5-git2 boot crashs
In-Reply-To: <alpine.DEB.2.00.1105040902210.5495@router.home>
Message-ID: <alpine.LFD.2.02.1105041610590.3005@ionos>
References: <web-516671337@zbackend1.aha.ru> <BANLkTikFqF1vzMq3L9zDB=MDnCOFYp+XEQ@mail.gmail.com> <web-516990066@zbackend1.aha.ru> <BANLkTinCKC23WfG7jnd-ihW9kXz-6SEgFQ@mail.gmail.com> <20110503190822.GA20520@elte.hu> <BANLkTi=6_oXX1BM5O3kJ6bVevh9=ydjj3g@mail.gmail.com>
 <20110504083559.GB25724@elte.hu> <alpine.LFD.2.02.1105041124080.3005@ionos> <20110504101932.GA3392@elte.hu> <alpine.LFD.2.02.1105041233280.3005@ionos> <BANLkTinxe=gSERoOHOohb1V-CZ0c9BSy2Q@mail.gmail.com> <alpine.DEB.2.00.1105040902210.5495@router.home>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 May 2011, Christoph Lameter wrote:
>
> The above should not happen. If a kernel config indicates that there is no
> cmpxchg16b/cmpxchg8b available then we need to not compile the path that
> uses cmpxchg8b/cmpxchg16b. Guess we need CMPXCHG_DOUBLE_LOCAL or so.

Oh no, you have perfectly fine replacements for that in percpu.h with
irqsafe and preempt safe versions. So why adding another CONFIG from
hell which creates even more ifdef mess ?

The whole CONFIG_CMPXCHG_LOCAL ifdeffery in slub.c is horrible and I
think it's not necessary at all for two reasons:

1) irqsafe_cpu_cmpxchg() can be emulated cheap and we still have the
   advantatage of shorter irq disabled sections. And the difference
   between the current CONFIG_CMPXCHG_LOCAL=n and using the emulation
   macros with the short irqsave/restore around the access is probably
   not measurable at all.

2) that would actually test the code under all possible combinations
   and not splitting the tester base into x86 and !x86. So that bug
   would have been avoided in the first place.

Thanks,

	tglx
