Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753007Ab0F3CKR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 22:10:17 -0400
Received: from sh.osrg.net ([192.16.179.4]:54312 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752363Ab0F3CKP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 22:10:15 -0400
Date: Wed, 30 Jun 2010 11:10:08 +0900
To: cmetcalf@tilera.com
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] tile: set ARCH_KMALLOC_MINALIGN
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <4C2A0592.50709@tilera.com>
References: <20100629164117Z.fujita.tomonori@lab.ntt.co.jp>
	<4C2A0592.50709@tilera.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100630110749V.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Wed, 30 Jun 2010 11:10:09 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Jun 2010 10:39:14 -0400
Chris Metcalf <cmetcalf@tilera.com> wrote:

> This sounds OK.   The TILE-Gx chip does coherent DMA, so won't need
> this, I assume?  If you want to guard this suitably, you can add
> "#ifndef __tilegx__" around it and add a comment that TILE-Gx has
> coherent IO.  Thanks.

On Tue, 29 Jun 2010 10:39:14 -0400
Chris Metcalf <cmetcalf@tilera.com> wrote:

> This sounds OK.   The TILE-Gx chip does coherent DMA, so won't need
> this, I assume?

Yeah, if it's fully coherent (the hardware guarantees that the data in
the CPU cache and data in main memory is always identical), you don't
need.

> If you want to guard this suitably, you can add
> "#ifndef __tilegx__" around it and add a comment that TILE-Gx has
> coherent IO.  Thanks.

Ok, here's the second version.

Can I assume that you'll merge the patch into your git tree on
kernel.org?


=
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] tile: set ARCH_KMALLOC_MINALIGN

Architectures that handle DMA-non-coherent memory need to set
ARCH_KMALLOC_MINALIGN to make sure that kmalloc'ed buffer is DMA-safe:
the buffer doesn't share a cache with the others.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/tile/include/asm/cache.h |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/tile/include/asm/cache.h b/arch/tile/include/asm/cache.h
index ee59714..869a14f 100644
--- a/arch/tile/include/asm/cache.h
+++ b/arch/tile/include/asm/cache.h
@@ -31,6 +31,14 @@
 #define L2_CACHE_BYTES		(1 << L2_CACHE_SHIFT)
 #define L2_CACHE_ALIGN(x)	(((x)+(L2_CACHE_BYTES-1)) & -L2_CACHE_BYTES)
 
+/*
+ * TILE-Gx is fully coherents so we don't need to define
+ * ARCH_KMALLOC_MINALIGN.
+ */
+#ifndef __tilegx__
+#define ARCH_KMALLOC_MINALIGN	L2_CACHE_BYTES
+#endif
+
 /* use the cache line size for the L2, which is where it counts */
 #define SMP_CACHE_BYTES_SHIFT	L2_CACHE_SHIFT
 #define SMP_CACHE_BYTES		L2_CACHE_BYTES
-- 
1.6.5

