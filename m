Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932655Ab2DMIwk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 04:52:40 -0400
Received: from smtp.mei.co.jp ([133.183.100.20]:51864 "EHLO smtp.mei.co.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757443Ab2DMIwi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 04:52:38 -0400
Date: Fri, 13 Apr 2012 17:53:42 +0900
From: Akira Takeuchi <takeuchi.akr@jp.panasonic.com>
To: linux-mm@kvack.org
Subject: [PATCH RESEND][BUG] sparsemem: Initialize all memmap entries within sections
Cc: linux-kernel@vger.kernel.org
Message-Id: <20120413175342.FCE9.38390934@jp.panasonic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit fixes the problem for the kernel
with CONFIG_SPARSEMEM=y and CONFIG_HAVE_ARCH_PFN_VALID=y.

VM subsystem insists that memmap entries within the align to MAX_ORDER_NR_PAGES
must exist and be initialized.

However, in the kernel with CONFIG_SPARSEMEM=y and CONFIG_HAVE_ARCH_PFN_VALID=y,
the kernel only initializes the entries corresponding to the memory regions
specified by "mem=" options. This causes "kernel BUG at mm/page_alloc.c:777!"
This BUG message comes from the following BUG_ON() line in move_freepages().

    BUG_ON(page_zone(start_page) != page_zone(end_page));

Signed-off-by: Akira Takeuchi <takeuchi.akr@jp.panasonic.com>
Signed-off-by: Kiyoshi Owada <owada.kiyoshi@jp.panasonic.com>
---
 include/linux/mmzone.h |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index dff7115..1b7538c 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -1088,13 +1088,15 @@ static inline struct mem_section *__pfn_to_section(unsigned long pfn)
 	return __nr_to_section(pfn_to_section_nr(pfn));
 }
 
-#ifndef CONFIG_HAVE_ARCH_PFN_VALID
-static inline int pfn_valid(unsigned long pfn)
+static inline int sparsemem_pfn_valid(unsigned long pfn)
 {
 	if (pfn_to_section_nr(pfn) >= NR_MEM_SECTIONS)
 		return 0;
 	return valid_section(__nr_to_section(pfn_to_section_nr(pfn)));
 }
+
+#ifndef CONFIG_HAVE_ARCH_PFN_VALID
+#define pfn_valid(pfn) sparsemem_pfn_valid(pfn)
 #endif
 
 static inline int pfn_present(unsigned long pfn)
@@ -1119,7 +1121,7 @@ static inline int pfn_present(unsigned long pfn)
 #define pfn_to_nid(pfn)		(0)
 #endif
 
-#define early_pfn_valid(pfn)	pfn_valid(pfn)
+#define early_pfn_valid(pfn)	sparsemem_pfn_valid(pfn)
 void sparse_init(void);
 #else
 #define sparse_init()	do {} while (0)
-- 
1.7.4.1


