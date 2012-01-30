Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754490Ab2A3HIu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 02:08:50 -0500
Received: from mga09.intel.com ([134.134.136.24]:26010 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752615Ab2A3HHZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 02:07:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="101759507"
Message-Id: <20120130070635.068295150@sli10-conroe.sh.intel.com>
User-Agent: quilt/0.48-1
Date: Mon, 30 Jan 2012 15:02:19 +0800
From: Shaohua Li <shaohua.li@intel.com>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, vgoyal@redhat.com, david@fromorbit.com,
        jack@suse.cz, zhu.yanhai@gmail.com, namhyung.kim@lge.com,
        shaohua.li@intel.com
Subject: [patch v2 6/8]block: fiops bias sync workload
References: <20120130070213.793690895@sli10-conroe.sh.intel.com>
Content-Disposition: inline; filename=fiops-limit-async-workload.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If there are async requests running, delay async workload. Otherwise
async workload (usually very deep iodepth) will use all queue iodepth
and later sync requests will get long delayed. The idea is from CFQ.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
---
 block/fiops-iosched.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

Index: linux/block/fiops-iosched.c
===================================================================
--- linux.orig/block/fiops-iosched.c	2012-01-19 11:21:01.000000000 +0800
+++ linux/block/fiops-iosched.c	2012-01-21 10:30:46.000000000 +0800
@@ -372,6 +372,7 @@ static struct fiops_ioc *fiops_select_io
 	struct fiops_ioc *ioc;
 	struct fiops_rb_root *service_tree = NULL;
 	int i;
+	struct request *rq;
 
 	for (i = RT_WORKLOAD; i >= IDLE_WORKLOAD; i--) {
 		if (!RB_EMPTY_ROOT(&fiopsd->service_tree[i].rb)) {
@@ -384,6 +385,17 @@ static struct fiops_ioc *fiops_select_io
 		return NULL;
 
 	ioc = fiops_rb_first(service_tree);
+
+	rq = rq_entry_fifo(ioc->fifo.next);
+	/*
+	 * we are the only async task and sync requests are in flight, delay a
+	 * moment. If there are other tasks coming, sync tasks have no chance
+	 * to be starved, don't delay
+	 */
+	if (!rq_is_sync(rq) && fiopsd->in_flight[1] != 0 &&
+			service_tree->count == 1)
+		return NULL;
+
 	return ioc;
 }
 

