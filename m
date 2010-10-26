Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932927Ab0JZC4H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 22:56:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39192 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932676Ab0JZC4C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 22:56:02 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 32/43] MN10300: Optimise do_csum()
To: linux-am33-list@redhat.com
From: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Akira Takeuchi <takeuchi.akr@jp.panasonic.com>,
        Kiyoshi Owada <owada.kiyoshi@jp.panasonic.com>
Date: Tue, 26 Oct 2010 03:55:52 +0100
Message-ID: <20101026025552.23512.17136.stgit@warthog.procyon.org.uk>
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

Optimise do_csum() to gang up the loads so they're less likely to get
interruptions between.

Signed-off-by: Akira Takeuchi <takeuchi.akr@jp.panasonic.com>
Signed-off-by: Kiyoshi Owada <owada.kiyoshi@jp.panasonic.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/mn10300/lib/do_csum.S |   49 ++++++++++++++++++++------------------------
 1 files changed, 22 insertions(+), 27 deletions(-)


diff --git a/arch/mn10300/lib/do_csum.S b/arch/mn10300/lib/do_csum.S
index e138994..1d27bba 100644
--- a/arch/mn10300/lib/do_csum.S
+++ b/arch/mn10300/lib/do_csum.S
@@ -10,26 +10,25 @@
  */
 #include <asm/cache.h>
 
-        .section .text
-        .balign	L1_CACHE_BYTES
+	.section .text
+	.balign	L1_CACHE_BYTES
 
 ###############################################################################
 #
-# unsigned int do_csum(const unsigned char *buff, size_t len)
+# unsigned int do_csum(const unsigned char *buff, int len)
 #
 ###############################################################################
 	.globl	do_csum
-        .type	do_csum,@function
+	.type	do_csum,@function
 do_csum:
 	movm	[d2,d3],(sp)
-	mov	d0,(12,sp)
-	mov	d1,(16,sp)
 	mov	d1,d2				# count
 	mov	d0,a0				# buff
+	mov	a0,a1
 	clr	d1				# accumulator
 
 	cmp	+0,d2
-	beq	do_csum_done			# return if zero-length buffer
+	ble	do_csum_done			# check for zero length or negative
 
 	# 4-byte align the buffer pointer
 	btst	+3,a0
@@ -41,17 +40,15 @@ do_csum:
 	inc	a0
 	asl	+8,d0
 	add	d0,d1
-	addc	+0,d1
 	add	-1,d2
-do_csum_addr_not_odd:
 
+do_csum_addr_not_odd:
 	cmp	+2,d2
 	bcs	do_csum_fewer_than_4
 	btst	+2,a0
 	beq	do_csum_now_4b_aligned
 	movhu	(a0+),d0
 	add	d0,d1
-	addc	+0,d1
 	add	-2,d2
 	cmp	+4,d2
 	bcs	do_csum_fewer_than_4
@@ -66,20 +63,20 @@ do_csum_now_4b_aligned:
 
 do_csum_loop:
 	mov	(a0+),d0
-	add	d0,d1
 	mov	(a0+),e0
-	addc	e0,d1
 	mov	(a0+),e1
-	addc	e1,d1
 	mov	(a0+),e3
+	add	d0,d1
+	addc	e0,d1
+	addc	e1,d1
 	addc	e3,d1
 	mov	(a0+),d0
-	addc	d0,d1
 	mov	(a0+),e0
-	addc	e0,d1
 	mov	(a0+),e1
-	addc	e1,d1
 	mov	(a0+),e3
+	addc	d0,d1
+	addc	e0,d1
+	addc	e1,d1
 	addc	e3,d1
 	addc	+0,d1
 
@@ -94,12 +91,12 @@ do_csum_remainder:
 	cmp	+16,d2
 	bcs	do_csum_fewer_than_16
 	mov	(a0+),d0
-	add	d0,d1
 	mov	(a0+),e0
-	addc	e0,d1
 	mov	(a0+),e1
-	addc	e1,d1
 	mov	(a0+),e3
+	add	d0,d1
+	addc	e0,d1
+	addc	e1,d1
 	addc	e3,d1
 	addc	+0,d1
 	add	-16,d2
@@ -131,9 +128,9 @@ do_csum_fewer_than_4:
 	xor_cmp	d0,d0,+2,d2
 	bcs	do_csum_fewer_than_2
 	movhu	(a0+),d0
-do_csum_fewer_than_2:
 	and	+1,d2
 	beq	do_csum_add_last_bit
+do_csum_fewer_than_2:
 	movbu	(a0),d3
 	add	d3,d0
 do_csum_add_last_bit:
@@ -142,21 +139,19 @@ do_csum_add_last_bit:
 
 do_csum_done:
 	# compress the checksum down to 16 bits
-	mov	+0xffff0000,d2
-	and	d1,d2
+	mov	+0xffff0000,d0
+	and	d1,d0
 	asl	+16,d1
-	add	d2,d1,d0
+	add	d1,d0
 	addc	+0xffff,d0
 	lsr	+16,d0
 
 	# flip the halves of the word result if the buffer was oddly aligned
-	mov	(12,sp),d1
-	and	+1,d1
+	and	+1,a1
 	beq	do_csum_not_oddly_aligned
 	swaph	d0,d0				# exchange bits 15:8 with 7:0
 
 do_csum_not_oddly_aligned:
 	ret	[d2,d3],8
 
-do_csum_end:
-	.size	do_csum, do_csum_end-do_csum
+	.size	do_csum, .-do_csum

