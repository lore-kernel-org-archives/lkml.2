Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760547Ab2D0PUi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 11:20:38 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:38951 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760531Ab2D0PUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 11:20:35 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Yinghai Lu <yinghai@kernel.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Don Dutile <ddutile@redhat.com>,
        Greg KH <gregkh@linuxfoundation.org>
Cc: Jiang Liu <jiang.liu@huawei.com>, Keping Chen <chenkeping@huawei.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Jiang Liu <liuj97@gmail.com>
Subject: [PATCH v2 04/19] PCI: serialize hotplug operations triggered by PCI hotplug sysfs interfaces
Date: Fri, 27 Apr 2012 23:16:45 +0800
Message-Id: <1335539820-11232-5-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1335539820-11232-1-git-send-email-jiang.liu@huawei.com>
References: <1335539820-11232-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <jiang.liu@huawei.com>

Use PCI hotplug lock to globally serialize hotplug operations triggered by
PCI hotplug sysfs interfaces.

Signed-off-by: Jiang Liu <liuj97@gmail.com>
---
 drivers/pci/hotplug/pci_hotplug_core.c |   18 ++++++++++++++++--
 1 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/hotplug/pci_hotplug_core.c b/drivers/pci/hotplug/pci_hotplug_core.c
index 1572665..9bbbe3e 100644
--- a/drivers/pci/hotplug/pci_hotplug_core.c
+++ b/drivers/pci/hotplug/pci_hotplug_core.c
@@ -39,6 +39,7 @@
 #include <linux/mutex.h>
 #include <linux/pci.h>
 #include <linux/pci_hotplug.h>
+#include <linux/delay.h>
 #include <asm/uaccess.h>
 #include "../pci.h"
 
@@ -121,6 +122,17 @@ static ssize_t power_write_file(struct pci_slot *pci_slot, const char *buf,
 		retval = -ENODEV;
 		goto exit;
 	}
+
+	/* Avoid deadlock with pci_hp_deregister() */
+	while (!pci_hotplug_try_enter()) {
+		/* Check whether the slot has been deregistered. */
+		if (list_empty(&slot->slot_list)) {
+			retval = -ENODEV;
+			goto exit_put;
+		}
+		msleep(1);
+	}
+
 	switch (power) {
 		case 0:
 			if (slot->ops->disable_slot)
@@ -136,8 +148,10 @@ static ssize_t power_write_file(struct pci_slot *pci_slot, const char *buf,
 			err ("Illegal value specified for power\n");
 			retval = -EINVAL;
 	}
-	module_put(slot->ops->owner);
 
+	pci_hotplug_exit();
+exit_put:
+	module_put(slot->ops->owner);
 exit:	
 	if (retval)
 		return retval;
@@ -500,7 +514,7 @@ int pci_hp_deregister(struct hotplug_slot *hotplug)
 		return -ENODEV;
 	}
 
-	list_del(&hotplug->slot_list);
+	list_del_init(&hotplug->slot_list);
 
 	slot = hotplug->pci_slot;
 	fs_remove_slot(slot);
-- 
1.7.5.4

