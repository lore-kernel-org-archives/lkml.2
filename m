Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934491Ab2JYDmu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 23:42:50 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:14413 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758218Ab2JYDmm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 23:42:42 -0400
X-IronPort-AV: E=Sophos;i="4.80,645,1344182400"; 
   d="scan'208";a="6064359"
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
Cc: Wen Congyang <wency@cn.fujitsu.com>, Hu Tao <hutao@cn.fujitsu.com>
Subject: [PATCH v11] kvm: notify host when the guest is panicked
Date: Thu, 25 Oct 2012 11:42:32 +0800
Message-Id: <0a2274eccf1b1dd420f16359f7e1de74fa2f9fbe.1351131144.git.hutao@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.10.2
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/25 11:41:59,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/25 11:42:01,
	Serialize complete at 2012/10/25 11:42:01
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

changes from v10:
 
  - add a kernel parameter to disable pv-event
  - detailed documentation to describe pv event interface
  - make kvm_pv_event_init() local

 Documentation/virtual/kvm/pv_event.txt |   38 +++++++++++++++++++++++++
 arch/ia64/include/asm/kvm_para.h       |   14 ++++++++++
 arch/powerpc/include/asm/kvm_para.h    |   14 ++++++++++
 arch/s390/include/asm/kvm_para.h       |   14 ++++++++++
 arch/x86/include/asm/kvm_para.h        |   21 ++++++++++++++
 arch/x86/kernel/kvm.c                  |   48 ++++++++++++++++++++++++++++++++
 include/linux/kvm_para.h               |   18 ++++++++++++
 7 files changed, 167 insertions(+)
 create mode 100644 Documentation/virtual/kvm/pv_event.txt

diff --git a/Documentation/virtual/kvm/pv_event.txt b/Documentation/virtual/kvm/pv_event.txt
new file mode 100644
index 0000000..247379f
--- /dev/null
+++ b/Documentation/virtual/kvm/pv_event.txt
@@ -0,0 +1,38 @@
+The KVM Paravirtual Event Interface
+=================================
+
+The KVM Paravirtual Event Interface defines a simple interface,
+by which guest OS can inform hypervisor that something happened.
+
+To inform hypervisor of events, guest writes a 32-bit integer to
+the Interface. Each bit of the integer represents an event, if a
+bit is set, the corresponding event happens.
+
+To query events supported by hypervisor, guest reads from the
+Interface. If a bit is set, the corresponding event is supported.
+
+The Interface supports up to 32 events. Currently there is 1 event
+defined, as follow:
+
+KVM_PV_FEATURE_PANICKED		0
+
+
+Querying whether the event can be ejected
+======================
+kvm_pv_has_feature()
+Arguments:
+	feature: The bit value of this paravirtual event to query
+
+Return Value:
+	 0: The guest kernel can't eject this paravirtual event.
+	 1: The guest kernel can eject this paravirtual event.
+
+
+Ejecting paravirtual event
+======================
+kvm_pv_eject_event()
+Arguments:
+	event: The event to be ejected.
+
+Return Value:
+	None
diff --git a/arch/ia64/include/asm/kvm_para.h b/arch/ia64/include/asm/kvm_para.h
index 2019cb9..b5ec658 100644
--- a/arch/ia64/include/asm/kvm_para.h
+++ b/arch/ia64/include/asm/kvm_para.h
@@ -31,6 +31,20 @@ static inline bool kvm_check_and_clear_guest_paused(void)
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
 #endif
 
 #endif
diff --git a/arch/powerpc/include/asm/kvm_para.h b/arch/powerpc/include/asm/kvm_para.h
index c18916b..01b98c7 100644
--- a/arch/powerpc/include/asm/kvm_para.h
+++ b/arch/powerpc/include/asm/kvm_para.h
@@ -211,6 +211,20 @@ static inline bool kvm_check_and_clear_guest_paused(void)
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
 #endif /* __KERNEL__ */
 
 #endif /* __POWERPC_KVM_PARA_H__ */
diff --git a/arch/s390/include/asm/kvm_para.h b/arch/s390/include/asm/kvm_para.h
index da44867..00ce058 100644
--- a/arch/s390/include/asm/kvm_para.h
+++ b/arch/s390/include/asm/kvm_para.h
@@ -154,6 +154,20 @@ static inline bool kvm_check_and_clear_guest_paused(void)
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
 #endif
 
 #endif /* __S390_KVM_PARA_H */
diff --git a/arch/x86/include/asm/kvm_para.h b/arch/x86/include/asm/kvm_para.h
index eb3e9d8..4315af6 100644
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
@@ -228,6 +231,24 @@ static inline void kvm_disable_steal_time(void)
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
 #endif /* __KERNEL__ */
 
 #endif /* _ASM_X86_KVM_PARA_H */
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 4180a87..c44e46f 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -62,6 +62,15 @@ static int parse_no_stealacc(char *arg)
 
 early_param("no-steal-acc", parse_no_stealacc);
 
+static int pv_event = 1;
+static int parse_no_pv_event(char *arg)
+{
+	pv_event = 0;
+	return 0;
+}
+
+early_param("no-pv-event", parse_no_pv_event);
+
 static DEFINE_PER_CPU(struct kvm_vcpu_pv_apf_data, apf_reason) __aligned(64);
 static DEFINE_PER_CPU(struct kvm_steal_time, steal_time) __aligned(64);
 static int has_steal_clock = 0;
@@ -372,6 +381,17 @@ static struct notifier_block kvm_pv_reboot_nb = {
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
@@ -449,6 +469,34 @@ static void __init kvm_apf_trap_init(void)
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
index ff476dd..495e411 100644
--- a/include/linux/kvm_para.h
+++ b/include/linux/kvm_para.h
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
@@ -33,5 +39,17 @@ static inline int kvm_para_has_feature(unsigned int feature)
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
 #endif /* __KERNEL__ */
 #endif /* __LINUX_KVM_PARA_H */
-- 
1.7.10.2

