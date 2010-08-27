Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754352Ab0H0JnI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 05:43:08 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:52511 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818Ab0H0JnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 05:43:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=cNGdd1+JAX5i//6T3jz4BSherL9SV7F4mK6bTq3XIMf/wMaAqD3iQF6Ob+9Tt52w/f
         QXSA6WL5X9y5AbedDndDDmH0ktNAwVtec6dB0l8Ey2LH4fvB1ls+gL9ac6J1gJjs4F2z
         kouwR8lgCQiJ+GDu0Hyoot+zj9Nc7rSRGb4HA=
From: Namhyung Kim <namhyung@gmail.com>
To: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [RFC PATCH 04/43] ptrace, x86: change signature of arch_ptrace()
Date: Fri, 27 Aug 2010 18:41:50 +0900
Message-Id: <1282902149-12991-5-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1282902149-12991-1-git-send-email-namhyung@gmail.com>
References: <1282902149-12991-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

change type of @addr and @data into unsigned long according to commit
f76671df26ef06321480e702770f88f61272be29 [PATCH 03/43]

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---
 arch/x86/kernel/ptrace.c |   13 ++++++-------
 1 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index 70c4872..ea7766a 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -801,7 +801,8 @@ void ptrace_disable(struct task_struct *child)
 static const struct user_regset_view user_x86_32_view; /* Initialized below. */
 #endif
 
-long arch_ptrace(struct task_struct *child, long request, long addr, long data)
+long arch_ptrace(struct task_struct *child, long request,
+		 unsigned long addr, unsigned long data)
 {
 	int ret;
 	unsigned long __user *datap = (unsigned long __user *)data;
@@ -812,8 +813,7 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 		unsigned long tmp;
 
 		ret = -EIO;
-		if ((addr & (sizeof(data) - 1)) || addr < 0 ||
-		    addr >= sizeof(struct user))
+		if ((addr & (sizeof(data) - 1)) || addr >= sizeof(struct user))
 			break;
 
 		tmp = 0;  /* Default return condition */
@@ -830,8 +830,7 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 
 	case PTRACE_POKEUSR: /* write the word at location addr in the USER area */
 		ret = -EIO;
-		if ((addr & (sizeof(data) - 1)) || addr < 0 ||
-		    addr >= sizeof(struct user))
+		if ((addr & (sizeof(data) - 1)) || addr >= sizeof(struct user))
 			break;
 
 		if (addr < sizeof(struct user_regs_struct))
@@ -888,14 +887,14 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 
 #if defined CONFIG_X86_32 || defined CONFIG_IA32_EMULATION
 	case PTRACE_GET_THREAD_AREA:
-		if (addr < 0)
+		if ((int) addr < 0)
 			return -EIO;
 		ret = do_get_thread_area(child, addr,
 					 (struct user_desc __user *) data);
 		break;
 
 	case PTRACE_SET_THREAD_AREA:
-		if (addr < 0)
+		if ((int) addr < 0)
 			return -EIO;
 		ret = do_set_thread_area(child, addr,
 					 (struct user_desc __user *) data, 0);
-- 
1.7.2.2

