Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758491Ab2CIVq3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 16:46:29 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:65479 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753536Ab2CIVq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 16:46:27 -0500
Message-Id: <20120309214623.974272927@openvz.org>
User-Agent: quilt/0.48-1
Date: Sat, 10 Mar 2012 01:41:04 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Matt Helsley <matthltc@us.ibm.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>,
        Oleg Nesterov <oleg@redhat.com>, Andrew Vagin <avagin@openvz.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>, Pedro Alves <palves@redhat.com>
Subject: [patch 2/2] c/r: prctl: Add ability to get clear_tid_address
References: <20120309214102.240208363@openvz.org>
Content-Disposition: inline; filename=c-r-prctl-add-PR_GET_TID_ADDRESS
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zero is written at clear_tid_address, when
the process exits. This functionality is used
by pthread_join().

We already have sys_set_tid_address() to change this
address for current task but there is no way to obtain
it from a user space.

Without ability to find this address and dump it we can't
restore pthread'ed apps which do call pthread_join() once
they have been restored.

This patch introduces PR_GET_TID_ADDRESS prctl option
which allow current process to obtain own clear_tid_address.

This feature is available iif CONFIG_CHECKPOINT_RESTORE is set.

Signed-off-by: Andrew Vagin <avagin@openvz.org>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
CC: Pedro Alves <palves@redhat.com>
CC: Oleg Nesterov <oleg@redhat.com>
CC: Pavel Emelyanov <xemul@parallels.com>
CC: Tejun Heo <tj@kernel.org>
---
 include/linux/prctl.h |    2 ++
 kernel/sys.c          |   13 +++++++++++++
 2 files changed, 15 insertions(+)

Index: linux-2.6.git/include/linux/prctl.h
===================================================================
--- linux-2.6.git.orig/include/linux/prctl.h
+++ linux-2.6.git/include/linux/prctl.h
@@ -120,4 +120,6 @@
 # define PR_SET_MM_AUXV			12
 # define PR_SET_MM_EXE_FILE		13
 
+#define PR_GET_TID_ADDRESS		36
+
 #endif /* _LINUX_PRCTL_H */
Index: linux-2.6.git/kernel/sys.c
===================================================================
--- linux-2.6.git.orig/kernel/sys.c
+++ linux-2.6.git/kernel/sys.c
@@ -1897,12 +1897,22 @@ out:
 	up_read(&mm->mmap_sem);
 	return error;
 }
+
+static int prctl_get_tid_address(struct task_struct *me, int __user **tid_addr)
+{
+	return put_user(me->clear_child_tid, tid_addr);
+}
+
 #else /* CONFIG_CHECKPOINT_RESTORE */
 static int prctl_set_mm(int opt, unsigned long addr,
 			unsigned long arg4, unsigned long arg5)
 {
 	return -EINVAL;
 }
+static int prctl_get_tid_address(struct task_struct *me, int __user **tid_addr)
+{
+	return -EINVAL;
+}
 #endif
 
 SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
@@ -2057,6 +2067,9 @@ SYSCALL_DEFINE5(prctl, int, option, unsi
 		case PR_SET_MM:
 			error = prctl_set_mm(arg2, arg3, arg4, arg5);
 			break;
+		case PR_GET_TID_ADDRESS:
+			error = prctl_get_tid_address(me, (int __user **)arg2);
+			break;
 		default:
 			error = -EINVAL;
 			break;

