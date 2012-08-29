Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754814Ab2H2Xcc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 19:32:32 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:35263 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754679Ab2H2Xbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 19:31:43 -0400
From: Mathias Krause <minipli@googlemail.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mathias Krause <minipli@googlemail.com>
Subject: [PATCH 7/8] KVM: VMX: constify lookup tables
Date: Thu, 30 Aug 2012 01:30:19 +0200
Message-Id: <1346283020-22385-8-git-send-email-minipli@googlemail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1346283020-22385-1-git-send-email-minipli@googlemail.com>
References: <1346283020-22385-1-git-send-email-minipli@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We use vmcs_field_to_offset_table[], kvm_vmx_segment_fields[] and
kvm_vmx_exit_handlers[] as lookup tables only -- make them r/o.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
---
 arch/x86/kvm/vmx.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 248c2b4..d62b413 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -450,7 +450,7 @@ static inline struct vcpu_vmx *to_vmx(struct kvm_vcpu *vcpu)
 #define FIELD64(number, name)	[number] = VMCS12_OFFSET(name), \
 				[number##_HIGH] = VMCS12_OFFSET(name)+4
 
-static unsigned short vmcs_field_to_offset_table[] = {
+static const unsigned short vmcs_field_to_offset_table[] = {
 	FIELD(VIRTUAL_PROCESSOR_ID, virtual_processor_id),
 	FIELD(GUEST_ES_SELECTOR, guest_es_selector),
 	FIELD(GUEST_CS_SELECTOR, guest_cs_selector),
@@ -666,7 +666,7 @@ static struct vmx_capability {
 		.ar_bytes = GUEST_##seg##_AR_BYTES,	   	\
 	}
 
-static struct kvm_vmx_segment_field {
+static const struct kvm_vmx_segment_field {
 	unsigned selector;
 	unsigned base;
 	unsigned limit;
@@ -2695,7 +2695,7 @@ static __exit void hardware_unsetup(void)
 
 static void fix_pmode_dataseg(struct kvm_vcpu *vcpu, int seg, struct kvm_segment *save)
 {
-	struct kvm_vmx_segment_field *sf = &kvm_vmx_segment_fields[seg];
+	const struct kvm_vmx_segment_field *sf = &kvm_vmx_segment_fields[seg];
 	struct kvm_segment tmp = *save;
 
 	if (!(vmcs_readl(sf->base) == tmp.base && tmp.s)) {
@@ -2764,7 +2764,7 @@ static gva_t rmode_tss_base(struct kvm *kvm)
 
 static void fix_rmode_seg(int seg, struct kvm_segment *save)
 {
-	struct kvm_vmx_segment_field *sf = &kvm_vmx_segment_fields[seg];
+	const struct kvm_vmx_segment_field *sf = &kvm_vmx_segment_fields[seg];
 
 	vmcs_write16(sf->selector, save->base >> 4);
 	vmcs_write32(sf->base, save->base & 0xffff0);
@@ -3202,7 +3202,7 @@ static void vmx_set_segment(struct kvm_vcpu *vcpu,
 			    struct kvm_segment *var, int seg)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
-	struct kvm_vmx_segment_field *sf = &kvm_vmx_segment_fields[seg];
+	const struct kvm_vmx_segment_field *sf = &kvm_vmx_segment_fields[seg];
 	u32 ar;
 
 	vmx_segment_cache_clear(vmx);
@@ -3572,7 +3572,7 @@ out:
 
 static void seg_setup(int seg)
 {
-	struct kvm_vmx_segment_field *sf = &kvm_vmx_segment_fields[seg];
+	const struct kvm_vmx_segment_field *sf = &kvm_vmx_segment_fields[seg];
 	unsigned int ar;
 
 	vmcs_write16(sf->selector, 0);
@@ -5655,7 +5655,7 @@ static int handle_vmptrst(struct kvm_vcpu *vcpu)
  * may resume.  Otherwise they set the kvm_run parameter to indicate what needs
  * to be done to userspace and return 0.
  */
-static int (*kvm_vmx_exit_handlers[])(struct kvm_vcpu *vcpu) = {
+static int (*const kvm_vmx_exit_handlers[])(struct kvm_vcpu *vcpu) = {
 	[EXIT_REASON_EXCEPTION_NMI]           = handle_exception,
 	[EXIT_REASON_EXTERNAL_INTERRUPT]      = handle_external_interrupt,
 	[EXIT_REASON_TRIPLE_FAULT]            = handle_triple_fault,
-- 
1.7.10.4

