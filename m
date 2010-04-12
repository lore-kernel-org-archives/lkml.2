Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753961Ab0DLUkT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 16:40:19 -0400
Received: from mail.digidescorp.com ([66.244.163.200]:58070 "EHLO
	digidescorp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753478Ab0DLUkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 16:40:17 -0400
X-Spam-Processed: digidescorp.com, Mon, 12 Apr 2010 15:40:17 -0500
X-Authenticated-Sender: steve@digidescorp.com
X-Return-Path: prvs=17180e0865=steve@digidescorp.com
X-Envelope-From: steve@digidescorp.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
From: "Steven J. Magnani" <steve@digidescorp.com>
To: microblaze-uclinux@itee.uq.edu.au
Cc: monstr@monstr.eu, linux-kernel@vger.kernel.org,
       "Steven J. Magnani" <steve@digidescorp.com>
Subject: [PATCH] microblaze: speedup for word-aligned memcpys
Date: Mon, 12 Apr 2010 15:40:09 -0500
Message-Id: <1271104809-12624-1-git-send-email-steve@digidescorp.com>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

memcpy performance was measured on a noMMU system having a barrel shifter, 
4K caches, and 32-byte write-through cachelines. In this environment, 
copying word-aligned data in word-sized chunks appears to be about 3% more 
efficient on packet-sized buffers (1460 bytes) than copying in cacheline-sized 
chunks.

Skip to word-based copying when buffers are both word-aligned.

Signed-off-by: Steven J. Magnani <steve@digidescorp.com>
---
diff -uprN a/arch/microblaze/lib/fastcopy.S b/arch/microblaze/lib/fastcopy.S
--- a/arch/microblaze/lib/fastcopy.S	2010-04-09 21:52:36.000000000 -0500
+++ b/arch/microblaze/lib/fastcopy.S	2010-04-12 15:37:44.000000000 -0500
@@ -69,37 +69,13 @@ a_dalign_done:
 	blti	r4, a_block_done
 
 a_block_xfer:
-	andi	r4, r7, 0xffffffe0	/* n = c & ~31 */
-	rsub	r7, r4, r7		/* c = c - n */
-
 	andi	r9, r6, 3		/* t1 = s & 3 */
-	/* if temp != 0, unaligned transfers needed */
-	bnei	r9, a_block_unaligned
-
-a_block_aligned:
-	lwi	r9, r6, 0		/* t1 = *(s + 0) */
-	lwi	r10, r6, 4		/* t2 = *(s + 4) */
-	lwi	r11, r6, 8		/* t3 = *(s + 8) */
-	lwi	r12, r6, 12		/* t4 = *(s + 12) */
-	swi	r9, r5, 0		/* *(d + 0) = t1 */
-	swi	r10, r5, 4		/* *(d + 4) = t2 */
-	swi	r11, r5, 8		/* *(d + 8) = t3 */
-	swi	r12, r5, 12		/* *(d + 12) = t4 */
-	lwi	r9, r6, 16		/* t1 = *(s + 16) */
-	lwi	r10, r6, 20		/* t2 = *(s + 20) */
-	lwi	r11, r6, 24		/* t3 = *(s + 24) */
-	lwi	r12, r6, 28		/* t4 = *(s + 28) */
-	swi	r9, r5, 16		/* *(d + 16) = t1 */
-	swi	r10, r5, 20		/* *(d + 20) = t2 */
-	swi	r11, r5, 24		/* *(d + 24) = t3 */
-	swi	r12, r5, 28		/* *(d + 28) = t4 */
-	addi	r6, r6, 32		/* s = s + 32 */
-	addi	r4, r4, -32		/* n = n - 32 */
-	bneid	r4, a_block_aligned	/* while (n) loop */
-	addi	r5, r5, 32		/* d = d + 32 (IN DELAY SLOT) */
-	bri	a_block_done
+	/* if temp == 0, everything is word-aligned */
+	beqi	r9, a_word_xfer
 
 a_block_unaligned:
+	andi	r4, r7, 0xffffffe0	/* n = c & ~31 */
+	rsub	r7, r4, r7		/* c = c - n */
 	andi	r8, r6, 0xfffffffc	/* as = s & ~3 */
 	add	r6, r6, r4		/* s = s + n */
 	lwi	r11, r8, 0		/* h = *(as + 0) */

