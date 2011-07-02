Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754881Ab1GBRgc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jul 2011 13:36:32 -0400
Received: from mail.southpole.se ([193.12.106.18]:48466 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095Ab1GBRg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jul 2011 13:36:29 -0400
From: Jonas Bonn <jonas@southpole.se>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: Jonas Bonn <jonas@southpole.se>, vapier@gentoo.org,
        liqin.chen@sunplusct.com, gxt@mprc.pku.edu.cn
Subject: [PATCH v2 1/1] asm-generic: add MMU variants of io.h functions
Date: Sat,  2 Jul 2011 19:36:08 +0200
Message-Id: <1309628168-3413-1-git-send-email-jonas@southpole.se>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <CAMjpGUeMqVzcAWKpAojZVbj9ywH+4HmW4Hx-8D1WQmTqPSNqQA@mail.gmail.com>
References: <CAMjpGUeMqVzcAWKpAojZVbj9ywH+4HmW4Hx-8D1WQmTqPSNqQA@mail.gmail.com>
X-Assp-Client-SSL: yes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Some of the implementations, in particular the ioremap variants, in
asm-generic/io.h are for systems without an MMU.  In order to be able to
use the generic header file for systems with an MMU, this patch wraps
these implementations in checks for CONFIG_MMU.

Tested on OpenRISC.

Signed-off-by: Jonas Bonn <jonas@southpole.se>
Cc: vapier@gentoo.org
Cc: liqin.chen@sunplusct.com
Cc: gxt@mprc.pku.edu.cn
---
 include/asm-generic/io.h |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/include/asm-generic/io.h b/include/asm-generic/io.h
index e0ffa3d..a1caf2d 100644
--- a/include/asm-generic/io.h
+++ b/include/asm-generic/io.h
@@ -307,7 +307,11 @@ static inline void *phys_to_virt(unsigned long address)
 
 /*
  * Change "struct page" to physical address.
+ *
+ * This implementation is for the no-MMU case only... if you have an MMU
+ * you'll need to provide your own definitions.
  */
+#ifndef CONFIG_MMU
 static inline void __iomem *ioremap(phys_addr_t offset, unsigned long size)
 {
 	return (void __iomem*) (unsigned long)offset;
@@ -326,6 +330,7 @@ static inline void __iomem *ioremap(phys_addr_t offset, unsigned long size)
 static inline void iounmap(void *addr)
 {
 }
+#endif /* CONFIG_MMU */
 
 #ifndef CONFIG_GENERIC_IOMAP
 static inline void __iomem *ioport_map(unsigned long port, unsigned int nr)
@@ -342,7 +347,7 @@ extern void ioport_unmap(void __iomem *p);
 #endif /* CONFIG_GENERIC_IOMAP */
 
 #define xlate_dev_kmem_ptr(p)	p
-#define xlate_dev_mem_ptr(p)	((void *) (p))
+#define xlate_dev_mem_ptr(p)	__va(p)
 
 #ifndef virt_to_bus
 static inline unsigned long virt_to_bus(volatile void *address)
-- 
1.7.4.1

