Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753322Ab2CCXo7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2012 18:44:59 -0500
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:36938 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752407Ab2CCXo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2012 18:44:58 -0500
Message-ID: <1330818296.15243.1.camel@dabdike.int.hansenpartnership.com>
Subject: [GIT PULL] parisc fixes for 3.3-rc5
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Parisc List <linux-parisc@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Sat, 03 Mar 2012 17:44:56 -0600
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a set of build fixes to get the cross compiled architecture
testbeds building again

The patches are here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git parisc-fixes

The short changelog is:

Cong Wang (1):
      [PARISC] include <linux/prefetch.h> in drivers/parisc/iommu-helpers.h

James Bottomley (2):
      [PARISC] don't unconditionally override CROSS_COMPILE for 64 bit.
      [PARISC] fix compile break caused by iomap: make IOPORT/PCI mapping functions conditional

And the diffstat

 arch/parisc/Makefile            |    4 ++++
 drivers/parisc/iommu-helpers.h  |    2 ++
 include/asm-generic/iomap.h     |    2 +-
 include/asm-generic/pci_iomap.h |    2 +-
 4 files changed, 8 insertions(+), 2 deletions(-)

With the full diffs below.

James

---

diff --git a/arch/parisc/Makefile b/arch/parisc/Makefile
index 55cca1d..19ab7b2 100644
--- a/arch/parisc/Makefile
+++ b/arch/parisc/Makefile
@@ -31,7 +31,11 @@ ifdef CONFIG_64BIT
 UTS_MACHINE	:= parisc64
 CHECKFLAGS	+= -D__LP64__=1 -m64
 WIDTH		:= 64
+
+# FIXME: if no default set, should really try to locate dynamically
+ifeq ($(CROSS_COMPILE),)
 CROSS_COMPILE	:= hppa64-linux-gnu-
+endif
 else # 32-bit
 WIDTH		:=
 endif
diff --git a/drivers/parisc/iommu-helpers.h b/drivers/parisc/iommu-helpers.h
index a9c46cc..8c33491 100644
--- a/drivers/parisc/iommu-helpers.h
+++ b/drivers/parisc/iommu-helpers.h
@@ -1,3 +1,5 @@
+#include <linux/prefetch.h>
+
 /**
  * iommu_fill_pdir - Insert coalesced scatter/gather chunks into the I/O Pdir.
  * @ioc: The I/O Controller.
diff --git a/include/asm-generic/iomap.h b/include/asm-generic/iomap.h
index 8a3d4fd..6afd7d6 100644
--- a/include/asm-generic/iomap.h
+++ b/include/asm-generic/iomap.h
@@ -70,7 +70,7 @@ extern void ioport_unmap(void __iomem *);
 /* Destroy a virtual mapping cookie for a PCI BAR (memory or IO) */
 struct pci_dev;
 extern void pci_iounmap(struct pci_dev *dev, void __iomem *);
-#else
+#elif defined(CONFIG_GENERIC_IOMAP)
 struct pci_dev;
 static inline void pci_iounmap(struct pci_dev *dev, void __iomem *addr)
 { }
diff --git a/include/asm-generic/pci_iomap.h b/include/asm-generic/pci_iomap.h
index e58fcf8..ce37349 100644
--- a/include/asm-generic/pci_iomap.h
+++ b/include/asm-generic/pci_iomap.h
@@ -25,7 +25,7 @@ extern void __iomem *__pci_ioport_map(struct pci_dev *dev, unsigned long port,
 #define __pci_ioport_map(dev, port, nr) ioport_map((port), (nr))
 #endif
 
-#else
+#elif defined(CONFIG_GENERIC_PCI_IOMAP)
 static inline void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long max)
 {
 	return NULL;



