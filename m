Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754829Ab0H0Jrd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 05:47:33 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:42423 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754697Ab0H0JoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 05:44:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=sKvkz89DH5ZggOD7zSNsuOwMqlweb5wKVt9Az97dLt7LPKd3udEZuDbOO2hvjCrpMj
         TStbVEjmMQJlxF3A6pju+/Zh5rk15yt/tu7uHSHLCnk10s4IG8OolDUvODSYk3h1eOdE
         zVg21ippjOsln78yYkU9vzaFRF2QhOaekfFv0=
From: Namhyung Kim <namhyung@gmail.com>
To: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>
Subject: [RFC PATCH 27/43] ptrace, mips: cleanup arch_ptrace()
Date: Fri, 27 Aug 2010 18:42:13 +0900
Message-Id: <1282902149-12991-28-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1282902149-12991-1-git-send-email-namhyung@gmail.com>
References: <1282902149-12991-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

use new 'addrp' and 'datap' variables type of void pointer in order to remove
unnecessary castings.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
---
 arch/mips/kernel/ptrace.c |   23 ++++++++++++-----------
 1 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/arch/mips/kernel/ptrace.c b/arch/mips/kernel/ptrace.c
index 26c29dd..c0ab9d2 100644
--- a/arch/mips/kernel/ptrace.c
+++ b/arch/mips/kernel/ptrace.c
@@ -259,6 +259,8 @@ long arch_ptrace(struct task_struct *child, long request,
 		 unsigned long addr, unsigned long data)
 {
 	int ret;
+	void __user *addrp = (void __user *) addr;
+	void __user *datap = (void __user *) data;
 
 	switch (request) {
 	/* when I and D space are separate, these will need to be fixed. */
@@ -387,7 +389,9 @@ long arch_ptrace(struct task_struct *child, long request,
 			ret = -EIO;
 			goto out;
 		}
-		ret = put_user(tmp, (unsigned long __user *) data);
+		ret = copy_to_user(datap, &tmp, sizeof(tmp));
+		if (ret)
+			ret = -EFAULT;
 		break;
 	}
 
@@ -479,34 +483,31 @@ long arch_ptrace(struct task_struct *child, long request,
 		}
 
 	case PTRACE_GETREGS:
-		ret = ptrace_getregs(child, (__s64 __user *) data);
+		ret = ptrace_getregs(child, datap);
 		break;
 
 	case PTRACE_SETREGS:
-		ret = ptrace_setregs(child, (__s64 __user *) data);
+		ret = ptrace_setregs(child, datap);
 		break;
 
 	case PTRACE_GETFPREGS:
-		ret = ptrace_getfpregs(child, (__u32 __user *) data);
+		ret = ptrace_getfpregs(child, datap);
 		break;
 
 	case PTRACE_SETFPREGS:
-		ret = ptrace_setfpregs(child, (__u32 __user *) data);
+		ret = ptrace_setfpregs(child, datap);
 		break;
 
 	case PTRACE_GET_THREAD_AREA:
-		ret = put_user(task_thread_info(child)->tp_value,
-				(unsigned long __user *) data);
+		ret = put_user(task_thread_info(child)->tp_value, datap);
 		break;
 
 	case PTRACE_GET_WATCH_REGS:
-		ret = ptrace_get_watch_regs(child,
-					(struct pt_watch_regs __user *) addr);
+		ret = ptrace_get_watch_regs(child, addrp);
 		break;
 
 	case PTRACE_SET_WATCH_REGS:
-		ret = ptrace_set_watch_regs(child,
-					(struct pt_watch_regs __user *) addr);
+		ret = ptrace_set_watch_regs(child, addrp);
 		break;
 
 	default:
-- 
1.7.2.2

