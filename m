Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756448Ab2JEO4e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 10:56:34 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:49773 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756438Ab2JEO4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 10:56:21 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, arm@kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>
Subject: [PATCH 06/16] mm/slob: use min_t() to compare ARCH_SLAB_MINALIGN
Date: Fri,  5 Oct 2012 16:55:20 +0200
Message-Id: <1349448930-23976-7-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1349448930-23976-1-git-send-email-arnd@arndb.de>
References: <1349448930-23976-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:USz0MW8FHEbHrDYmVpUP3B4yrJ7vIv+hy6kHPEnO/lP
 HFcGNdSR0qpQvkynOuKo6gDO+SWAur1p8qnQ90xy++yhTlfs2t
 z3CsjWd6KcjGN0JNPdezFA4bo8Z9KnK/RxBURoh7vYXewTuRwB
 KCokkUWKHsi1919ZI5qocu2A6lNzmQygOmxbEtS+EONXzXmHvv
 m2teVjZqVRuQ09CT5Ssh/OS8JmDnAoOC1s+T0/v6ubRASphvob
 xNTn4DBQcf3Zrwjd/HbkGOy1enoXQKe4R2bd1x1WdYYr4as4Tp
 V/t+OpsOsayQ9cQcUfEhVKSnvIGsm/ShIF3EXiqKSE8JiJOiOw
 jyoDoPbpI+Gqc4T6P8J8i6x753jAQ6SMn8jxyGOrnWZsou7KWa
 9mRkaMGinIrIvbLpEfqm96F4VbJDj1hPMY=
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
Cc: Christoph Lameter <cl@linux.com>
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

