Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756196Ab2BAWnQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 17:43:16 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:32799 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753472Ab2BAWnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 17:43:14 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Ram Pai <linuxram@us.ibm.com>,
        "Cc: Dominik Brodowski" <linux@dominikbrodowski.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 7/7] PCI: only enable pci realloc when SRIOV bar is not assigned
Date: Wed,  1 Feb 2012 14:42:50 -0800
Message-Id: <1328136170-17613-8-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1328136170-17613-1-git-send-email-yinghai@kernel.org>
References: <1328136170-17613-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090205.4F29BFFC.003E,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If bios does not assign those BAR or wrong address, then kernel will
try to do pci realloc.

in that case, user still can use pci=realloc=off to override it.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/setup-bus.c |   28 ++++++++++++++++++++++++++++
 1 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index 9526038..520f256 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -1293,6 +1293,31 @@ static bool __init pci_realloc_enabled(void)
 	return pci_realloc_enable >= enable_yes_user;
 }
 
+static void __init pci_realloc_detect(void)
+{
+	struct pci_dev *dev = NULL;
+
+	if (pci_realloc_enable != enable_not_set)
+		return;
+
+#ifdef CONFIG_PCI_IOV
+	for_each_pci_dev(dev) {
+		int i;
+
+		for (i = PCI_IOV_RESOURCES; i <= PCI_IOV_RESOURCE_END; i++) {
+			struct resource *r = &dev->resource[i];
+
+			/* Not assigned, or rejected by kernel */
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
 			printk(KERN_INFO "Some pci devices resources are not assigned, please try to boot with pci=realloc\n");
+		else if (pci_realloc_enable == enable_yes_detected)
+			printk(KERN_INFO "Automatically enabled pci realloc, if you have problem, please try to boot with pci=realloc=off\n");
 
 		free_list(&fail_head);
 		goto enable_and_dump;
-- 
1.7.7

