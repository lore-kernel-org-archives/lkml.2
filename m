Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755748Ab0HXW7F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 18:59:05 -0400
Received: from kroah.org ([198.145.64.141]:40432 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932562Ab0HXW6y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 18:58:54 -0400
X-Mailbox-Line: From gregkh@clark.site Tue Aug 24 15:42:15 2010
Message-Id: <20100824224215.678866443@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 24 Aug 2010 15:42:04 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Kiyoshi Ueda <k-ueda@ct.jp.nec.com>,
        Junichi Nomura <j-nomura@ce.jp.nec.com>,
        Alasdair G Kergon <agk@redhat.com>
Subject: [42/91] dm ioctl: release _hash_lock between devices in remove_all
In-Reply-To: <20100824224617.GA5440@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>

commit 98f332855effef02aeb738e4d62e9a5b903c52fd upstream.

This patch changes dm_hash_remove_all() to release _hash_lock when
removing a device.  After removing the device, dm_hash_remove_all()
takes _hash_lock and searches the hash from scratch again.

This patch is a preparation for the next patch, which changes device
deletion code to wait for md reference to be 0.  Without this patch,
the wait in the next patch may cause AB-BA deadlock:
  CPU0                                CPU1
  -----------------------------------------------------------------------
  dm_hash_remove_all()
    down_write(_hash_lock)
                                      table_status()
                                        md = find_device()
                                               dm_get(md)
                                                 <increment md->holders>
                                        dm_get_live_or_inactive_table()
                                          dm_get_inactive_table()
                                            down_write(_hash_lock)
    <in the md deletion code>
      <wait for md->holders to be 0>

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/dm-ioctl.c |   44 +++++++++++++++++++++++++-------------------
 1 file changed, 25 insertions(+), 19 deletions(-)

--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -249,40 +249,46 @@ static void __hash_remove(struct hash_ce
 
 static void dm_hash_remove_all(int keep_open_devices)
 {
-	int i, dev_skipped, dev_removed;
+	int i, dev_skipped;
 	struct hash_cell *hc;
-	struct list_head *tmp, *n;
+	struct mapped_device *md;
+
+retry:
+	dev_skipped = 0;
 
 	down_write(&_hash_lock);
 
-retry:
-	dev_skipped = dev_removed = 0;
 	for (i = 0; i < NUM_BUCKETS; i++) {
-		list_for_each_safe (tmp, n, _name_buckets + i) {
-			hc = list_entry(tmp, struct hash_cell, name_list);
+		list_for_each_entry(hc, _name_buckets + i, name_list) {
+			md = hc->md;
+			dm_get(md);
 
-			if (keep_open_devices &&
-			    dm_lock_for_deletion(hc->md)) {
+			if (keep_open_devices && dm_lock_for_deletion(md)) {
+				dm_put(md);
 				dev_skipped++;
 				continue;
 			}
+
 			__hash_remove(hc);
-			dev_removed = 1;
-		}
-	}
 
-	/*
-	 * Some mapped devices may be using other mapped devices, so if any
-	 * still exist, repeat until we make no further progress.
-	 */
-	if (dev_skipped) {
-		if (dev_removed)
-			goto retry;
+			up_write(&_hash_lock);
 
-		DMWARN("remove_all left %d open device(s)", dev_skipped);
+			dm_put(md);
+
+			/*
+			 * Some mapped devices may be using other mapped
+			 * devices, so repeat until we make no further
+			 * progress.  If a new mapped device is created
+			 * here it will also get removed.
+			 */
+			goto retry;
+		}
 	}
 
 	up_write(&_hash_lock);
+
+	if (dev_skipped)
+		DMWARN("remove_all left %d open device(s)", dev_skipped);
 }
 
 static int dm_hash_rename(uint32_t cookie, uint32_t *flags, const char *old,


