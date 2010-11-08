Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754060Ab0KHCHa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 21:07:30 -0500
Received: from mga11.intel.com ([192.55.52.93]:23827 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754026Ab0KHCH2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 21:07:28 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.58,311,1286175600"; 
   d="scan'208";a="624431479"
Subject: [patch 3/3]cfq-iosched: don't idle if a deep seek queue is slow
From: Shaohua Li <shaohua.li@intel.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Jens Axboe <jaxboe@fusionio.com>, vgoyal@redhat.com, czoccolo@gmail.com
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 08 Nov 2010 10:07:25 +0800
Message-ID: <1289182045.23014.191.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a deep seek queue slowly deliver requests but disk is much faster, idle
for the queue just wastes disk throughput. If the queue delevers all requests
before half its slice is used, the patch disable idle for it.
In my test, application delivers 32 requests one time, the disk can accept
128 requests at maxium and disk is fast. without the patch, the throughput
is just around 30m/s, while with it, the speed is about 80m/s. The disk is
a SSD, but is detected as a rotational disk. I can configure it as SSD, but
I thought the deep seek queue logic should be fixed too, for example,
considering a fast raid.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>

---
 block/cfq-iosched.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

Index: linux/block/cfq-iosched.c
===================================================================
--- linux.orig/block/cfq-iosched.c	2010-11-08 08:43:51.000000000 +0800
+++ linux/block/cfq-iosched.c	2010-11-08 08:49:52.000000000 +0800
@@ -2293,6 +2293,17 @@ static struct cfq_queue *cfq_select_queu
 		goto keep_queue;
 	}
 
+	/*
+	 * This is a deep seek queue, but the device is much faster than
+	 * the queue can deliver, don't idle
+	 **/
+	if (CFQQ_SEEKY(cfqq) && cfq_cfqq_idle_window(cfqq) &&
+	    (cfq_cfqq_slice_new(cfqq) ||
+	    (cfqq->slice_end - jiffies > jiffies - cfqq->slice_start))) {
+		cfq_clear_cfqq_deep(cfqq);
+		cfq_clear_cfqq_idle_window(cfqq);
+	}
+
 	if (cfqq->dispatched && cfq_should_idle(cfqd, cfqq)) {
 		cfqq = NULL;
 		goto keep_queue;


