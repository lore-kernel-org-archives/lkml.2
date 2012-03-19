Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162064Ab2CSGDz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 02:03:55 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:29330 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161150Ab2CSFrl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 01:47:41 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, x86 <x86@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH -v3 13/47] PCI: Clean up rescan_bus_bridge_resize()
Date: Sun, 18 Mar 2012 22:46:02 -0700
Message-Id: <1332135996-13860-14-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1332135996-13860-1-git-send-email-yinghai@kernel.org>
References: <1332135996-13860-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4F66C87B.0021,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Should only use it with bridge instead of bus.
It could get new subordinate. so can not use it with reguar bus.

In that case, user may need to make sure all children devices get removed
already before rescan.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/pci-sysfs.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index d5c8ffb..2049b2f 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -337,7 +337,7 @@ dev_bridge_rescan_store(struct device *dev, struct device_attribute *attr,
 
 	if (val) {
 		mutex_lock(&pci_remove_rescan_mutex);
-		pci_rescan_bus(pdev->subordinate);
+		pci_rescan_bus_bridge_resize(pdev);
 		mutex_unlock(&pci_remove_rescan_mutex);
 	}
 	return count;
@@ -387,10 +387,7 @@ dev_bus_rescan_store(struct device *dev, struct device_attribute *attr,
 
 	if (val) {
 		mutex_lock(&pci_remove_rescan_mutex);
-		if (!pci_is_root_bus(bus) && list_empty(&bus->devices))
-			pci_rescan_bus_bridge_resize(bus->self);
-		else
-			pci_rescan_bus(bus);
+		pci_rescan_bus(bus);
 		mutex_unlock(&pci_remove_rescan_mutex);
 	}
 	return count;
-- 
1.7.7

