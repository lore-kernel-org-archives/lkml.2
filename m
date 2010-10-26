Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759292Ab0JZCzX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 22:55:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4314 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751159Ab0JZCzU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 22:55:20 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 24/43] MN10300: Make the boot wrapper able to use writeback
 caching
To: linux-am33-list@redhat.com
From: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Akira Takeuchi <takeuchi.akr@jp.panasonic.com>,
        Kiyoshi Owada <owada.kiyoshi@jp.panasonic.com>
Date: Tue, 26 Oct 2010 03:55:09 +0100
Message-ID: <20101026025509.23512.307.stgit@warthog.procyon.org.uk>
In-Reply-To: <20101026025301.23512.24525.stgit@warthog.procyon.org.uk>
References: <20101026025301.23512.24525.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.15-97-g9680-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Akira Takeuchi <takeuchi.akr@jp.panasonic.com>

Make the boot wrapper able to use writeback caching, including flushing the
cache before jumping to the main kernel.

Signed-off-by: Akira Takeuchi <takeuchi.akr@jp.panasonic.com>
Signed-off-by: Kiyoshi Owada <owada.kiyoshi@jp.panasonic.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/mn10300/boot/compressed/head.S |   49 ++++++++++++++++++++++++++++++++++-
 1 files changed, 48 insertions(+), 1 deletions(-)


diff --git a/arch/mn10300/boot/compressed/head.S b/arch/mn10300/boot/compressed/head.S
index 502e1eb..4ef608a 100644
--- a/arch/mn10300/boot/compressed/head.S
+++ b/arch/mn10300/boot/compressed/head.S
@@ -14,6 +14,7 @@
 
 #include <linux/linkage.h>
 #include <asm/cpu-regs.h>
+#include <asm/cache.h>
 
 	.globl startup_32
 startup_32:
@@ -37,8 +38,15 @@ startup_32:
 	mov	(a0),d0
 	btst	CHCTR_ICBUSY|CHCTR_DCBUSY,d0		# wait till not busy
 	lne
-	mov	CHCTR_ICEN|CHCTR_DCEN|CHCTR_DCWTMD,d0	# writethru dcache
+
+#ifdef CONFIG_MN10300_CACHE_ENABLED
+#ifdef CONFIG_MN10300_CACHE_WBACK
+	mov	CHCTR_ICEN|CHCTR_DCEN|CHCTR_DCWTMD_WRBACK,d0
+#else
+	mov	CHCTR_ICEN|CHCTR_DCEN|CHCTR_DCWTMD_WRTHROUGH,d0
+#endif /* WBACK */
 	movhu	d0,(a0)					# enable
+#endif /* !ENABLED */
 
 	# clear the BSS area
 	mov	__bss_start,a0
@@ -54,6 +62,9 @@ bssclear_end:
 
 	# decompress the kernel
 	call	decompress_kernel[],0
+#ifdef CONFIG_MN10300_CACHE_WBACK
+	call	mn10300_dcache_flush_inv[],0
+#endif
 
 	# disable caches again
 	mov	CHCTR,a0
@@ -69,10 +80,46 @@ bssclear_end:
 	mov	(4,a0),d1
 	mov	(8,a0),d2
 
+	# jump to the kernel proper entry point
 	mov	a3,sp
 	mov	CONFIG_KERNEL_TEXT_ADDRESS,a0
 	jmp	(a0)
 
+
+###############################################################################
+#
+# Cache flush routines
+#
+###############################################################################
+#ifdef CONFIG_MN10300_CACHE_WBACK
+mn10300_dcache_flush_inv:
+	movhu	(CHCTR),d0
+	btst	CHCTR_DCEN,d0
+	beq	mn10300_dcache_flush_inv_end
+
+	mov	L1_CACHE_NENTRIES,d1
+	clr	a1
+
+mn10300_dcache_flush_inv_loop:
+	mov	(DCACHE_PURGE_WAY0(0),a1),d0	# unconditional purge
+	mov	(DCACHE_PURGE_WAY1(0),a1),d0	# unconditional purge
+	mov	(DCACHE_PURGE_WAY2(0),a1),d0	# unconditional purge
+	mov	(DCACHE_PURGE_WAY3(0),a1),d0	# unconditional purge
+
+	add	L1_CACHE_BYTES,a1
+	add	-1,d1
+	bne	mn10300_dcache_flush_inv_loop
+
+mn10300_dcache_flush_inv_end:
+	ret	[],0
+#endif /* CONFIG_MN10300_CACHE_WBACK */
+
+
+###############################################################################
+#
+# Data areas
+#
+###############################################################################
 	.data
 	.align		4
 param_save_area:

