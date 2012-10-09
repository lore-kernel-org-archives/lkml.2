Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978Ab2JIUOI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 16:14:08 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:53324 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752584Ab2JIUOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 16:14:05 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: arm@kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Pekka Enberg <penberg@kernel.org>
Subject: [PATCH v2 3/8] mm/slob: use min_t() to compare ARCH_SLAB_MINALIGN
Date: Tue,  9 Oct 2012 22:13:53 +0200
Message-Id: <1349813638-4617-4-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1349813638-4617-1-git-send-email-arnd@arndb.de>
References: <1349813638-4617-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:H9Ddkcvhxw/aYf04rCHopIDJpzijy88GdIdwejCnkRu
 OBSXjHv5zboLGoPQtN+MgejkQAefpsdRNTKa7v6uTlmblraz2D
 Oak4ylPsNg4t8OqCXseitslXKRWNdcYFzwc+sWer6Y1ALWwHrN
 BqVQ3WOLi8Q8om5RW16eltCiMQ4M36a+69xE2kq8ExbSfwTEHz
 166Frn7oYng9JDn+17ZIdDxk8DTovVo66L8OGYxzlayW8Tq59P
 vBgVh67K3g1VDnCrP9yPSOyvJlvmy0J9OJbBZp65TvSxxOoEVR
 3vRnXBC3oLrhslz9oMChzAMAg6KNinHv/ey09dTULkXS8M7xUX
 TGvHGIvRKdpxsFBqpexX8xeRH6A187vlILHic54Um
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The definition of ARCH_SLAB_MINALIGN is architecture dependent
and can be either of type size_t or int. Comparing that value
with ARCH_KMALLOC_MINALIGN can cause harmless warnings on
platforms where they are different. Since both are always
small positive integer numbers, using the size_t type to compare
them is safe and gets rid of the warning.

Without this patch, building ARM collie_defconfig results in:

mm/slob.c: In function '__kmalloc_node':
mm/slob.c:431:152: warning: comparison of distinct pointer types lacks a cast [enabled by default]
mm/slob.c: In function 'kfree':
mm/slob.c:484:153: warning: comparison of distinct pointer types lacks a cast [enabled by default]
mm/slob.c: In function 'ksize':
mm/slob.c:503:153: warning: comparison of distinct pointer types lacks a cast [enabled by default]

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
---
 mm/slob.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/slob.c b/mm/slob.c
index 45d4ca7..497c55e 100644
--- a/mm/slob.c
+++ b/mm/slob.c
@@ -428,7 +428,7 @@ out:
 void *__kmalloc_node(size_t size, gfp_t gfp, int node)
 {
 	unsigned int *m;
-	int align = max(ARCH_KMALLOC_MINALIGN, ARCH_SLAB_MINALIGN);
+	int align = max_t(size_t, ARCH_KMALLOC_MINALIGN, ARCH_SLAB_MINALIGN);
 	void *ret;
 
 	gfp &= gfp_allowed_mask;
@@ -481,7 +481,7 @@ void kfree(const void *block)
 
 	sp = virt_to_page(block);
 	if (PageSlab(sp)) {
-		int align = max(ARCH_KMALLOC_MINALIGN, ARCH_SLAB_MINALIGN);
+		int align = max_t(size_t, ARCH_KMALLOC_MINALIGN, ARCH_SLAB_MINALIGN);
 		unsigned int *m = (unsigned int *)(block - align);
 		slob_free(m, *m + align);
 	} else
@@ -500,7 +500,7 @@ size_t ksize(const void *block)
 
 	sp = virt_to_page(block);
 	if (PageSlab(sp)) {
-		int align = max(ARCH_KMALLOC_MINALIGN, ARCH_SLAB_MINALIGN);
+		int align = max_t(size_t, ARCH_KMALLOC_MINALIGN, ARCH_SLAB_MINALIGN);
 		unsigned int *m = (unsigned int *)(block - align);
 		return SLOB_UNITS(*m) * SLOB_UNIT;
 	} else
-- 
1.7.10

