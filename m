Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753453Ab2AZSjN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 13:39:13 -0500
Received: from mga02.intel.com ([134.134.136.20]:12851 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752484Ab2AZSjM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 13:39:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="103068461"
From: Allen Kay <allen.m.kay@intel.com>
To: linux-pci-owner@vger.kernel.org
Cc: jesse.barnes@intel.com, matthew.wilcox@intel.com,
        linux-kernel@vger.kernel.org, jean.guyader@eu.citrix.com,
        eric.chanudet@citrix.com, allen.m.kay@intel.com
Subject: [PATCH 1/1] check for pci bar restore completion and retry
Date: Thu, 26 Jan 2012 10:23:44 -0800
Message-Id: <1327602224-30710-1-git-send-email-allen.m.kay@intel.com>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On some OEM systems, pci_restore_state() is called while FLR has not yet
completed.  As a result, PCI BAR register restore is not successful.  This fix
reads back the restored value and compares it with saved value and re-tries 10
times before giving up.

Signed-off-by: Jean Guyader <jean.guyader@eu.citrix.com>
Signed-off-by: Eric Chanudet <eric.chanudet@citrix.com>
Signed-off-by: Allen Kay <allen.m.kay@intel.com>
---
 drivers/pci/pci.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index af295bb..0549050 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -959,6 +959,7 @@ void pci_restore_state(struct pci_dev *dev)
 {
 	int i;
 	u32 val;
+	int tries;
 
 	if (!dev->state_saved)
 		return;
@@ -973,12 +974,16 @@ void pci_restore_state(struct pci_dev *dev)
 	 */
 	for (i = 15; i >= 0; i--) {
 		pci_read_config_dword(dev, i * 4, &val);
-		if (val != dev->saved_config_space[i]) {
+		tries = 10;		
+		while (tries && val != dev->saved_config_space[i]) {
 			dev_dbg(&dev->dev, "restoring config "
 				"space at offset %#x (was %#x, writing %#x)\n",
 				i, val, (int)dev->saved_config_space[i]);
 			pci_write_config_dword(dev,i * 4,
 				dev->saved_config_space[i]);
+			pci_read_config_dword(dev, i * 4, &val);
+			mdelay(10);
+			tries--;
 		}
 	}
 	pci_restore_pcix_state(dev);
-- 
1.6.0.6

