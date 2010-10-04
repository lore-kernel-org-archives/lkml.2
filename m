Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932109Ab0JDP7i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 11:59:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21706 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756418Ab0JDP5E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 11:57:04 -0400
From: Gleb Natapov <gleb@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, avi@redhat.com,
        mingo@elte.hu, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        hpa@zytor.com, riel@redhat.com, cl@linux-foundation.org,
        mtosatti@redhat.com
Subject: [PATCH v6 12/12] Send async PF when guest is not in userspace too.
Date: Mon,  4 Oct 2010 17:56:34 +0200
Message-Id: <1286207794-16120-13-git-send-email-gleb@redhat.com>
In-Reply-To: <1286207794-16120-1-git-send-email-gleb@redhat.com>
References: <1286207794-16120-1-git-send-email-gleb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If guest indicates that it can handle async pf in kernel mode too send
it, but only if interrupts are enabled.

Signed-off-by: Gleb Natapov <gleb@redhat.com>
---
 arch/x86/kvm/x86.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index cad4412..30b1cd1 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6244,7 +6244,8 @@ void kvm_arch_async_page_not_present(struct kvm_vcpu *vcpu,
 		kvm_add_async_pf_gfn(vcpu, work->arch.gfn);
 
 		if (!(vcpu->arch.apf.msr_val & KVM_ASYNC_PF_ENABLED) ||
-		    kvm_x86_ops->get_cpl(vcpu) == 0)
+		    (vcpu->arch.apf.send_user_only &&
+		     kvm_x86_ops->get_cpl(vcpu) == 0))
 			vcpu->arch.mp_state = KVM_MP_STATE_HALTED;
 		else if (!apf_put_user(vcpu, KVM_PV_REASON_PAGE_NOT_PRESENT)) {
 			vcpu->arch.fault.error_code = 0;
-- 
1.7.1

