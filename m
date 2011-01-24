Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754232Ab1AXSIg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 13:08:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41413 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754197Ab1AXSIS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 13:08:18 -0500
From: Glauber Costa <glommer@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, aliguori@us.ibm.com,
        Rik van Riel <riel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Peter Zijlstra <peterz@infradead.org>, Avi Kivity <avi@redhat.com>
Subject: [PATCH 13/16] KVM-HV: KVM Steal time calculation
Date: Mon, 24 Jan 2011 13:06:34 -0500
Message-Id: <1295892397-11354-14-git-send-email-glommer@redhat.com>
In-Reply-To: <1295892397-11354-1-git-send-email-glommer@redhat.com>
References: <1295892397-11354-1-git-send-email-glommer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To implement steal time, we need the hypervisor to pass the guest information
about how much time was spent running other processes outside the VM.
We consider time to be potentially stolen everytime we schedule out the vcpu,
until we schedule it in again. If this is, or if this will not, be accounted
as steal time for the guest, is a guest's decision.

Signed-off-by: Glauber Costa <glommer@redhat.com>
CC: Rik van Riel <riel@redhat.com>
CC: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Avi Kivity <avi@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |    3 +++
 arch/x86/kvm/x86.c              |   13 +++++++++++++
 2 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index ffd7f8d..038679b 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -377,6 +377,9 @@ struct kvm_vcpu_arch {
 	unsigned int hw_tsc_khz;
 	unsigned int time_offset;
 	struct page *time_page;
+	gpa_t stime;
+	u64 time_out;
+	u64 this_time_out;
 	u64 last_host_tsc;
 	u64 last_guest_tsc;
 	u64 last_kernel_ns;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f129ea1..33af936 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2123,6 +2123,9 @@ static bool need_emulate_wbinvd(struct kvm_vcpu *vcpu)
 
 void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 {
+	struct kvm_steal_time *st;
+	st = (struct kvm_steal_time *)vcpu->arch.stime;
+
 	/* Address WBINVD may be executed by guest */
 	if (need_emulate_wbinvd(vcpu)) {
 		if (kvm_x86_ops->has_wbinvd_exit())
@@ -2148,6 +2151,14 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 			kvm_migrate_timers(vcpu);
 		vcpu->cpu = cpu;
 	}
+	if (vcpu->arch.this_time_out) {
+		vcpu->arch.time_out +=
+				(get_kernel_ns() - vcpu->arch.this_time_out);
+		kvm_write_guest(vcpu->kvm, (gpa_t)&st->steal,
+				&vcpu->arch.time_out, sizeof(st->steal));
+		/* is it possible to have 2 loads in sequence? */
+		vcpu->arch.this_time_out = 0;
+	}
 }
 
 void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
@@ -5333,6 +5344,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 
 	kvm_lapic_sync_from_vapic(vcpu);
 
+	vcpu->arch.this_time_out = get_kernel_ns();
+
 	r = kvm_x86_ops->handle_exit(vcpu);
 out:
 	return r;
-- 
1.7.2.3

