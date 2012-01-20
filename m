Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751472Ab2ATD4M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 22:56:12 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:54503 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751309Ab2ATD4F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 22:56:05 -0500
Message-ID: <4F18E673.9070306@cn.fujitsu.com>
Date: Fri, 20 Jan 2012 11:58:43 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: [PATCH 2/2] cgroup: move struct cgroup_pidlist out from the header
 file
References: <4F18E651.2000109@cn.fujitsu.com>
In-Reply-To: <4F18E651.2000109@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-01-20 11:54:56,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-01-20 11:54:56,
	Serialize complete at 2012-01-20 11:54:56
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's internally used only.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 include/linux/cgroup.h |   32 --------------------------------
 kernel/cgroup.c        |   32 ++++++++++++++++++++++++++++++++
 2 files changed, 32 insertions(+), 32 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index dee53bd..7da3e74 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -160,38 +160,6 @@ enum {
 	CGRP_CLONE_CHILDREN,
 };
 
-/* which pidlist file are we talking about? */
-enum cgroup_filetype {
-	CGROUP_FILE_PROCS,
-	CGROUP_FILE_TASKS,
-};
-
-/*
- * A pidlist is a list of pids that virtually represents the contents of one
- * of the cgroup files ("procs" or "tasks"). We keep a list of such pidlists,
- * a pair (one each for procs, tasks) for each pid namespace that's relevant
- * to the cgroup.
- */
-struct cgroup_pidlist {
-	/*
-	 * used to find which pidlist is wanted. doesn't change as long as
-	 * this particular list stays in the list.
-	 */
-	struct { enum cgroup_filetype type; struct pid_namespace *ns; } key;
-	/* array of xids */
-	pid_t *list;
-	/* how many elements the above list has */
-	int length;
-	/* how many files are using the current array */
-	int use_count;
-	/* each of these stored in a list by its cgroup */
-	struct list_head links;
-	/* pointer to the cgroup we belong to, for list removal purposes */
-	struct cgroup *owner;
-	/* protects the other fields */
-	struct rw_semaphore mutex;
-};
-
 struct cgroup {
 	unsigned long flags;		/* "unsigned long" so bitops work */
 
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index a5d3b53..6ca7aca 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -3043,6 +3043,38 @@ int cgroup_scan_tasks(struct cgroup_scanner *scan)
  *
  */
 
+/* which pidlist file are we talking about? */
+enum cgroup_filetype {
+	CGROUP_FILE_PROCS,
+	CGROUP_FILE_TASKS,
+};
+
+/*
+ * A pidlist is a list of pids that virtually represents the contents of one
+ * of the cgroup files ("procs" or "tasks"). We keep a list of such pidlists,
+ * a pair (one each for procs, tasks) for each pid namespace that's relevant
+ * to the cgroup.
+ */
+struct cgroup_pidlist {
+	/*
+	 * used to find which pidlist is wanted. doesn't change as long as
+	 * this particular list stays in the list.
+	*/
+	struct { enum cgroup_filetype type; struct pid_namespace *ns; } key;
+	/* array of xids */
+	pid_t *list;
+	/* how many elements the above list has */
+	int length;
+	/* how many files are using the current array */
+	int use_count;
+	/* each of these stored in a list by its cgroup */
+	struct list_head links;
+	/* pointer to the cgroup we belong to, for list removal purposes */
+	struct cgroup *owner;
+	/* protects the other fields */
+	struct rw_semaphore mutex;
+};
+
 /*
  * The following two functions "fix" the issue where there are more pids
  * than kmalloc will give memory for; in such cases, we use vmalloc/vfree.
-- 
1.7.3.1
