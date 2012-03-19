Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756798Ab2CSFx0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 01:53:26 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:31324 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162005Ab2CSFts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 01:49:48 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, x86 <x86@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH -v2 13/26] PCI: Use for_each_res pci_assign_resource
Date: Sun, 18 Mar 2012 22:48:36 -0700
Message-Id: <1332136129-14010-14-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1332136129-14010-1-git-send-email-yinghai@kernel.org>
References: <1332136129-14010-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-CT-RefId: str=0001.0A090203.4F66C8F9.005F,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/setup-res.c |   14 ++++++--------
 1 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/pci/setup-res.c b/drivers/pci/setup-res.c
index eea85da..161a015 100644
--- a/drivers/pci/setup-res.c
+++ b/drivers/pci/setup-res.c
@@ -92,7 +92,7 @@ void pci_update_resource(struct pci_dev *dev, int resno)
 
 int pci_claim_resource(struct pci_dev *dev, int resource)
 {
-	struct resource *res = &dev->resource[resource];
+	struct resource *res = pci_dev_resource_n(dev, resource);
 	struct resource *root, *conflict;
 
 	root = pci_find_parent_resource(dev, res);
@@ -130,7 +130,7 @@ void pci_disable_bridge_window(struct pci_dev *dev)
 static int __pci_assign_resource(struct pci_bus *bus, struct pci_dev *dev,
 		int resno, resource_size_t size, resource_size_t align)
 {
-	struct resource *res = dev->resource + resno;
+	struct resource *res = pci_dev_resource_n(dev, resno);
 	resource_size_t min;
 	int ret;
 
@@ -208,7 +208,7 @@ static int pci_revert_fw_address(struct resource *res, struct pci_dev *dev,
 
 static int _pci_assign_resource(struct pci_dev *dev, int resno, int size, resource_size_t min_align)
 {
-	struct resource *res = dev->resource + resno;
+	struct resource *res = pci_dev_resource_n(dev, resno);
 	struct pci_bus *bus;
 	int ret;
 	char *type;
@@ -241,7 +241,7 @@ static int _pci_assign_resource(struct pci_dev *dev, int resno, int size, resour
 int pci_reassign_resource(struct pci_dev *dev, int resno, resource_size_t addsize,
 			resource_size_t min_align)
 {
-	struct resource *res = dev->resource + resno;
+	struct resource *res = pci_dev_resource_n(dev, resno);
 	resource_size_t new_size;
 	int ret;
 
@@ -265,7 +265,7 @@ int pci_reassign_resource(struct pci_dev *dev, int resno, resource_size_t addsiz
 
 int pci_assign_resource(struct pci_dev *dev, int resno)
 {
-	struct resource *res = dev->resource + resno;
+	struct resource *res = pci_dev_resource_n(dev, resno);
 	resource_size_t align, size;
 	struct pci_bus *bus;
 	int ret;
@@ -307,12 +307,10 @@ int pci_enable_resources(struct pci_dev *dev, int mask)
 	pci_read_config_word(dev, PCI_COMMAND, &cmd);
 	old_cmd = cmd;
 
-	for (i = 0; i < PCI_NUM_RESOURCES; i++) {
+	for_each_pci_dev_all_resource(dev, r, i) {
 		if (!(mask & (1 << i)))
 			continue;
 
-		r = &dev->resource[i];
-
 		if (!(r->flags & (IORESOURCE_IO | IORESOURCE_MEM)))
 			continue;
 		if ((i == PCI_ROM_RESOURCE) &&
-- 
1.7.7

