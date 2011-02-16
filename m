Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933376Ab1BPAvZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:51:25 -0500
Received: from kroah.org ([198.145.64.141]:46114 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933351Ab1BPAvP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:51:15 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:21:13 2011
Message-Id: <20110216002113.143896097@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:21:49 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        NeilBrown <neilb@suse.de>
Subject: [patch 141/176] md: Ensure no IO request to get md device before it is properly initialised.
In-Reply-To: <20110216002212.GA9246@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: NeilBrown <neilb@suse.de>

commit 0ca69886a8273ac1350143d562280bfcbe4760dc upstream.

When an md device is in the process of coming on line it is possible
for an IO request (typically a partition table probe) to get through
before the array is fully initialised, which can cause unexpected
behaviour (e.g. a crash).

So explicitly record when the array is ready for IO and don't allow IO
through until then.

There is no possibility for a similar problem when the array is going
off-line as there must only be one 'open' at that time, and it is busy
off-lining the array and so cannot send IO requests.  So no memory
barrier is needed in md_stop()

This has been a bug since commit 409c57f3801 in 2.6.30 which
introduced md_make_request.  Before then, each personality would
register its own make_request_fn when it was ready.
This is suitable for any stable kernel from 2.6.30.y onwards.

Signed-off-by: NeilBrown <neilb@suse.de>
Reported-by:  "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/md.c |    8 ++++++--
 drivers/md/md.h |    3 ++-
 2 files changed, 8 insertions(+), 3 deletions(-)

--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -221,10 +221,12 @@ static int md_make_request(struct reques
 	int rv;
 	int cpu;
 
-	if (mddev == NULL || mddev->pers == NULL) {
+	if (mddev == NULL || mddev->pers == NULL
+	    || !mddev->ready) {
 		bio_io_error(bio);
 		return 0;
 	}
+	smp_rmb(); /* Ensure implications of  'active' are visible */
 	rcu_read_lock();
 	if (mddev->suspended || mddev->barrier) {
 		DEFINE_WAIT(__wait);
@@ -4554,7 +4556,8 @@ int md_run(mddev_t *mddev)
 	mddev->safemode_timer.data = (unsigned long) mddev;
 	mddev->safemode_delay = (200 * HZ)/1000 +1; /* 200 msec delay */
 	mddev->in_sync = 1;
-
+	smp_wmb();
+	mddev->ready = 1;
 	list_for_each_entry(rdev, &mddev->disks, same_set)
 		if (rdev->raid_disk >= 0) {
 			char nm[20];
@@ -4716,6 +4719,7 @@ EXPORT_SYMBOL_GPL(md_stop_writes);
 
 void md_stop(mddev_t *mddev)
 {
+	mddev->ready = 0;
 	mddev->pers->stop(mddev);
 	if (mddev->pers->sync_request && mddev->to_remove == NULL)
 		mddev->to_remove = &md_redundancy_group;
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -149,7 +149,8 @@ struct mddev_s
 						       * are happening, so run/
 						       * takeover/stop are not safe
 						       */
-
+	int				ready; /* See when safe to pass
+						* IO requests down */
 	struct gendisk			*gendisk;
 
 	struct kobject			kobj;


