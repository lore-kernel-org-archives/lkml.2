Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932098Ab0ESNA6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 09:00:58 -0400
Received: from casper.infradead.org ([85.118.1.10]:46830 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753306Ab0ESNA4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 09:00:56 -0400
Subject: Re: [PATCH v3] ad7877: keep dma rx buffers in seperate cache lines
From: David Woodhouse <dwmw2@infradead.org>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Matt Mackall <mpm@selenic.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Oskar Schirmer <os@emlix.com>,
       Michael Hennerich <Michael.Hennerich@analog.com>,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       Daniel =?ISO-8859-1?Q?Gl=F6ckner?= <dg@emlix.com>,
       Oliver Schneidewind <osw@emlix.com>, Johannes Weiner <jw@emlix.com>,
       Nick Piggin <npiggin@suse.de>, David Rientjes <rientjes@google.com>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Grant Likely <grant.likely@secretlab.ca>
In-Reply-To: <AANLkTimzxrZyQAfocTwIt5zCVyXP7bReKOvP4K7m8epO@mail.gmail.com>
References: <1273487642-2169-1-git-send-email-os@emlix.com>
	 <AANLkTiktu7N5IXknkkJ9D5L4z5plhuGvD45IVqJm9zG1@mail.gmail.com>
	 <20100511063309.GC9644@core.coreip.homeip.net>
	 <y2k84144f021005102342m18bce930g53599c9112565f78@mail.gmail.com>
	 <AANLkTinV79HZqS1cktHDsTsHDel-0Nti_Uk4i7mGaRiK@mail.gmail.com>
	 <1273608441.15067.1002.camel@calx>
	 <AANLkTimt-eRCt_HTq7OUwzG1dgRuzJHk1tlgOcq4ocL7@mail.gmail.com>
	 <alpine.DEB.2.00.1005111520260.1500@router.home>
	 <AANLkTilEfZLWYxPmCQ1KHIvUGIF_8Qchali66wHNf2gB@mail.gmail.com>
	 <alpine.DEB.2.00.1005111544330.8388@router.home>
	 <AANLkTimzxrZyQAfocTwIt5zCVyXP7bReKOvP4K7m8epO@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 19 May 2010 14:00:23 +0100
Message-ID: <1274274023.6930.10047.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-05-11 at 16:54 -0400, Mike Frysinger wrote:
> 
> > kmalloc returns a pointer to a DMA safe buffer. There is no requirement on
> > the x86 hardware that the DMA buffers have to be cache aligned. Cachelines
> > will be invalidated as needed.
> 
> so this guarantee is made by the kmalloc() API ?  and for arches where
> the cacheline invalidation is handled in software rather than
> hardware, they must declare a min alignment value for kmalloc to be at
> least as big as their cache alignment ?
> 
> does the phrase "DMA safe buffer" imply cache alignment ? 

Not necessarily. If you have cache-coherent DMA, then there's no need to
align things. You only need cache-alignment when you have
cache-incoherent DMA and have to manage the cache in software. And in
that case, the architecture must set ARCH_KMALLOC_MINALIGN to an
appropriate value so that kmalloc() meets the guarantee.

However, your problem is kind of unrelated to that -- your problem is
actually that you're putting both a DMA buffer _and_ other stuff into
the same kmalloc'd buffer. Don't do that. Instead, allocate your DMA
buffer separately and put a _pointer_ to it into the structure.

Or if you really _must_ include it in your structure, then align to
ARCH_KMALLOC_MINALIGN bytes both before and after the DMA buffer by
adding __attribute__((__aligned__(ARCH_KMALLOC_MINALIGN))) to both the
DMA buffer _and_ the element which follows it in your struct (if any).

Using ____cacheline_aligned wastes a lot of space on the architectures
that don't need it.

Arguably, this __dma_aligned definition should go somewhere generic...

diff --git a/drivers/input/touchscreen/ad7877.c b/drivers/input/touchscreen/ad7877.c
index 0d2d7e5..ae5d56e 100644
--- a/drivers/input/touchscreen/ad7877.c
+++ b/drivers/input/touchscreen/ad7877.c
@@ -151,6 +151,11 @@ enum {
 /*
  * Non-touchscreen sensors only use single-ended conversions.
  */
+#ifdef ARCH_KMALLOC_MINALIGN
+#define __dma_aligned __attribute__((__aligned__(ARCH_KMALLOC_MINALIGN)))
+#else
+#define __dma_aligned
+#endif
 
 struct ser_req {
 	u16			reset;
@@ -163,7 +168,7 @@ struct ser_req {
 	 * DMA (thus cache coherency maintenance) requires the
 	 * transfer buffers to live in their own cache lines.
 	 */
-	u16 sample ____cacheline_aligned;
+	u16 sample __dma_aligned;
 };
 
 struct ad7877 {
@@ -203,7 +208,7 @@ struct ad7877 {
 	 * DMA (thus cache coherency maintenance) requires the
 	 * transfer buffers to live in their own cache lines.
 	 */
-	u16 conversion_data[AD7877_NR_SENSE] ____cacheline_aligned;
+	u16 conversion_data[AD7877_NR_SENSE] __dma_aligned;
 };
 
 static int gpio3;


-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

