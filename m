Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109Ab2DWHKX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 03:10:23 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:45494 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753938Ab2DWHKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 03:10:17 -0400
Date: Mon, 23 Apr 2012 00:09:01 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>
Cc: Russell King <linux@arm.linux.org.uk>, Mike Frysinger <vapier@gentoo.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Richard Weinberger <richard@nod.at>, Paul Mundt <lethal@linux-sh.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        John Stultz <john.stultz@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        uclinux-dist-devel@blackfin.uclinux.org, linuxppc-dev@lists.ozlabs.org,
        linux-sh@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net,
        linaro-kernel@lists.linaro.org, patches@linaro.org, linux-mm@kvack.org
Subject: [PATCH 5/9] blackfin: A couple of task->mm handling fixes
Message-ID: <20120423070901.GE30752@lizard>
References: <20120423070641.GA27702@lizard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120423070641.GA27702@lizard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch fixes two problems:

1. Working with task->mm w/o getting mm or grabing the task lock is
   dangerous as ->mm might disappear (exit_mm() assigns NULL under
   task_lock(), so tasklist lock is not enough).

   We can't use get_task_mm()/mmput() pair as mmput() might sleep,
   so we have to take the task lock while handle its mm.

2. Checking for process->mm is not enough because process' main
   thread may exit or detach its mm via use_mm(), but other threads
   may still have a valid mm.

   To catch this we use find_lock_task_mm(), which walks up all
   threads and returns an appropriate task (with task lock held).

Suggested-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
---
 arch/blackfin/kernel/trace.c |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/arch/blackfin/kernel/trace.c b/arch/blackfin/kernel/trace.c
index 44bbf2f..d08f0e3 100644
--- a/arch/blackfin/kernel/trace.c
+++ b/arch/blackfin/kernel/trace.c
@@ -10,6 +10,8 @@
 #include <linux/hardirq.h>
 #include <linux/thread_info.h>
 #include <linux/mm.h>
+#include <linux/oom.h>
+#include <linux/sched.h>
 #include <linux/uaccess.h>
 #include <linux/module.h>
 #include <linux/kallsyms.h>
@@ -28,7 +30,6 @@ void decode_address(char *buf, unsigned long address)
 	struct task_struct *p;
 	struct mm_struct *mm;
 	unsigned long flags, offset;
-	unsigned char in_atomic = (bfin_read_IPEND() & 0x10) || in_atomic();
 	struct rb_node *n;
 
 #ifdef CONFIG_KALLSYMS
@@ -114,15 +115,15 @@ void decode_address(char *buf, unsigned long address)
 	 */
 	write_lock_irqsave(&tasklist_lock, flags);
 	for_each_process(p) {
-		mm = (in_atomic ? p->mm : get_task_mm(p));
-		if (!mm)
-			continue;
+		struct task_struct *t;
 
-		if (!down_read_trylock(&mm->mmap_sem)) {
-			if (!in_atomic)
-				mmput(mm);
+		t = find_lock_task_mm(p);
+		if (!t)
 			continue;
-		}
+
+		mm = t->mm;
+		if (!down_read_trylock(&mm->mmap_sem))
+			goto __continue;
 
 		for (n = rb_first(&mm->mm_rb); n; n = rb_next(n)) {
 			struct vm_area_struct *vma;
@@ -131,7 +132,7 @@ void decode_address(char *buf, unsigned long address)
 
 			if (address >= vma->vm_start && address < vma->vm_end) {
 				char _tmpbuf[256];
-				char *name = p->comm;
+				char *name = t->comm;
 				struct file *file = vma->vm_file;
 
 				if (file) {
@@ -164,8 +165,7 @@ void decode_address(char *buf, unsigned long address)
 						name, vma->vm_start, vma->vm_end);
 
 				up_read(&mm->mmap_sem);
-				if (!in_atomic)
-					mmput(mm);
+				task_unlock(t);
 
 				if (buf[0] == '\0')
 					sprintf(buf, "[ %s ] dynamic memory", name);
@@ -175,8 +175,8 @@ void decode_address(char *buf, unsigned long address)
 		}
 
 		up_read(&mm->mmap_sem);
-		if (!in_atomic)
-			mmput(mm);
+__continue:
+		task_unlock(t);
 	}
 
 	/*
-- 
1.7.9.2

