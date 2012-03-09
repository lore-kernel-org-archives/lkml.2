Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031262Ab2CITub (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 14:50:31 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48917 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031240Ab2CITu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 14:50:26 -0500
Message-Id: <20120309190209.389491452@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 09 Mar 2012 11:03:30 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Mike Snitzer <snitzer@redhat.com>,
        Alasdair G Kergon <agk@redhat.com>
Subject: [ 88/95] dm thin metadata: remove incorrect close_device on creation error paths
In-Reply-To: <20120309194424.GA2134@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Snitzer <snitzer@redhat.com>

commit 1f3db25d8be4ac50b897b39609802183ea68a514 upstream.

The __open_device() error paths in __create_thin() and __create_snap()
incorrectly call __close_device() even if td was not initialized by
__open_device().  Remove this.

Also document __open_device() return values, remove a redundant
td->changed = 1 in __create_thin(), and insert an additional
safeguard against creating an already-existing device.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-thin-metadata.c |   22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

--- a/drivers/md/dm-thin-metadata.c
+++ b/drivers/md/dm-thin-metadata.c
@@ -789,6 +789,11 @@ int dm_pool_metadata_close(struct dm_poo
 	return 0;
 }
 
+/*
+ * __open_device: Returns @td corresponding to device with id @dev,
+ * creating it if @create is set and incrementing @td->open_count.
+ * On failure, @td is undefined.
+ */
 static int __open_device(struct dm_pool_metadata *pmd,
 			 dm_thin_id dev, int create,
 			 struct dm_thin_device **td)
@@ -799,10 +804,16 @@ static int __open_device(struct dm_pool_
 	struct disk_device_details details_le;
 
 	/*
-	 * Check the device isn't already open.
+	 * If the device is already open, return it.
 	 */
 	list_for_each_entry(td2, &pmd->thin_devices, list)
 		if (td2->id == dev) {
+			/*
+			 * May not create an already-open device.
+			 */
+			if (create)
+				return -EEXIST;
+
 			td2->open_count++;
 			*td = td2;
 			return 0;
@@ -817,6 +828,9 @@ static int __open_device(struct dm_pool_
 		if (r != -ENODATA || !create)
 			return r;
 
+		/*
+		 * Create new device.
+		 */
 		changed = 1;
 		details_le.mapped_blocks = 0;
 		details_le.transaction_id = cpu_to_le64(pmd->trans_id);
@@ -882,12 +896,10 @@ static int __create_thin(struct dm_pool_
 
 	r = __open_device(pmd, dev, 1, &td);
 	if (r) {
-		__close_device(td);
 		dm_btree_remove(&pmd->tl_info, pmd->root, &key, &pmd->root);
 		dm_btree_del(&pmd->bl_info, dev_root);
 		return r;
 	}
-	td->changed = 1;
 	__close_device(td);
 
 	return r;
@@ -967,14 +979,14 @@ static int __create_snap(struct dm_pool_
 		goto bad;
 
 	r = __set_snapshot_details(pmd, td, origin, pmd->time);
+	__close_device(td);
+
 	if (r)
 		goto bad;
 
-	__close_device(td);
 	return 0;
 
 bad:
-	__close_device(td);
 	dm_btree_remove(&pmd->tl_info, pmd->root, &key, &pmd->root);
 	dm_btree_remove(&pmd->details_info, pmd->details_root,
 			&key, &pmd->details_root);


