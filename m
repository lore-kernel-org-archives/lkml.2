Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964819Ab1C3VHK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:07:10 -0400
Received: from mga02.intel.com ([134.134.136.20]:51403 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933352Ab1C3VG6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:06:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="727133054"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: snitzer@redhat.com, agk@redhat.com, ak@linux.intel.com,
        andmike@linux.vnet.ibm.com, michaelc@cs.wisc.edu, gregkh@suse.de,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [78/275] dm mpath: disable blk_abort_queue
Message-Id: <20110330210515.CA2283E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:05:15 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Mike Anderson <andmike@linux.vnet.ibm.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/dm-mpath.c |   12 ------------
 1 file changed, 12 deletions(-)

Index: linux-2.6.35.y/drivers/md/dm-mpath.c
===================================================================
--- linux-2.6.35.y.orig/drivers/md/dm-mpath.c	2011-03-29 22:51:38.968726056 -0700
+++ linux-2.6.35.y/drivers/md/dm-mpath.c	2011-03-29 23:02:59.780305791 -0700
@@ -33,7 +33,6 @@
 	unsigned fail_count;		/* Cumulative failure count */
 
 	struct dm_path path;
-	struct work_struct deactivate_path;
 	struct work_struct activate_path;
 };
 
@@ -116,7 +115,6 @@
 static void process_queued_ios(struct work_struct *work);
 static void trigger_event(struct work_struct *work);
 static void activate_path(struct work_struct *work);
-static void deactivate_path(struct work_struct *work);
 
 
 /*-----------------------------------------------
@@ -129,7 +127,6 @@
 
 	if (pgpath) {
 		pgpath->is_active = 1;
-		INIT_WORK(&pgpath->deactivate_path, deactivate_path);
 		INIT_WORK(&pgpath->activate_path, activate_path);
 	}
 
@@ -141,14 +138,6 @@
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
@@ -993,7 +982,6 @@
 		      pgpath->path.dev->name, m->nr_valid_paths);
 
 	schedule_work(&m->trigger_event);
-	queue_work(kmultipathd, &pgpath->deactivate_path);
 
 out:
 	spin_unlock_irqrestore(&m->lock, flags);
