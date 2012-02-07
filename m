Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756673Ab2BGGu7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 01:50:59 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:61195 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756572Ab2BGGu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 01:50:57 -0500
Date: Tue, 7 Feb 2012 10:50:54 +0400
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Mundt <lethal@linux-sh.org>,
        Russell King <linux@arm.linux.org.uk>,
        Mike Frysinger <vapier@gentoo.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Richard Weinberger <richard@nod.at>, linux-kernel@vger.kernel.org
Subject: [PATCH 6/8] blackfin: Fix possible race on task->mm
Message-ID: <20120207065054.GF1496@oksana.dev.rtsoft.ru>
References: <20120207064809.GA29061@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120207064809.GA29061@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Even when in atomic context, grabbing irqsave variant of tasklist lock
is not enough to protect task->mm from disappearing on SMP machines.
Instead, we have to grab the task lock.

Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
---

p.s. I don't have blackfin toolchain handy, so I did not build-test
the patch.

 arch/blackfin/kernel/trace.c |   21 +++++++++------------
 1 files changed, 9 insertions(+), 12 deletions(-)

diff --git a/arch/blackfin/kernel/trace.c b/arch/blackfin/kernel/trace.c
index 050db44..19bc02a 100644
--- a/arch/blackfin/kernel/trace.c
+++ b/arch/blackfin/kernel/trace.c
@@ -10,6 +10,7 @@
 #include <linux/hardirq.h>
 #include <linux/thread_info.h>
 #include <linux/mm.h>
+#include <linux/sched.h>
 #include <linux/uaccess.h>
 #include <linux/module.h>
 #include <linux/kallsyms.h>
@@ -27,7 +28,6 @@ void decode_address(char *buf, unsigned long address)
 	struct task_struct *p;
 	struct mm_struct *mm;
 	unsigned long flags, offset;
-	unsigned char in_atomic = (bfin_read_IPEND() & 0x10) || in_atomic();
 	struct rb_node *n;
 
 #ifdef CONFIG_KALLSYMS
@@ -113,15 +113,13 @@ void decode_address(char *buf, unsigned long address)
 	 */
 	write_lock_irqsave(&tasklist_lock, flags);
 	for_each_process(p) {
-		mm = (in_atomic ? p->mm : get_task_mm(p));
+		task_lock(p);
+		mm = p->mm;
 		if (!mm)
-			continue;
+			goto __continue;
 
-		if (!down_read_trylock(&mm->mmap_sem)) {
-			if (!in_atomic)
-				mmput(mm);
-			continue;
-		}
+		if (!down_read_trylock(&mm->mmap_sem))
+			goto __continue;
 
 		for (n = rb_first(&mm->mm_rb); n; n = rb_next(n)) {
 			struct vm_area_struct *vma;
@@ -163,8 +161,7 @@ void decode_address(char *buf, unsigned long address)
 						name, vma->vm_start, vma->vm_end);
 
 				up_read(&mm->mmap_sem);
-				if (!in_atomic)
-					mmput(mm);
+				task_unlock(p);
 
 				if (buf[0] == '\0')
 					sprintf(buf, "[ %s ] dynamic memory", name);
@@ -174,8 +171,8 @@ void decode_address(char *buf, unsigned long address)
 		}
 
 		up_read(&mm->mmap_sem);
-		if (!in_atomic)
-			mmput(mm);
+__continue:
+		task_unlock(p);
 	}
 
 	/*
-- 
1.7.7.6

