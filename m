Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753747Ab2IXKH1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 06:07:27 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:28846 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752788Ab2IXKFO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 06:05:14 -0400
X-IronPort-AV: E=Sophos;i="4.80,474,1344182400"; 
   d="scan'208";a="5907210"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 05/10] workqueue: add wq_dec_flusher_ref()
Date: Mon, 24 Sep 2012 18:07:07 +0800
Message-Id: <1348481238-6138-6-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1348481238-6138-1-git-send-email-laijs@cn.fujitsu.com>
References: <1348481238-6138-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/24 18:05:28,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/24 18:05:28,
	Serialize complete at 2012/09/24 18:05:28
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

it is a helper to relase reference.

This patch doesn't make any functional difference.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |   22 +++++++++++++---------
 1 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 861b4c7..e5ba08c 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -995,6 +995,16 @@ static void cwq_activate_first_delayed(struct cpu_workqueue_struct *cwq)
 	cwq_activate_delayed_work(work);
 }
 
+static void wq_dec_flusher_ref(struct workqueue_struct *wq, int color)
+{
+	/*
+	 * If this was the last reference, wake up the first flusher.
+	 * It will handle the rest.
+	 */
+	if (atomic_dec_and_test(&wq->nr_cwqs_to_flush[color]))
+		complete(&wq->first_flusher->done);
+}
+
 /**
  * cwq_dec_nr_in_flight - decrement cwq's nr_in_flight
  * @cwq: cwq of interest
@@ -1032,12 +1042,7 @@ static void cwq_dec_nr_in_flight(struct cpu_workqueue_struct *cwq, int color)
 	/* this cwq is done, clear flush_color */
 	cwq->flush_color = -1;
 
-	/*
-	 * If this was the last cwq, wake up the first flusher.  It
-	 * will handle the rest.
-	 */
-	if (atomic_dec_and_test(&cwq->wq->nr_cwqs_to_flush[color]))
-		complete(&cwq->wq->first_flusher->done);
+	wq_dec_flusher_ref(cwq->wq, color);
 }
 
 /**
@@ -2594,9 +2599,8 @@ static bool flush_workqueue_prep_cwqs(struct workqueue_struct *wq,
 		spin_unlock_irq(&gcwq->lock);
 	}
 
-	if (flush_color >= 0 &&
-	    atomic_dec_and_test(&wq->nr_cwqs_to_flush[flush_color]))
-		complete(&wq->first_flusher->done);
+	if (flush_color >= 0)
+		wq_dec_flusher_ref(wq, flush_color);
 
 	return wait;
 }
-- 
1.7.4.4

