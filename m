Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752417Ab1K0Cmd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Nov 2011 21:42:33 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:40997 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821Ab1K0Cmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Nov 2011 21:42:31 -0500
From: Liu Ping Fan <kernelfans@gmail.com>
To: kvm@vger.kernel.org, qemu-devel@nongnu.org
Cc: linux-kernel@vger.kernel.org, avi@redhat.com, aliguori@us.ibm.com,
        jan.kiszka@web.de, ryanh@us.ibm.com
Subject: [PATCH 2/2] kvm: exit to userspace with reason KVM_EXIT_VCPU_DEAD
Date: Sun, 27 Nov 2011 10:42:15 +0800
Message-Id: <1322361735-21428-1-git-send-email-kernelfans@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1322188529-11609-1-git-send-email-kernelfans@gmail.com>
References: <1322188529-11609-1-git-send-email-kernelfans@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Liu Ping Fan <pingfank@linux.vnet.ibm.com>

The vcpu can be safely released when
--1.guest tells us that the vcpu is not needed any longer.
--2.vcpu hits the last instruction _halt_

If both of the conditions are satisfied, kvm exits to userspace
with the reason vcpu dead. So the user thread can exit safely.

Signed-off-by: Liu Ping Fan <pingfank@linux.vnet.ibm.com>
---
 arch/x86/kvm/x86.c       |   16 ++++++++++++++++
 include/linux/kvm.h      |   11 +++++++++++
 include/linux/kvm_host.h |    1 +
 3 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ea2315a..7948eaf 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5825,11 +5825,27 @@ static int __vcpu_run(struct kvm_vcpu *vcpu)
 		    !vcpu->arch.apf.halted)
 			r = vcpu_enter_guest(vcpu);
 		else {
+retry:
+			if  (vcpu->arch.mp_state == KVM_MP_STATE_HALTED) {
+				/*1st check whether guest notify CPU_DEAD*/
+				if (vcpu->state == KVM_VCPU_STATE_DYING) {
+					vcpu->state = KVM_VCPU_STATE_DEAD;
+					vcpu->run->exit_reason = KVM_EXIT_VCPU_DEAD;
+					break;
+				}
+			}
 			srcu_read_unlock(&kvm->srcu, vcpu->srcu_idx);
 			kvm_vcpu_block(vcpu);
 			vcpu->srcu_idx = srcu_read_lock(&kvm->srcu);
 			if (kvm_check_request(KVM_REQ_UNHALT, vcpu))
 			{
+				switch (vcpu->state) {
+				case KVM_VCPU_STATE_DYING:
+					r = 1;
+					goto retry;
+				default:
+					break;
+				}
 				switch(vcpu->arch.mp_state) {
 				case KVM_MP_STATE_HALTED:
 					vcpu->arch.mp_state =
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index c3892fc..d5ff3f7 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -162,6 +162,7 @@ struct kvm_pit_config {
 #define KVM_EXIT_INTERNAL_ERROR   17
 #define KVM_EXIT_OSI              18
 #define KVM_EXIT_PAPR_HCALL	  19
+#define KVM_EXIT_VCPU_DEAD              20
 
 /* For KVM_EXIT_INTERNAL_ERROR */
 #define KVM_INTERNAL_ERROR_EMULATION 1
@@ -334,6 +335,12 @@ struct kvm_signal_mask {
 	__u8  sigset[0];
 };
 
+/*for KVM_VCPU_SET_STATE */
+struct kvm_vcpu_state {
+	int vcpu_id;
+	int state;
+};
+
 /* for KVM_TPR_ACCESS_REPORTING */
 struct kvm_tpr_access_ctl {
 	__u32 enabled;
@@ -354,6 +361,9 @@ struct kvm_vapic_addr {
 #define KVM_MP_STATE_HALTED            3
 #define KVM_MP_STATE_SIPI_RECEIVED     4
 
+#define KVM_VCPU_STATE_DYING 1
+#define KVM_VCPU_STATE_DEAD 2
+
 struct kvm_mp_state {
 	__u32 mp_state;
 };
@@ -762,6 +772,7 @@ struct kvm_clock_data {
 #define KVM_CREATE_SPAPR_TCE	  _IOW(KVMIO,  0xa8, struct kvm_create_spapr_tce)
 /* Available with KVM_CAP_RMA */
 #define KVM_ALLOCATE_RMA	  _IOR(KVMIO,  0xa9, struct kvm_allocate_rma)
+#define KVM_SETSTATE_VCPU     _IOW(KVMIO,   0xaa, struct kvm_vcpu_state)
 
 #define KVM_DEV_ASSIGN_ENABLE_IOMMU	(1 << 0)
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index fe35078..6fdf927 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -114,6 +114,7 @@ enum {
 struct kvm_vcpu {
 	struct kvm *kvm;
 	struct kref refcount;
+	int state;
 #ifdef CONFIG_PREEMPT_NOTIFIERS
 	struct preempt_notifier preempt_notifier;
 #endif
-- 
1.7.4.4

