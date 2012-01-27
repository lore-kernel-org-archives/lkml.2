Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753414Ab2A0Szj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 13:55:39 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:24521 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753248Ab2A0Szg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 13:55:36 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Matthew Wilcox <matthew@wil.cx>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
        Yinghai Lu <yinghai.lu@oracle.com>
Subject: [PATCH 5/7] pciehp: Add pcie_wait_link_not_active()
Date: Fri, 27 Jan 2012 10:55:13 -0800
Message-Id: <1327690515-2991-6-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1327690515-2991-1-git-send-email-yinghai@kernel.org>
References: <1327690515-2991-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4F22F323.00AB,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Will use for link disable status checking

Signed-off-by: Yinghai Lu <yinghai.lu@oracle.com>
---
 drivers/pci/hotplug/pciehp_hpc.c |   19 +++++++++++++++----
 1 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/pci/hotplug/pciehp_hpc.c b/drivers/pci/hotplug/pciehp_hpc.c
index a1a9879..ea54aef 100644
--- a/drivers/pci/hotplug/pciehp_hpc.c
+++ b/drivers/pci/hotplug/pciehp_hpc.c
@@ -257,19 +257,30 @@ static bool check_link_active(struct controller *ctrl)
 	return ret;
 }
 
-static void pcie_wait_link_active(struct controller *ctrl)
+static void __pcie_wait_link_active(struct controller *ctrl, bool active)
 {
 	int timeout = 1000;
 
-	if (check_link_active(ctrl))
+	if (check_link_active(ctrl) == active)
 		return;
 	while (timeout > 0) {
 		msleep(10);
 		timeout -= 10;
-		if (check_link_active(ctrl))
+		if (check_link_active(ctrl) == active)
 			return;
 	}
-	ctrl_dbg(ctrl, "Data Link Layer Link Active not set in 1000 msec\n");
+	ctrl_dbg(ctrl, "Data Link Layer Link Active not %s in 1000 msec\n",
+			active ? "set" : "cleared");
+}
+
+static void pcie_wait_link_active(struct controller *ctrl)
+{
+	__pcie_wait_link_active(ctrl, true);
+}
+
+static void pcie_wait_link_not_active(struct controller *ctrl)
+{
+	__pcie_wait_link_active(ctrl, false);
 }
 
 static bool pci_bus_check_dev(struct pci_bus *bus, int devfn)
-- 
1.7.7

