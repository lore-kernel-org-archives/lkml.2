Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754037Ab1LCIVY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Dec 2011 03:21:24 -0500
Received: from www17.your-server.de ([213.133.104.17]:58094 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752217Ab1LCIUz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Dec 2011 03:20:55 -0500
Subject: [PATCH] xen-blkfront: Use kcalloc instead of kzalloc to allocate
 array
From: Thomas Meyer <thomas@m3y3r.de>
To: xen-devel@lists.xensource.com, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Date: Tue, 29 Nov 2011 22:08:00 +0100
Message-ID: <1322600880.1534.293.camel@localhost.localdomain>
X-Mailer: Evolution 3.2.2 (3.2.2-1.fc16) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The advantage of kcalloc is, that will prevent integer overflows which could
result from the multiplication of number of elements and size and it is also
a bit nicer to read.

The semantic patch that makes this change is available
in https://lkml.org/lkml/2011/11/25/107

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/drivers/block/cciss_scsi.c b/drivers/block/cciss_scsi.c
--- a/drivers/block/cciss_scsi.c 2011-11-28 19:36:47.343430551 +0100
+++ b/drivers/block/cciss_scsi.c 2011-11-28 19:49:24.922716381 +0100
@@ -534,10 +534,10 @@ adjust_cciss_scsi_table(ctlr_info_t *h,
 	int nadded, nremoved;
 	struct Scsi_Host *sh = NULL;
 
-	added = kzalloc(sizeof(*added) * CCISS_MAX_SCSI_DEVS_PER_HBA,
-			GFP_KERNEL);
-	removed = kzalloc(sizeof(*removed) * CCISS_MAX_SCSI_DEVS_PER_HBA,
+	added = kcalloc(CCISS_MAX_SCSI_DEVS_PER_HBA, sizeof(*added),
 			GFP_KERNEL);
+	removed = kcalloc(CCISS_MAX_SCSI_DEVS_PER_HBA, sizeof(*removed),
+			  GFP_KERNEL);
 
 	if (!added || !removed) {
 		dev_warn(&h->pdev->dev,
@@ -1191,8 +1191,8 @@ cciss_update_non_disk_devices(ctlr_info_
 
 	ld_buff = kzalloc(reportlunsize, GFP_KERNEL);
 	inq_buff = kmalloc(OBDR_TAPE_INQ_SIZE, GFP_KERNEL);
-	currentsd = kzalloc(sizeof(*currentsd) *
-			(CCISS_MAX_SCSI_DEVS_PER_HBA+1), GFP_KERNEL);
+	currentsd = kcalloc(CCISS_MAX_SCSI_DEVS_PER_HBA + 1,
+			    sizeof(*currentsd), GFP_KERNEL);
 	if (ld_buff == NULL || inq_buff == NULL || currentsd == NULL) {
 		printk(KERN_ERR "cciss: out of memory\n");
 		goto out;
diff -u -p a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
--- a/drivers/block/xen-blkfront.c 2011-11-13 11:07:22.680095573 +0100
+++ b/drivers/block/xen-blkfront.c 2011-11-28 19:49:29.109460410 +0100
@@ -156,7 +156,7 @@ static int xlbd_reserve_minors(unsigned
 	if (end > nr_minors) {
 		unsigned long *bitmap, *old;
 
-		bitmap = kzalloc(BITS_TO_LONGS(end) * sizeof(*bitmap),
+		bitmap = kcalloc(BITS_TO_LONGS(end), sizeof(*bitmap),
 				 GFP_KERNEL);
 		if (bitmap == NULL)
 			return -ENOMEM;
