Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932252Ab1ACNzO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 08:55:14 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60593 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755061Ab1ACNu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 08:50:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=CW4M+iHedyptnxARsU/qdQu20N48wlX7KSGvATwkJtxQ0TvX1pegzbo1wkfgEmSkmt
         KASdXweLesC2ffCIDLUWw/u7VP847tjzOkcLOtCKpMjyWF1eq/mxphTZFuL6CK3UQZ+o
         XoE1x8Ld5g0Z7qsj3GGB4CPgty0DNO9BpWia4=
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, Andy Walls <awalls@md.metrocast.net>,
        linux-media@vger.kernel.org
Subject: [PATCH 11/32] v4l/cx18: update workqueue usage
Date: Mon,  3 Jan 2011 14:49:34 +0100
Message-Id: <1294062595-30097-12-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1294062595-30097-1-git-send-email-tj@kernel.org>
References: <1294062595-30097-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With cmwq, there's no reason to use separate out_work_queue.  Drop it
and use system_wq instead.  The in_work_queue needs to be ordered so
can't use one of the system wqs; however, as it isn't used to reclaim
memory, allocate the workqueue with alloc_ordered_workqueue() without
WQ_MEM_RECLAIM.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Andy Walls <awalls@md.metrocast.net>
Cc: linux-media@vger.kernel.org
---
Only compile tested.  Please feel free to take it into the subsystem
tree or simply ack - I'll route it through the wq tree.

Thanks.

 drivers/media/video/cx18/cx18-driver.c  |   24 ++----------------------
 drivers/media/video/cx18/cx18-driver.h  |    3 ---
 drivers/media/video/cx18/cx18-streams.h |    3 +--
 3 files changed, 3 insertions(+), 27 deletions(-)

diff --git a/drivers/media/video/cx18/cx18-driver.c b/drivers/media/video/cx18/cx18-driver.c
index df60f27..41c0822 100644
--- a/drivers/media/video/cx18/cx18-driver.c
+++ b/drivers/media/video/cx18/cx18-driver.c
@@ -656,7 +656,7 @@ static int __devinit cx18_create_in_workq(struct cx18 *cx)
 {
 	snprintf(cx->in_workq_name, sizeof(cx->in_workq_name), "%s-in",
 		 cx->v4l2_dev.name);
-	cx->in_work_queue = create_singlethread_workqueue(cx->in_workq_name);
+	cx->in_work_queue = alloc_ordered_workqueue(cx->in_workq_name, 0);
 	if (cx->in_work_queue == NULL) {
 		CX18_ERR("Unable to create incoming mailbox handler thread\n");
 		return -ENOMEM;
@@ -664,18 +664,6 @@ static int __devinit cx18_create_in_workq(struct cx18 *cx)
 	return 0;
 }
 
-static int __devinit cx18_create_out_workq(struct cx18 *cx)
-{
-	snprintf(cx->out_workq_name, sizeof(cx->out_workq_name), "%s-out",
-		 cx->v4l2_dev.name);
-	cx->out_work_queue = create_workqueue(cx->out_workq_name);
-	if (cx->out_work_queue == NULL) {
-		CX18_ERR("Unable to create outgoing mailbox handler threads\n");
-		return -ENOMEM;
-	}
-	return 0;
-}
-
 static void __devinit cx18_init_in_work_orders(struct cx18 *cx)
 {
 	int i;
@@ -702,15 +690,9 @@ static int __devinit cx18_init_struct1(struct cx18 *cx)
 	mutex_init(&cx->epu2apu_mb_lock);
 	mutex_init(&cx->epu2cpu_mb_lock);
 
-	ret = cx18_create_out_workq(cx);
-	if (ret)
-		return ret;
-
 	ret = cx18_create_in_workq(cx);
-	if (ret) {
-		destroy_workqueue(cx->out_work_queue);
+	if (ret)
 		return ret;
-	}
 
 	cx18_init_in_work_orders(cx);
 
@@ -1094,7 +1076,6 @@ free_mem:
 	release_mem_region(cx->base_addr, CX18_MEM_SIZE);
 free_workqueues:
 	destroy_workqueue(cx->in_work_queue);
-	destroy_workqueue(cx->out_work_queue);
 err:
 	if (retval == 0)
 		retval = -ENODEV;
@@ -1244,7 +1225,6 @@ static void cx18_remove(struct pci_dev *pci_dev)
 	cx18_halt_firmware(cx);
 
 	destroy_workqueue(cx->in_work_queue);
-	destroy_workqueue(cx->out_work_queue);
 
 	cx18_streams_cleanup(cx, 1);
 
diff --git a/drivers/media/video/cx18/cx18-driver.h b/drivers/media/video/cx18/cx18-driver.h
index 77be58c..f7f71d1 100644
--- a/drivers/media/video/cx18/cx18-driver.h
+++ b/drivers/media/video/cx18/cx18-driver.h
@@ -614,9 +614,6 @@ struct cx18 {
 	struct cx18_in_work_order in_work_order[CX18_MAX_IN_WORK_ORDERS];
 	char epu_debug_str[256]; /* CX18_EPU_DEBUG is rare: use shared space */
 
-	struct workqueue_struct *out_work_queue;
-	char out_workq_name[12]; /* "cx18-NN-out" */
-
 	/* i2c */
 	struct i2c_adapter i2c_adap[2];
 	struct i2c_algo_bit_data i2c_algo[2];
diff --git a/drivers/media/video/cx18/cx18-streams.h b/drivers/media/video/cx18/cx18-streams.h
index 77412be..5837ffb 100644
--- a/drivers/media/video/cx18/cx18-streams.h
+++ b/drivers/media/video/cx18/cx18-streams.h
@@ -41,8 +41,7 @@ static inline bool cx18_stream_enabled(struct cx18_stream *s)
 /* Related to submission of mdls to firmware */
 static inline void cx18_stream_load_fw_queue(struct cx18_stream *s)
 {
-	struct cx18 *cx = s->cx;
-	queue_work(cx->out_work_queue, &s->out_work_order);
+	schedule_work(&s->out_work_order);
 }
 
 static inline void cx18_stream_put_mdl_fw(struct cx18_stream *s,
-- 
1.7.1

