Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882Ab1I0XWS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 19:22:18 -0400
Received: from mms2.broadcom.com ([216.31.210.18]:3313 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753083Ab1I0XWR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 19:22:17 -0400
X-Server-Uuid: D3C04415-6FA8-4F2C-93C1-920E106A2031
From: "Michael Chan" <mchan@broadcom.com>
To: Matt_Domsch@dell.com, linux-kernel@vger.kernel.org
cc: devel@open-fcoe.org, "Michael Chan" <mchan@broadcom.com>
Subject: [PATCH] drivers/firmware/edd: Treat "XPRS" host bus type the
 same as "PCI"
Date: Tue, 27 Sep 2011 15:32:08 -0700
Message-ID: <1317162728-14488-1-git-send-email-mchan@broadcom.com>
X-Mailer: git-send-email 1.5.5.GIT
MIME-Version: 1.0
X-WSS-ID: 629C83965IS12866271-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PCI Express devices will return "XPRS" host bus type during BIOS EDD
call.  "XPRS" should be treated just like "PCI" so that the proper
pci_dev symlink will be created.  Scripts such as fcoe-edd.sh will
then work correctly.

Cc: Matt Domsch <Matt_Domsch@dell.com>
Signed-off-by: Michael Chan <mchan@broadcom.com>
---
 drivers/firmware/edd.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/firmware/edd.c b/drivers/firmware/edd.c
index f1b7f65..e229576 100644
--- a/drivers/firmware/edd.c
+++ b/drivers/firmware/edd.c
@@ -151,7 +151,8 @@ edd_show_host_bus(struct edd_device *edev, char *buf)
 		p += scnprintf(p, left, "\tbase_address: %x\n",
 			     info->params.interface_path.isa.base_address);
 	} else if (!strncmp(info->params.host_bus_type, "PCIX", 4) ||
-		   !strncmp(info->params.host_bus_type, "PCI", 3)) {
+		   !strncmp(info->params.host_bus_type, "PCI", 3) ||
+		   !strncmp(info->params.host_bus_type, "XPRS", 4)) {
 		p += scnprintf(p, left,
 			     "\t%02x:%02x.%d  channel: %u\n",
 			     info->params.interface_path.pci.bus,
@@ -159,7 +160,6 @@ edd_show_host_bus(struct edd_device *edev, char *buf)
 			     info->params.interface_path.pci.function,
 			     info->params.interface_path.pci.channel);
 	} else if (!strncmp(info->params.host_bus_type, "IBND", 4) ||
-		   !strncmp(info->params.host_bus_type, "XPRS", 4) ||
 		   !strncmp(info->params.host_bus_type, "HTPT", 4)) {
 		p += scnprintf(p, left,
 			     "\tTBD: %llx\n",
@@ -668,7 +668,7 @@ edd_get_pci_dev(struct edd_device *edev)
 {
 	struct edd_info *info = edd_dev_get_info(edev);
 
-	if (edd_dev_is_type(edev, "PCI")) {
+	if (edd_dev_is_type(edev, "PCI") || edd_dev_is_type(edev, "XPRS")) {
 		return pci_get_bus_and_slot(info->params.interface_path.pci.bus,
 				     PCI_DEVFN(info->params.interface_path.pci.slot,
 					       info->params.interface_path.pci.
-- 
1.7.1.GIT


