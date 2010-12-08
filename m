Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756148Ab0LHCMv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 21:12:51 -0500
Received: from kroah.org ([198.145.64.141]:46075 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756043Ab0LHArJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 19:47:09 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:44:28 2010
Message-Id: <20101208004428.701936567@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:43:50 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Gleb Natapov <gleb@redhat.com>, Avi Kivity <avi@redhat.com>
Subject: [044/127] KVM: VMX: fix vmx null pointer dereference on debug register access
In-Reply-To: <20101208004456.GA23578@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

There is a bug in KVM that can be used to crash a host on Intel
machines. If emulator is tricked into emulating mov to/from DR instruction
it causes NULL pointer dereference on VMX since kvm_x86_ops->(set|get)_dr
are not initialized. Recently this is not exploitable from guest
userspace, but malicious guest kernel can trigger it easily.

CVE-2010-0435

On upstream bug was fixed differently around 2.6.34.

Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/x86/kvm/x86.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2782,6 +2782,9 @@ int emulator_get_dr(struct x86_emulate_c
 {
 	struct kvm_vcpu *vcpu = ctxt->vcpu;
 
+	if (!kvm_x86_ops->get_dr)
+		return X86EMUL_UNHANDLEABLE;
+
 	switch (dr) {
 	case 0 ... 3:
 		*dest = kvm_x86_ops->get_dr(vcpu, dr);
@@ -2797,6 +2800,9 @@ int emulator_set_dr(struct x86_emulate_c
 	unsigned long mask = (ctxt->mode == X86EMUL_MODE_PROT64) ? ~0ULL : ~0U;
 	int exception;
 
+	if (!kvm_x86_ops->set_dr)
+		return X86EMUL_UNHANDLEABLE;
+
 	kvm_x86_ops->set_dr(ctxt->vcpu, dr, value & mask, &exception);
 	if (exception) {
 		/* FIXME: better handling */


