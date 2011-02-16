Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933468Ab1BPA4G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:56:06 -0500
Received: from kroah.org ([198.145.64.141]:46217 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933454Ab1BPAvr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:51:47 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:21:14 2011
Message-Id: <20110216002114.700906570@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:22:05 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mike Snitzer <snitzer@redhat.com>, Alasdair G Kergon <agk@redhat.com>,
        Mike Anderson <andmike@linux.vnet.ibm.com>,
        Mike Christie <michaelc@cs.wisc.edu>
Subject: [patch 157/176] dm mpath: disable blk_abort_queue
In-Reply-To: <20110216002212.GA9246@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mike Snitzer <snitzer@redhat.com>

commit 09c9d4c9b6a2b5909ae3c6265e4cd3820b636863 upstream.

Revert commit 224cb3e981f1b2f9f93dbd49eaef505d17d894c2
  dm: Call blk_abort_queue on failed paths

Multipath began to use blk_abort_queue() to allow for
lower latency path deactivation.  This was found to
cause list corruption:

   the cmd gets blk_abort_queued/timedout run on it and the scsi eh
   somehow is able to complete and run scsi_queue_insert while
   scsi_request_fn is still trying to process the request.

   https://www.redhat.com/archives/dm-devel/2010-November/msg00085.html

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Cc: Mike Anderson <andmike@linux.vnet.ibm.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/dm-mpath.c |   12 ------------
 1 file changed, 12 deletions(-)

--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -33,7 +33,6 @@ struct pgpath {
 	unsigned fail_count;		/* Cumulative failure count */
 
 	struct dm_path path;
-	struct work_struct deactivate_path;
 	struct work_struct activate_path;
 };
 
@@ -116,7 +115,6 @@ static struct workqueue_struct *kmultipa
 static void process_queued_ios(struct work_struct *work);
 static void trigger_event(struct work_struct *work);
 static void activate_path(struct work_struct *work);
-static void deactivate_path(struct work_struct *work);
 
 
 /*-----------------------------------------------
@@ -129,7 +127,6 @@ static struct pgpath *alloc_pgpath(void)
 
 	if (pgpath) {
 		pgpath->is_active = 1;
-		INIT_WORK(&pgpath->deactivate_path, deactivate_path);
 		INIT_WORK(&pgpath->activate_path, activate_path);
 	}
 
@@ -141,14 +138,6 @@ static void free_pgpath(struct pgpath *p
 	kfree(pgpath);
 }
 
-static void deactivate_path(struct work_struct *work)
-{
-	struct pgpath *pgpath =
-		container_of(work, struct pgpath, deactivate_path);
-
-	blk_abort_queue(pgpath->path.dev->bdev->bd_disk->queue);
-}
-
 static struct priority_group *alloc_priority_group(void)
 {
 	struct priority_group *pg;
@@ -995,7 +984,6 @@ static int fail_path(struct pgpath *pgpa
 		      pgpath->path.dev->name, m->nr_valid_paths);
 
 	schedule_work(&m->trigger_event);
-	queue_work(kmultipathd, &pgpath->deactivate_path);
 
 out:
 	spin_unlock_irqrestore(&m->lock, flags);


