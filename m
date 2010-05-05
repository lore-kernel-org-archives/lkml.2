Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760119Ab0EEOHJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 10:07:09 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:52674
	"EHLO VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755927Ab0EEOHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 10:07:06 -0400
X-SpamScore: -4
X-BigFish: VPS-4(zz936eMab9bhzz1202hzz6ff19hz32i2a8h87h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L1Y9S1-02-IK8-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 2/5] KVM: SVM: Dump vmcb contents on failed vmrun
Date: Wed, 5 May 2010 16:04:42 +0200
Message-ID: <1273068285-3105-3-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1273068285-3105-1-git-send-email-joerg.roedel@amd.com>
References: <1273068285-3105-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a function to dump the vmcb into the kernel
log and calls it after a failed vmrun to ease debugging.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/svm.c |   95 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 95 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 889f660..0201b06 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -2637,6 +2637,99 @@ static int (*svm_exit_handlers[])(struct vcpu_svm *svm) = {
 	[SVM_EXIT_NPF]				= pf_interception,
 };
 
+void dump_vmcb(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+	struct vmcb_control_area *control = &svm->vmcb->control;
+	struct vmcb_save_area *save = &svm->vmcb->save;
+
+	pr_err("VMCB Control Area:\n");
+	pr_err("cr_read:            %04x\n", control->intercept_cr_read);
+	pr_err("cr_write:           %04x\n", control->intercept_cr_write);
+	pr_err("dr_read:            %04x\n", control->intercept_dr_read);
+	pr_err("dr_write:           %04x\n", control->intercept_dr_write);
+	pr_err("exceptions:         %08x\n", control->intercept_exceptions);
+	pr_err("intercepts:         %016llx\n", control->intercept);
+	pr_err("pause filter count: %d\n", control->pause_filter_count);
+	pr_err("iopm_base_pa:       %016llx\n", control->iopm_base_pa);
+	pr_err("msrpm_base_pa:      %016llx\n", control->msrpm_base_pa);
+	pr_err("tsc_offset:         %016llx\n", control->tsc_offset);
+	pr_err("asid:               %d\n", control->asid);
+	pr_err("tlb_ctl:            %d\n", control->tlb_ctl);
+	pr_err("int_ctl:            %08x\n", control->int_ctl);
+	pr_err("int_vector:         %08x\n", control->int_vector);
+	pr_err("int_state:          %08x\n", control->int_state);
+	pr_err("exit_code:          %08x\n", control->exit_code);
+	pr_err("exit_info1:         %016llx\n", control->exit_info_1);
+	pr_err("exit_info2:         %016llx\n", control->exit_info_2);
+	pr_err("exit_int_info:      %08x\n", control->exit_int_info);
+	pr_err("exit_int_info_err:  %08x\n", control->exit_int_info_err);
+	pr_err("nested_ctl:         %lld\n", control->nested_ctl);
+	pr_err("nested_cr3:         %016llx\n", control->nested_cr3);
+	pr_err("event_inj:          %08x\n", control->event_inj);
+	pr_err("event_inj_err:      %08x\n", control->event_inj_err);
+	pr_err("lbr_ctl:            %lld\n", control->lbr_ctl);
+	pr_err("next_rip:           %016llx\n", control->next_rip);
+	pr_err("VMCB State Save Area:\n");
+	pr_err("es:   s: %04x a: %04x l: %08x b: %016llx\n",
+		save->es.selector, save->es.attrib,
+		save->es.limit, save->es.base);
+	pr_err("cs:   s: %04x a: %04x l: %08x b: %016llx\n",
+		save->cs.selector, save->cs.attrib,
+		save->cs.limit, save->cs.base);
+	pr_err("ss:   s: %04x a: %04x l: %08x b: %016llx\n",
+		save->ss.selector, save->ss.attrib,
+		save->ss.limit, save->ss.base);
+	pr_err("ds:   s: %04x a: %04x l: %08x b: %016llx\n",
+		save->ds.selector, save->ds.attrib,
+		save->ds.limit, save->ds.base);
+	pr_err("fs:   s: %04x a: %04x l: %08x b: %016llx\n",
+		save->fs.selector, save->fs.attrib,
+		save->fs.limit, save->fs.base);
+	pr_err("gs:   s: %04x a: %04x l: %08x b: %016llx\n",
+		save->gs.selector, save->gs.attrib,
+		save->gs.limit, save->gs.base);
+	pr_err("gdtr: s: %04x a: %04x l: %08x b: %016llx\n",
+		save->gdtr.selector, save->gdtr.attrib,
+		save->gdtr.limit, save->gdtr.base);
+	pr_err("ldtr: s: %04x a: %04x l: %08x b: %016llx\n",
+		save->ldtr.selector, save->ldtr.attrib,
+		save->ldtr.limit, save->ldtr.base);
+	pr_err("idtr: s: %04x a: %04x l: %08x b: %016llx\n",
+		save->idtr.selector, save->idtr.attrib,
+		save->idtr.limit, save->idtr.base);
+	pr_err("tr:   s: %04x a: %04x l: %08x b: %016llx\n",
+		save->tr.selector, save->tr.attrib,
+		save->tr.limit, save->tr.base);
+	pr_err("cpl:            %d                efer:         %016llx\n",
+		save->cpl, save->efer);
+	pr_err("cr0:            %016llx cr2:          %016llx\n",
+		save->cr0, save->cr2);
+	pr_err("cr3:            %016llx cr4:          %016llx\n",
+		save->cr3, save->cr4);
+	pr_err("dr6:            %016llx dr7:          %016llx\n",
+		save->dr6, save->dr7);
+	pr_err("rip:            %016llx rflags:       %016llx\n",
+		save->rip, save->rflags);
+	pr_err("rsp:            %016llx rax:          %016llx\n",
+		save->rsp, save->rax);
+	pr_err("star:           %016llx lstar:        %016llx\n",
+		save->star, save->lstar);
+	pr_err("cstar:          %016llx sfmask:       %016llx\n",
+		save->cstar, save->sfmask);
+	pr_err("kernel_gs_base: %016llx sysenter_cs:  %016llx\n",
+		save->kernel_gs_base, save->sysenter_cs);
+	pr_err("sysenter_esp:   %016llx sysenter_eip: %016llx\n",
+		save->sysenter_esp, save->sysenter_eip);
+	pr_err("gpat:           %016llx dbgctl:       %016llx\n",
+		save->g_pat, save->dbgctl);
+	pr_err("br_from:        %016llx br_to:        %016llx\n",
+		save->br_from, save->br_to);
+	pr_err("excp_from:      %016llx excp_to:      %016llx\n",
+		save->last_excp_from, save->last_excp_to);
+
+}
+
 static int handle_exit(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -2681,6 +2774,8 @@ static int handle_exit(struct kvm_vcpu *vcpu)
 		kvm_run->exit_reason = KVM_EXIT_FAIL_ENTRY;
 		kvm_run->fail_entry.hardware_entry_failure_reason
 			= svm->vmcb->control.exit_code;
+		pr_err("KVM: FAILED VMRUN WITH VMCB:\n");
+		dump_vmcb(vcpu);
 		return 0;
 	}
 
-- 
1.7.1


