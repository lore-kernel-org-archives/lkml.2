Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756193Ab1CVBLg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 21:11:36 -0400
Received: from smtp-out.google.com ([216.239.44.51]:3648 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755929Ab1CVBLA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 21:11:00 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=Md99Hh/KCZWfB5ENuiPSLaCUWOwjxl9GNXP8AQdmCfjI96V+p/rJNrMc0D1+yl3Rw
	Bk7H51sl3e+MFYTXkcvvg==
From: Chad Talbott <ctalbott@google.com>
To: jaxboe@fusionio.com, vgoyal@redhat.com
Cc: linux-kernel@vger.kernel.org, mrubin@google.com, teravest@google.com,
        Chad Talbott <ctalbott@google.com>
Subject: [PATCH 2/3] cfq-iosched: Fair cross-group preemption (implementation)
Date: Mon, 21 Mar 2011 18:10:44 -0700
Message-Id: <1300756245-12380-3-git-send-email-ctalbott@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1300756245-12380-1-git-send-email-ctalbott@google.com>
References: <1300756245-12380-1-git-send-email-ctalbott@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new function cfq_group_should_preempt() which uses the new
service classes to decide if a task in one cgroup should preempt a
task in another.  We only allow it if the preempting task's vdisktime
is "behind" the preempted task.

Signed-off-by: Chad Talbott <ctalbott@google.com>
---
 block/cfq-iosched.c |   41 ++++++++++++++++++++++++++++++++++++++---
 1 files changed, 38 insertions(+), 3 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 55e78b7..dfcce80 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1157,6 +1157,32 @@ void cfq_unlink_blkio_group(void *key, struct blkio_group *blkg)
 	spin_unlock_irqrestore(cfqd->queue->queue_lock, flags);
 }
 
+/*
+ * Return true if new_cfqg should preempt cfqg.  A return value of
+ * false means "don't care."  In that case, cfq has other heuristics
+ * to decide
+ */
+static bool
+cfq_group_should_preempt(struct cfq_queue *new_cfqq, struct cfq_queue *cfqq,
+			 struct request *rq)
+{
+	struct cfq_group *cfqg = cfqq->cfqg;
+	struct cfq_group *new_cfqg = new_cfqq->cfqg;
+	u64 grace_period;
+
+	/* in-group preemption is handled elsewhere */
+	if (new_cfqg == cfqg)
+		return false;
+
+	if (!(new_cfqg->class == BLKIO_RT_CLASS &&
+	      cfqg->class == BLKIO_BE_CLASS))
+		return false;
+
+	grace_period = cfq_scale_slice(cfqq->allocated_slice, cfqg);
+	return time_before64(new_cfqg->vdisktime,
+			     cfqg->vdisktime + grace_period);
+}
+
 #else /* GROUP_IOSCHED */
 static struct cfq_group *cfq_get_cfqg(struct cfq_data *cfqd, int create)
 {
@@ -1176,6 +1202,12 @@ cfq_link_cfqq_cfqg(struct cfq_queue *cfqq, struct cfq_group *cfqg) {
 static void cfq_release_cfq_groups(struct cfq_data *cfqd) {}
 static inline void cfq_put_cfqg(struct cfq_group *cfqg) {}
 
+static bool
+cfq_group_should_preempt(struct cfq_queue *new_cfqq, struct cfq_queue *cfqq,
+			 struct request *rq)
+{
+	return false;
+}
 #endif /* GROUP_IOSCHED */
 
 /*
@@ -3234,6 +3266,12 @@ cfq_should_preempt(struct cfq_data *cfqd, struct cfq_queue *new_cfqq,
 	if (!cfqq)
 		return false;
 
+	if (cfq_group_should_preempt(new_cfqq, cfqq, rq))
+		return true;
+
+	if (new_cfqq->cfqg != cfqq->cfqg)
+		return false;
+
 	if (cfq_class_idle(new_cfqq))
 		return false;
 
@@ -3253,9 +3291,6 @@ cfq_should_preempt(struct cfq_data *cfqd, struct cfq_queue *new_cfqq,
 	if (rq_is_sync(rq) && !cfq_cfqq_sync(cfqq))
 		return true;
 
-	if (new_cfqq->cfqg != cfqq->cfqg)
-		return false;
-
 	if (cfq_slice_used(cfqq))
 		return true;
 
-- 
1.7.3.1

