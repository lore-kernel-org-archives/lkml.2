Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161983Ab2CSFz7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 01:55:59 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:25394 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161859Ab2CSFtd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 01:49:33 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, x86 <x86@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH -v2 02/26] PCI: Add for_each_resource helpers to make resource loop easier.
Date: Sun, 18 Mar 2012 22:48:25 -0700
Message-Id: <1332136129-14010-3-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1332136129-14010-1-git-send-email-yinghai@kernel.org>
References: <1332136129-14010-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090205.4F66C8EA.0023,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 include/linux/pci.h |   49 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 49 insertions(+), 0 deletions(-)

diff --git a/include/linux/pci.h b/include/linux/pci.h
index bb81080..2b1fff8 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -349,6 +349,55 @@ struct pci_dev {
 
 struct resource *pci_dev_resource_n(struct pci_dev *dev, int n);
 
+#define resno_is_for_bridge(n)						\
+	((n) >= PCI_BRIDGE_RESOURCES && (n) <= PCI_BRIDGE_RESOURCE_END)
+
+/* all (include bridge) resources */
+#define for_each_pci_dev_all_resource(dev, res, i)			\
+	for (i = 0;							\
+	     (res = pci_dev_resource_n(dev, i)) || i < PCI_NUM_RESOURCES; \
+	     i++)
+/* exclude bridge resources */
+#define for_each_pci_dev_nobridge_resource(dev, res, i)			\
+	for (i = 0;							\
+	     (res = pci_dev_resource_n(dev, i)) || i < PCI_NUM_RESOURCES; \
+	     i = (i != (PCI_BRIDGE_RESOURCES - 1)) ? (i+1) : PCI_NUM_RESOURCES)
+/* exclude bridge and IOV resources */
+#define for_each_pci_dev_base_resource(dev, res, i)			\
+	for (i = 0;							\
+	     (res = pci_dev_resource_n(dev, i)) || i < PCI_NUM_RESOURCES; \
+	     i = (i != PCI_ROM_RESOURCE) ? (i+1) : PCI_NUM_RESOURCES)
+/* exclude ROM and bridge and IOV resources */
+#define for_each_pci_dev_base_norom_resource(dev, res, i)		\
+	for (i = 0;							\
+	     (res = pci_dev_resource_n(dev, i)) || i < PCI_NUM_RESOURCES; \
+	     i = (i != (PCI_ROM_RESOURCE-1)) ? (i+1) : PCI_NUM_RESOURCES)
+/* exclude IOV resources */
+#define for_each_pci_dev_noiov_resource(dev, res, i)			\
+	for (i = 0;							\
+	     (res = pci_dev_resource_n(dev, i)) || i < PCI_NUM_RESOURCES; \
+	     i = (i != PCI_ROM_RESOURCE) ? (i+1) : PCI_BRIDGE_RESOURCES)
+/* only std resources */
+#define for_each_pci_dev_std_resource(dev, res, i)			\
+	for (i = PCI_STD_RESOURCES;					\
+	   (res = pci_dev_resource_n(dev, i)) && i < (PCI_STD_RESOURCE_END+1); \
+	     i++)
+/* only IOV resources */
+#define for_each_pci_dev_iov_resource(dev, res, i)			\
+	for (i = PCI_IOV_RESOURCES;					\
+	   (res = pci_dev_resource_n(dev, i)) && i < (PCI_IOV_RESOURCE_END+1); \
+	     i++)
+/* only bridge resources */
+#define for_each_pci_dev_bridge_resource(dev, res, i)			\
+	for (i = PCI_BRIDGE_RESOURCES;					\
+	(res = pci_dev_resource_n(dev, i)) && i < (PCI_BRIDGE_RESOURCE_END+1); \
+	     i++)
+/* only addon resources */
+#define for_each_pci_dev_addon_resource(dev, res, i)			\
+	for (i = PCI_NUM_RESOURCES;					\
+	     (res = pci_dev_resource_n(dev, i));			\
+	     i++)
+
 static inline struct pci_dev *pci_physfn(struct pci_dev *dev)
 {
 #ifdef CONFIG_PCI_IOV
-- 
1.7.7

