Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932918Ab1KDQzU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 12:55:20 -0400
Received: from oz.csail.mit.edu ([128.30.30.239]:35646 "EHLO mail.mgebm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932673Ab1KDQzQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 12:55:16 -0400
From: Eric B Munson <emunson@mgebm.net>
To: avi@redhat.com
Cc: Eric B Munson <emunson@mgebm.net>, mingo@redhat.com, hpa@zytor.com,
        arnd@arndb.de, ryanh@linux.vnet.ibm.com, aliguori@us.ibm.com,
        mtosatti@redhat.com, jeremy.fitzhardinge@citrix.com,
        kvm@vger.kernel.org, linux-arch@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/6 V3] Add functions to check if the host has stopped the vm
Date: Fri,  4 Nov 2011 12:55:08 -0400
Message-Id: <1320425712-5312-3-git-send-email-emunson@mgebm.net>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1320425712-5312-1-git-send-email-emunson@mgebm.net>
References: <1320425712-5312-1-git-send-email-emunson@mgebm.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a host stops or suspends a VM it will set a flag to show this.  The
watchdog will use these functions to determine if a softlockup is real, or the
result of a suspended VM.

Signed-off-by: Eric B Munson <emunson@mgebm.net>
Cc: mingo@redhat.com
Cc: hpa@zytor.com
Cc: arnd@arndb.de
Cc: ryanh@linux.vnet.ibm.com
Cc: aliguori@us.ibm.com
Cc: mtosatti@redhat.com
Cc: jeremy.fitzhardinge@citrix.com
Cc: kvm@vger.kernel.org
Cc: linux-arch@vger.kernel.org
Cc: x86@kernel.org
Cc: linux-kernel@vger.kernel.org
---
Changes from V2:
 Move function definition to kvm_para.h

 arch/x86/include/asm/kvm_para.h |    1 +
 arch/x86/kernel/kvmclock.c      |   21 +++++++++++++++++++++
 2 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/kvm_para.h b/arch/x86/include/asm/kvm_para.h
index 734c376..e9d63a6 100644
--- a/arch/x86/include/asm/kvm_para.h
+++ b/arch/x86/include/asm/kvm_para.h
@@ -95,6 +95,7 @@ struct kvm_vcpu_pv_apf_data {
 extern void kvmclock_init(void);
 extern int kvm_register_clock(char *txt);
 
+bool kvm_check_and_clear_guest_paused(int cpu);
 
 /* This instruction is vmcall.  On non-VT architectures, it will generate a
  * trap that we will then rewrite to the appropriate instruction.
diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
index c1a0188..b6e10b1 100644
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -22,6 +22,7 @@
 #include <asm/msr.h>
 #include <asm/apic.h>
 #include <linux/percpu.h>
+#include <linux/hardirq.h>
 
 #include <asm/x86_init.h>
 #include <asm/reboot.h>
@@ -113,6 +114,26 @@ static void kvm_get_preset_lpj(void)
 	preset_lpj = lpj;
 }
 
+bool kvm_check_and_clear_guest_paused(int cpu)
+{
+	bool ret = false;
+	struct pvclock_vcpu_time_info *src;
+
+	/*
+	 * per_cpu() is safe here because this function is only called from
+	 * timer functions where preemption is already disabled.
+	 */
+	WARN_ON(!in_atomic());
+	src = &per_cpu(hv_clock, cpu);
+	if ((src->flags & PVCLOCK_GUEST_STOPPED) != 0) {
+		src->flags = src->flags & (~PVCLOCK_GUEST_STOPPED);
+		ret = true;
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(kvm_check_and_clear_guest_paused);
+
 static struct clocksource kvm_clock = {
 	.name = "kvm-clock",
 	.read = kvm_clock_get_cycles,
-- 
1.7.5.4

