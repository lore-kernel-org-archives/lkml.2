Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753846Ab0G3FTl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 01:19:41 -0400
Received: from smtp-out.google.com ([216.239.44.51]:39529 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752697Ab0G3FTk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 01:19:40 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=QKjgaqSJC5f8NKBNSC+WQN+/iBP+tvLhKCdJFfLxa2vibAf7ILFnwdXu/PtLachD1
	lnmBpOMoNvJZ9MlrHX9+g==
From: Nikhil Rao <ncrao@google.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org
Cc: Venkatesh Pallipadi <venki@google.com>, Ken Chen <kenchen@google.com>,
        Paul Turner <pjt@google.com>, Nikhil Rao <ncrao@google.com>
Subject: [PATCH 1/6] sched: account SCHED_IDLE tasks on rq->idle_nr_running
Date: Thu, 29 Jul 2010 22:19:01 -0700
Message-Id: <1280467146-32218-2-git-send-email-ncrao@google.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1280467146-32218-1-git-send-email-ncrao@google.com>
References: <1280467146-32218-1-git-send-email-ncrao@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Account SCHED_IDLE tasks on rq->idle_nr_running in addition to rq->nr_running.
This is a preparatory patch for the SCHED_IDLE load balancer.

Signed-off-by: Nikhil Rao <ncrao@google.com>
---
 kernel/sched.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index f52a880..26e74e9 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -456,6 +456,7 @@ struct rq {
 	unsigned long nr_running;
 	#define CPU_LOAD_IDX_MAX 5
 	unsigned long cpu_load[CPU_LOAD_IDX_MAX];
+	unsigned long idle_nr_running;
 #ifdef CONFIG_NO_HZ
 	u64 nohz_stamp;
 	unsigned char in_nohz_recently;
@@ -1838,6 +1839,16 @@ static void dec_nr_running(struct rq *rq)
 	rq->nr_running--;
 }
 
+static void inc_idle_nr_running(struct rq *rq)
+{
+	rq->idle_nr_running++;
+}
+
+static void dec_idle_nr_running(struct rq *rq)
+{
+	rq->idle_nr_running--;
+}
+
 static void set_load_weight(struct task_struct *p)
 {
 	if (task_has_rt_policy(p)) {
@@ -1885,6 +1896,8 @@ static void activate_task(struct rq *rq, struct task_struct *p, int flags)
 
 	enqueue_task(rq, p, flags);
 	inc_nr_running(rq);
+	if (p->policy == SCHED_IDLE)
+		inc_idle_nr_running(rq);
 }
 
 /*
@@ -1897,6 +1910,8 @@ static void deactivate_task(struct rq *rq, struct task_struct *p, int flags)
 
 	dequeue_task(rq, p, flags);
 	dec_nr_running(rq);
+	if (p->policy == SCHED_IDLE)
+		dec_idle_nr_running(rq);
 }
 
 #include "sched_idletask.c"
-- 
1.7.1

