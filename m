Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753453Ab2JRBvf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 21:51:35 -0400
Received: from noserose.net ([66.220.18.76]:51727 "HELO noserose.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753364Ab2JRBve (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 21:51:34 -0400
Date: Wed, 17 Oct 2012 18:51:31 -0700
Message-Id: <99ed04bff467f3b3752bc9b2480db07f12a2b2f5.1350524227.git.ecashin@coraid.com>
In-Reply-To: <cover.1350524227.git.ecashin@coraid.com>
References: <cover.1350524227.git.ecashin@coraid.com>
From: Ed Cashin <ecashin@coraid.com>
Subject: [PATCH 5/9] aoe: support larger I/O requests via aoe_maxsectors module param
To: akpm@linux-foundation.org
Cc: ecashin@coraid.com, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The GPFS filesystem is an example of an aoe user that requires the
aoe driver to support I/O request sizes larger than the default.
Most users will not need large I/O request sizes, because they would
need to be split up into multiple AoE commands anyway.

Signed-off-by: Ed Cashin <ecashin@coraid.com>
---
 drivers/block/aoe/aoeblk.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/block/aoe/aoeblk.c b/drivers/block/aoe/aoeblk.c
index 00dfc50..d5aa3b8 100644
--- a/drivers/block/aoe/aoeblk.c
+++ b/drivers/block/aoe/aoeblk.c
@@ -16,11 +16,18 @@
 #include <linux/netdevice.h>
 #include <linux/mutex.h>
 #include <linux/export.h>
+#include <linux/moduleparam.h>
 #include "aoe.h"
 
 static DEFINE_MUTEX(aoeblk_mutex);
 static struct kmem_cache *buf_pool_cache;
 
+/* GPFS needs a larger value than the default. */
+static int aoe_maxsectors;
+module_param(aoe_maxsectors, int, 0644);
+MODULE_PARM_DESC(aoe_maxsectors,
+	"When nonzero, set the maximum number of sectors per I/O request");
+
 static ssize_t aoedisk_show_state(struct device *dev,
 				  struct device_attribute *attr, char *page)
 {
@@ -248,6 +255,8 @@ aoeblk_gdalloc(void *vp)
 	d->blkq = gd->queue = q;
 	q->queuedata = d;
 	d->gd = gd;
+	if (aoe_maxsectors)
+		blk_queue_max_hw_sectors(q, aoe_maxsectors);
 	gd->major = AOE_MAJOR;
 	gd->first_minor = d->sysminor;
 	gd->fops = &aoe_bdops;
-- 
1.7.1

