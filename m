Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933465Ab1KJAoD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 19:44:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31627 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933440Ab1KJAoA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 19:44:00 -0500
From: Myron Stowe <myron.stowe@redhat.com>
Subject: [PATCH 3/3] x86/PCI: Convert maintaining FW-assigned BIOS BAR values
	to use a list
To: jbarnes@virtuousgeek.org
Cc: linux-pci@vger.kernel.org, bhelgaas@google.com,
        linux-kernel@vger.kernel.org
Date: Wed, 09 Nov 2011 17:43:57 -0700
Message-ID: <20111110004357.5866.557.stgit@amt.stowe>
In-Reply-To: <20111110004339.5866.28478.stgit@amt.stowe>
References: <20111110004339.5866.28478.stgit@amt.stowe>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Myron Stowe <mstowe@redhat.com>

This patch converts the underlying maintenance aspects of FW-assigned
BIOS BAR values from a statically allocated array within struct pci_dev
to a list of temporary, stand alone, entries.

Signed-off-by: Myron Stowe <myron.stowe@redhat.com>
---

 arch/x86/pci/i386.c     |    2 +-
 drivers/pci/setup-res.c |   14 +++++++++-----
 include/linux/pci.h     |    1 -
 3 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/arch/x86/pci/i386.c b/arch/x86/pci/i386.c
index 494f2e7..99ba108 100644
--- a/arch/x86/pci/i386.c
+++ b/arch/x86/pci/i386.c
@@ -181,7 +181,7 @@ static void __init pcibios_allocate_resources(int pass)
 					idx, r, disabled, pass);
 				if (pci_claim_resource(dev, idx) < 0) {
 					/* We'll assign a new address later */
-					dev->fw_addr[idx] = r->start;
+					pci_save_fw_addr(dev, idx, r->start);
 					r->end -= r->start;
 					r->start = 0;
 				}
diff --git a/drivers/pci/setup-res.c b/drivers/pci/setup-res.c
index ab45c11..7e4711e 100644
--- a/drivers/pci/setup-res.c
+++ b/drivers/pci/setup-res.c
@@ -231,7 +231,7 @@ static int __pci_assign_resource(struct pci_bus *bus, struct pci_dev *dev,
 }
 
 static int pci_revert_fw_address(struct resource *res, struct pci_dev *dev, 
-		int resno, resource_size_t size)
+		int resno, resource_size_t fw_addr, resource_size_t size)
 {
 	struct resource *root, *conflict;
 	resource_size_t start, end;
@@ -239,7 +239,7 @@ static int pci_revert_fw_address(struct resource *res, struct pci_dev *dev,
 
 	start = res->start;
 	end = res->end;
-	res->start = dev->fw_addr[resno];
+	res->start = fw_addr;
 	res->end = res->start + size - 1;
 
 	root = pci_find_parent_resource(dev, res);
@@ -322,7 +322,7 @@ int pci_reassign_resource(struct pci_dev *dev, int resno, resource_size_t addsiz
 int pci_assign_resource(struct pci_dev *dev, int resno)
 {
 	struct resource *res = dev->resource + resno;
-	resource_size_t align, size;
+	resource_size_t align, fw_addr, size;
 	struct pci_bus *bus;
 	int ret;
 
@@ -342,8 +342,12 @@ int pci_assign_resource(struct pci_dev *dev, int resno)
 	 * where firmware left it.  That at least has a chance of
 	 * working, which is better than just leaving it disabled.
 	 */
-	if (ret < 0 && dev->fw_addr[resno])
-		ret = pci_revert_fw_address(res, dev, resno, size);
+	if (ret < 0) {
+		fw_addr = pci_retrieve_fw_addr(dev, resno);
+		if (fw_addr)
+			ret = pci_revert_fw_address(res, dev, resno, fw_addr,
+						    size);
+	}
 
 	if (!ret) {
 		res->flags &= ~IORESOURCE_STARTALIGN;
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 14f2492..5a5d2fc 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -299,7 +299,6 @@ struct pci_dev {
 	 */
 	unsigned int	irq;
 	struct resource resource[DEVICE_COUNT_RESOURCE]; /* I/O and memory regions + expansion ROMs */
-	resource_size_t	fw_addr[DEVICE_COUNT_RESOURCE]; /* FW-assigned addr */
 
 	/* These fields are used by common fixups */
 	unsigned int	transparent:1;	/* Transparent PCI bridge */

