Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756635Ab2AUJxm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 04:53:42 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:42686 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752599Ab2AUJwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 04:52:46 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Matthew Wilcox <matthew@wil.cx>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 4/7] pciehp: print out link status when dlla get active.
Date: Sat, 21 Jan 2012 01:52:16 -0800
Message-Id: <1327139539-14301-5-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1327139539-14301-1-git-send-email-yinghai@kernel.org>
References: <1327139539-14301-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090201.4F1A8AE8.009D,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use it get timestamp to calculate time for the pci conf access readness.

and let it return bool instead of int.

also remove inline attribute, let compiler decide it.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/hotplug/pciehp_hpc.c |   17 ++++++++++++-----
 1 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/pci/hotplug/pciehp_hpc.c b/drivers/pci/hotplug/pciehp_hpc.c
index ad8c1be..a1a9879 100644
--- a/drivers/pci/hotplug/pciehp_hpc.c
+++ b/drivers/pci/hotplug/pciehp_hpc.c
@@ -241,13 +241,20 @@ static int pcie_write_cmd(struct controller *ctrl, u16 cmd, u16 mask)
 	return retval;
 }
 
-static inline int check_link_active(struct controller *ctrl)
+static bool check_link_active(struct controller *ctrl)
 {
-	u16 link_status;
+	bool ret = false;
+	u16 lnk_status;
 
-	if (pciehp_readw(ctrl, PCI_EXP_LNKSTA, &link_status))
-		return 0;
-	return !!(link_status & PCI_EXP_LNKSTA_DLLLA);
+	if (pciehp_readw(ctrl, PCI_EXP_LNKSTA, &lnk_status))
+		return ret;
+
+	ret = !!(lnk_status & PCI_EXP_LNKSTA_DLLLA);
+
+	if (ret)
+		ctrl_dbg(ctrl, "%s: lnk_status = %x\n", __func__, lnk_status);
+
+	return ret;
 }
 
 static void pcie_wait_link_active(struct controller *ctrl)
-- 
1.7.7

