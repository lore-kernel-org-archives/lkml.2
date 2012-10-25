Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759954Ab2JYPnP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 11:43:15 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:3505 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754116Ab2JYPnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 11:43:13 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 25 Oct 2012 08:31:00 -0700
From: Denis Kirjanov <kirjanov@gmail.com>
To: dougthompson@xmission.com
CC: linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org,
        kirjanov@gmail.com
Subject: [PATCH 1/2] handle error path in edac_mc_sysfs_init()
Date: Thu, 25 Oct 2012 19:42:58 +0400
Message-ID: <1351179778-6591-1-git-send-email-kirjanov@gmail.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Handle errors on edac_mc_sysfs_init()'s error path

Signed-off-by: Denis Kirjanov <kirjanov@gmail.com>
---
 drivers/edac/edac_mc_sysfs.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/edac/edac_mc_sysfs.c b/drivers/edac/edac_mc_sysfs.c
index ed0bc07..ea34ece 100644
--- a/drivers/edac/edac_mc_sysfs.c
+++ b/drivers/edac/edac_mc_sysfs.c
@@ -1124,11 +1124,16 @@ int __init edac_mc_sysfs_init(void)
 	edac_subsys = edac_get_sysfs_subsys();
 	if (edac_subsys == NULL) {
 		edac_dbg(1, "no edac_subsys\n");
-		return -EINVAL;
+		err = -EINVAL;
+		goto out;
 	}
 
 	mci_pdev = kzalloc(sizeof(*mci_pdev), GFP_KERNEL);
-
+	if (!mci_pdev) {
+		err = -ENOMEM;
+		goto out_put_sysfs;
+	}
+		
 	mci_pdev->bus = edac_subsys;
 	mci_pdev->type = &mc_attr_type;
 	device_initialize(mci_pdev);
@@ -1141,6 +1146,11 @@ int __init edac_mc_sysfs_init(void)
 	edac_dbg(0, "device %s created\n", dev_name(mci_pdev));
 
 	return 0;
+
+out_put_sysfs:
+	edac_put_sysfs_subsys();
+out:
+	return err;
 }
 
 void __exit edac_mc_sysfs_exit(void)
-- 
1.7.9.5

