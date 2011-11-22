Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757417Ab1KVDgG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 22:36:06 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64096 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753365Ab1KVDgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 22:36:03 -0500
From: Min Zhang <mzhang@mvista.com>
To: linux-kernel@vger.kernel.org
Cc: Min Zhang <mzhang@mvista.com>
Subject: [PATCH] waitpid: traverse pid task list instead of children or ptraced list
Date: Mon, 21 Nov 2011 19:35:09 -0800
Message-Id: <1321932909-7101-1-git-send-email-mzhang@mvista.com>
X-Mailer: git-send-email 1.6.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shorten waitpid system call time by traversing pid task list intead of
entire children or ptraced list when waiting for specific PIDTYPE_PID/PGID/SID.

Tested by fork thousands child processes, PTRACE_ATTACH on each, then
waitpid on each. Result shows saving 2 order of magnitude of time.

Signed-off-by: Min Zhang <mzhang@mvista.com>
---
 kernel/exit.c |   26 ++++++++++++++++++++++++++
 1 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index 2913b35..89c5d51 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -1634,6 +1634,19 @@ static int do_wait_thread(struct wait_opts *wo, struct task_struct *tsk)
 {
 	struct task_struct *p;
 
+	/* traverse pid task list for a specific child pid */
+	if (wo->wo_type != PIDTYPE_MAX) {
+		do_each_pid_task(wo->wo_pid, wo->wo_type, p) {
+			if (p->parent == tsk) {
+				int ret = wait_consider_task(wo, 0, p);
+				if (ret)
+					return ret;
+			}
+		} while_each_pid_task(wo->wo_pid, wo->wo_type, p);
+		return 0;
+	}
+
+	/* traverse entire children list for any child pid */
 	list_for_each_entry(p, &tsk->children, sibling) {
 		int ret = wait_consider_task(wo, 0, p);
 		if (ret)
@@ -1647,6 +1660,19 @@ static int ptrace_do_wait(struct wait_opts *wo, struct task_struct *tsk)
 {
 	struct task_struct *p;
 
+	/* traverse pid task list for a specific child pid */
+	if (wo->wo_type != PIDTYPE_MAX) {
+		do_each_pid_task(wo->wo_pid, wo->wo_type, p) {
+			if (task_is_traced(p) && p->parent == tsk) {
+				int ret = wait_consider_task(wo, 1, p);
+				if (ret)
+					return ret;
+			}
+		} while_each_pid_task(wo->wo_pid, wo->wo_type, p);
+		return 0;
+	}
+
+	/* traverse entire children list for any child pid */
 	list_for_each_entry(p, &tsk->ptraced, ptrace_entry) {
 		int ret = wait_consider_task(wo, 1, p);
 		if (ret)
-- 
1.6.4.2

