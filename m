Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753598Ab0IDU45 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Sep 2010 16:56:57 -0400
Received: from mx1.riseup.net ([204.13.164.18]:50441 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753002Ab0IDU4z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Sep 2010 16:56:55 -0400
From: Francisco Jerez <currojerez@riseup.net>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 2/2] io-mapping: Fix the address space annotations.
Date: Sat,  4 Sep 2010 22:56:44 +0200
Message-Id: <1283633804-11749-2-git-send-email-currojerez@riseup.net>
X-Mailer: git-send-email 1.6.4.4
In-Reply-To: <1283633804-11749-1-git-send-email-currojerez@riseup.net>
References: <1283633804-11749-1-git-send-email-currojerez@riseup.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes a bunch of sparse warnings in io-mapping.h because of the
inconsistent __iomem usage.

Signed-off-by: Francisco Jerez <currojerez@riseup.net>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: H. Peter Anvin <hpa@zytor.com>
---
 include/linux/io-mapping.h |   24 ++++++++++++------------
 1 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/include/linux/io-mapping.h b/include/linux/io-mapping.h
index 0a6b3d5..7fb5927 100644
--- a/include/linux/io-mapping.h
+++ b/include/linux/io-mapping.h
@@ -79,7 +79,7 @@ io_mapping_free(struct io_mapping *mapping)
 }
 
 /* Atomic map/unmap */
-static inline void *
+static inline void __iomem *
 io_mapping_map_atomic_wc(struct io_mapping *mapping,
 			 unsigned long offset,
 			 int slot)
@@ -94,12 +94,12 @@ io_mapping_map_atomic_wc(struct io_mapping *mapping,
 }
 
 static inline void
-io_mapping_unmap_atomic(void *vaddr, int slot)
+io_mapping_unmap_atomic(void __iomem *vaddr, int slot)
 {
 	iounmap_atomic(vaddr, slot);
 }
 
-static inline void *
+static inline void __iomem *
 io_mapping_map_wc(struct io_mapping *mapping, unsigned long offset)
 {
 	resource_size_t phys_addr;
@@ -111,7 +111,7 @@ io_mapping_map_wc(struct io_mapping *mapping, unsigned long offset)
 }
 
 static inline void
-io_mapping_unmap(void *vaddr)
+io_mapping_unmap(void __iomem *vaddr)
 {
 	iounmap(vaddr);
 }
@@ -125,38 +125,38 @@ struct io_mapping;
 static inline struct io_mapping *
 io_mapping_create_wc(resource_size_t base, unsigned long size)
 {
-	return (struct io_mapping *) ioremap_wc(base, size);
+	return (struct io_mapping __force *) ioremap_wc(base, size);
 }
 
 static inline void
 io_mapping_free(struct io_mapping *mapping)
 {
-	iounmap(mapping);
+	iounmap((void __force __iomem *) mapping);
 }
 
 /* Atomic map/unmap */
-static inline void *
+static inline void __iomem *
 io_mapping_map_atomic_wc(struct io_mapping *mapping,
 			 unsigned long offset,
 			 int slot)
 {
-	return ((char *) mapping) + offset;
+	return ((char __force __iomem *) mapping) + offset;
 }
 
 static inline void
-io_mapping_unmap_atomic(void *vaddr, int slot)
+io_mapping_unmap_atomic(void __iomem *vaddr, int slot)
 {
 }
 
 /* Non-atomic map/unmap */
-static inline void *
+static inline void __iomem *
 io_mapping_map_wc(struct io_mapping *mapping, unsigned long offset)
 {
-	return ((char *) mapping) + offset;
+	return ((char __force __iomem *) mapping) + offset;
 }
 
 static inline void
-io_mapping_unmap(void *vaddr)
+io_mapping_unmap(void __iomem *vaddr)
 {
 }
 
-- 
1.6.4.4

