Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250Ab2BZXZK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Feb 2012 18:25:10 -0500
Received: from mail.windriver.com ([147.11.1.11]:63110 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752909Ab2BZXZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Feb 2012 18:25:08 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: JBottomley@parallels.com, jejb@parisc-linux.org, kyle@mcmartin.ca,
        deller@gmx.de
Cc: linux-parisc@vger.kernel.org, mst@redhat.com, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Randy Dunlap <rdunlap@xenotime.net>
Subject: [PATCH] parisc: fix longstanding build failures for !CONFIG_PCI
Date: Sun, 26 Feb 2012 18:24:37 -0500
Message-Id: <1330298677-17205-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Upstream commit fea80311a939a746533a6d7e7c3183729d6a3faf

    "iomap: make IOPORT/PCI mapping functions conditional"

introduced an arch independent stub for pci_iounmap() but the
parisc had its own that was unconditionally built.  So builds
since v3.0-3553-gfea8031 have been failing with:

arch/parisc/lib/iomap.c:439:6: error: redefinition of 'pci_iounmap'
include/asm-generic/iomap.h:75:20: note: previous definition of 'pci_iounmap' was here

Making the parisc one specific to CONFIG_PCI fixes the problem.

CC: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---

[This fixes the linux-next builds that have been consistently failing
 since last July -- http://kisskb.ellerman.id.au/kisskb/target/2069/ ]

diff --git a/arch/parisc/lib/iomap.c b/arch/parisc/lib/iomap.c
index fb8e10a..dc0a2c3 100644
--- a/arch/parisc/lib/iomap.c
+++ b/arch/parisc/lib/iomap.c
@@ -436,12 +436,15 @@ void ioport_unmap(void __iomem *addr)
 	}
 }
 
+#ifdef CONFIG_PCI
 void pci_iounmap(struct pci_dev *dev, void __iomem * addr)
 {
 	if (!INDIRECT_ADDR(addr)) {
 		iounmap(addr);
 	}
 }
+EXPORT_SYMBOL(pci_iounmap);
+#endif
 
 EXPORT_SYMBOL(ioread8);
 EXPORT_SYMBOL(ioread16);
@@ -461,4 +464,3 @@ EXPORT_SYMBOL(iowrite16_rep);
 EXPORT_SYMBOL(iowrite32_rep);
 EXPORT_SYMBOL(ioport_map);
 EXPORT_SYMBOL(ioport_unmap);
-EXPORT_SYMBOL(pci_iounmap);
-- 
1.7.9.1

