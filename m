Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757206Ab0GAPyP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 11:54:15 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:47045 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756762Ab0GAPyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 11:54:05 -0400
From: Borislav Petkov <bp@amd64.org>
To: <linux-kernel@vger.kernel.org>
Subject: [PATCH 04/21] perf_events: Handle persistent events accordingly
Date: Thu,  1 Jul 2010 17:55:46 +0200
Message-Id: <1277999763-20357-5-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1277999763-20357-1-git-send-email-bp@amd64.org>
References: <1277999763-20357-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Add a persistent events flag which is passed to sys_perf_event_open().
Also, teach the perf syscall to differentiate between previously
allocated persistent events and new ones which are about to be created.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 include/linux/perf_event.h |    5 +++--
 kernel/perf_event.c        |   28 +++++++++++++++++++++++++---
 2 files changed, 28 insertions(+), 5 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index cb242bd..1d7907a 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -452,8 +452,9 @@ enum perf_callchain_context {
 	PERF_CONTEXT_MAX		= (__u64)-4095,
 };
 
-#define PERF_FLAG_FD_NO_GROUP	(1U << 0)
-#define PERF_FLAG_FD_OUTPUT	(1U << 1)
+#define PERF_FLAG_FD_NO_GROUP		(1U << 0)
+#define PERF_FLAG_FD_OUTPUT		(1U << 1)
+#define PERF_FLAG_EVENT_PERSISTENT	(1U << 2)
 
 #ifdef __KERNEL__
 /*
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 168764b..8b41a4e 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -5107,7 +5107,9 @@ SYSCALL_DEFINE5(perf_event_open,
 	int err;
 
 	/* for future expandability... */
-	if (flags & ~(PERF_FLAG_FD_NO_GROUP | PERF_FLAG_FD_OUTPUT))
+	if (flags & ~(PERF_FLAG_FD_NO_GROUP |
+		      PERF_FLAG_FD_OUTPUT |
+		      PERF_FLAG_EVENT_PERSISTENT))
 		return -EINVAL;
 
 	err = perf_copy_attr(attr_uptr, &attr);
@@ -5175,8 +5177,23 @@ SYSCALL_DEFINE5(perf_event_open,
 			goto err_put_context;
 	}
 
-	event = perf_event_alloc(&attr, cpu, ctx, group_leader,
-				     NULL, NULL, GFP_KERNEL);
+	if (flags & PERF_FLAG_EVENT_PERSISTENT) {
+		mutex_lock(&ctx->mutex);
+		raw_spin_lock(&ctx->lock);
+
+		event = find_event_in_context(&attr, ctx);
+
+		raw_spin_unlock(&ctx->lock);
+		mutex_unlock(&ctx->mutex);
+
+		if (!event) {
+			printk(KERN_WARNING "Hmm, uninitialized persistent event?!");
+			return -EINVAL;
+		}
+	} else
+		event = perf_event_alloc(&attr, cpu, ctx, group_leader,
+					 NULL, NULL, GFP_KERNEL);
+
 	if (IS_ERR(event)) {
 		err = PTR_ERR(event);
 		goto err_put_context;
@@ -5195,6 +5212,10 @@ SYSCALL_DEFINE5(perf_event_open,
 	}
 
 	event->filp = event_file;
+
+	if (flags & PERF_FLAG_EVENT_PERSISTENT)
+		goto out_drop_ref;
+
 	WARN_ON_ONCE(ctx->parent_ctx);
 	mutex_lock(&ctx->mutex);
 	perf_install_in_context(ctx, event, cpu);
@@ -5207,6 +5228,7 @@ SYSCALL_DEFINE5(perf_event_open,
 	list_add_tail(&event->owner_entry, &current->perf_event_list);
 	mutex_unlock(&current->perf_event_mutex);
 
+out_drop_ref:
 	/*
 	 * Drop the reference on the group_event after placing the
 	 * new event on the sibling_list. This ensures destruction
-- 
1.7.1

