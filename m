Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756637Ab0GMCJ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 22:09:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11981 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756666Ab0GMCJP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 22:09:15 -0400
From: Zachary Amsden <zamsden@redhat.com>
To: KVM <kvm@vger.kernel.org>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Glauber Costa <glommer@redhat.com>
Cc: Linux-kernel <linux-kernel@vger.kernel.org>,
        Zachary Amsden <zamsden@redhat.com>
Subject: [PATCH 10/18] Keep SMP VMs more in sync on unstable TSC
Date: Mon, 12 Jul 2010 16:08:04 -1000
Message-Id: <1278986892-11733-11-git-send-email-zamsden@redhat.com>
In-Reply-To: <1278986892-11733-1-git-send-email-zamsden@redhat.com>
References: <1278986892-11733-1-git-send-email-zamsden@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SMP VMs on machines with unstable TSC have their TSC offset adjusted by the
local offset delta from last measurement.  This does not take into account how
long it has been since the measurement, leading to drift.  Minimize the drift
by accounting for any time difference the kernel has observed.

Signed-off-by: Zachary Amsden <zamsden@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |    1 +
 arch/x86/kvm/x86.c              |    8 +++++++-
 2 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 324e892..d9e0aa0 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -339,6 +339,7 @@ struct kvm_vcpu_arch {
 	unsigned int time_offset;
 	struct page *time_page;
 	u64 last_host_tsc;
+	u64 last_host_ns;
 
 	bool nmi_pending;
 	bool nmi_injected;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ad58c77..dcaece4 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1887,8 +1887,13 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 				native_read_tsc() - vcpu->arch.last_host_tsc;
 		if (tsc_delta < 0)
 			mark_tsc_unstable("KVM discovered backwards TSC");
-		if (check_tsc_unstable())
+		if (check_tsc_unstable()) {
+			/* Subtract elapsed cycle time */
+			u64 ns = !vcpu->arch.last_host_ns ? 0 :
+				  get_kernel_ns() - vcpu->arch.last_host_ns;
+			tsc_delta -= nsec_to_cycles(ns);
 			kvm_x86_ops->adjust_tsc_offset(vcpu, -tsc_delta);
+		}
 		kvm_migrate_timers(vcpu);
 		kvm_request_guest_time_update(vcpu);
 		vcpu->cpu = cpu;
@@ -1900,6 +1905,7 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 	kvm_x86_ops->vcpu_put(vcpu);
 	kvm_put_guest_fpu(vcpu);
 	vcpu->arch.last_host_tsc = native_read_tsc();
+	vcpu->arch.last_host_ns = get_kernel_ns();
 }
 
 static int is_efer_nx(void)
-- 
1.7.1

