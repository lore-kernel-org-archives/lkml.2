Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752141Ab2LLGP7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 01:15:59 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:53365 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751488Ab2LLGP4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 01:15:56 -0500
X-IronPort-AV: E=Sophos;i="4.84,264,1355068800"; 
   d="scan'208";a="6381003"
From: Hu Tao <hutao@cn.fujitsu.com>
To: kvm list <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Avi Kivity <avi@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Gleb Natapov <gleb@redhat.com>,
        Blue Swirl <blauwirbel@gmail.com>, Eric Blake <eblake@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Sasha Levin <levinsasha928@gmail.com>,
        Luiz Capitulino <lcapitulino@redhat.com>
Cc: Wen Congyang <wency@cn.fujitsu.com>
Subject: [PATCH] kvm: notify host when the guest is panicked
Date: Wed, 12 Dec 2012 14:15:52 +0800
Message-Id: <1355292952-3395-1-git-send-email-hutao@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.0.1.240.ge8a1f5a
In-Reply-To: <cover.1355290850.git.hutao@cn.fujitsu.com>
References: <cover.1355290850.git.hutao@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/12/12 14:15:05,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/12/12 14:15:05,
	Serialize complete at 2012/12/12 14:15:05
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can know the guest is panicked when the guest runs on xen.
But we do not have such feature on kvm.

Another purpose of this feature is: management app(for example:
libvirt) can do auto dump when the guest is panicked. If management
app does not do auto dump, the guest's user can do dump by hand if
he sees the guest is panicked.

We have three solutions to implement this feature:
1. use vmcall
2. use I/O port
3. use virtio-serial.

We have decided to avoid touching hypervisor. The reason why I choose
choose the I/O port is:
1. it is easier to implememt
2. it does not depend any virtual device
3. it can work when starting the kernel

Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
Signed-off-by: Hu Tao <hutao@cn.fujitsu.com>
---
 arch/ia64/kvm/irq.h                 | 19 +++++++++++++
 arch/powerpc/include/asm/kvm_para.h | 18 +++++++++++++
 arch/s390/include/asm/kvm_para.h    | 19 +++++++++++++
 arch/x86/include/asm/kvm_para.h     | 23 ++++++++++++++++
 arch/x86/kernel/kvm.c               | 53 +++++++++++++++++++++++++++++++++++++
 include/linux/kvm_para.h            | 18 +++++++++++++
 include/uapi/linux/kvm_para.h       |  6 +++++
 kernel/panic.c                      |  4 +++
 8 files changed, 160 insertions(+)

diff --git a/arch/ia64/kvm/irq.h b/arch/ia64/kvm/irq.h
index c0785a7..b3870f8 100644
--- a/arch/ia64/kvm/irq.h
+++ b/arch/ia64/kvm/irq.h
@@ -30,4 +30,23 @@ static inline int irqchip_in_kernel(struct kvm *kvm)
 	return 1;
 }
 
+static inline int kvm_arch_pv_event_init(void)
+{
+	return 0;
+}
+
+static inline unsigned int kvm_arch_pv_features(void)
+{
+	return 0;
+}
+
+static inline void kvm_arch_pv_eject_event(unsigned int event)
+{
+}
+
+static inline bool kvm_arch_pv_event_enabled(void)
+{
+	return false;
+}
+
 #endif
diff --git a/arch/powerpc/include/asm/kvm_para.h b/arch/powerpc/include/asm/kvm_para.h
index 9365860..4b0e8dd 100644
--- a/arch/powerpc/include/asm/kvm_para.h
+++ b/arch/powerpc/include/asm/kvm_para.h
@@ -145,4 +145,22 @@ static inline bool kvm_check_and_clear_guest_paused(void)
 	return false;
 }
 
+static inline int kvm_arch_pv_event_init(void)
+{
+	return 0;
+}
+
+static inline unsigned int kvm_arch_pv_features(void)
+{
+	return 0;
+}
+
+static inline void kvm_arch_pv_eject_event(unsigned int event)
+{
+}
+
+static inline bool kvm_arch_pv_event_enabled(void)
+{
+	return false;
+}
 #endif /* __POWERPC_KVM_PARA_H__ */
diff --git a/arch/s390/include/asm/kvm_para.h b/arch/s390/include/asm/kvm_para.h
index e0f8423..81d87ec 100644
--- a/arch/s390/include/asm/kvm_para.h
+++ b/arch/s390/include/asm/kvm_para.h
@@ -154,4 +154,23 @@ static inline bool kvm_check_and_clear_guest_paused(void)
 	return false;
 }
 
+static inline int kvm_arch_pv_event_init(void)
+{
+	return 0;
+}
+
+static inline unsigned int kvm_arch_pv_features(void)
+{
+	return 0;
+}
+
+static inline void kvm_arch_pv_eject_event(unsigned int event)
+{
+}
+
+static inline bool kvm_arch_pv_event_enabled(void)
+{
+	return false;
+}
+
 #endif /* __S390_KVM_PARA_H */
diff --git a/arch/x86/include/asm/kvm_para.h b/arch/x86/include/asm/kvm_para.h
index eb3e9d8..5c38429 100644
--- a/arch/x86/include/asm/kvm_para.h
+++ b/arch/x86/include/asm/kvm_para.h
@@ -96,8 +96,11 @@ struct kvm_vcpu_pv_apf_data {
 #define KVM_PV_EOI_ENABLED KVM_PV_EOI_MASK
 #define KVM_PV_EOI_DISABLED 0x0
 
+#define KVM_PV_EVENT_PORT	(0x505UL)
+
 #ifdef __KERNEL__
 #include <asm/processor.h>
+#include <linux/ioport.h>
 
 extern void kvmclock_init(void);
 extern int kvm_register_clock(char *txt);
@@ -228,6 +231,26 @@ static inline void kvm_disable_steal_time(void)
 }
 #endif
 
