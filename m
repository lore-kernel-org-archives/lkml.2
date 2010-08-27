Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754608Ab0H0Juc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 05:50:32 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:52511 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754448Ab0H0JnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 05:43:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=DXQZ+AE8cAeDbjGL3yOKHfAdMr6PzRg3t4Ir7o2xTbNc4dgvt/POa64I/VI7ebjXDp
         pX3y6Q3aOxLtttrsBQ1TYiljpJNiIyafjIduxlOmSbtBuPd19x8ThD3HiaTSxWth0YW6
         cb7r80RyNVPucypuR5uajKVWC3UBOhUJeS5jI=
From: Namhyung Kim <namhyung@gmail.com>
To: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>
Subject: [RFC PATCH 08/43] ptrace, arm: cleanup arch_ptrace()
Date: Fri, 27 Aug 2010 18:41:54 +0900
Message-Id: <1282902149-12991-9-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1282902149-12991-1-git-send-email-namhyung@gmail.com>
References: <1282902149-12991-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

use new 'datap' variable type of void pointer in order to remove unnecessary
castings.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>
---
 arch/arm/kernel/ptrace.c |   33 +++++++++++++++++++--------------
 1 files changed, 19 insertions(+), 14 deletions(-)

diff --git a/arch/arm/kernel/ptrace.c b/arch/arm/kernel/ptrace.c
index 87ca2c7..4be8a58 100644
--- a/arch/arm/kernel/ptrace.c
+++ b/arch/arm/kernel/ptrace.c
@@ -851,10 +851,11 @@ long arch_ptrace(struct task_struct *child, long request,
 		 unsigned long addr, unsigned long data)
 {
 	int ret;
+	void __user *datap = (void __user *) data;
 
 	switch (request) {
 		case PTRACE_PEEKUSR:
-			ret = ptrace_read_user(child, addr, (unsigned long __user *)data);
+			ret = ptrace_read_user(child, addr, datap);
 			break;
 
 		case PTRACE_POKEUSR:
@@ -862,35 +863,39 @@ long arch_ptrace(struct task_struct *child, long request,
 			break;
 
 		case PTRACE_GETREGS:
-			ret = ptrace_getregs(child, (void __user *)data);
+			ret = ptrace_getregs(child, datap);
 			break;
 
 		case PTRACE_SETREGS:
-			ret = ptrace_setregs(child, (void __user *)data);
+			ret = ptrace_setregs(child, datap);
 			break;
 
 		case PTRACE_GETFPREGS:
-			ret = ptrace_getfpregs(child, (void __user *)data);
+			ret = ptrace_getfpregs(child, datap);
 			break;
 		
 		case PTRACE_SETFPREGS:
-			ret = ptrace_setfpregs(child, (void __user *)data);
+			ret = ptrace_setfpregs(child, datap);
 			break;
 
 #ifdef CONFIG_IWMMXT
 		case PTRACE_GETWMMXREGS:
-			ret = ptrace_getwmmxregs(child, (void __user *)data);
+			ret = ptrace_getwmmxregs(child, datap);
 			break;
 
 		case PTRACE_SETWMMXREGS:
-			ret = ptrace_setwmmxregs(child, (void __user *)data);
+			ret = ptrace_setwmmxregs(child, datap);
 			break;
 #endif
 
-		case PTRACE_GET_THREAD_AREA:
-			ret = put_user(task_thread_info(child)->tp_value,
-				       (unsigned long __user *) data);
+		case PTRACE_GET_THREAD_AREA: {
+			unsigned long tpval;
+			tpval = task_thread_info(child)->tp_value;
+			
+			ret = copy_to_user(datap, &tpval, sizeof(tpval)) ?
+				-EFAULT : 0;
 			break;
+		}
 
 		case PTRACE_SET_SYSCALL:
 			task_thread_info(child)->syscall = data;
@@ -899,21 +904,21 @@ long arch_ptrace(struct task_struct *child, long request,
 
 #ifdef CONFIG_CRUNCH
 		case PTRACE_GETCRUNCHREGS:
-			ret = ptrace_getcrunchregs(child, (void __user *)data);
+			ret = ptrace_getcrunchregs(child, datap);
 			break;
 
 		case PTRACE_SETCRUNCHREGS:
-			ret = ptrace_setcrunchregs(child, (void __user *)data);
+			ret = ptrace_setcrunchregs(child, datap);
 			break;
 #endif
 
 #ifdef CONFIG_VFP
 		case PTRACE_GETVFPREGS:
-			ret = ptrace_getvfpregs(child, (void __user *)data);
+			ret = ptrace_getvfpregs(child, datap);
 			break;
 
 		case PTRACE_SETVFPREGS:
-			ret = ptrace_setvfpregs(child, (void __user *)data);
+			ret = ptrace_setvfpregs(child, datap);
 			break;
 #endif
 
-- 
1.7.2.2

