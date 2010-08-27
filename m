Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754798Ab0H0Joh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 05:44:37 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:42423 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754658Ab0H0Jo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 05:44:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=s4AVJFmQhSUKKXDnIi+joX/h55o68ZQZecXwb/prwwWfkev60kivlwbIKfF1QbgBSP
         khBXpmFTH4wwOtOS5M1Wr7NUUi2JMDJ0CbIIA1SyTJfOpHFLIkrTc0uOGpurZlpiriI8
         QtV4GvsIsVdGY4AWCPDDSNtEJpHnREssC1EM8=
From: Namhyung Kim <namhyung@gmail.com>
To: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, Kyle McMartin <kyle@mcmartin.ca>,
        Helge Deller <deller@gmx.de>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>
Subject: [RFC PATCH 30/43] ptrace, parisc: change signature of arch_ptrace()
Date: Fri, 27 Aug 2010 18:42:16 +0900
Message-Id: <1282902149-12991-31-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1282902149-12991-1-git-send-email-namhyung@gmail.com>
References: <1282902149-12991-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

change type of @addr and @data into unsigned long according to commit
f76671df26ef06321480e702770f88f61272be29 [PATCH 03/43]

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Helge Deller <deller@gmx.de>
Cc: "James E.J. Bottomley" <jejb@parisc-linux.org>
---
 arch/parisc/kernel/ptrace.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/parisc/kernel/ptrace.c b/arch/parisc/kernel/ptrace.c
index c4f49e4..2905b1f 100644
--- a/arch/parisc/kernel/ptrace.c
+++ b/arch/parisc/kernel/ptrace.c
@@ -110,7 +110,8 @@ void user_enable_block_step(struct task_struct *task)
 	pa_psw(task)->l = 0;
 }
 
-long arch_ptrace(struct task_struct *child, long request, long addr, long data)
+long arch_ptrace(struct task_struct *child, long request,
+		 unsigned long addr, unsigned long data)
 {
 	unsigned long tmp;
 	long ret = -EIO;
@@ -120,11 +121,11 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 	/* Read the word at location addr in the USER area.  For ptraced
 	   processes, the kernel saves all regs on a syscall. */
 	case PTRACE_PEEKUSR:
-		if ((addr & (sizeof(long)-1)) ||
-		    (unsigned long) addr >= sizeof(struct pt_regs))
+		if ((addr & (sizeof(unsigned long)-1)) ||
+		     addr >= sizeof(struct pt_regs))
 			break;
 		tmp = *(unsigned long *) ((char *) task_regs(child) + addr);
-		ret = put_user(tmp, (unsigned long *) data);
+		ret = put_user(tmp, (unsigned long __user *) data);
 		break;
 
 	/* Write the word at location addr in the USER area.  This will need
@@ -151,8 +152,8 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 			break;
 		}
 
-		if ((addr & (sizeof(long)-1)) ||
-		    (unsigned long) addr >= sizeof(struct pt_regs))
+		if ((addr & (sizeof(unsigned long)-1)) ||
+		     addr >= sizeof(struct pt_regs))
 			break;
 		if ((addr >= PT_GR1 && addr <= PT_GR31) ||
 				addr == PT_IAOQ0 || addr == PT_IAOQ1 ||
-- 
1.7.2.2

