Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753234Ab2DKGBQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 02:01:16 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48331 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752767Ab2DKGBO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 02:01:14 -0400
From: Cong Wang <xiyou.wangcong@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Cong Wang <xiyou.wangcong@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Vasiliy Kulikov <segoon@openwall.com>,
        David Rientjes <rientjes@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Stephen Wilson <wilsons@start.ca>,
        Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>,
        Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: [PATCH 3/6] proc: remove mm_for_maps()
Date: Wed, 11 Apr 2012 13:59:24 +0800
Message-Id: <1334123976-11681-3-git-send-email-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1334123976-11681-1-git-send-email-xiyou.wangcong@gmail.com>
References: <1334123976-11681-1-git-send-email-xiyou.wangcong@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mm_for_maps() is a simple wrapper for mm_access(),
and the name is misleading, so just remove it and use
mm_access() directly.

Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
---
 fs/proc/base.c       |    7 +------
 fs/proc/internal.h   |    2 --
 fs/proc/task_mmu.c   |    4 ++--
 fs/proc/task_nommu.c |    2 +-
 4 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 919d14c..8608a4d 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -198,11 +198,6 @@ static int proc_root_link(struct dentry *dentry, struct path *path)
 	return result;
 }
 
-struct mm_struct *mm_for_maps(struct task_struct *task)
-{
-	return mm_access(task, PTRACE_MODE_READ);
-}
-
 static int proc_pid_cmdline(struct task_struct *task, char * buffer)
 {
 	int res = 0;
@@ -242,7 +237,7 @@ out:
 
 static int proc_pid_auxv(struct task_struct *task, char *buffer)
 {
-	struct mm_struct *mm = mm_for_maps(task);
+	struct mm_struct *mm = mm_access(task, PTRACE_MODE_READ);
 	int res = PTR_ERR(mm);
 	if (mm && !IS_ERR(mm)) {
 		unsigned int nwords = 0;
diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index 5f79bb8..a306437 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -31,8 +31,6 @@ struct vmalloc_info {
 	unsigned long	largest_chunk;
 };
 
-extern struct mm_struct *mm_for_maps(struct task_struct *);
-
 #ifdef CONFIG_MMU
 #define VMALLOC_TOTAL (VMALLOC_END - VMALLOC_START)
 extern void get_vmalloc_info(struct vmalloc_info *vmi);
diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 2b9a760..03360a1 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -125,7 +125,7 @@ static void *m_start(struct seq_file *m, loff_t *pos)
 	if (!priv->task)
 		return ERR_PTR(-ESRCH);
 
-	mm = mm_for_maps(priv->task);
+	mm = mm_access(priv->task, PTRACE_MODE_READ);
 	if (!mm || IS_ERR(mm))
 		return mm;
 	down_read(&mm->mmap_sem);
@@ -914,7 +914,7 @@ static ssize_t pagemap_read(struct file *file, char __user *buf,
 	if (!pm.buffer)
 		goto out_task;
 
-	mm = mm_for_maps(task);
+	mm = mm_access(task, PTRACE_MODE_READ);
 	ret = PTR_ERR(mm);
 	if (!mm || IS_ERR(mm))
 		goto out_free;
diff --git a/fs/proc/task_nommu.c b/fs/proc/task_nommu.c
index 74fe164..1ccfa53 100644
--- a/fs/proc/task_nommu.c
+++ b/fs/proc/task_nommu.c
@@ -223,7 +223,7 @@ static void *m_start(struct seq_file *m, loff_t *pos)
 	if (!priv->task)
 		return ERR_PTR(-ESRCH);
 
-	mm = mm_for_maps(priv->task);
+	mm = mm_access(priv->task, PTRACE_MODE_READ);
 	if (!mm || IS_ERR(mm)) {
 		put_task_struct(priv->task);
 		priv->task = NULL;
-- 
1.7.7.6

