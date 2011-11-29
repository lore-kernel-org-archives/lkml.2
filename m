Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756229Ab1K2TRx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 14:17:53 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:46582 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755286Ab1K2TR3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 14:17:29 -0500
Message-Id: <20111129191638.912537377@openvz.org>
User-Agent: quilt/0.48-1
Date: Tue, 29 Nov 2011 23:12:55 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Andrew Vagin <avagin@openvz.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>
Subject: [rfc 3/3] prctl: Add PR_SET_MM codes to tune up mm_struct entires
References: <20111129191252.769160532@openvz.org>
Content-Disposition: inline; filename=prctl-tune-up-mm_struct-members
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A few members of mm_struct such as start_code, end_code,
start_data, end_data, start_stack, start_brk, brk provided
by the kernel via /proc/$pid/stat and we use it at checkpoint
time.

At restore time we need a mechanism to restore those values
back and for this sake PR_SET_MM prctl code is introduced.

Note at moment this inteface is allowed for CAP_SYS_ADMIN
only.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---

Actually I'm not sure if CAP_SYS_ADMIN restriction is
really needed here. Opinions?

 include/linux/prctl.h |   12 +++++++++++
 kernel/sys.c          |   52 ++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 64 insertions(+)

Index: linux-2.6.git/include/linux/prctl.h
===================================================================
--- linux-2.6.git.orig/include/linux/prctl.h
+++ linux-2.6.git/include/linux/prctl.h
@@ -102,4 +102,16 @@
 
 #define PR_MCE_KILL_GET 34
 
+/*
+ * Tune up process memory map specifics.
+ */
+#define PR_SET_MM		35
+# define PR_SET_MM_START_CODE		1
+# define PR_SET_MM_END_CODE		2
+# define PR_SET_MM_START_DATA		3
+# define PR_SET_MM_END_DATA		4
+# define PR_SET_MM_START_STACK		5
+# define PR_SET_MM_START_BRK		6
+# define PR_SET_MM_BRK			7
+
 #endif /* _LINUX_PRCTL_H */
Index: linux-2.6.git/kernel/sys.c
===================================================================
--- linux-2.6.git.orig/kernel/sys.c
+++ linux-2.6.git/kernel/sys.c
@@ -1841,6 +1841,58 @@ SYSCALL_DEFINE5(prctl, int, option, unsi
 			else
 				error = PR_MCE_KILL_DEFAULT;
 			break;
+		case PR_SET_MM: {
+			struct mm_struct *mm;
+			struct vm_area_struct *vma;
+
+			if (arg4 | arg5)
+				return -EINVAL;
+
+			if (!capable(CAP_SYS_ADMIN))
+				return -EPERM;
+
+			error = -ENOENT;
+			mm = get_task_mm(current);
+			if (!mm)
+				return error;
+
+			down_read(&mm->mmap_sem);
+			vma = find_vma(mm, arg3);
+			if (!vma)
+				goto out;
+
+			error = 0;
+			switch (arg2) {
+			case PR_SET_MM_START_CODE:
+				current->mm->start_code = arg3;
+				break;
+			case PR_SET_MM_END_CODE:
+				current->mm->end_code = arg3;
+				break;
+			case PR_SET_MM_START_DATA:
+				current->mm->start_data = arg3;
+				break;
+			case PR_SET_MM_END_DATA:
+				current->mm->end_data = arg3;
+				break;
+			case PR_SET_MM_START_STACK:
+				current->mm->start_stack = arg3;
+				break;
+			case PR_SET_MM_START_BRK:
+				current->mm->start_brk = arg3;
+				break;
+			case PR_SET_MM_BRK:
+				current->mm->brk = arg3;
+				break;
+			default:
+				error = -EINVAL;
+				break;
+			}
+out:
+			up_read(&mm->mmap_sem);
+			mmput(mm);
+			break;
+		}
 		default:
 			error = -EINVAL;
 			break;

