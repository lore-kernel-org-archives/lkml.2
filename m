Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754076Ab2A3BNy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jan 2012 20:13:54 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:47353 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753876Ab2A3BNv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jan 2012 20:13:51 -0500
Date: Mon, 30 Jan 2012 05:13:48 +0400
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Arve =?utf-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, San Mehat <san@google.com>,
        Colin Cross <ccross@android.com>, Oleg Nesterov <oleg@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org, kernel-team@android.com,
        linaro-kernel@lists.linaro.org
Subject: [PATCH 3/3] staging: android: lowmemorykiller: Drop tasklist_lock
 usage
Message-ID: <20120130011348.GC30274@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of walking through the whole task list (where we must hold the
task list lock for the whole period while we search for the victim),
let's take procfs' approach of walking up the tgids (for_each_tgit()
walks a pidmap, which internally grabs an rcu lock, but only while
it searches for the next tgid).

Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
---
 drivers/staging/android/lowmemorykiller.c |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/android/lowmemorykiller.c b/drivers/staging/android/lowmemorykiller.c
index 2d8d2b7..a9edb53 100644
--- a/drivers/staging/android/lowmemorykiller.c
+++ b/drivers/staging/android/lowmemorykiller.c
@@ -34,6 +34,7 @@
 #include <linux/mm.h>
 #include <linux/oom.h>
 #include <linux/sched.h>
+#include <linux/pid.h>
 #include <linux/profile.h>
 #include <linux/notifier.h>
 
@@ -81,7 +82,8 @@ task_notify_func(struct notifier_block *self, unsigned long val, void *data)
 
 static int lowmem_shrink(struct shrinker *s, struct shrink_control *sc)
 {
-	struct task_struct *p;
+	struct pid_namespace *ns = &init_pid_ns;
+	struct tgid_iter iter = {};
 	struct task_struct *selected = NULL;
 	int rem = 0;
 	int tasksize;
@@ -132,8 +134,8 @@ static int lowmem_shrink(struct shrinker *s, struct shrink_control *sc)
 	}
 	selected_oom_adj = min_adj;
 
-	read_lock(&tasklist_lock);
-	for_each_process(p) {
+	for_each_tgid(ns, iter) {
+		struct task_struct *p = iter.task;
 		struct mm_struct *mm;
 		struct signal_struct *sig;
 		int oom_adj;
@@ -160,7 +162,9 @@ static int lowmem_shrink(struct shrinker *s, struct shrink_control *sc)
 			if (oom_adj == selected_oom_adj &&
 			    tasksize <= selected_tasksize)
 				continue;
+			put_task_struct(selected);
 		}
+		get_task_struct(p);
 		selected = p;
 		selected_tasksize = tasksize;
 		selected_oom_adj = oom_adj;
@@ -181,11 +185,11 @@ static int lowmem_shrink(struct shrinker *s, struct shrink_control *sc)
 		task_handoff_register(&task_nb);
 #endif
 		force_sig(SIGKILL, selected);
+		put_task_struct(selected);
 		rem -= selected_tasksize;
 	}
 	lowmem_print(4, "lowmem_shrink %lu, %x, return %d\n",
 		     sc->nr_to_scan, sc->gfp_mask, rem);
-	read_unlock(&tasklist_lock);
 	return rem;
 }
 
-- 
1.7.7
