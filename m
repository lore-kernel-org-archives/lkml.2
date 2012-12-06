Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932787Ab2LFPk5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 10:40:57 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:44757 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932229Ab2LFPk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 10:40:56 -0500
Message-ID: <50C0BC7F.8030302@gmail.com>
Date: Thu, 06 Dec 2012 23:40:47 +0800
From: Zhang Yanfei <zhangyanfei.yes@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120607 Thunderbird/10.0.5
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
CC: kexec@lists.infradead.org, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v11 1/2] x86/kexec: VMCLEAR VMCSs loaded on all cpus if necessary
References: <50C0BB90.1080804@gmail.com>
In-Reply-To: <50C0BB90.1080804@gmail.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>

This patch provides a way to VMCLEAR VMCSs related to guests
on all cpus before executing the VMXOFF when doing kdump. This
is used to ensure the VMCSs in the vmcore updated and
non-corrupted.

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Acked-by: Eric W. Biederman <ebiederm@xmission.com>
---
 arch/x86/include/asm/kexec.h |    2 ++
 arch/x86/kernel/crash.c      |   32 ++++++++++++++++++++++++++++++++
 2 files changed, 34 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/kexec.h b/arch/x86/include/asm/kexec.h
index 317ff17..28feeba 100644
--- a/arch/x86/include/asm/kexec.h
+++ b/arch/x86/include/asm/kexec.h
@@ -163,6 +163,8 @@ struct kimage_arch {
 };
 #endif
 
+extern void (*crash_vmclear_loaded_vmcss)(void);
+
 #endif /* __ASSEMBLY__ */
 
 #endif /* _ASM_X86_KEXEC_H */
diff --git a/arch/x86/kernel/crash.c b/arch/x86/kernel/crash.c
index 13ad899..b914b7f 100644
--- a/arch/x86/kernel/crash.c
+++ b/arch/x86/kernel/crash.c
@@ -16,6 +16,7 @@
 #include <linux/delay.h>
 #include <linux/elf.h>
 #include <linux/elfcore.h>
+#include <linux/module.h>
 
 #include <asm/processor.h>
 #include <asm/hardirq.h>
@@ -30,6 +31,27 @@
 
 int in_crash_kexec;
 
+/*
+ * This is used to VMCLEAR all VMCSs loaded on the
+ * processor. And when loading kvm_intel module, the
+ * callback function pointer will be assigned.
+ *
+ * protected by rcu.
+ */
+void (*crash_vmclear_loaded_vmcss)(void) = NULL;
+EXPORT_SYMBOL_GPL(crash_vmclear_loaded_vmcss);
+
+static inline void cpu_crash_vmclear_loaded_vmcss(void)
+{
+	void (*do_vmclear_operation)(void) = NULL;
+
+	rcu_read_lock();
+	do_vmclear_operation = rcu_dereference(crash_vmclear_loaded_vmcss);
+	if (do_vmclear_operation)
+		do_vmclear_operation();
+	rcu_read_unlock();
+}
+
 #if defined(CONFIG_SMP) && defined(CONFIG_X86_LOCAL_APIC)
 
 static void kdump_nmi_callback(int cpu, struct pt_regs *regs)
@@ -46,6 +68,11 @@ static void kdump_nmi_callback(int cpu, struct pt_regs *regs)
 #endif
 	crash_save_cpu(regs, cpu);
 
+	/*
+	 * VMCLEAR VMCSs loaded on all cpus if needed.
+	 */
+	cpu_crash_vmclear_loaded_vmcss();
+
 	/* Disable VMX or SVM if needed.
 	 *
 	 * We need to disable virtualization on all CPUs.
@@ -88,6 +115,11 @@ void native_machine_crash_shutdown(struct pt_regs *regs)
 
 	kdump_nmi_shootdown_cpus();
 
+	/*
+	 * VMCLEAR VMCSs loaded on this cpu if needed.
+	 */
+	cpu_crash_vmclear_loaded_vmcss();
+
 	/* Booting kdump kernel with VMX or SVM enabled won't work,
 	 * because (among other limitations) we can't disable paging
 	 * with the virt flags.
-- 
1.7.1

