Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754534Ab2A3HIw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 02:08:52 -0500
Received: from mga01.intel.com ([192.55.52.88]:16158 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752402Ab2A3HHZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 02:07:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="117918263"
Message-Id: <20120130070635.412104517@sli10-conroe.sh.intel.com>
User-Agent: quilt/0.48-1
Date: Mon, 30 Jan 2012 15:02:21 +0800
From: Shaohua Li <shaohua.li@intel.com>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, vgoyal@redhat.com, david@fromorbit.com,
        jack@suse.cz, zhu.yanhai@gmail.com, namhyung.kim@lge.com,
        shaohua.li@intel.com
Subject: [patch v2 8/8]block: fiops sync preempts async
References: <20120130070213.793690895@sli10-conroe.sh.intel.com>
Content-Disposition: inline; filename=fiops-preempt-async.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Debug patch only.

This implements CFQ like sync preempts async. But like CFQ, this
will starve async.

---
 block/fiops-iosched.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

Index: linux/block/fiops-iosched.c
===================================================================
--- linux.orig/block/fiops-iosched.c	2012-01-21 10:35:04.000000000 +0800
+++ linux/block/fiops-iosched.c	2012-01-21 10:48:52.000000000 +0800
@@ -408,6 +408,21 @@ static struct fiops_ioc *fiops_select_io
 		return NULL;
 	}
 
+	/* Let sync request preempt async queue */
+	if (!rq_is_sync(rq) && service_tree->count > 1) {
+		struct rb_node *tmp = rb_next(&ioc->rb_node);
+		struct fiops_ioc *sync_ioc = NULL;
+		while (tmp) {
+			sync_ioc = rb_entry(tmp, struct fiops_ioc, rb_node);
+			rq = rq_entry_fifo(sync_ioc->fifo.next);
+			if (rq_is_sync(rq))
+				break;
+			tmp = rb_next(&sync_ioc->rb_node);
+		}
+		if (sync_ioc)
+			ioc = sync_ioc;
+	}
+
 	return ioc;
 }
 

