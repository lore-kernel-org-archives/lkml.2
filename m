Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754915Ab0JJO6O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Oct 2010 10:58:14 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:57332 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751707Ab0JJO6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Oct 2010 10:58:13 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 10 Oct 2010 16:57:11 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] firewire: sbp2: parallelize login/inquiry, reconnect, and
 shutdown
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
In-Reply-To: <tkrat.06dc43b96f9ab9bf@s5r6.in-berlin.de>
Message-ID: <tkrat.1433473bc081daa9@s5r6.in-berlin.de>
References: <tkrat.06dc43b96f9ab9bf@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

firewire-sbp2 used to perform management tasks (and SCSI Inquiry, sd
probe etc.) in one single-threaded workqueue for all targets.  Some of
these jobs may take very long, e.g. when the target needs to spin up a
disk to perform the task.

We should have had per-target workqueues for that but didn't because
that would have created respectively many kernel threads which almost
always sit idle.  Now that we have concurrency managed workqueues,
correct that lack of parallelism:

Simply swap out the driver workqueue by system_nrt_wq.  It provides all
the parallelism we will ever need, accepts long-running work, and
provides the here necessary guarantee of non-reentrance across all CPUs.
(The work items are scheduled from firewire-core's fw_device work items
which themselves may change CPUs.)

This simple approach requires though that targets with multiple logical
units accept multiple outstanding management requests.  The SBP-2 spec
implicitly requires this capability, but who knows how real firmwares
react.

I only have access to two dual-LU targets:  A OXUF924DSB based one from
MacPower and a INIC-2430 based one from IOI.  They both work fine with
this change, as do several single-LU targets of course.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/sbp2.c |    9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

Index: b/drivers/firewire/sbp2.c
===================================================================
--- a/drivers/firewire/sbp2.c
+++ b/drivers/firewire/sbp2.c
@@ -835,8 +835,6 @@ static void sbp2_target_put(struct sbp2_
 	kref_put(&tgt->kref, sbp2_release_target);
 }
 
-static struct workqueue_struct *sbp2_wq;
-
 /*
  * Always get the target's kref when scheduling work on one its units.
  * Each workqueue job is responsible to call sbp2_target_put() upon return.
@@ -844,7 +842,7 @@ static struct workqueue_struct *sbp2_wq;
 static void sbp2_queue_work(struct sbp2_logical_unit *lu, unsigned long delay)
 {
 	sbp2_target_get(lu->tgt);
-	if (!queue_delayed_work(sbp2_wq, &lu->work, delay))
+	if (!queue_delayed_work(system_nrt_wq, &lu->work, delay))
 		sbp2_target_put(lu->tgt);
 }
 
@@ -1656,17 +1654,12 @@ MODULE_ALIAS("sbp2");
 
 static int __init sbp2_init(void)
 {
-	sbp2_wq = create_singlethread_workqueue(KBUILD_MODNAME);
-	if (!sbp2_wq)
-		return -ENOMEM;
-
 	return driver_register(&sbp2_driver.driver);
 }
 
 static void __exit sbp2_cleanup(void)
 {
 	driver_unregister(&sbp2_driver.driver);
-	destroy_workqueue(sbp2_wq);
 }
 
 module_init(sbp2_init);

-- 
Stefan Richter
-=====-==-=- =-=- -=-=-
http://arcgraph.de/sr/

