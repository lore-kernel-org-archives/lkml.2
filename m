Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933185Ab2K0D17 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 22:27:59 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:8709 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S933078Ab2K0D15 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 22:27:57 -0500
X-IronPort-AV: E=Sophos;i="4.83,325,1352044800"; 
   d="scan'208";a="6280661"
Message-ID: <50B432CA.70804@cn.fujitsu.com>
Date: Tue, 27 Nov 2012 11:26:02 +0800
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.8) Gecko/20121012 Thunderbird/10.0.8
MIME-Version: 1.0
To: "x86@kernel.org" <x86@kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>,
        Gleb Natapov <gleb@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
CC: "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v9 1/2] x86/kexec: VMCLEAR VMCSs loaded on all cpus if necessary
References: <50B43299.9030409@cn.fujitsu.com>
In-Reply-To: <50B43299.9030409@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/27 11:27:31,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/27 11:27:31,
	Serialize complete at 2012/11/27 11:27:31
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch provides a way to VMCLEAR VMCSs related to guests
on all cpus before executing the VMXOFF when doing kdump. This
is used to ensure the VMCSs in the vmcore updated and
non-corrupted.

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
---
 arch/x86/include/asm/kexec.h |    2 ++
 arch/x86/kernel/crash.c      |   25 +++++++++++++++++++++++++
 2 files changed, 27 insertions(+), 0 deletions(-)

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
index 13ad899..4a2a12f 100644
--- a/arch/x86/kernel/crash.c
+++ b/arch/x86/kernel/crash.c
@@ -16,6 +16,7 @@
 #include <linux/delay.h>
 #include <linux/elf.h>
 #include <linux/elfcore.h>
+#include <linux/module.h>
 
 #include <asm/processor.h>
 #include <asm/hardirq.h>
@@ -29,6 +30,20 @@
 #include <asm/virtext.h>
 
 int in_crash_kexec;
+ 
+/*
+ * This is used to VMCLEAR all VMCSs loaded on the
+ * processor. And when loading kvm_intel module, the
+ * callback function pointer will be assigned.
+ */
+void (*crash_vmclear_loaded_vmcss)(void) = NULL;
+EXPORT_SYMBOL_GPL(crash_vmclear_loaded_vmcss);
+
+static inline void cpu_emergency_vmclear_loaded_vmcss(void)
+{
+	if (crash_vmclear_loaded_vmcss)
+		crash_vmclear_loaded_vmcss();
+}
 
 #if defined(CONFIG_SMP) && defined(CONFIG_X86_LOCAL_APIC)
 
@@ -46,6 +61,11 @@ static void kdump_nmi_callback(int cpu, struct pt_regs *regs)
 #endif
 	crash_save_cpu(regs, cpu);
 
+	/*
+	 * VMCLEAR VMCSs loaded on all cpus if needed.
+	 */
+	cpu_emergency_vmclear_loaded_vmcss();
+
 	/* Disable VMX or SVM if needed.
 	 *
 	 * We need to disable virtualization on all CPUs.
@@ -88,6 +108,11 @@ void native_machine_crash_shutdown(struct pt_regs *regs)
 
 	kdump_nmi_shootdown_cpus();
 
+	/*
+	 * VMCLEAR VMCSs loaded on this cpu if needed.
+	 */
+	cpu_emergency_vmclear_loaded_vmcss();
+
 	/* Booting kdump kernel with VMX or SVM enabled won't work,
 	 * because (among other limitations) we can't disable paging
 	 * with the virt flags.
-- 
1.7.1

