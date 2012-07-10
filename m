Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753863Ab2GJUzo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 16:55:44 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:63047 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753783Ab2GJUzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 16:55:42 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Pekka Enberg <penberg@kernel.org>
Subject: [PATCH] mm/slob: avoid type warning about alignment value
Date: Tue, 10 Jul 2012 20:55:34 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: Christoph Lameter <cl@linux.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Matt Mackall <mpm@selenic.com>, linux-mm@kvack.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201207102055.35278.arnd@arndb.de>
X-Provags-ID: V02:K0:BbwQaNN+5Kg/yYiTzRXZFgmdKaMNnUboZkpt4WByO5h
 ivBsH1flMk1t28sxypZN2JP5qyfBvPl+wo3IbjNW69abtbS8jT
 fVNU+sSeBayC+PS1Yb6p2nh1vFe2Qtfmc0Fr0NYDdm6y1nCuD4
 esVnPjdQfY2e5aVX2NYJ7DUvMuMXjhDNWnO69yjGfgxuQsl5dJ
 kAKnW+PABlt2sCVLmSEluQXKwUFCClpoWKhnMbuwBuVnUatzA8
 a1KcmAFJYFeOX1POMaO8VjuzjbM4xhHcNUZ9eHCTbeN5Vg/Uha
 du72ZOvzEivzytWij6XtF/mAdgZYPlKIfXY11t6ovnxapwmn/C
 R0sTCgicH2F8v06kVpVs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The types for ARCH_KMALLOC_MINALIGN and ARCH_SLAB_MINALIGN are not always
the same, as seen by building ARM collie_defconfig:

mm/slob.c: In function 'kfree':
mm/slob.c:482:153: warning: comparison of distinct pointer types lacks a cast
mm/slob.c: In function 'ksize':
mm/slob.c:501:153: warning: comparison of distinct pointer types lacks a cast

Using max_t to find the correct alignment avoids the warning.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
diff --git a/mm/slob.c b/mm/slob.c
index 95d1c7d..51d6a27 100644
--- a/mm/slob.c
+++ b/mm/slob.c
@@ -426,7 +426,7 @@ out:
 void *__kmalloc_node(size_t size, gfp_t gfp, int node)
 {
 	unsigned int *m;
-	int align = max(ARCH_KMALLOC_MINALIGN, ARCH_SLAB_MINALIGN);
+	int align = max_t(size_t, ARCH_KMALLOC_MINALIGN, ARCH_SLAB_MINALIGN);
 	void *ret;
 
 	gfp &= gfp_allowed_mask;
@@ -479,7 +479,7 @@ void kfree(const void *block)
 
 	sp = virt_to_page(block);
 	if (PageSlab(sp)) {
-		int align = max(ARCH_KMALLOC_MINALIGN, ARCH_SLAB_MINALIGN);
+		int align = max_t(size_t, ARCH_KMALLOC_MINALIGN, ARCH_SLAB_MINALIGN);
 		unsigned int *m = (unsigned int *)(block - align);
 		slob_free(m, *m + align);
 	} else
@@ -498,7 +498,7 @@ size_t ksize(const void *block)
 
 	sp = virt_to_page(block);
 	if (PageSlab(sp)) {
-		int align = max(ARCH_KMALLOC_MINALIGN, ARCH_SLAB_MINALIGN);
+		int align = max_t(size_t, ARCH_KMALLOC_MINALIGN, ARCH_SLAB_MINALIGN);
 		unsigned int *m = (unsigned int *)(block - align);
 		return SLOB_UNITS(*m) * SLOB_UNIT;
 	} else
