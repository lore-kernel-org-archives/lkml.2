Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754887Ab0H0Jpq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 05:45:46 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:42423 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754866Ab0H0Joz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 05:44:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=E07RrhjKYblcSai5z2+K4JEP0RbgdLfs+1KzDDgPfDRcgpsqvDDjaOB6qaoKfSyuvw
         m6BAFU1Pf4M/7SZUMHA9qUYcfdRVD6izSgbUO0Ss+Vvoua4N2Ouj/Bc3Yxz0mRiJo3c8
         PRJPgJT0JXnD4E6v0AN6Um1RnUxjlyv+G6Pnc=
From: Namhyung Kim <namhyung@gmail.com>
To: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, Chris Metcalf <cmetcalf@tilera.com>
Subject: [RFC PATCH 39/43] ptrace, tile: change signature of arch_ptrace()
Date: Fri, 27 Aug 2010 18:42:25 +0900
Message-Id: <1282902149-12991-40-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1282902149-12991-1-git-send-email-namhyung@gmail.com>
References: <1282902149-12991-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

change type of @addr and @data into unsigned long according to commit
f76671df26ef06321480e702770f88f61272be29 [PATCH 03/43]

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/kernel/ptrace.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/tile/kernel/ptrace.c b/arch/tile/kernel/ptrace.c
index 7161bd0..704bf11 100644
--- a/arch/tile/kernel/ptrace.c
+++ b/arch/tile/kernel/ptrace.c
@@ -64,7 +64,8 @@ void ptrace_disable(struct task_struct *child)
 	clear_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
 }
 
-long arch_ptrace(struct task_struct *child, long request, long addr, long data)
+long arch_ptrace(struct task_struct *child, long request,
+		 unsigned long addr, unsigned long data)
 {
 	unsigned long __user *datap;
 	unsigned long tmp;
@@ -84,7 +85,7 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 	case PTRACE_PEEKUSR:  /* Read register from pt_regs. */
 		if (addr & (sizeof(data)-1))
 			break;
-		if (addr < 0 || addr >= PTREGS_SIZE)
+		if (addr >= PTREGS_SIZE)
 			break;
 		tmp = getreg(child, addr);   /* Read register */
 		ret = put_user(tmp, datap);
@@ -93,7 +94,7 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 	case PTRACE_POKEUSR:  /* Write register in pt_regs. */
 		if (addr & (sizeof(data)-1))
 			break;
-		if (addr < 0 || addr >= PTREGS_SIZE)
+		if (addr >= PTREGS_SIZE)
 			break;
 		putreg(child, addr, data);   /* Write register */
 		ret = 0;
@@ -102,7 +103,7 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 	case PTRACE_GETREGS:  /* Get all registers from the child. */
 		if (!access_ok(VERIFY_WRITE, datap, PTREGS_SIZE))
 			break;
-		for (i = 0; i < PTREGS_SIZE; i += sizeof(long)) {
+		for (i = 0; i < PTREGS_SIZE; i += sizeof(unsigned long)) {
 			ret = __put_user(getreg(child, i), datap);
 			if (ret != 0)
 				break;
@@ -113,7 +114,7 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 	case PTRACE_SETREGS:  /* Set all registers in the child. */
 		if (!access_ok(VERIFY_READ, datap, PTREGS_SIZE))
 			break;
-		for (i = 0; i < PTREGS_SIZE; i += sizeof(long)) {
+		for (i = 0; i < PTREGS_SIZE; i += sizeof(unsigned long)) {
 			ret = __get_user(tmp, datap);
 			if (ret != 0)
 				break;
-- 
1.7.2.2

