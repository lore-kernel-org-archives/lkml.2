Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754014Ab2KUCZF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 21:25:05 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:49992 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752861Ab2KUCZE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 21:25:04 -0500
X-IronPort-AV: E=Sophos;i="4.83,290,1352044800"; 
   d="scan'208";a="6242714"
Message-ID: <50AC3B10.3090005@cn.fujitsu.com>
Date: Wed, 21 Nov 2012 10:23:12 +0800
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.8) Gecko/20121012 Thunderbird/10.0.8
MIME-Version: 1.0
To: "x86@kernel.org" <x86@kernel.org>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: [PATCH v5 1/2] x86/kexec: VMCLEAR vmcss on all cpus if necessary
References: <50AC3AA9.7080004@cn.fujitsu.com>
In-Reply-To: <50AC3AA9.7080004@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/21 10:24:45,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/21 10:24:46,
	Serialize complete at 2012/11/21 10:24:46
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds an atomic notifier list named crash_notifier_list.
When loading kvm-intel module, a notifier will be registered in
the list to enable vmcss loaded on all cpus to be VMCLEAR'd if
needed.

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
---
 arch/x86/include/asm/kexec.h |    2 ++
 arch/x86/kernel/crash.c      |   25 +++++++++++++++++++++++++
 2 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/kexec.h b/arch/x86/include/asm/kexec.h
index 317ff17..5e22b00 100644
--- a/arch/x86/include/asm/kexec.h
+++ b/arch/x86/include/asm/kexec.h
@@ -163,6 +163,8 @@ struct kimage_arch {
 };
 #endif
 
+extern struct atomic_notifier_head crash_notifier_list;
+
 #endif /* __ASSEMBLY__ */
 
 #endif /* _ASM_X86_KEXEC_H */
diff --git a/arch/x86/kernel/crash.c b/arch/x86/kernel/crash.c
index 13ad899..0f3d5b4 100644
--- a/arch/x86/kernel/crash.c
+++ b/arch/x86/kernel/crash.c
@@ -16,6 +16,8 @@
 #include <linux/delay.h>
 #include <linux/elf.h>
 #include <linux/elfcore.h>
+#include <linux/module.h>
+#include <linux/notifier.h>
 
 #include <asm/processor.h>
 #include <asm/hardirq.h>
@@ -30,6 +32,19 @@
 
 int in_crash_kexec;
 
+/*
+ * The list is used to VMCLEAR vmcss loaded on all
+ * cpus. And when loading kvm_intel module, the
+ * vmclear function will be registered in the list.
+ */
+ATOMIC_NOTIFIER_HEAD(crash_notifier_list);
+EXPORT_SYMBOL_GPL(crash_notifier_list);
+
+static inline void cpu_emergency_vmclear_loaded_vmcss(void)
+{
+	atomic_notifier_call_chain(&crash_notifier_list, 0, NULL);
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
+	cpu_emergency_vmclear_loaded_vmcss();
+
 	/* Disable VMX or SVM if needed.
 	 *
 	 * We need to disable virtualization on all CPUs.
@@ -88,6 +108,11 @@ void native_machine_crash_shutdown(struct pt_regs *regs)
 
 	kdump_nmi_shootdown_cpus();
 
+	/*
+	 * VMCLEAR vmcss loaded on this cpu if needed.
+	 */
+	cpu_emergency_vmclear_loaded_vmcss();
+
 	/* Booting kdump kernel with VMX or SVM enabled won't work,
 	 * because (among other limitations) we can't disable paging
 	 * with the virt flags.
-- 
1.7.1

