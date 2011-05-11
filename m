Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756046Ab1EKVGn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 17:06:43 -0400
Received: from c-76-97-164-112.hsd1.ga.comcast.net ([76.97.164.112]:55110 "EHLO
	deneb.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755664Ab1EKVGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 17:06:41 -0400
X-Greylist: delayed 3155 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 May 2011 17:06:39 EDT
From: Mark Salter <msalter@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 02/16] fixed generic page.h for non-zero PAGE_OFFSET
Date: Wed, 11 May 2011 16:13:49 -0400
Message-Id: <1305144843-5058-3-git-send-email-msalter@redhat.com>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1305144843-5058-2-git-send-email-msalter@redhat.com>
References: <1305144843-5058-1-git-send-email-msalter@redhat.com>
 <1305144843-5058-2-git-send-email-msalter@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

asm-generic/page.h had several problems when used with a non-zero PAGE_OFFSET.
This patch adds a default ARCH_PFN_OFFSET and fixes the __va, __pa, and
pfn_valid macros to work with non-zero PAGE_OFFSETs.

Signed-off-by: Mark Salter <msalter@redhat.com>
---
 include/asm-generic/page.h |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/include/asm-generic/page.h b/include/asm-generic/page.h
index 75fec18..f376db2 100644
--- a/include/asm-generic/page.h
+++ b/include/asm-generic/page.h
@@ -71,10 +71,14 @@ extern unsigned long memory_end;
 #define PAGE_OFFSET		(0)
 #endif
 
+#ifndef ARCH_PFN_OFFSET
+#define ARCH_PFN_OFFSET		(PAGE_OFFSET >> PAGE_SHIFT)
+#endif
+
 #ifndef __ASSEMBLY__
 
-#define __va(x) ((void *)((unsigned long)(x) + PAGE_OFFSET))
-#define __pa(x) ((unsigned long) (x) - PAGE_OFFSET)
+#define __va(x) ((void *)((unsigned long) (x)))
+#define __pa(x) ((unsigned long) (x))
 
 #define virt_to_pfn(kaddr)	(__pa(kaddr) >> PAGE_SHIFT)
 #define pfn_to_virt(pfn)	__va((pfn) << PAGE_SHIFT)
@@ -86,7 +90,7 @@ extern unsigned long memory_end;
 #define page_to_phys(page)      ((dma_addr_t)page_to_pfn(page) << PAGE_SHIFT)
 #endif
 
-#define pfn_valid(pfn)		((pfn) < max_mapnr)
+#define pfn_valid(pfn)		((pfn) >= ARCH_PFN_OFFSET && ((pfn) - ARCH_PFN_OFFSET) < max_mapnr)
 
 #define	virt_addr_valid(kaddr)	(((void *)(kaddr) >= (void *)PAGE_OFFSET) && \
 				((void *)(kaddr) < (void *)memory_end))
-- 
1.6.2.5

