Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754076Ab1KXMA5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 07:00:57 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:50546 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752970Ab1KXMA4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 07:00:56 -0500
Date: Thu, 24 Nov 2011 16:00:51 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [RFC] prctl: Add PR_ codes to restore vDSO and tune up mm_struct
 entires
Message-ID: <20111124120051.GV1820@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While doing restore of a task we need to setup vDSO at predefined address
unmapping current one and tune up mm_struct members which are set at Elf
loading stage.

So I would like to know what people think about the patch below? Maybe I
miss something and we already have some convenient way to deal with it?

Complains are highly appreciated!

---
From: Cyrill Gorcunov <gorcunov@gmail.com>
Date: Tue, 22 Nov 2011 21:08:43 +0400
Subject: [PATCH] prctl: Add PR_ codes to restore vDSO and tune up mm_struct entires

To be able to use vDSO facility at process restore time we need it
being mapped at predefined address (at the address it had at checkpoint
time). For this sake PR_SETUP_VDSO_AT is introduced.

Same time a few members in mm_struct are set up by a binfmt
handler code, such as mm_struct -> start_code, end_code,
start_data, end_data, start_stack, start_brk, brk. So at
restore time we need them to have exactly the same values
as they had at checkpoint time. This is handled by PR_SET_MM
prctl opcode.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 arch/x86/vdso/vma.c   |   39 +++++++++++++++++++++++++++
 include/linux/prctl.h |   18 ++++++++++++
 kernel/sys.c          |   71 +++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 128 insertions(+), 0 deletions(-)

diff --git a/arch/x86/vdso/vma.c b/arch/x86/vdso/vma.c
index 153407c..e0f03da 100644
--- a/arch/x86/vdso/vma.c
+++ b/arch/x86/vdso/vma.c
@@ -137,6 +137,45 @@ up_fail:
 	return ret;
 }
 
+int arch_setup_additional_pages_at(void *addr)
+{
+	struct mm_struct *mm = current->mm;
+	int ret;
+
+	if (!vdso_enabled)
+		return 0;
+
+	if ((unsigned long)addr > TASK_SIZE - vdso_size)
+		return -ENOMEM;
+
+	if ((unsigned long)addr & ~PAGE_MASK)
+		return -EINVAL;
+
+	down_write(&mm->mmap_sem);
+
+	/*
+	 * Unmap previous entry.
+	 */
+	if (mm->context.vdso) {
+		ret = do_munmap(mm, (unsigned long)mm->context.vdso, vdso_size);
+		if (ret)
+			goto err;
+	}
+
+	mm->context.vdso = addr;
+	ret = install_special_mapping(mm, (unsigned long)addr, vdso_size,
+				      VM_READ | VM_EXEC |
+				      VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC |
+				      VM_ALWAYSDUMP,
+				      vdso_pages);
+	if (ret)
+		mm->context.vdso = NULL;
+
+err:
+	up_write(&mm->mmap_sem);
+	return ret;
+}
+
 static __init int vdso_setup(char *s)
 {
 	vdso_enabled = simple_strtoul(s, NULL, 0);
diff --git a/include/linux/prctl.h b/include/linux/prctl.h
index a3baeb2..dddacb0 100644
--- a/include/linux/prctl.h
+++ b/include/linux/prctl.h
@@ -102,4 +102,22 @@
 
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
+/*
+ * Unmap current vDSO and setup new one
+ * at predefined address.
+ */
+#define PR_SETUP_VDSO_AT	36
+
 #endif /* _LINUX_PRCTL_H */
diff --git a/kernel/sys.c b/kernel/sys.c
index 481611f..96ee568 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -123,6 +123,12 @@ EXPORT_SYMBOL(cad_pid);
 
 void (*pm_power_off_prepare)(void);
 
+#ifdef ARCH_HAS_SETUP_ADDITIONAL_PAGES
+extern int arch_setup_additional_pages_at(void *addr);
+#else
+static int arch_setup_additional_pages_at(void *addr) { return 0; }
+#endif
+
 /*
  * Returns true if current's euid is same as p's uid or euid,
  * or has CAP_SYS_NICE to p's user_ns.
@@ -1841,6 +1847,71 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 			else
 				error = PR_MCE_KILL_DEFAULT;
 			break;
+		case PR_SETUP_VDSO_AT:
+			if (arg3 | arg4 | arg5)
+				return -EINVAL;
+
+			if (!capable(CAP_SYS_ADMIN))
+				return -EPERM;
+
+#ifdef ARCH_HAS_SETUP_ADDITIONAL_PAGES
+			error = arch_setup_additional_pages_at((void *)arg2);
+#else
+			error = -ENOSYS;
+#endif
+			break;
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
-- 
1.7.7.3

