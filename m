Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932994Ab2GENLa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 09:11:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47530 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932339Ab2GENL0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 09:11:26 -0400
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Prarit Bhargava <prarit@redhat.com>, Avi Kivity <avi@redhat.com>,
        Gleb Natapov <gleb@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 1/2] kvm, Add x86_hyper_kvm to complete detect_hypervisor_platform check [v2]
Date: Thu,  5 Jul 2012 09:11:16 -0400
Message-Id: <1341493877-16622-2-git-send-email-prarit@redhat.com>
In-Reply-To: <1341493877-16622-1-git-send-email-prarit@redhat.com>
References: <1341493877-16622-1-git-send-email-prarit@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While debugging I noticed that unlike all the other hypervisor code in the
kernel, kvm does not have an entry for x86_hyper which is used in
detect_hypervisor_platform() which results in a nice printk in the
syslog.  This is only really a stub function but it
does make kvm more consistent with the other hypervisors.

[v2]: add detect and _GPL export

Signed-off-by: Prarit Bhargava <prarit@redhat.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Gleb Natapov <gleb@redhat.com>
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/include/asm/hypervisor.h |    1 +
 arch/x86/kernel/cpu/hypervisor.c  |    1 +
 arch/x86/kernel/kvm.c             |   14 ++++++++++++++
 3 files changed, 16 insertions(+)

diff --git a/arch/x86/include/asm/hypervisor.h b/arch/x86/include/asm/hypervisor.h
index 7a15153..b518c75 100644
--- a/arch/x86/include/asm/hypervisor.h
+++ b/arch/x86/include/asm/hypervisor.h
@@ -49,6 +49,7 @@ extern const struct hypervisor_x86 *x86_hyper;
 extern const struct hypervisor_x86 x86_hyper_vmware;
 extern const struct hypervisor_x86 x86_hyper_ms_hyperv;
 extern const struct hypervisor_x86 x86_hyper_xen_hvm;
+extern const struct hypervisor_x86 x86_hyper_kvm;
 
 static inline bool hypervisor_x2apic_available(void)
 {
diff --git a/arch/x86/kernel/cpu/hypervisor.c b/arch/x86/kernel/cpu/hypervisor.c
index 755f64f..6d6dd7a 100644
--- a/arch/x86/kernel/cpu/hypervisor.c
+++ b/arch/x86/kernel/cpu/hypervisor.c
@@ -37,6 +37,7 @@ static const __initconst struct hypervisor_x86 * const hypervisors[] =
 #endif
 	&x86_hyper_vmware,
 	&x86_hyper_ms_hyperv,
+	&x86_hyper_kvm,
 };
 
 const struct hypervisor_x86 *x86_hyper;
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index e554e5a..865cd13 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -39,6 +39,7 @@
 #include <asm/desc.h>
 #include <asm/tlbflush.h>
 #include <asm/idle.h>
+#include <asm/hypervisor.h>
 
 static int kvmapf = 1;
 
@@ -432,6 +433,19 @@ void __init kvm_guest_init(void)
 #endif
 }
 
+static bool __init kvm_detect(void)
+{
+	if (!kvm_para_available())
+		return false;
+	return true;
+}
+
+const struct hypervisor_x86 x86_hyper_kvm __refconst = {
+	.name			= "KVM",
+	.detect			= kvm_detect,
+};
+EXPORT_SYMBOL_GPL(x86_hyper_kvm);
+
 static __init int activate_jump_labels(void)
 {
 	if (has_steal_clock) {
-- 
1.7.9.3

