Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756687Ab0HXXKt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 19:10:49 -0400
Received: from kroah.org ([198.145.64.141]:41323 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933601Ab0HXXDQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 19:03:16 -0400
X-Mailbox-Line: From gregkh@clark.site Tue Aug 24 15:45:08 2010
Message-Id: <20100824224508.545220406@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 24 Aug 2010 15:45:29 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Kiyoshi Ueda <k-ueda@ct.jp.nec.com>,
        Junichi Nomura <j-nomura@ce.jp.nec.com>,
        Alasdair G Kergon <agk@redhat.com>
Subject: [084/114] dm: separate device deletion from dm_put
In-Reply-To: <20100824224610.GA5424@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>

commit 3f77316de0ec0fd208467fbee8d9edc70e2c73b2 upstream.

This patch separates the device deletion code from dm_put()
to make sure the deletion happens in the process context.

By this patch, device deletion always occurs in an ioctl (process)
context and dm_put() can be called in interrupt context.
As a result, the request-based dm's bad dm_put() usage pointed out
by Mikulas below disappears.
    http://marc.info/?l=dm-devel&m=126699981019735&w=2

Without this patch, I confirmed there is a case to crash the system:
    dm_put() => dm_table_destroy() => vfree() => BUG_ON(in_interrupt())

Some more backgrounds and details:
In request-based dm, a device opener can remove a mapped_device
while the last request is still completing, because bios in the last
request complete first and then the device opener can close and remove
the mapped_device before the last request completes:
  CPU0                                          CPU1
  =================================================================
  <<INTERRUPT>>
  blk_end_request_all(clone_rq)
    blk_update_request(clone_rq)
      bio_endio(clone_bio) == end_clone_bio
        blk_update_request(orig_rq)
          bio_endio(orig_bio)
                                                <<I/O completed>>
                                                dm_blk_close()
                                                dev_remove()
                                                  dm_put(md)
                                                    <<Free md>>
   blk_finish_request(clone_rq)
     ....
     dm_end_request(clone_rq)
       free_rq_clone(clone_rq)
       blk_end_request_all(orig_rq)
       rq_completed(md)

So request-based dm used dm_get()/dm_put() to hold md for each I/O
until its request completion handling is fully done.
However, the final dm_put() can call the device deletion code which
must not be run in interrupt context and may cause kernel panic.

To solve the problem, this patch moves the device deletion code,
dm_destroy(), to predetermined places that is actually deleting
the mapped_device in ioctl (process) context, and changes dm_put()
just to decrement the reference count of the mapped_device.
By this change, dm_put() can be used in any context and the symmetric
model below is introduced:
    dm_create():  create a mapped_device
    dm_destroy(): destroy a mapped_device
    dm_get():     increment the reference count of a mapped_device
    dm_put():     decrement the reference count of a mapped_device

dm_destroy() waits for all references of the mapped_device to disappear,
then deletes the mapped_device.

dm_destroy() uses active waiting with msleep(1), since deleting
the mapped_device isn't performance-critical task.
And since at this point, nobody opens the mapped_device and no new
reference will be taken, the pending counts are just for racing
completing activity and will eventually decrease to zero.

For the unlikely case of the forced module unload, dm_destroy_immediate(),
which doesn't wait and forcibly deletes the mapped_device, is also
introduced and used in dm_hash_remove_all().  Otherwise, "rmmod -f"
may be stuck and never return.
And now, because the mapped_device is deleted at this point, subsequent
accesses to the mapped_device may cause NULL pointer references.

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/dm-ioctl.c |    6 ++++
 drivers/md/dm.c       |   62 +++++++++++++++++++++++++++++++++++++-------------
 drivers/md/dm.h       |    5 ++++
 3 files changed, 57 insertions(+), 16 deletions(-)

--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -274,6 +274,10 @@ retry:
 			up_write(&_hash_lock);
 
 			dm_put(md);
+			if (likely(keep_open_devices))
+				dm_destroy(md);
+			else
+				dm_destroy_immediate(md);
 
 			/*
 			 * Some mapped devices may be using other mapped
@@ -646,6 +650,7 @@ static int dev_create(struct dm_ioctl *p
 	r = dm_hash_insert(param->name, *param->uuid ? param->uuid : NULL, md);
 	if (r) {
 		dm_put(md);
+		dm_destroy(md);
 		return r;
 	}
 
@@ -748,6 +753,7 @@ static int dev_remove(struct dm_ioctl *p
 		param->flags |= DM_UEVENT_GENERATED_FLAG;
 
 	dm_put(md);
+	dm_destroy(md);
 	return 0;
 }
 
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -19,6 +19,7 @@
 #include <linux/slab.h>
 #include <linux/idr.h>
 #include <linux/hdreg.h>
+#include <linux/delay.h>
 
 #include <trace/events/block.h>
 
@@ -2176,6 +2177,7 @@ void dm_set_mdptr(struct mapped_device *
 void dm_get(struct mapped_device *md)
 {
 	atomic_inc(&md->holders);
+	BUG_ON(test_bit(DMF_FREEING, &md->flags));
 }
 
 const char *dm_device_name(struct mapped_device *md)
@@ -2184,27 +2186,55 @@ const char *dm_device_name(struct mapped
 }
 EXPORT_SYMBOL_GPL(dm_device_name);
 
-void dm_put(struct mapped_device *md)
+static void __dm_destroy(struct mapped_device *md, bool wait)
 {
 	struct dm_table *map;
 
-	BUG_ON(test_bit(DMF_FREEING, &md->flags));
+	might_sleep();
 
-	if (atomic_dec_and_lock(&md->holders, &_minor_lock)) {
-		map = dm_get_live_table(md);
-		idr_replace(&_minor_idr, MINOR_ALLOCED,
-			    MINOR(disk_devt(dm_disk(md))));
-		set_bit(DMF_FREEING, &md->flags);
-		spin_unlock(&_minor_lock);
-		if (!dm_suspended_md(md)) {
-			dm_table_presuspend_targets(map);
-			dm_table_postsuspend_targets(map);
-		}
-		dm_sysfs_exit(md);
-		dm_table_put(map);
-		dm_table_destroy(__unbind(md));
-		free_dev(md);
+	spin_lock(&_minor_lock);
+	map = dm_get_live_table(md);
+	idr_replace(&_minor_idr, MINOR_ALLOCED, MINOR(disk_devt(dm_disk(md))));
+	set_bit(DMF_FREEING, &md->flags);
+	spin_unlock(&_minor_lock);
+
+	if (!dm_suspended_md(md)) {
+		dm_table_presuspend_targets(map);
+		dm_table_postsuspend_targets(map);
 	}
+
+	/*
+	 * Rare, but there may be I/O requests still going to complete,
+	 * for example.  Wait for all references to disappear.
+	 * No one should increment the reference count of the mapped_device,
+	 * after the mapped_device state becomes DMF_FREEING.
+	 */
+	if (wait)
+		while (atomic_read(&md->holders))
+			msleep(1);
+	else if (atomic_read(&md->holders))
+		DMWARN("%s: Forcibly removing mapped_device still in use! (%d users)",
+		       dm_device_name(md), atomic_read(&md->holders));
+
+	dm_sysfs_exit(md);
+	dm_table_put(map);
+	dm_table_destroy(__unbind(md));
+	free_dev(md);
+}
+
+void dm_destroy(struct mapped_device *md)
+{
+	__dm_destroy(md, true);
+}
+
+void dm_destroy_immediate(struct mapped_device *md)
+{
+	__dm_destroy(md, false);
+}
+
+void dm_put(struct mapped_device *md)
+{
+	atomic_dec(&md->holders);
 }
 EXPORT_SYMBOL_GPL(dm_put);
 
--- a/drivers/md/dm.h
+++ b/drivers/md/dm.h
@@ -122,6 +122,11 @@ void dm_linear_exit(void);
 int dm_stripe_init(void);
 void dm_stripe_exit(void);
 
+/*
+ * mapped_device operations
+ */
+void dm_destroy(struct mapped_device *md);
+void dm_destroy_immediate(struct mapped_device *md);
 int dm_open_count(struct mapped_device *md);
 int dm_lock_for_deletion(struct mapped_device *md);
 


