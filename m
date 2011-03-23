Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932862Ab1CWOqm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 10:46:42 -0400
Received: from mout.perfora.net ([74.208.4.194]:51585 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932410Ab1CWOqk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 10:46:40 -0400
From: Stephen Wilson <wilsons@start.ca>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Michel Lespinasse <walken@google.com>, Andi Kleen <ak@linux.intel.com>,
        Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Matt Mackall <mpm@selenic.com>, David Rientjes <rientjes@google.com>,
        Nick Piggin <npiggin@kernel.dk>,
        Andrea Arcangeli <aarcange@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>, x86@kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Stephen Wilson <wilsons@start.ca>
Subject: [PATCH v2 resend 04/12] mm: arch: make in_gate_area take an mm_struct instead of a task_struct
Date: Wed, 23 Mar 2011 10:43:53 -0400
Message-Id: <1300891441-16280-5-git-send-email-wilsons@start.ca>
X-Mailer: git-send-email 1.7.3.5
In-Reply-To: <1300891441-16280-1-git-send-email-wilsons@start.ca>
References: <1300891441-16280-1-git-send-email-wilsons@start.ca>
X-Provags-ID: V02:K0:PkEIpVRT+vPRM3mM+1uG5VHEE6oqs9SCb26uUBsHCN+
 LVIP0fFtlLzctXG1T0JGaWpJAunHqPSTgd+CTRnDsV1ymwFIHf
 MCWPVMUPWifGhqKyk0d/4ZTtIAXEu49GGkt9VueJZ4pO3R+z2o
 YzdUuBuO4Zc5Wlmd7+W9ZJw9j4lQN3pvzaho4j6bhfXw0sxKma
 YJ31V1QioBc8C/lNyto1/6R9sLWL4ZZvdCy0KRNT/U=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Morally, the question of whether an address lies in a gate vma should be asked
with respect to an mm, not a particular task.  Moreover, dropping the dependency
on task_struct will help make existing and future operations on mm's more
flexible and convenient.

Signed-off-by: Stephen Wilson <wilsons@start.ca>
Reviewed-by: Michel Lespinasse <walken@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---
 arch/powerpc/kernel/vdso.c         |    2 +-
 arch/s390/kernel/vdso.c            |    2 +-
 arch/sh/kernel/vsyscall/vsyscall.c |    2 +-
 arch/x86/mm/init_64.c              |    4 ++--
 arch/x86/vdso/vdso32-setup.c       |    4 ++--
 include/linux/mm.h                 |    4 ++--
 mm/memory.c                        |    2 +-
 7 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/powerpc/kernel/vdso.c b/arch/powerpc/kernel/vdso.c
index 6169f17..467aa9e 100644
--- a/arch/powerpc/kernel/vdso.c
+++ b/arch/powerpc/kernel/vdso.c
@@ -825,7 +825,7 @@ int in_gate_area_no_task(unsigned long addr)
 	return 0;
 }
 
-int in_gate_area(struct task_struct *task, unsigned long addr)
+int in_gate_area(struct mm_struct *mm, unsigned long addr)
 {
 	return 0;
 }
diff --git a/arch/s390/kernel/vdso.c b/arch/s390/kernel/vdso.c
index d19f305..9006e96 100644
--- a/arch/s390/kernel/vdso.c
+++ b/arch/s390/kernel/vdso.c
@@ -342,7 +342,7 @@ int in_gate_area_no_task(unsigned long addr)
 	return 0;
 }
 
-int in_gate_area(struct task_struct *task, unsigned long addr)
+int in_gate_area(struct mm_struct *mm, unsigned long addr)
 {
 	return 0;
 }
diff --git a/arch/sh/kernel/vsyscall/vsyscall.c b/arch/sh/kernel/vsyscall/vsyscall.c
index 3f9b6f4..62c36a8 100644
--- a/arch/sh/kernel/vsyscall/vsyscall.c
+++ b/arch/sh/kernel/vsyscall/vsyscall.c
@@ -99,7 +99,7 @@ struct vm_area_struct *get_gate_vma(struct mm_struct *mm)
 	return NULL;
 }
 
-int in_gate_area(struct task_struct *task, unsigned long address)
+int in_gate_area(struct mm_struct *mm, unsigned long address)
 {
 	return 0;
 }
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index fa56f9b..4deb881 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -879,9 +879,9 @@ struct vm_area_struct *get_gate_vma(struct mm_struct *mm)
 	return &gate_vma;
 }
 
-int in_gate_area(struct task_struct *task, unsigned long addr)
+int in_gate_area(struct mm_struct *mm, unsigned long addr)
 {
-	struct vm_area_struct *vma = get_gate_vma(task->mm);
+	struct vm_area_struct *vma = get_gate_vma(mm);
 
 	if (!vma)
 		return 0;
diff --git a/arch/x86/vdso/vdso32-setup.c b/arch/x86/vdso/vdso32-setup.c
index 1f651f6..f849bb2 100644
--- a/arch/x86/vdso/vdso32-setup.c
+++ b/arch/x86/vdso/vdso32-setup.c
@@ -428,9 +428,9 @@ struct vm_area_struct *get_gate_vma(struct mm_struct *mm)
 	return NULL;
 }
 
-int in_gate_area(struct task_struct *task, unsigned long addr)
+int in_gate_area(struct mm_struct *mm, unsigned long addr)
 {
-	const struct vm_area_struct *vma = get_gate_vma(task->mm);
+	const struct vm_area_struct *vma = get_gate_vma(mm);
 
 	return vma && addr >= vma->vm_start && addr < vma->vm_end;
 }
diff --git a/include/linux/mm.h b/include/linux/mm.h
index b571921..c700bbb 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1571,10 +1571,10 @@ static inline bool kernel_page_present(struct page *page) { return true; }
 extern struct vm_area_struct *get_gate_vma(struct mm_struct *mm);
 #ifdef	__HAVE_ARCH_GATE_AREA
 int in_gate_area_no_task(unsigned long addr);
-int in_gate_area(struct task_struct *task, unsigned long addr);
+int in_gate_area(struct mm_struct *mm, unsigned long addr);
 #else
 int in_gate_area_no_task(unsigned long addr);
-#define in_gate_area(task, addr) ({(void)task; in_gate_area_no_task(addr);})
+#define in_gate_area(mm, addr) ({(void)mm; in_gate_area_no_task(addr);})
 #endif	/* __HAVE_ARCH_GATE_AREA */
 
 int drop_caches_sysctl_handler(struct ctl_table *, int,
diff --git a/mm/memory.c b/mm/memory.c
index aec7cbd..d1347ac 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1437,7 +1437,7 @@ int __get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
 		struct vm_area_struct *vma;
 
 		vma = find_extend_vma(mm, start);
-		if (!vma && in_gate_area(tsk, start)) {
+		if (!vma && in_gate_area(tsk->mm, start)) {
 			unsigned long pg = start & PAGE_MASK;
 			struct vm_area_struct *gate_vma = get_gate_vma(tsk->mm);
 			pgd_t *pgd;
-- 
1.7.3.5

