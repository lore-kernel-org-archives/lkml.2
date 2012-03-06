Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030992Ab2CFUPp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 15:15:45 -0500
Received: from mail-pz0-f52.google.com ([209.85.210.52]:35524 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030934Ab2CFUPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 15:15:42 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of siddhesh.poyarekar@gmail.com designates 10.68.216.98 as permitted sender) smtp.mail=siddhesh.poyarekar@gmail.com; dkim=pass header.i=siddhesh.poyarekar@gmail.com
From: Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>
To: Mark Salter <msalter@redhat.com>
Cc: linux-next <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>
Subject: [PATCH 1/2] mm: Fix task_nommu build regression in linux-next
Date: Wed,  7 Mar 2012 01:46:33 +0530
Message-Id: <1331064994-6693-1-git-send-email-siddhesh.poyarekar@gmail.com>
X-Mailer: git-send-email 1.7.7.4
In-Reply-To: <1331045377.17099.2.camel@deneb.redhat.com>
References: <1331045377.17099.2.camel@deneb.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit b7b2a0afacada237005068294cb0ccc49d32889e resulted in a build
failure for nommu builds:

fs/built-in.o: In function `nommu_vma_show':
task_nommu.c:(.text+0x564a0): undefined reference to `vm_is_stack'
make[1]: *** [.tmp_vmlinux1] Error 1

Fix is to provide definitions of vm_is_stack() and
vm_is_stack_for_task() for nommu as well. This patch also adds an
explicit include of sched.h based on observations and patch submission
by Paul Gortmaker <paul.gortmaker@windriver.com>:

https://lkml.org/lkml/2012/3/5/326

Signed-off-by: Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>
---
 mm/memory.c |    1 +
 mm/nommu.c  |   40 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 41 insertions(+), 0 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 2533d9f..0ca7fe6 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -57,6 +57,7 @@
 #include <linux/swapops.h>
 #include <linux/elf.h>
 #include <linux/gfp.h>
+#include <linux/sched.h>
 
 #include <asm/io.h>
 #include <asm/pgalloc.h>
diff --git a/mm/nommu.c b/mm/nommu.c
index b982290..5a5c3fc 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -29,6 +29,7 @@
 #include <linux/security.h>
 #include <linux/syscalls.h>
 #include <linux/audit.h>
+#include <linux/sched.h>
 
 #include <asm/uaccess.h>
 #include <asm/tlb.h>
@@ -2089,3 +2090,42 @@ int nommu_shrink_inode_mappings(struct inode *inode, size_t size,
 	up_write(&nommu_region_sem);
 	return 0;
 }
+
+/* Check if the vma is being used as a stack by this task */
+static int vm_is_stack_for_task(struct task_struct *t,
+				struct vm_area_struct *vma)
+{
+	return (vma->vm_start <= KSTK_ESP(t) && vma->vm_end >= KSTK_ESP(t));
+}
+
+/*
+ * Check if the vma is being used as a stack.
+ * If is_group is non-zero, check in the entire thread group or else
+ * just check in the current task. Returns the pid of the task that
+ * the vma is stack for.
+ */
+pid_t vm_is_stack(struct task_struct *task,
+		  struct vm_area_struct *vma, int in_group)
+{
+	pid_t ret = 0;
+
+	if (vm_is_stack_for_task(task, vma))
+		return task->pid;
+
+	if (in_group) {
+		struct task_struct *t;
+		rcu_read_lock();
+		t = list_first_entry_rcu(&task->thread_group,
+					 struct task_struct, thread_group);
+		do {
+			if (vm_is_stack_for_task(t, vma)) {
+				ret = t->pid;
+				goto done;
+			}
+		} while_each_thread(task, t);
+done:
+		rcu_read_unlock();
+	}
+
+	return ret;
+}
-- 
1.7.7.4

