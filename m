Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753843Ab2A3HH2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 02:07:28 -0500
Received: from mga09.intel.com ([134.134.136.24]:26010 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751288Ab2A3HHY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 02:07:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="101759503"
Message-Id: <20120130070634.587891025@sli10-conroe.sh.intel.com>
User-Agent: quilt/0.48-1
Date: Mon, 30 Jan 2012 15:02:16 +0800
From: Shaohua Li <shaohua.li@intel.com>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, vgoyal@redhat.com, david@fromorbit.com,
        jack@suse.cz, zhu.yanhai@gmail.com, namhyung.kim@lge.com,
        shaohua.li@intel.com
Subject: [patch v2 3/8]block: fiops sync/async scale
References: <20120130070213.793690895@sli10-conroe.sh.intel.com>
Content-Disposition: inline; filename=fiops-sync-async-scale.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CFQ gives 2.5 times more share to sync workload. This matches CFQ.

Note this is different with the read/write scale. We have 3 types of
requests:
1. read
2. sync write
3. write
CFQ doesn't differentitate type 1 and 2, but request cost of 1 and 2
are usually different for flash based storage. So we have both sync/async
and read/write scale here.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
---
 block/fiops-iosched.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

Index: linux/block/fiops-iosched.c
===================================================================
--- linux.orig/block/fiops-iosched.c	2012-01-18 14:33:51.000000000 +0800
+++ linux/block/fiops-iosched.c	2012-01-18 14:33:59.000000000 +0800
@@ -17,6 +17,8 @@
 
 #define VIOS_READ_SCALE (1)
 #define VIOS_WRITE_SCALE (1)
+#define VIOS_SYNC_SCALE (2)
+#define VIOS_ASYNC_SCALE (5)
 
 struct fiops_rb_root {
 	struct rb_root rb;
@@ -39,6 +41,8 @@ struct fiops_data {
 
 	unsigned int read_scale;
 	unsigned int write_scale;
+	unsigned int sync_scale;
+	unsigned int async_scale;
 };
 
 struct fiops_ioc {
@@ -291,6 +295,9 @@ static u64 fiops_scaled_vios(struct fiop
 	if (rq_data_dir(rq) == WRITE)
 		vios = vios * fiopsd->write_scale / fiopsd->read_scale;
 
+	if (!rq_is_sync(rq))
+		vios = vios * fiopsd->async_scale / fiopsd->sync_scale;
+
 	return vios;
 }
 
@@ -513,6 +520,8 @@ static void *fiops_init_queue(struct req
 
 	fiopsd->read_scale = VIOS_READ_SCALE;
 	fiopsd->write_scale = VIOS_WRITE_SCALE;
+	fiopsd->sync_scale = VIOS_SYNC_SCALE;
+	fiopsd->async_scale = VIOS_ASYNC_SCALE;
 
 	return fiopsd;
 }
@@ -557,6 +566,8 @@ static ssize_t __FUNC(struct elevator_qu
 }
 SHOW_FUNCTION(fiops_read_scale_show, fiopsd->read_scale);
 SHOW_FUNCTION(fiops_write_scale_show, fiopsd->write_scale);
+SHOW_FUNCTION(fiops_sync_scale_show, fiopsd->sync_scale);
+SHOW_FUNCTION(fiops_async_scale_show, fiopsd->async_scale);
 #undef SHOW_FUNCTION
 
 #define STORE_FUNCTION(__FUNC, __PTR, MIN, MAX)				\
@@ -574,6 +585,8 @@ static ssize_t __FUNC(struct elevator_qu
 }
 STORE_FUNCTION(fiops_read_scale_store, &fiopsd->read_scale, 1, 100);
 STORE_FUNCTION(fiops_write_scale_store, &fiopsd->write_scale, 1, 100);
+STORE_FUNCTION(fiops_sync_scale_store, &fiopsd->sync_scale, 1, 100);
+STORE_FUNCTION(fiops_async_scale_store, &fiopsd->async_scale, 1, 100);
 #undef STORE_FUNCTION
 
 #define FIOPS_ATTR(name) \
@@ -582,6 +595,8 @@ STORE_FUNCTION(fiops_write_scale_store,
 static struct elv_fs_entry fiops_attrs[] = {
 	FIOPS_ATTR(read_scale),
 	FIOPS_ATTR(write_scale),
+	FIOPS_ATTR(sync_scale),
+	FIOPS_ATTR(async_scale),
 	__ATTR_NULL
 };
 

