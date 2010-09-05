Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116Ab0IENEm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 09:04:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:53066 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753467Ab0IENEe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 09:04:34 -0400
Date: Sun, 5 Sep 2010 13:04:15 GMT
From: tip-bot for Francisco Jerez <currojerez@riseup.net>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        akpm@linux-foundation.org, currojerez@riseup.net, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, currojerez@riseup.net, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <1283633804-11749-2-git-send-email-currojerez@riseup.net>
References: <1283633804-11749-2-git-send-email-currojerez@riseup.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] io-mapping: Fix the address space annotations
Message-ID: <tip-29bc17ecb856ffb2b47c7009a71971c6f9334205@git.kernel.org>
Git-Commit-ID: 29bc17ecb856ffb2b47c7009a71971c6f9334205
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 05 Sep 2010 13:04:15 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  29bc17ecb856ffb2b47c7009a71971c6f9334205
Gitweb:     http://git.kernel.org/tip/29bc17ecb856ffb2b47c7009a71971c6f9334205
Author:     Francisco Jerez <currojerez@riseup.net>
AuthorDate: Sat, 4 Sep 2010 22:56:44 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 5 Sep 2010 14:26:15 +0200

io-mapping: Fix the address space annotations

Fixes a bunch of sparse warnings in io-mapping.h because of the
inconsistent __iomem usage.

Signed-off-by: Francisco Jerez <currojerez@riseup.net>
LKML-Reference: <1283633804-11749-2-git-send-email-currojerez@riseup.net>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
 
