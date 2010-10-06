Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758163Ab0JFBug (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 21:50:36 -0400
Received: from ns2.cypress.com ([157.95.67.5]:53082 "EHLO ns2.cypress.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751493Ab0JFBuf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 21:50:35 -0400
Subject: [PATCH] west bridge, block driver change for partition support
From: David Cross <david.cross@cypress.com>
Reply-To: david.cross@cypress.com
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1286329688.9470.11.camel@odc-laptop>
References: <1285287600.17888.2.camel@odc-laptop>
	 <1286329688.9470.11.camel@odc-laptop>
Content-Type: text/plain
Organization: Cypress
Date: Tue, 05 Oct 2010 18:50:26 -0700
Message-Id: <1286329826.9470.14.camel@odc-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-Brightmail-Tracker: AAAAAA==
X-MailScanner: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes an error in the block driver wherein multiple
partitions in an mmc card were not detected correctly due to
incorrect alloc_disk arguments.

Signed-off-by: David Cross <david.cross@cypress.com>
---
diff -uprN -X linux-next-vanilla/Documentation/dontdiff linux-next-vanilla/drivers/staging/westbridge/astoria/block/cyasblkdev_block.c linux-next-incremen/drivers/staging/westbridge/astoria/block/cyasblkdev_block.c
--- linux-next-vanilla/drivers/staging/westbridge/astoria/block/cyasblkdev_block.c	2010-10-04 21:56:31.000000000 -0700
+++ linux-next-incremen/drivers/staging/westbridge/astoria/block/cyasblkdev_block.c	2010-10-05 16:35:07.000000000 -0700
@@ -403,7 +403,7 @@ int cyasblkdev_media_changed(struct gend
 	}
 
 	/* return media change state "1" yes, 0 no */
-	return 1;
+	return 0;
 }
 
 /*  this one called by kernel to give us a chence
@@ -1111,7 +1111,8 @@ static int cyasblkdev_add_disks(int bus_
 		 * public partition beginning */
 		if (vfat_search) {
 			bd->user_disk_0_first_sector =
-				cyasblkdev_get_vfat_offset(0,
+				cyasblkdev_get_vfat_offset(
+					bd->user_disk_0_bus_num,
 					bd->user_disk_0_unit_no);
 		} else {
 			bd->user_disk_0_first_sector = 0;
@@ -1244,7 +1245,8 @@ static int cyasblkdev_add_disks(int bus_
 		if (vfat_search) {
 			bd->user_disk_1_first_sector =
 				cyasblkdev_get_vfat_offset(
-					1, bd->user_disk_1_unit_no);
+					bd->user_disk_1_bus_num,
+					bd->user_disk_1_unit_no);
 		} else {
 			bd->user_disk_1_first_sector
 				= 0;
@@ -1256,8 +1258,8 @@ static int cyasblkdev_add_disks(int bus_
 	if (lcl_unit_no > 0) {
 		if (bd->system_disk == NULL) {
 			bd->system_disk =
-				alloc_disk(CYASBLKDEV_MINOR_2
-					<< CYASBLKDEV_SHIFT);
+				alloc_disk(8);
+
 			if (bd->system_disk == NULL) {
 				kfree(bd);
 				bd = ERR_PTR(-ENOMEM);
@@ -1423,8 +1425,7 @@ static struct cyasblkdev_blk_data *cyasb
 			if (bd->user_disk_0 == NULL) {
 
 				bd->user_disk_0 =
-					alloc_disk(CYASBLKDEV_MINOR_0
-						<< CYASBLKDEV_SHIFT);
+					alloc_disk(8);
 				if (bd->user_disk_0 == NULL) {
 					kfree(bd);
 					bd = ERR_PTR(-ENOMEM);
@@ -1443,8 +1444,7 @@ static struct cyasblkdev_blk_data *cyasb
 		if (total_media_count == 2) {
 			if (bd->user_disk_1 == NULL) {
 				bd->user_disk_1 =
-					alloc_disk(CYASBLKDEV_MINOR_1
-						<< CYASBLKDEV_SHIFT);
+					alloc_disk(8);
 				if (bd->user_disk_1 == NULL) {
 					kfree(bd);
 					bd = ERR_PTR(-ENOMEM);


---------------------------------------------------------------
This message and any attachments may contain Cypress (or its
subsidiaries) confidential information. If it has been received
in error, please advise the sender and immediately delete this
message.
---------------------------------------------------------------

