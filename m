Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754027Ab2KVW1f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 17:27:35 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:40370 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753815Ab2KVW1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 17:27:32 -0500
X-Originating-IP: 217.70.178.144
X-Originating-IP: 83.160.107.163
Date: Thu, 22 Nov 2012 23:26:14 +0100
From: Matthias Kaehlcke <matthias@kaehlcke.net>
To: Pavan Savoy <pavan_savoy@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] misc/st_kim: Free resources in the error path of probe()
Message-ID: <20121122222613.GC19316@darwin>
Mail-Followup-To: Matthias Kaehlcke <matthias@kaehlcke.net>,
	Pavan Savoy <pavan_savoy@ti.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Matthias Kaehlcke <matthias@kaehlcke.net>
---
 drivers/misc/ti-st/st_kim.c |   30 +++++++++++++++++++++---------
 1 file changed, 21 insertions(+), 9 deletions(-)

diff --git a/drivers/misc/ti-st/st_kim.c b/drivers/misc/ti-st/st_kim.c
index 04a8199..9ff942a 100644
--- a/drivers/misc/ti-st/st_kim.c
+++ b/drivers/misc/ti-st/st_kim.c
@@ -705,9 +705,9 @@ static const struct file_operations list_debugfs_fops = {
 static struct dentry *kim_debugfs_dir;
 static int kim_probe(struct platform_device *pdev)
 {
-	long status;
 	struct kim_data_s	*kim_gdata;
 	struct ti_st_plat_data	*pdata = pdev->dev.platform_data;
+	int err;
 
 	if ((pdev->id != -1) && (pdev->id < MAX_ST_DEVICES)) {
 		/* multiple devices could exist */
@@ -724,10 +724,11 @@ static int kim_probe(struct platform_device *pdev)
 	}
 	dev_set_drvdata(&pdev->dev, kim_gdata);
 
-	status = st_core_init(&kim_gdata->core_data);
-	if (status != 0) {
+	err = st_core_init(&kim_gdata->core_data);
+	if (err != 0) {
 		pr_err(" ST core init failed");
-		return -EIO;
+		err = -EIO;
+		goto err_core_init;
 	}
 	/* refer to itself */
 	kim_gdata->core_data->kim_data = kim_gdata;
@@ -738,10 +739,10 @@ static int kim_probe(struct platform_device *pdev)
 	init_completion(&kim_gdata->kim_rcvd);
 	init_completion(&kim_gdata->ldisc_installed);
 
-	status = sysfs_create_group(&pdev->dev.kobj, &uim_attr_grp);
-	if (status) {
+	err = sysfs_create_group(&pdev->dev.kobj, &uim_attr_grp);
+	if (err) {
 		pr_err("failed to create sysfs entries");
-		return status;
+		goto err_sysfs_group;
 	}
 
 	/* copying platform data */
@@ -753,8 +754,8 @@ static int kim_probe(struct platform_device *pdev)
 	kim_debugfs_dir = debugfs_create_dir("ti-st", NULL);
 	if (IS_ERR(kim_debugfs_dir)) {
 		pr_err(" debugfs entries creation failed ");
-		kim_debugfs_dir = NULL;
-		return -EIO;
+		err = -EIO;
+		goto err_debugfs_dir;
 	}
 
 	debugfs_create_file("version", S_IRUGO, kim_debugfs_dir,
@@ -763,6 +764,17 @@ static int kim_probe(struct platform_device *pdev)
 				kim_gdata, &list_debugfs_fops);
 	pr_info(" debugfs entries created ");
 	return 0;
+
+err_debugfs_dir:
+	sysfs_remove_group(&pdev->dev.kobj, &uim_attr_grp);
+
+err_sysfs_group:
+	st_core_exit(kim_gdata->core_data);
+
+err_core_init:
+	kfree(kim_gdata);
+
+	return err;
 }
 
 static int kim_remove(struct platform_device *pdev)
-- 
1.7.10

