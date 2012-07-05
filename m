Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933066Ab2GENhF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 09:37:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27643 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750910Ab2GENhD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 09:37:03 -0400
Message-ID: <4FF5987C.6080905@redhat.com>
Date: Thu, 05 Jul 2012 09:37:00 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: linux-kernel@vger.kernel.org, Gleb Natapov <gleb@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Marcelo Tostatti <mtosatti@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH 1/2] kvm, Add x86_hyper_kvm to complete detect_hypervisor_platform
 check [v2]
References: <1341493877-16622-1-git-send-email-prarit@redhat.com> <1341493877-16622-2-git-send-email-prarit@redhat.com> <4FF59606.4060504@redhat.com>
In-Reply-To: <4FF59606.4060504@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 07/05/2012 09:26 AM, Avi Kivity wrote:
> Please copy at least kvm@vger.kernel.org, and preferably Marcelo as well
> (the other kvm co-maintainer).
> 
> 

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
@@ -37,6 +37,7 @@ static const __initconst struct hypervisor_x86 * const
hypervisors[] =
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

