Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755172Ab0INTkl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 15:40:41 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:56159 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755134Ab0INTka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 15:40:30 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 09/18] sh: kill big kernel lock
Date: Tue, 14 Sep 2010 21:40:13 +0200
Message-Id: <1284493213-7263-10-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1284493139-7233-1-git-send-email-arnd@arndb.de>
References: <1284493139-7233-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:xhBZrOxqfdFPmIvnkzbgxG9v8uQmPQGv18LyHpIfKSt
 IobZT1+2K7H/egH/qMKGLhmmgQJtHH8RZOumqPIF0XF0usomm8
 EBz1lICQKYQMqPthbJOpmpvbG0592xsp837WSQ7pLivjw+BOCJ
 m7SoTb9YOSX5+yff0G9RW0JRvEaO0hPnZuap6dPtOklonGV4NJ
 Ui9aNKrsg7i/JYlQSSG6g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The only BKL user in arch/sh protects a single bit,
so we can trivially replace it with test_and_set_bit.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: linux-sh@vger.kernel.org
---
 arch/sh/kernel/ptrace_64.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/arch/sh/kernel/ptrace_64.c b/arch/sh/kernel/ptrace_64.c
index 5fd644d..178b6b0 100644
--- a/arch/sh/kernel/ptrace_64.c
+++ b/arch/sh/kernel/ptrace_64.c
@@ -20,7 +20,7 @@
 #include <linux/sched.h>
 #include <linux/mm.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
+#include <linux/bitops.h>
 #include <linux/errno.h>
 #include <linux/ptrace.h>
 #include <linux/user.h>
@@ -395,10 +395,9 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 asmlinkage int sh64_ptrace(long request, long pid, long addr, long data)
 {
 #define WPC_DBRMODE 0x0d104008
-	static int first_call = 1;
+	static unsigned long first_call;
 
-	lock_kernel();
-	if (first_call) {
+	if (!test_and_set_bit(0, &first_call)) {
 		/* Set WPC.DBRMODE to 0.  This makes all debug events get
 		 * delivered through RESVEC, i.e. into the handlers in entry.S.
 		 * (If the kernel was downloaded using a remote gdb, WPC.DBRMODE
@@ -408,9 +407,7 @@ asmlinkage int sh64_ptrace(long request, long pid, long addr, long data)
 		 * the remote gdb.) */
 		printk("DBRMODE set to 0 to permit native debugging\n");
 		poke_real_address_q(WPC_DBRMODE, 0);
-		first_call = 0;
 	}
-	unlock_kernel();
 
 	return sys_ptrace(request, pid, addr, data);
 }
-- 
1.7.1

