Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756214Ab1D1DLp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 23:11:45 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:40415 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754480Ab1D1DLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 23:11:44 -0400
From: Will Drewry <wad@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: kees.cook@canonical.com, eparis@redhat.com, agl@chromium.org,
        mingo@elte.hu, jmorris@namei.org, rostedt@goodmis.org,
        Will Drewry <wad@chromium.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 7/7] arch/x86: hook int returning system calls
Date: Wed, 27 Apr 2011 22:08:51 -0500
Message-Id: <1303960136-14298-6-git-send-email-wad@chromium.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1303960136-14298-1-git-send-email-wad@chromium.org>
References: <1303960136-14298-1-git-send-email-wad@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using the newly specified __SYSCALL_DEFINEx helpers, redefine
int-returning system calls with the macro to enable ftrace access.

Signed-off-by: Will Drewry <wad@chromium.org>
---
 arch/x86/kernel/ldt.c |    5 +++--
 arch/x86/kernel/tls.c |    7 +++++--
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/ldt.c b/arch/x86/kernel/ldt.c
index ea69726..3f1160c 100644
--- a/arch/x86/kernel/ldt.c
+++ b/arch/x86/kernel/ldt.c
@@ -10,6 +10,7 @@
 #include <linux/gfp.h>
 #include <linux/sched.h>
 #include <linux/string.h>
+#include <linux/syscalls.h>
 #include <linux/mm.h>
 #include <linux/smp.h>
 #include <linux/vmalloc.h>
@@ -245,8 +246,8 @@ out:
 	return error;
 }
 
-asmlinkage int sys_modify_ldt(int func, void __user *ptr,
-			      unsigned long bytecount)
+__SYSCALL_DEFINEx(asmlinkage, int, 3, _modify_ldt,
+		  int, func, void __user *, ptr, unsigned long, bytecount)
 {
 	int ret = -ENOSYS;
 
diff --git a/arch/x86/kernel/tls.c b/arch/x86/kernel/tls.c
index 6bb7b85..0f27a6b 100644
--- a/arch/x86/kernel/tls.c
+++ b/arch/x86/kernel/tls.c
@@ -1,6 +1,7 @@
 #include <linux/kernel.h>
 #include <linux/errno.h>
 #include <linux/sched.h>
+#include <linux/syscalls.h>
 #include <linux/user.h>
 #include <linux/regset.h>
 
@@ -90,7 +91,8 @@ int do_set_thread_area(struct task_struct *p, int idx,
 	return 0;
 }
 
-asmlinkage int sys_set_thread_area(struct user_desc __user *u_info)
+__SYSCALL_DEFINEx(asmlinkage, int, 1, _set_thread_area,
+		  struct user_desc __user *, u_info)
 {
 	int ret = do_set_thread_area(current, -1, u_info, 1);
 	asmlinkage_protect(1, ret, u_info);
@@ -140,7 +142,8 @@ int do_get_thread_area(struct task_struct *p, int idx,
 	return 0;
 }
 
-asmlinkage int sys_get_thread_area(struct user_desc __user *u_info)
+__SYSCALL_DEFINEx(asmlinkage, int, 1, _get_thread_area,
+		  struct user_desc __user *, u_info)
 {
 	int ret = do_get_thread_area(current, -1, u_info);
 	asmlinkage_protect(1, ret, u_info);
-- 
1.7.0.4

