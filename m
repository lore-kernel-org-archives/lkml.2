Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755162Ab0DZTbx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 15:31:53 -0400
Received: from ppsw-33.csi.cam.ac.uk ([131.111.8.133]:51611 "EHLO
	ppsw-33.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754734Ab0DZT2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 15:28:31 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
From: Jonathan Cameron <jic23@cam.ac.uk>
To: iio-linux@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de,
       Jonathan Cameron <jic23@cam.ac.uk>
Subject: [PATCH 06/19] staging:iio: Move event attributes into the event[n] device in sysfs
Date: Mon, 26 Apr 2010 20:31:08 +0100
Message-Id: <1272310281-7418-7-git-send-email-jic23@cam.ac.uk>
X-Mailer: git-send-email 1.6.4.4
In-Reply-To: <1272310281-7418-6-git-send-email-jic23@cam.ac.uk>
References: <1272310281-7418-1-git-send-email-jic23@cam.ac.uk>
 <1272310281-7418-2-git-send-email-jic23@cam.ac.uk>
 <1272310281-7418-3-git-send-email-jic23@cam.ac.uk>
 <1272310281-7418-4-git-send-email-jic23@cam.ac.uk>
 <1272310281-7418-5-git-send-email-jic23@cam.ac.uk>
 <1272310281-7418-6-git-send-email-jic23@cam.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
---
 drivers/staging/iio/industrialio-core.c |   25 ++++++++++++-------------
 1 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/iio/industrialio-core.c b/drivers/staging/iio/industrialio-core.c
index c19a080..3df23be 100644
--- a/drivers/staging/iio/industrialio-core.c
+++ b/drivers/staging/iio/industrialio-core.c
@@ -676,16 +676,14 @@ static int iio_device_register_eventset(struct iio_dev *dev_info)
 					 dev_info->event_interfaces[i].id);
 			goto error_free_setup_ev_ints;
 		}
-	}
 
-	for (i = 0; i < dev_info->num_interrupt_lines; i++) {
-		snprintf(dev_info->event_interfaces[i]._attrname, 20,
-			"event_line%d_sources", i);
-		dev_info->event_attrs[i].name
-			= (const char *)
-			(dev_info->event_interfaces[i]._attrname);
-		ret = sysfs_create_group(&dev_info->dev.kobj,
-					 &dev_info->event_attrs[i]);
+		dev_set_drvdata(&dev_info->event_interfaces[i].dev,
+				(void *)dev_info);
+		ret = sysfs_create_group(&dev_info
+					->event_interfaces[i]
+					.dev.kobj,
+					&dev_info->event_attrs[i]);
+
 		if (ret) {
 			dev_err(&dev_info->dev,
 				"Failed to register sysfs for event attrs");
@@ -707,13 +705,13 @@ error_unregister_config_attrs:
 	i = dev_info->num_interrupt_lines - 1;
 error_remove_sysfs_interfaces:
 	for (j = 0; j < i; j++)
-		sysfs_remove_group(&dev_info->dev.kobj,
+		sysfs_remove_group(&dev_info
+				   ->event_interfaces[j].dev.kobj,
 				   &dev_info->event_attrs[j]);
-	i = dev_info->num_interrupt_lines - 1;
 error_free_setup_ev_ints:
 	for (j = 0; j < i; j++) {
 		iio_free_idr_val(&iio_event_idr,
-				 dev_info->event_interfaces[i].id);
+				 dev_info->event_interfaces[j].id);
 		iio_free_ev_int(&dev_info->event_interfaces[j]);
 	}
 	kfree(dev_info->interrupts);
@@ -731,7 +729,8 @@ static void iio_device_unregister_eventset(struct iio_dev *dev_info)
 	if (dev_info->num_interrupt_lines == 0)
 		return;
 	for (i = 0; i < dev_info->num_interrupt_lines; i++)
-		sysfs_remove_group(&dev_info->dev.kobj,
+		sysfs_remove_group(&dev_info
+				   ->event_interfaces[i].dev.kobj,
 				   &dev_info->event_attrs[i]);
 
 	for (i = 0; i < dev_info->num_interrupt_lines; i++) {
-- 
1.6.4.4

