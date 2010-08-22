Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752281Ab0HVKWp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Aug 2010 06:22:45 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:58479 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752153Ab0HVKWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Aug 2010 06:22:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=w9KPDnWpMCq4TrenDPLF23kFjxyDWJ3BUMDozOcMGfRmUL7wq03TiQjd2ZNOQnh9nB
         VYoBuZFI1HXLhMSjOCJMj9Dbc4D8VbPnQm7egheC82JGgutVAJmxNXfNeld9GGDWdRvR
         iCERb/ks/OF33DTjnirzMayFYKgmDq9JkvVMo=
From: Namhyung Kim <namhyung@gmail.com>
To: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] ptrace: add __force markup
Date: Sun, 22 Aug 2010 19:22:15 +0900
Message-Id: <1282472536-7430-2-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

casting from kernel address space to user needs __force markup. Add it.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 kernel/ptrace.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 4afd9b8..1abbb4d 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -580,18 +580,19 @@ int ptrace_request(struct task_struct *child, long request,
 		ret = ptrace_setoptions(child, data);
 		break;
 	case PTRACE_GETEVENTMSG:
-		ret = put_user(child->ptrace_message, (unsigned long __user *) data);
+		ret = put_user(child->ptrace_message,
+			       (unsigned long __user __force *) data);
 		break;
 
 	case PTRACE_GETSIGINFO:
 		ret = ptrace_getsiginfo(child, &siginfo);
 		if (!ret)
-			ret = copy_siginfo_to_user((siginfo_t __user *) data,
+			ret = copy_siginfo_to_user((siginfo_t __user __force *) data,
 						   &siginfo);
 		break;
 
 	case PTRACE_SETSIGINFO:
-		if (copy_from_user(&siginfo, (siginfo_t __user *) data,
+		if (copy_from_user(&siginfo, (siginfo_t __user __force *) data,
 				   sizeof siginfo))
 			ret = -EFAULT;
 		else
@@ -623,7 +624,7 @@ int ptrace_request(struct task_struct *child, long request,
 		}
 		mmput(mm);
 
-		ret = put_user(tmp, (unsigned long __user *) data);
+		ret = put_user(tmp, (unsigned long __user __force *) data);
 		break;
 	}
 #endif
@@ -652,7 +653,7 @@ int ptrace_request(struct task_struct *child, long request,
 	case PTRACE_SETREGSET:
 	{
 		struct iovec kiov;
-		struct iovec __user *uiov = (struct iovec __user *) data;
+		struct iovec __user *uiov = (struct iovec __user __force *) data;
 
 		if (!access_ok(VERIFY_WRITE, uiov, sizeof(*uiov)))
 			return -EFAULT;
@@ -742,7 +743,7 @@ int generic_ptrace_peekdata(struct task_struct *tsk, long addr, long data)
 	copied = access_process_vm(tsk, addr, &tmp, sizeof(tmp), 0);
 	if (copied != sizeof(tmp))
 		return -EIO;
-	return put_user(tmp, (unsigned long __user *)data);
+	return put_user(tmp, (unsigned long __user __force *)data);
 }
 
 int generic_ptrace_pokedata(struct task_struct *tsk, long addr, long data)
-- 
1.7.0.4

