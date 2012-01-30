Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753656Ab2A3HIt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 02:08:49 -0500
Received: from mga02.intel.com ([134.134.136.20]:54287 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752638Ab2A3HHZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 02:07:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="104051234"
Message-Id: <20120130070635.234238863@sli10-conroe.sh.intel.com>
User-Agent: quilt/0.48-1
Date: Mon, 30 Jan 2012 15:02:20 +0800
From: Shaohua Li <shaohua.li@intel.com>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, vgoyal@redhat.com, david@fromorbit.com,
        jack@suse.cz, zhu.yanhai@gmail.com, namhyung.kim@lge.com,
        shaohua.li@intel.com
Subject: [patch v2 7/8]block: fiops add some trace information
References: <20120130070213.793690895@sli10-conroe.sh.intel.com>
Content-Disposition: inline; filename=fiops-tracing.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add some trace information, which is helpful when I do debugging.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
---
 block/fiops-iosched.c |   19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

Index: linux/block/fiops-iosched.c
===================================================================
--- linux.orig/block/fiops-iosched.c	2012-01-21 10:30:46.000000000 +0800
+++ linux/block/fiops-iosched.c	2012-01-21 10:35:04.000000000 +0800
@@ -10,6 +10,7 @@
 #include <linux/jiffies.h>
 #include <linux/rbtree.h>
 #include <linux/ioprio.h>
+#include <linux/blktrace_api.h>
 #include "blk.h"
 
 #define VIOS_SCALE_SHIFT 10
@@ -99,6 +100,11 @@ FIOPS_IOC_FNS(on_rr);
 FIOPS_IOC_FNS(prio_changed);
 #undef FIOPS_IOC_FNS
 
+#define fiops_log_ioc(fiopsd, ioc, fmt, args...)	\
+	blk_add_trace_msg((fiopsd)->queue, "ioc%d " fmt, (ioc)->pid, ##args)
+#define fiops_log(fiopsd, fmt, args...)	\
+	blk_add_trace_msg((fiopsd)->queue, "fiops " fmt, ##args)
+
 enum wl_prio_t fiops_wl_type(short prio_class)
 {
 	if (prio_class == IOPRIO_CLASS_RT)
@@ -200,6 +206,8 @@ static void fiops_service_tree_add(struc
 		ioc->service_tree = NULL;
 	}
 
+	fiops_log_ioc(fiopsd, ioc, "service tree add, vios %lld", vios);
+
 	left = 1;
 	parent = NULL;
 	ioc->service_tree = service_tree;
@@ -393,8 +401,12 @@ static struct fiops_ioc *fiops_select_io
 	 * to be starved, don't delay
 	 */
 	if (!rq_is_sync(rq) && fiopsd->in_flight[1] != 0 &&
-			service_tree->count == 1)
+			service_tree->count == 1) {
+		fiops_log_ioc(fiopsd, ioc,
+				"postpone async, in_flight async %d sync %d",
+				fiopsd->in_flight[0], fiopsd->in_flight[1]);
 		return NULL;
+	}
 
 	return ioc;
 }
@@ -405,6 +417,8 @@ static void fiops_charge_vios(struct fio
 	struct fiops_rb_root *service_tree = ioc->service_tree;
 	ioc->vios += vios;
 
+	fiops_log_ioc(fiopsd, ioc, "charge vios %lld, new vios %lld", vios, ioc->vios);
+
 	if (RB_EMPTY_ROOT(&ioc->sort_list))
 		fiops_del_ioc_rr(fiopsd, ioc);
 	else
@@ -498,6 +512,9 @@ static void fiops_completed_request(stru
 	fiopsd->in_flight[rq_is_sync(rq)]--;
 	ioc->in_flight--;
 
+	fiops_log_ioc(fiopsd, ioc, "in_flight %d, busy queues %d",
+		ioc->in_flight, fiopsd->busy_queues);
+
 	if (fiopsd->in_flight[0] + fiopsd->in_flight[1] == 0)
 		fiops_schedule_dispatch(fiopsd);
 }

