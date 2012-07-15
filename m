Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752838Ab2GOM5q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2012 08:57:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3553 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752727Ab2GOM4q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2012 08:56:46 -0400
Date: Sun, 15 Jul 2012 15:56:52 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Jacob Pan <jacob.jun.pan@intel.com>,
        Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Joerg Roedel <joerg.roedel@amd.com>, Yinghai Lu <yinghai@kernel.org>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org, avi@redhat.com,
        gleb@redhat.com
Subject: [PATCH 2/3] kvm: switch to apic_set_eoi_write, apic_write
Message-ID: <d473ac40afcc317b9b7c6834d8cf3c4502209920.1342356186.git.mst@redhat.com>
References: <cover.1342356186.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1342356186.git.mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use apic_set_eoi_write, apic_write to avoid meedling in core apic
driver data structures directly.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 arch/x86/kernel/kvm.c | 13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 75ab94c..60108ce 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -298,7 +298,7 @@ static void kvm_guest_apic_eoi_write(u32 reg, u32 val)
 	 */
 	if (__test_and_clear_bit(KVM_PV_EOI_BIT, &__get_cpu_var(kvm_apic_eoi)))
 		return;
-	apic->write(APIC_EOI, APIC_EOI_ACK);
+	apic_write(APIC_EOI, APIC_EOI_ACK);
 }
 
 void __cpuinit kvm_guest_cpu_init(void)
@@ -465,15 +465,8 @@ void __init kvm_guest_init(void)
 		pv_time_ops.steal_clock = kvm_steal_clock;
 	}
 
-	if (kvm_para_has_feature(KVM_FEATURE_PV_EOI)) {
-		struct apic **drv;
-
-		for (drv = __apicdrivers; drv < __apicdrivers_end; drv++) {
-			/* Should happen once for each apic */
-			WARN_ON((*drv)->eoi_write == kvm_guest_apic_eoi_write);
-			(*drv)->eoi_write = kvm_guest_apic_eoi_write;
-		}
-	}
+	if (kvm_para_has_feature(KVM_FEATURE_PV_EOI))
+		apic_set_eoi_write(kvm_guest_apic_eoi_write);
 
 #ifdef CONFIG_SMP
 	smp_ops.smp_prepare_boot_cpu = kvm_smp_prepare_boot_cpu;
-- 
MST

