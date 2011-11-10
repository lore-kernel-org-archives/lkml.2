Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934472Ab1KJM6a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 07:58:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51349 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934398Ab1KJM6R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 07:58:17 -0500
From: Gleb Natapov <gleb@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, avi@redhat.com, mtosatti@redhat.com,
        mingo@elte.hu, a.p.zijlstra@chello.nl, acme@ghostprotocols.net
Subject: [PATCHv3 03/10] KVM: Add generic RDPMC support
Date: Thu, 10 Nov 2011 14:57:23 +0200
Message-Id: <1320929850-10480-4-git-send-email-gleb@redhat.com>
In-Reply-To: <1320929850-10480-1-git-send-email-gleb@redhat.com>
References: <1320929850-10480-1-git-send-email-gleb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Avi Kivity <avi@redhat.com>

Add a helper function that emulates the RDPMC instruction operation.

Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Gleb Natapov <gleb@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |    1 +
 arch/x86/kvm/x86.c              |   15 +++++++++++++++
 2 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 5807a49..422824c 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -756,6 +756,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 data);
 
 unsigned long kvm_get_rflags(struct kvm_vcpu *vcpu);
 void kvm_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags);
+bool kvm_rdpmc(struct kvm_vcpu *vcpu);
 
 void kvm_queue_exception(struct kvm_vcpu *vcpu, unsigned nr);
 void kvm_queue_exception_e(struct kvm_vcpu *vcpu, unsigned nr, u32 error_code);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 52a8666..b88426c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -815,6 +815,21 @@ int kvm_get_dr(struct kvm_vcpu *vcpu, int dr, unsigned long *val)
 }
 EXPORT_SYMBOL_GPL(kvm_get_dr);
 
+bool kvm_rdpmc(struct kvm_vcpu *vcpu)
+{
+	u32 ecx = kvm_register_read(vcpu, VCPU_REGS_RCX);
+	u64 data;
+	int err;
+
+	err = kvm_pmu_read_pmc(vcpu, ecx, &data);
+	if (err)
+		return err;
+	kvm_register_write(vcpu, VCPU_REGS_RAX, (u32)data);
+	kvm_register_write(vcpu, VCPU_REGS_RDX, data >> 32);
+	return err;
+}
+EXPORT_SYMBOL_GPL(kvm_rdpmc);
+
 /*
  * List of msr numbers which we expose to userspace through KVM_GET_MSRS
  * and KVM_SET_MSRS, and KVM_GET_MSR_INDEX_LIST.
-- 
1.7.7.1

