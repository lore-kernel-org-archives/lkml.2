Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756216Ab1DTUw2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 16:52:28 -0400
Received: from smtp-out.google.com ([216.239.44.51]:7876 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755867Ab1DTUwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 16:52:07 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=Q5Dm/XoBIyrZ70sI4E4bCIjEQbFkH6LOwt47GZZ7miRmJk4HEXxR0voGWX1f4+cYq
	PHlpfyNpqLY4R5DXy0Bnw==
From: Nikhil Rao <ncrao@google.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Cc: Paul Turner <pjt@google.com>, Mike Galbraith <efault@gmx.de>,
        linux-kernel@vger.kernel.org, Nikhil Rao <ncrao@google.com>
Subject: [RFC][Patch 04/18] sched: update cpu_load to be u64
Date: Wed, 20 Apr 2011 13:51:23 -0700
Message-Id: <1303332697-16426-5-git-send-email-ncrao@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1303332697-16426-1-git-send-email-ncrao@google.com>
References: <1303332697-16426-1-git-send-email-ncrao@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cpu_load derives from rq->load.weight and needs to be updated to u64 as it can
now overflow on 32-bit machines. This patch updates cpu_load in rq struct, and
all functions that use this field.

Signed-off-by: Nikhil Rao <ncrao@google.com>
---
 kernel/sched.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index bfee8ff..94dd1df 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -454,7 +454,7 @@ struct rq {
 	 */
 	unsigned long nr_running;
 	#define CPU_LOAD_IDX_MAX 5
-	unsigned long cpu_load[CPU_LOAD_IDX_MAX];
+	u64 cpu_load[CPU_LOAD_IDX_MAX];
 	unsigned long last_load_update_tick;
 #ifdef CONFIG_NO_HZ
 	u64 nohz_stamp;
@@ -3365,8 +3365,7 @@ static const unsigned char
  * would be when CPU is idle and so we just decay the old load without
  * adding any new load.
  */
-static unsigned long
-decay_load_missed(unsigned long load, unsigned long missed_updates, int idx)
+static u64 decay_load_missed(u64 load, unsigned long missed_updates, int idx)
 {
 	int j = 0;
 
@@ -3396,7 +3395,7 @@ decay_load_missed(unsigned long load, unsigned long missed_updates, int idx)
  */
 static void update_cpu_load(struct rq *this_rq)
 {
-	unsigned long this_load = this_rq->load.weight;
+	u64 this_load = this_rq->load.weight;
 	unsigned long curr_jiffies = jiffies;
 	unsigned long pending_updates;
 	int i, scale;
@@ -3413,7 +3412,7 @@ static void update_cpu_load(struct rq *this_rq)
 	/* Update our load: */
 	this_rq->cpu_load[0] = this_load; /* Fasttrack for idx 0 */
 	for (i = 1, scale = 2; i < CPU_LOAD_IDX_MAX; i++, scale += scale) {
-		unsigned long old_load, new_load;
+		u64 old_load, new_load;
 
 		/* scale is effectively 1 << i now, and >> i divides by scale */
 
-- 
1.7.3.1

