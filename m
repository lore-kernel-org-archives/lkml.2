Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753254Ab2JQFrM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 01:47:12 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:59966 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752596Ab2JQFrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 01:47:10 -0400
Message-ID: <507E464C.3010108@linux.vnet.ibm.com>
Date: Wed, 17 Oct 2012 13:46:52 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH 1/2] KVM: VMX: report internal error for the unhandleable
 event
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12101705-9574-0000-0000-000004E57E10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

VM exits during Event Delivery is really unexpected if it is not caused
by Exceptions/EPT-VIOLATION/TASK_SWITCH, we'd better to report an internal
and freeze the guest, the VMM has the chance to check the guest

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/vmx.c  |   19 +++++++++++++++----
 include/linux/kvm.h |    8 ++++++--
 2 files changed, 21 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index ad6b1dd..b8a0841 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -5979,13 +5979,24 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu)
 		return 0;
 	}

+	/*
+	 * Note:
+	 * Do not try to fix EXIT_REASON_EPT_MISCONFIG if it caused by
+	 * delivery event since it indicates guest is accessing MMIO.
+	 * The vm-exit can be triggered again after return to guest that
+	 * will cause infinite loop.
+	 */
 	if ((vectoring_info & VECTORING_INFO_VALID_MASK) &&
 			(exit_reason != EXIT_REASON_EXCEPTION_NMI &&
 			exit_reason != EXIT_REASON_EPT_VIOLATION &&
-			exit_reason != EXIT_REASON_TASK_SWITCH))
-		printk(KERN_WARNING "%s: unexpected, valid vectoring info "
-		       "(0x%x) and exit reason is 0x%x\n",
-		       __func__, vectoring_info, exit_reason);
+			exit_reason != EXIT_REASON_TASK_SWITCH)) {
+		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
+		vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_DELIVERY_EV;
+		vcpu->run->internal.ndata = 2;
+		vcpu->run->internal.data[0] = vectoring_info;
+		vcpu->run->internal.data[1] = exit_reason;
+		return 0;
+	}

 	if (unlikely(!cpu_has_virtual_nmis() && vmx->soft_vnmi_blocked &&
 	    !(is_guest_mode(vcpu) && nested_cpu_has_virtual_nmis(
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index 65ad5c6..494a84c 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -170,8 +170,12 @@ struct kvm_pit_config {
 #define KVM_EXIT_WATCHDOG         21

 /* For KVM_EXIT_INTERNAL_ERROR */
-#define KVM_INTERNAL_ERROR_EMULATION 1
-#define KVM_INTERNAL_ERROR_SIMUL_EX 2
+/* Emulate instruction failed. */
+#define KVM_INTERNAL_ERROR_EMULATION	1
+/* Encounter unexpected simultaneous exceptions. */
+#define KVM_INTERNAL_ERROR_SIMUL_EX	2
+/* Encounter unexpected vm-exit due to delivery event. */
+#define KVM_INTERNAL_ERROR_DELIVERY_EV	3

 /* for KVM_RUN, returned by mmap(vcpu_fd, offset=0) */
 struct kvm_run {
-- 
1.7.7.6

