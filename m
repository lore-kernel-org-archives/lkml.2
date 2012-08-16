Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932941Ab2HPRpg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 13:45:36 -0400
Received: from mail.x86-64.org ([217.9.48.20]:52290 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756634Ab2HPRpd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 13:45:33 -0400
From: Borislav Petkov <bp@amd64.org>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [RFC PATCH -v2 2/4] perf: Add persistent events
Date: Thu, 16 Aug 2012 19:45:21 +0200
Message-Id: <1345139123-15212-3-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.11.rc1
In-Reply-To: <1345139123-15212-1-git-send-email-bp@amd64.org>
References: <1345139123-15212-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Add the needed pieces for persistent events which are process-agnostic.
Also, make their buffers read-only when mmaping them from userspace.
Add a descriptor struct collecting all that is needed for a persistent
event, for ease of handling in the code later.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 include/linux/perf_event.h | 17 ++++++++++++++++-
 kernel/events/core.c       |  5 ++++-
 2 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 7602ccb3f40e..252aab74e64d 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -254,8 +254,9 @@ struct perf_event_attr {
 
 				exclude_host   :  1, /* don't count in host   */
 				exclude_guest  :  1, /* don't count in guest  */
+				persistent     :  1, /* always-on event */
 
-				__reserved_1   : 43;
+				__reserved_1   : 42;
 
 	union {
 		__u32		wakeup_events;	  /* wakeup every n events */
@@ -1078,6 +1079,20 @@ struct perf_output_handle {
 	int				page;
 };
 
+/*
+ * perf event descriptor to collect all attributes belonging to an event
+ */
+struct perf_event_desc {
+	struct perf_event *event;
+	struct perf_event_attr *pattr;
+	const struct file_operations *fops;
+	/* debugfs entry */
+	struct dentry *dentry;
+	const char *dir_name;
+	const char *fname;
+	int fd;
+};
+
 #ifdef CONFIG_PERF_EVENTS
 
 extern int perf_pmu_register(struct pmu *pmu, char *name, int type);
diff --git a/kernel/events/core.c b/kernel/events/core.c
index b7935fcec7d9..95026f2b3d55 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -3589,7 +3589,10 @@ static int perf_mmap(struct file *file, struct vm_area_struct *vma)
 	if (event->cpu == -1 && event->attr.inherit)
 		return -EINVAL;
 
-	if (!(vma->vm_flags & VM_SHARED))
+	if (!(vma->vm_flags & VM_SHARED) && !event->attr.persistent)
+		return -EINVAL;
+
+	if (event->attr.persistent && (vma->vm_flags & VM_WRITE))
 		return -EINVAL;
 
 	vma_size = vma->vm_end - vma->vm_start;
-- 
1.7.11.rc1

