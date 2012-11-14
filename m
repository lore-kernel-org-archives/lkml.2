Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932822Ab2KNJc7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 04:32:59 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:62747 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754466Ab2KNJc5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 04:32:57 -0500
X-IronPort-AV: E=Sophos;i="4.83,249,1352044800"; 
   d="scan'208";a="6195908"
Message-ID: <50A364E3.2090608@cn.fujitsu.com>
Date: Wed, 14 Nov 2012 17:31:15 +0800
From: zhangyanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.8) Gecko/20121012 Thunderbird/10.0.8
MIME-Version: 1.0
To: "x86@kernel.org" <x86@kernel.org>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: [PATCH v4 1/2] x86/kexec: VMCLEAR vmcss on all cpus if necessary
References: <50A3645F.60302@cn.fujitsu.com>
In-Reply-To: <50A3645F.60302@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/14 17:32:50,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/14 17:32:51,
	Serialize complete at 2012/11/14 17:32:51
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

crash_clear_loaded_vmcss is added to VMCLEAR vmcss loaded on all
cpus. And when loading kvm_intel module, the function pointer will be
made valid.
The percpu variable vmclear_skipped is added to flag the case that
if loaded_vmcss_on_cpu list is being modified while the machine crashes
and doing kdump, the vmclear here can be skipped.

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
---
 arch/x86/include/asm/kexec.h |    3 +++
 arch/x86/kernel/crash.c      |   32 ++++++++++++++++++++++++++++++++
 2 files changed, 35 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/kexec.h b/arch/x86/include/asm/kexec.h
index 317ff17..d892211 100644
--- a/arch/x86/include/asm/kexec.h
+++ b/arch/x86/include/asm/kexec.h
@@ -163,6 +163,9 @@ struct kimage_arch {
 };
 #endif
 
+extern void (*crash_clear_loaded_vmcss)(void);
+DECLARE_PER_CPU(int, vmclear_skipped);
+
 #endif /* __ASSEMBLY__ */
 
 #endif /* _ASM_X86_KEXEC_H */
diff --git a/arch/x86/kernel/crash.c b/arch/x86/kernel/crash.c
index 13ad899..b9f264e 100644
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
+ * This is used to VMCLEAR vmcss loaded on all
+ * cpus. And when loading kvm_intel module, the
+ * function pointer will be made valid.
+ */
+void (*crash_clear_loaded_vmcss)(void) = NULL;
+EXPORT_SYMBOL_GPL(crash_clear_loaded_vmcss);
+
+DEFINE_PER_CPU(int, vmclear_skipped) = 1;
+EXPORT_SYMBOL_GPL(vmclear_skipped);
+
+static void cpu_emergency_clear_loaded_vmcss(void)
+{
+	int cpu = raw_smp_processor_id();
+	int skipped;
+
+	skipped = per_cpu(vmclear_skipped, cpu);
+	if (!skipped && crash_clear_loaded_vmcss)
+		crash_clear_loaded_vmcss();
+}
+
 #if defined(CONFIG_SMP) && defined(CONFIG_X86_LOCAL_APIC)
 
 static void kdump_nmi_callback(int cpu, struct pt_regs *regs)
@@ -46,6 +68,11 @@ static void kdump_nmi_callback(int cpu, struct pt_regs *regs)
 #endif
 	crash_save_cpu(regs, cpu);
 
+	/*
+	 * VMCLEAR vmcss loaded on all cpus if needed.
+	 */
+	cpu_emergency_clear_loaded_vmcss();
+
 	/* Disable VMX or SVM if needed.
 	 *
 	 * We need to disable virtualization on all CPUs.
@@ -88,6 +115,11 @@ void native_machine_crash_shutdown(struct pt_regs *regs)
 
 	kdump_nmi_shootdown_cpus();
 
+	/*
+	 * VMCLEAR vmcss loaded on this cpu if needed.
+	 */
+	cpu_emergency_clear_loaded_vmcss();
+
 	/* Booting kdump kernel with VMX or SVM enabled won't work,
 	 * because (among other limitations) we can't disable paging
 	 * with the virt flags.
-- 
1.7.1

