Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754298Ab1CYUb5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 16:31:57 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:59469 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751511Ab1CYUb4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 16:31:56 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: uclinux-dev@uclinux.org, David Howells <dhowells@redhat.com>,
        Greg Ungerer <gerg@uclinux.org>, Paul Mundt <lethal@linux-sh.org>
Cc: uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org
Subject: [PATCH] NOMMU: implement access_remote_vm
Date: Fri, 25 Mar 2011 16:32:28 -0400
Message-Id: <1301085148-14860-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recent vm changes brought in a new function which the core procfs code
utilizes.  So implement it for nommu systems too to avoid link failures.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 mm/nommu.c |   52 +++++++++++++++++++++++++++++++++++++++-------------
 1 files changed, 39 insertions(+), 13 deletions(-)

diff --git a/mm/nommu.c b/mm/nommu.c
index cb86e7d..c4c542c 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -1971,21 +1971,10 @@ int filemap_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 }
 EXPORT_SYMBOL(filemap_fault);
 
-/*
- * Access another process' address space.
- * - source/target buffer must be kernel space
- */
-int access_process_vm(struct task_struct *tsk, unsigned long addr, void *buf, int len, int write)
+static int __access_remote_vm(struct task_struct *tsk, struct mm_struct *mm,
+		unsigned long addr, void *buf, int len, int write)
 {
 	struct vm_area_struct *vma;
-	struct mm_struct *mm;
-
-	if (addr + len < addr)
-		return 0;
-
-	mm = get_task_mm(tsk);
-	if (!mm)
-		return 0;
 
 	down_read(&mm->mmap_sem);
 
@@ -2010,6 +1999,43 @@ int access_process_vm(struct task_struct *tsk, unsigned long addr, void *buf, in
 	}
 
 	up_read(&mm->mmap_sem);
+
+	return len;
+}
+
+/**
+ * @access_remote_vm - access another process' address space
+ * @mm:		the mm_struct of the target address space
+ * @addr:	start address to access
+ * @buf:	source or destination buffer
+ * @len:	number of bytes to transfer
+ * @write:	whether the access is a write
+ *
+ * The caller must hold a reference on @mm.
+ */
+int access_remote_vm(struct mm_struct *mm, unsigned long addr,
+		void *buf, int len, int write)
+{
+	return __access_remote_vm(NULL, mm, addr, buf, len, write);
+}
+
+/*
+ * Access another process' address space.
+ * - source/target buffer must be kernel space
+ */
+int access_process_vm(struct task_struct *tsk, unsigned long addr, void *buf, int len, int write)
+{
+	struct mm_struct *mm;
+
+	if (addr + len < addr)
+		return 0;
+
+	mm = get_task_mm(tsk);
+	if (!mm)
+		return 0;
+
+	len = __access_remote_vm(tsk, mm, addr, buf, len, write);
+
 	mmput(mm);
 	return len;
 }
-- 
1.7.4.1

