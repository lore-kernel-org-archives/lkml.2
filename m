Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753747Ab0F1VGG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 17:06:06 -0400
Received: from hera.kernel.org ([140.211.167.34]:42810 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751470Ab0F1VGE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 17:06:04 -0400
From: Tejun Heo <tj@kernel.org>
To: torvalds@linux-foundation.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       jeff@garzik.org, akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       oleg@redhat.com, axboe@kernel.dk, fweisbec@gmail.com,
       dwalker@codeaurora.org, stefanr@s5r6.in-berlin.de, florian@mickler.org,
       andi@firstfloor.org, mst@redhat.com, randy.dunlap@oracle.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 03/35] kthread: implement kthread_data()
Date: Mon, 28 Jun 2010 23:03:51 +0200
Message-Id: <1277759063-24607-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1277759063-24607-1-git-send-email-tj@kernel.org>
References: <1277759063-24607-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 28 Jun 2010 21:04:59 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement kthread_data() which takes @task pointing to a kthread and
returns @data specified when creating the kthread.  The caller is
responsible for ensuring the validity of @task when calling this
function.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/kthread.h |    1 +
 kernel/kthread.c        |   15 +++++++++++++++
 2 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/include/linux/kthread.h b/include/linux/kthread.h
index f93cb69..685ea65 100644
--- a/include/linux/kthread.h
+++ b/include/linux/kthread.h
@@ -30,6 +30,7 @@ struct task_struct *kthread_create(int (*threadfn)(void *data),
 void kthread_bind(struct task_struct *k, unsigned int cpu);
 int kthread_stop(struct task_struct *k);
 int kthread_should_stop(void);
+void *kthread_data(struct task_struct *k);
 
 int kthreadd(void *unused);
 extern struct task_struct *kthreadd_task;
diff --git a/kernel/kthread.c b/kernel/kthread.c
index 8b63c7f..2dc3786 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -37,6 +37,7 @@ struct kthread_create_info
 
 struct kthread {
 	int should_stop;
+	void *data;
 	struct completion exited;
 };
 
@@ -56,6 +57,19 @@ int kthread_should_stop(void)
 }
 EXPORT_SYMBOL(kthread_should_stop);
 
+/**
+ * kthread_data - return data value specified on kthread creation
+ * @task: kthread task in question
+ *
+ * Return the data value specified when kthread @task was created.
+ * The caller is responsible for ensuring the validity of @task when
+ * calling this function.
+ */
+void *kthread_data(struct task_struct *task)
+{
+	return to_kthread(task)->data;
+}
+
 static int kthread(void *_create)
 {
 	/* Copy data: it's on kthread's stack */
@@ -66,6 +80,7 @@ static int kthread(void *_create)
 	int ret;
 
 	self.should_stop = 0;
+	self.data = data;
 	init_completion(&self.exited);
 	current->vfork_done = &self.exited;
 
-- 
1.6.4.2

