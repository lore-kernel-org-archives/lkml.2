Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031011Ab2CNSOz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 14:14:55 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:48310 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030973Ab2CNSOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 14:14:51 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: JBeulich@suse.com, linux-kernel@vger.kernel.org, axboe@kernel.dk
Cc: xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 2/2] xen/blkback: Make optional features be really optional.
Date: Wed, 14 Mar 2012 14:10:31 -0400
Message-Id: <1331748631-4022-3-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.5
In-Reply-To: <1331748631-4022-1-git-send-email-konrad.wilk@oracle.com>
References: <1331748631-4022-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090205.4F60E012.0081,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

They were using the xenbus_dev_fatal() function which would
change the state of the connection immediately. Which is not
what we want when we advertise optional features.

So make 'feature-discard','feature-barrier','feature-flush-cache'
optional.

Suggested-by: Jan Beulich <JBeulich@suse.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/block/xen-blkback/xenbus.c |   25 ++++++++++---------------
 1 files changed, 10 insertions(+), 15 deletions(-)

diff --git a/drivers/block/xen-blkback/xenbus.c b/drivers/block/xen-blkback/xenbus.c
index d417c13..d90a39c 100644
--- a/drivers/block/xen-blkback/xenbus.c
+++ b/drivers/block/xen-blkback/xenbus.c
@@ -381,7 +381,7 @@ int xen_blkbk_flush_diskcache(struct xenbus_transaction xbt,
 	err = xenbus_printf(xbt, dev->nodename, "feature-flush-cache",
 			    "%d", state);
 	if (err)
-		xenbus_dev_fatal(dev, err, "writing feature-flush-cache");
+		dev_warn(&dev->dev, "writing feature-flush-cache (%d)", err);
 
 	return err;
 }
@@ -400,16 +400,14 @@ int xen_blkbk_discard(struct xenbus_transaction xbt, struct backend_info *be)
 			"discard-granularity", "%u",
 			q->limits.discard_granularity);
 		if (err) {
-			xenbus_dev_fatal(dev, err,
-				"writing discard-granularity");
+			dev_warn(&dev->dev, "writing discard-granularity (%d)", err);
 			goto out;
 		}
 		err = xenbus_printf(xbt, dev->nodename,
 			"discard-alignment", "%u",
 			q->limits.discard_alignment);
 		if (err) {
-			xenbus_dev_fatal(dev, err,
-				"writing discard-alignment");
+			dev_warn(&dev->dev, "writing discard-alignment (%d)", err);
 			goto out;
 		}
 		state = 1;
@@ -418,15 +416,14 @@ int xen_blkbk_discard(struct xenbus_transaction xbt, struct backend_info *be)
 				    "discard-secure", "%d",
 				    blkif->vbd.discard_secure);
 		if (err) {
-			xenbus_dev_fatal(dev, err,
-					"writting discard-secure");
+			dev_warn(dev-dev, "writing discard-secure (%d)", err);
 			goto out;
 		}
 	}
 	err = xenbus_printf(xbt, dev->nodename, "feature-discard",
 			    "%d", state);
 	if (err)
-		xenbus_dev_fatal(dev, err, "writing feature-discard");
+		dev_warn(&dev->dev, "writing feature-discard (%d)", err);
 out:
 	return err;
 }
@@ -439,7 +436,7 @@ int xen_blkbk_barrier(struct xenbus_transaction xbt,
 	err = xenbus_printf(xbt, dev->nodename, "feature-barrier",
 			    "%d", state);
 	if (err)
-		xenbus_dev_fatal(dev, err, "writing feature-barrier");
+		dev_warn(&dev->dev, "writing feature-barrier (%d)", err);
 
 	return err;
 }
@@ -671,14 +668,12 @@ again:
 		return;
 	}
 
-	err = xen_blkbk_flush_diskcache(xbt, be, be->blkif->vbd.flush_support);
-	if (err)
-		goto abort;
+	/* If we can't advertise it is OK. */
+	(void)xen_blkbk_flush_diskcache(xbt, be, be->blkif->vbd.flush_support);
 
-	err = xen_blkbk_discard(xbt, be);
+	(void)xen_blkbk_discard(xbt, be);
 
-	/* If we can't advertise it is OK. */
-	err = xen_blkbk_barrier(xbt, be, be->blkif->vbd.flush_support);
+	(void)xen_blkbk_barrier(xbt, be, be->blkif->vbd.flush_support);
 
 	err = xenbus_printf(xbt, dev->nodename, "sectors", "%llu",
 			    (unsigned long long)vbd_sz(&be->blkif->vbd));
-- 
1.7.9.48.g85da4d

