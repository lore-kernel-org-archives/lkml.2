Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756552Ab0EQWh5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 18:37:57 -0400
Received: from waste.org ([173.11.57.241]:37388 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756536Ab0EQWhz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 18:37:55 -0400
Subject: Re: [BUG] SLOB breaks Crypto
From: Matt Mackall <mpm@selenic.com>
To: Adrian-Ken Rueegsegger <ken@codelabs.ch>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
       Herbert Xu <herbert@gondor.hengli.com.au>, michael-dev@fami-braun.de,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       linux-crypto@vger.kernel.org, Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <4BF1BA0E.4010402@codelabs.ch>
References: <4B9E38AF.70309@fami-braun.de>
	 <84144f021003180930s44e239dfmb38183096f07c8a8@mail.gmail.com>
	 <4BA29A19.2050307@fami-braun.de>
	 <20100319003351.GC20227@gondor.apana.org.au>
	 <AANLkTilPEnh3ewTb-KDsReBpjcszh1wkbfZohIaPXBKe@mail.gmail.com>
	 <4BF1BA0E.4010402@codelabs.ch>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 17 May 2010 17:37:49 -0500
Message-ID: <1274135869.11603.473.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-05-17 at 23:50 +0200, Adrian-Ken Rueegsegger wrote:
> Geert Uytterhoeven wrote:
> > On Fri, Mar 19, 2010 at 02:33, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> >> On Thu, Mar 18, 2010 at 10:24:41PM +0100, michael-dev@fami-braun.de wrote:
> >>> Pekka Enberg schrieb:
> >>>> Even with CONFIG_DEBUG_SLAB enabled or with CONFIG_SLUB and
> >>>> CONFIG_SLUB_DEBUG_ON?
> >>> no, these options have not been / are not enabled.
> >> Can you please try it with those options enabled? That will tell
> >> us if there is some latent bug in the crypto layer that only shows
> >> up right away under SLOB.
> > 
> > After seeing a posting from Nemoto-san on the linux-mips list (should
> > show up soon on
> > http://www.linux-mips.org/archives/linux-mips/2010-05/threads.html),
> > I'm wondering if these defaults are the culprit;
> > 
> > mm/slab.c:#define ARCH_KMALLOC_MINALIGN __alignof__(unsigned long long)
> > mm/slob.c:#define ARCH_KMALLOC_MINALIGN __alignof__(unsigned long)
> > mm/slub.c:#define ARCH_KMALLOC_MINALIGN __alignof__(unsigned long long)

Seems the target here is x86, which has no DMA or other alignment
constraints.

> Just a quick note: I changed this line in mm/slob.c to (unsigned long
> long) and was able to load tcrypt without the kernel oopsing or
> panic'ing. When running all test via
> 
> modprobe tcrypt

Hmmm, sounds like something in crypto has a bogus alignment/padding
expectation. Surprised it wasn't caught by SLAB redzoning though.
Perhaps we can 'bisect' the test suite to narrow it down to a particular
test. Alternately, we can tweak SLAB to offset buffers by two bytes and
see what breaks.

Ages ago, I had a simple redzoning patch for SLOB, but I never submitted
it: I wrote it to catch bugs in SLOB, not bugs in SLOB users.

-- 
Mathematics is the supreme nostalgia of our time.


