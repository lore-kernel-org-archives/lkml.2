Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757067Ab0GAPyH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 11:54:07 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:47039 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752539Ab0GAPyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 11:54:04 -0400
From: Borislav Petkov <bp@amd64.org>
To: <linux-kernel@vger.kernel.org>
Subject: [PATCH 03/21] perf_events: Add a helper to search for an event in a context
Date: Thu,  1 Jul 2010 17:55:45 +0200
Message-Id: <1277999763-20357-4-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1277999763-20357-1-git-send-email-bp@amd64.org>
References: <1277999763-20357-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

This is a straignt-forward helper to look for, e.g. already allocated
and enabled events (think persistent events here).

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 kernel/perf_event.c |   21 +++++++++++++++++++++
 1 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 40478af..168764b 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -307,6 +307,27 @@ list_add_event(struct perf_event *event, struct perf_event_context *ctx)
 		ctx->nr_stat++;
 }
 
+/*
+ * Find an event in a context.
+ * Must be called with ctx->mutex and ctx->lock held.
+ */
+static struct perf_event *find_event_in_context(struct perf_event_attr *attr,
+						struct perf_event_context *ctx)
+{
+	struct perf_event *event;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(event, &ctx->event_list, event_entry) {
+		if (event->attr.config == attr->config) {
+			rcu_read_unlock();
+			return event;
+		}
+	}
+	rcu_read_unlock();
+
+	return NULL;
+}
+
 static void perf_group_attach(struct perf_event *event)
 {
 	struct perf_event *group_leader = event->group_leader;
-- 
1.7.1