+static inline int kvm_arch_pv_event_init(void)
+{
+	if (!request_region(KVM_PV_EVENT_PORT, 4, "KVM_PV_EVENT"))
+		return -1;
+
+	return 0;
+}
+
+static inline unsigned int kvm_arch_pv_features(void)
+{
+	return inl(KVM_PV_EVENT_PORT);
+}
+
+static inline void kvm_arch_pv_eject_event(unsigned int event)
+{
+	outl(event, KVM_PV_EVENT_PORT);
+}
+
+bool kvm_arch_pv_event_enabled(void);
+
 #endif /* __KERNEL__ */
 
 #endif /* _ASM_X86_KVM_PARA_H */
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 4180a87..c92b962 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -62,6 +62,20 @@ static int parse_no_stealacc(char *arg)
 
 early_param("no-steal-acc", parse_no_stealacc);
 
+static int pv_event = 1;
+static int parse_no_pv_event(char *arg)
+{
+	pv_event = 0;
+	return 0;
+}
+
+bool kvm_arch_pv_event_enabled(void)
+{
+	return !!pv_event;
+}
+
+early_param("no-pv-event", parse_no_pv_event);
+
 static DEFINE_PER_CPU(struct kvm_vcpu_pv_apf_data, apf_reason) __aligned(64);
 static DEFINE_PER_CPU(struct kvm_steal_time, steal_time) __aligned(64);
 static int has_steal_clock = 0;
@@ -372,6 +386,17 @@ static struct notifier_block kvm_pv_reboot_nb = {
 	.notifier_call = kvm_pv_reboot_notify,
 };
 
+static int
+kvm_pv_panic_notify(struct notifier_block *nb, unsigned long code, void *unused)
+{
+	kvm_pv_eject_event(KVM_PV_EVENT_PANICKED);
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block kvm_pv_panic_nb = {
+	.notifier_call = kvm_pv_panic_notify,
+};
+
 static u64 kvm_steal_clock(int cpu)
 {
 	u64 steal;
@@ -449,6 +474,34 @@ static void __init kvm_apf_trap_init(void)
 	set_intr_gate(14, &async_page_fault);
 }
 
+static void __init kvm_pv_panicked_event_init(void)
+{
+	if (!kvm_para_available())
+		return;
+
+	if (kvm_pv_has_feature(KVM_PV_FEATURE_PANICKED))
+		atomic_notifier_chain_register(&panic_notifier_list,
+			&kvm_pv_panic_nb);
+}
+
+static inline int kvm_pv_event_init(void)
+{
+	return kvm_arch_pv_event_init();
+}
+
+static int __init enable_pv_event(void)
+{
+	if (pv_event) {
+		if (kvm_pv_event_init())
+			return 0;
+
+		kvm_pv_panicked_event_init();
+	}
+
+	return 0;
+}
+arch_initcall(enable_pv_event);
+
 void __init kvm_guest_init(void)
 {
 	int i;
diff --git a/include/linux/kvm_para.h b/include/linux/kvm_para.h
index 00a97bb..6fb6198 100644
--- a/include/linux/kvm_para.h
+++ b/include/linux/kvm_para.h
@@ -10,4 +10,22 @@ static inline int kvm_para_has_feature(unsigned int feature)
 		return 1;
 	return 0;
 }
+
+static inline int kvm_pv_has_feature(unsigned int feature)
+{
+	if (kvm_arch_pv_features() & (1UL << feature))
+		return 1;
+	return 0;
+}
+
+static inline void kvm_pv_eject_event(unsigned int event)
+{
+	kvm_arch_pv_eject_event(event);
+}
+
+static inline bool kvm_pv_event_enabled(void)
+{
+	return kvm_arch_pv_event_enabled();
+}
+
 #endif /* __LINUX_KVM_PARA_H */
diff --git a/include/uapi/linux/kvm_para.h b/include/uapi/linux/kvm_para.h
index cea2c5c..c41ddce 100644
--- a/include/uapi/linux/kvm_para.h
+++ b/include/uapi/linux/kvm_para.h
@@ -20,6 +20,12 @@
 #define KVM_HC_FEATURES			3
 #define KVM_HC_PPC_MAP_MAGIC_PAGE	4
 
+/* The bit of supported pv event */
+#define KVM_PV_FEATURE_PANICKED	0
+
+/* The pv event value */
+#define KVM_PV_EVENT_PANICKED	1
+
 /*
  * hypercalls use architecture specific
  */
diff --git a/kernel/panic.c b/kernel/panic.c
index e1b2822..a764d2e 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -23,6 +23,7 @@
 #include <linux/init.h>
 #include <linux/nmi.h>
 #include <linux/dmi.h>
+#include <linux/kvm_para.h>
 
 #define PANIC_TIMER_STEP 100
 #define PANIC_BLINK_SPD 18
@@ -132,6 +133,9 @@ void panic(const char *fmt, ...)
 	if (!panic_blink)
 		panic_blink = no_blink;
 
+	if (kvm_pv_event_enabled())
+		panic_timeout = 0;
+
 	if (panic_timeout > 0) {
 		/*
 		 * Delay timeout seconds before rebooting the machine.
-- 
1.8.0.1.240.ge8a1f5a

