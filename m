Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756866Ab2AUJxs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 04:53:48 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:59940 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754544Ab2AUJxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 04:53:00 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Matthew Wilcox <matthew@wil.cx>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
        Yinghai Lu <yinghai.lu@oracle.com>
Subject: [PATCH 5/7] pciehp: Add pcie_wait_link_not_active()
Date: Sat, 21 Jan 2012 01:52:17 -0800
Message-Id: <1327139539-14301-6-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1327139539-14301-1-git-send-email-yinghai@kernel.org>
References: <1327139539-14301-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090207.4F1A8AEB.003B,ss=1,re=0.000,fgs=0
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

