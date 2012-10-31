Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965361Ab2JaDeN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 23:34:13 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:36354 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752076Ab2JaDeK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 23:34:10 -0400
X-IronPort-AV: E=Sophos;i="4.80,684,1344182400"; 
   d="scan'208";a="6104052"
Message-ID: <50909BDF.1020503@cn.fujitsu.com>
Date: Wed, 31 Oct 2012 11:32:47 +0800
From: zhangyanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.8) Gecko/20121012 Thunderbird/10.0.8
MIME-Version: 1.0
To: x86@kernel.org, kexec@lists.infradead.org, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
CC: linux-kernel@vger.kernel.org, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: [PATCH v3 1/2] x86/kexec: VMCLEAR vmcss on all cpus if necessary
References: <50909B55.2070901@cn.fujitsu.com>
In-Reply-To: <50909B55.2070901@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/31 11:33:26,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/31 11:33:26,
	Serialize complete at 2012/10/31 11:33:26
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=GB2312
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch provides a way to VMCLEAR vmcss related to guests
on all cpus before executing the VMXOFF when doing kdump. This
is used to ensure the VMCSs in the vmcore updated and
non-corrupted.

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
---
 arch/x86/include/asm/kexec.h |    2 ++
 arch/x86/kernel/crash.c      |   25 +++++++++++++++++++++++++
 2 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/kexec.h b/arch/x86/include/asm/kexec.h
index 317ff17..fc05440 100644
--- a/arch/x86/include/asm/kexec.h
+++ b/arch/x86/include/asm/kexec.h
@@ -163,6 +163,8 @@ struct kimage_arch {
 };
 #endif
 
+extern void (*crash_clear_loaded_vmcss)(void);
+
 #endif /* __ASSEMBLY__ */
 
 #endif /* _ASM_X86_KEXEC_H */
diff --git a/arch/x86/kernel/crash.c b/arch/x86/kernel/crash.c
index 13ad899..9ed65c1 100644
--- a/arch/x86/kernel/crash.c
+++ b/arch/x86/kernel/crash.c
@@ -16,6 +16,7 @@
 #include <linux/delay.h>
 #include <linux/elf.h>
 #include <linux/elfcore.h>
+#include <linux/module.h>
 
 #include <asm/processor.h>
 #include <asm/hardirq.h>
@@ -30,6 +31,20 @@
 
 int in_crash_kexec;
 
+/*
+ * This is used to VMCLEAR vmcss loaded on all
+ * cpus. And when loading kvm_intel module, the
+ * function pointer will be made valid.
+ */
+void (*crash_clear_loaded_vmcss)(void) = NULL;
+EXPORT_SYMBOL_GPL(crash_clear_loaded_vmcss);
+
+static void cpu_emergency_clear_loaded_vmcss(void)
+{
+	if (crash_clear_loaded_vmcss)
+		crash_clear_loaded_vmcss();
+}
+
 #if defined(CONFIG_SMP) && defined(CONFIG_X86_LOCAL_APIC)
 
 static void kdump_nmi_callback(int cpu, struct pt_regs *regs)
@@ -46,6 +61,11 @@ static void kdump_nmi_callback(int cpu, struct pt_regs *regs)
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
@@ -88,6 +108,11 @@ void native_machine_crash_shutdown(struct pt_regs *regs)
 
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

