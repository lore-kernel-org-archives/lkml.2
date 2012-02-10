Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761131Ab2BJXfu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 18:35:50 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:56284 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760480Ab2BJXeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 18:34:19 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Ram Pai <linuxram@us.ibm.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 7/7] PCI: only enable pci realloc when SRIOV bar is not assigned
Date: Fri, 10 Feb 2012 15:33:52 -0800
Message-Id: <1328916832-6588-8-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1328916832-6588-1-git-send-email-yinghai@kernel.org>
References: <1328916832-6588-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4F35A975.0019,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If bios does not assign those BAR or wrong address, then kernel will
try to do pci realloc.

in that case, user still can use pci=realloc=off to override it.

-v2: According to Jesse, adding one CONFIG option for distribution to
     disable it or enable it.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/Kconfig     |   10 ++++++++++
 drivers/pci/setup-bus.c |   28 ++++++++++++++++++++++++++++
 2 files changed, 38 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/Kconfig b/drivers/pci/Kconfig
index 37856f7..ee29565 100644
--- a/drivers/pci/Kconfig
+++ b/drivers/pci/Kconfig
@@ -31,6 +31,16 @@ config PCI_DEBUG
 
 	  When in doubt, say N.
 
+config PCI_REALLOC_ENABLE_DETECT
+	bool "PCI Realloc Enable Detecting"
+	depends on PCI
+	help
+	  Say Y here if you want the PCI core to detect if  pci realloc
+	  need to be enabled. You can always use pci=realloc=on or
+	  pci=realloc=off to override it.
+
+	  When in doubt, say N.
+
 config PCI_STUB
 	tristate "PCI Stub driver"
 	depends on PCI
diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index c73244a..3aef181 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -1293,6 +1293,31 @@ static bool __init pci_realloc_enabled(void)
 	return pci_realloc_enable >= enable_yes_user;
 }
 
+static void __init pci_realloc_detect(void)
+{
+#if defined(CONFIG_PCI_IOV) && defined(CONFIG_PCI_REALLOC_ENABLE_DETECT)
+	struct pci_dev *dev = NULL;
+
+	if (pci_realloc_enable != enable_not_set)
+		return;
+
+	for_each_pci_dev(dev) {
+		int i;
+
+		for (i = PCI_IOV_RESOURCES; i <= PCI_IOV_RESOURCE_END; i++) {
+			struct resource *r = &dev->resource[i];
+
+			/* Not assigned, or rejected by kernel ? */
+			if (r->flags && !r->start) {
+				pci_realloc_enable = enable_yes_detected;
+
+				return;
+			}
+		}
+	}
+#endif
+}
+
 /*
  * first try will not touch pci bridge res
  * second  and later try will clear small leaf bridge res
@@ -1314,6 +1339,7 @@ pci_assign_unassigned_resources(void)
 	int pci_try_num = 1;
 
 	/* don't realloc if asked to do so */
+	pci_realloc_detect();
 	if (pci_realloc_enabled()) {
 		int max_depth = pci_get_max_depth();
 
@@ -1348,6 +1374,8 @@ again:
 	if (tried_times >= pci_try_num) {
 		if (pci_realloc_enable == enable_not_set)
 			printk(KERN_INFO "Some PCI device resources are unassigned, try booting with pci=realloc\n");
+		else if (pci_realloc_enable == enable_yes_detected)
+			printk(KERN_INFO "Automatically enabled pci realloc, if you have problem, try booting with pci=realloc=off\n");
 
 		free_list(&fail_head);
 		goto enable_and_dump;
-- 
1.7.7

