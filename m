Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754021Ab0ISMyp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Sep 2010 08:54:45 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:44711 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753726Ab0ISMyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Sep 2010 08:54:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=kAbV2TUdEmmAQpF7nD78SYzPF2+6GUHcfAnrFOitYtm8F7E1ROlpqtNPIwhIfMU/4q
         +vKiPFhG5lMXrzw8Eun6KdOvVkjMtdUQUfiqT//siY2ddagkCoDF6OTxGD3Zlc01+9T1
         vk+j/Yufz0SZFpqFp1i0bcSqXyNAcuqf9p7H8=
From: Vasiliy Kulikov <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Christof Schmitt <christof.schmitt@de.ibm.com>,
        Swen Schillig <swen@vnet.ibm.com>, linux390@de.ibm.com,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        James Bottomley <James.Bottomley@suse.de>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 01/14] s390: scsi: fix error path
Date: Sun, 19 Sep 2010 16:54:36 +0400
Message-Id: <1284900877-24201-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

zfcp_unit_add() doesn't free all allocated resources in error case.

Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
---
 I cannot compile this driver, so it is not tested at all.

 drivers/s390/scsi/zfcp_unit.c |   28 +++++++++++++++++-----------
 1 files changed, 17 insertions(+), 11 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_unit.c b/drivers/s390/scsi/zfcp_unit.c
index 1119c53..8eb4046 100644
--- a/drivers/s390/scsi/zfcp_unit.c
+++ b/drivers/s390/scsi/zfcp_unit.c
@@ -119,6 +119,7 @@ static void zfcp_unit_release(struct device *dev)
 int zfcp_unit_add(struct zfcp_port *port, u64 fcp_lun)
 {
 	struct zfcp_unit *unit;
+	int err;
 
 	unit = zfcp_unit_find(port, fcp_lun);
 	if (unit) {
@@ -136,21 +137,20 @@ int zfcp_unit_add(struct zfcp_port *port, u64 fcp_lun)
 	unit->dev.release = zfcp_unit_release;
 	INIT_WORK(&unit->scsi_work, zfcp_unit_scsi_scan_work);
 
-	if (dev_set_name(&unit->dev, "0x%016llx",
-			 (unsigned long long) fcp_lun)) {
-		kfree(unit);
-		return -ENOMEM;
-	}
+	err = dev_set_name(&unit->dev, "0x%016llx",
+			 (unsigned long long) fcp_lun);
+	if (err)
+		goto err_free;
 
-	if (device_register(&unit->dev)) {
+	err = device_register(&unit->dev);
+	if (err) {
 		put_device(&unit->dev);
-		return -ENOMEM;
+		goto err_free;
 	}
 
-	if (sysfs_create_group(&unit->dev.kobj, &zfcp_sysfs_unit_attrs)) {
-		device_unregister(&unit->dev);
-		return -EINVAL;
-	}
+	err = sysfs_create_group(&unit->dev.kobj, &zfcp_sysfs_unit_attrs);
+	if (err)
+		goto err_unreg;
 
 	get_device(&port->dev);
 
@@ -161,6 +161,12 @@ int zfcp_unit_add(struct zfcp_port *port, u64 fcp_lun)
 	zfcp_unit_scsi_scan(unit);
 
 	return 0;
+
+err_unreg:
+	device_unregister(&unit->dev);
+err_free:
+	kfree(unit);
+	return err;
 }
 
 /**
-- 
1.7.0.4

