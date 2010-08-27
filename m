Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754540Ab0H0Jna (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 05:43:30 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:55188 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754183Ab0H0Jn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 05:43:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ZB0ONd8l6Mn+mPBfR6s+AVGhQayKmyBi6DBaGk6L03ihKsfE6N5S8jgHhlQPHAHe/b
         WQk1tKHqDHQuwTYx9un7weo4aiX6hJd2o8YN2Bg5b6P9/VFjzjJQeEIQK0a02BJgcVNH
         Ws79P0lWRGZyqNGRgxvEL6HUh3rqAn8X0nJZI=
From: Namhyung Kim <namhyung@gmail.com>
To: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, Mike Frysinger <vapier@gentoo.org>
Subject: [RFC PATCH 11/43] ptrace, blackfin: change signature of arch_ptrace()
Date: Fri, 27 Aug 2010 18:41:57 +0900
Message-Id: <1282902149-12991-12-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1282902149-12991-1-git-send-email-namhyung@gmail.com>
References: <1282902149-12991-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

change type of @addr and @data into unsigned long according to commit
f76671df26ef06321480e702770f88f61272be29 [PATCH 03/43]

{get,put}_reg() also be changed because they are used only in
arch_ptrace() and this can make one of argument checking unnecessary.
And castings to void pointer can be removed by make use of datap.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/kernel/ptrace.c |   16 +++++++++-------
 1 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/arch/blackfin/kernel/ptrace.c b/arch/blackfin/kernel/ptrace.c
index 6ec7768..545fc14 100644
--- a/arch/blackfin/kernel/ptrace.c
+++ b/arch/blackfin/kernel/ptrace.c
@@ -37,12 +37,13 @@
  * Get contents of register REGNO in task TASK.
  */
 static inline long
-get_reg(struct task_struct *task, long regno, unsigned long __user *datap)
+get_reg(struct task_struct *task, unsigned long regno,
+	unsigned long __user *datap)
 {
 	long tmp;
 	struct pt_regs *regs = task_pt_regs(task);
 
-	if (regno & 3 || regno > PT_LAST_PSEUDO || regno < 0)
+	if (regno & 3 || regno > PT_LAST_PSEUDO)
 		return -EIO;
 
 	switch (regno) {
@@ -73,11 +74,11 @@ get_reg(struct task_struct *task, long regno, unsigned long __user *datap)
  * Write contents of register REGNO in task TASK.
  */
 static inline int
-put_reg(struct task_struct *task, long regno, unsigned long data)
+put_reg(struct task_struct *task, unsigned long regno, unsigned long data)
 {
 	struct pt_regs *regs = task_pt_regs(task);
 
-	if (regno & 3 || regno > PT_LAST_PSEUDO || regno < 0)
+	if (regno & 3 || regno > PT_LAST_PSEUDO)
 		return -EIO;
 
 	switch (regno) {
@@ -232,7 +233,8 @@ void user_disable_single_step(struct task_struct *child)
 	clear_tsk_thread_flag(child, TIF_SINGLESTEP);
 }
 
-long arch_ptrace(struct task_struct *child, long request, long addr, long data)
+long arch_ptrace(struct task_struct *child, long request,
+		 unsigned long addr, unsigned long data)
 {
 	int ret;
 	unsigned long __user *datap = (unsigned long __user *)data;
@@ -360,14 +362,14 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 		return copy_regset_to_user(child, &user_bfin_native_view,
 					   REGSET_GENERAL,
 					   0, sizeof(struct pt_regs),
-					   (void __user *)data);
+					   datap);
 
 	case PTRACE_SETREGS:
 		pr_debug("ptrace: PTRACE_SETREGS\n");
 		return copy_regset_from_user(child, &user_bfin_native_view,
 					     REGSET_GENERAL,
 					     0, sizeof(struct pt_regs),
-					     (const void __user *)data);
+					     datap);
 
 	case_default:
 	default:
-- 
1.7.2.2

