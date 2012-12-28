Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754859Ab2L1TsA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 14:48:00 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55164 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754171Ab2L1TR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:17:57 -0500
Message-Id: <20121228190357.660801084@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 28 Dec 2012 20:05:44 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Xiaotian Feng <xtfeng@gmail.com>,
        Xiaotian Feng <dannyfeng@tencent.com>,
        James Bottomley <JBottomley@Parallels.com>,
        Jeff Garzik <jgarzik@redhat.com>
Subject: [ 134/173] [libata] fix Null pointer dereference on disk error
In-Reply-To: <20121228190330.025298996@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.217.219.220
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiaotian Feng <xtfeng@gmail.com>

commit 26cd4d65deba587f3cf2329b6869ce02bcbe68ec upstream.

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
Cc: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/ata/libata-scsi.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index a6df6a3..7c337e7 100644
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


