Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753445Ab2LMILd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 03:11:33 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:33048 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426Ab2LMIL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 03:11:29 -0500
From: Xiaotian Feng <xtfeng@gmail.com>
To: jgarzik@pobox.com
Cc: Xiaotian Feng <xtfeng@gmail.com>, Xiaotian Feng <dannyfeng@tencent.com>,
        Jeff Garzik <jgarzik@redhat.com>,
        James Bottomley <JBottomley@Parallels.com>, stable@kernel.org,
        linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [libata] scsi: fix Null pointer dereference on disk error
Date: Thu, 13 Dec 2012 16:12:18 +0800
Message-Id: <1355386339-11411-1-git-send-email-xtfeng@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following oops were observed when disk error happened:

[ 4272.896937] sd 0:0:0:0: [sda] Unhandled error code
[ 4272.896939] sd 0:0:0:0: [sda] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[ 4272.896942] sd 0:0:0:0: [sda] CDB: Read(10): 28 00 00 5a de a7 00 00 08 00
[ 4272.896951] end_request: I/O error, dev sda, sector 5955239
[ 4291.574947] BUG: unable to handle kernel NULL pointer dereference at (null)
[ 4291.658305] IP: [] ahci_activity_show+0x1/0x40
[ 4291.730090] PGD 76dbbc067 PUD 6c4fba067 PMD 0
[ 4291.783408] Oops: 0000 [#1] SMP
[ 4291.822100] last sysfs file: /sys/devices/pci0000:00/0000:00:1f.2/host0/target0:0:0/0:0:0:0/sw_activity
[ 4291.934235] CPU 9
[ 4291.958301] Pid: 27942, comm: hwinfo ......

ata_scsi_find_dev could return NULL, so ata_scsi_activity_{show,store} should check if atadev is NULL.

Signed-off-by: Xiaotian Feng <dannyfeng@tencent.com>
Cc: Jeff Garzik <jgarzik@redhat.com>
Cc: James Bottomley <JBottomley@Parallels.com>
Cc: stable@kernel.org
Cc: linux-ide@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/ata/libata-scsi.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index a6df6a3..6407f05 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -309,7 +309,8 @@ ata_scsi_activity_show(struct device *dev, struct device_attribute *attr,
 	struct ata_port *ap = ata_shost_to_port(sdev->host);
 	struct ata_device *atadev = ata_scsi_find_dev(ap, sdev);
 
-	if (ap->ops->sw_activity_show && (ap->flags & ATA_FLAG_SW_ACTIVITY))
+	if (atadev && ap->ops->sw_activity_show &&
+	    (ap->flags & ATA_FLAG_SW_ACTIVITY))
 		return ap->ops->sw_activity_show(atadev, buf);
 	return -EINVAL;
 }
@@ -324,7 +325,8 @@ ata_scsi_activity_store(struct device *dev, struct device_attribute *attr,
 	enum sw_activity val;
 	int rc;
 
-	if (ap->ops->sw_activity_store && (ap->flags & ATA_FLAG_SW_ACTIVITY)) {
+	if (atadev && ap->ops->sw_activity_store &&
+	    (ap->flags & ATA_FLAG_SW_ACTIVITY)) {
 		val = simple_strtoul(buf, NULL, 0);
 		switch (val) {
 		case OFF: case BLINK_ON: case BLINK_OFF:
-- 
1.7.9.5

