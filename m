Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755333Ab0JNJS3 (ORCPT <rfc822;list-kernel77@spinics.net>);
	Thu, 14 Oct 2010 05:18:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43651 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755263Ab0JNJSN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 05:18:13 -0400
From: y@redhat.com
To: kvm@vger.kernel.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, avi@redhat.com,
        mingo@elte.hu, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        hpa@zytor.com, riel@redhat.com, cl@linux-foundation.org,
        mtosatti@redhat.com
Subject: [PATCH v7 12/12] Send async PF when guest is not in userspace too.
Date: Thu, 14 Oct 2010 11:17:10 +0200
Message-Id: <1287047830-2120-13-git-send-email-y>
In-Reply-To: <1287047830-2120-1-git-send-email-y>
References: <1287047830-2120-1-git-send-email-y>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gleb Natapov <gleb@redhat.com>

If guest indicates that it can handle async pf in kernel mode too send
it, but only if interrupts are enabled.

Acked-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Gleb Natapov <gleb@redhat.com>
---
 arch/x86/kvm/x86.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 1e442df..51cff2f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6248,7 +6248,8 @@ void kvm_arch_async_page_not_present(struct kvm_vcpu *vcpu,
 	kvm_add_async_pf_gfn(vcpu, work->arch.gfn);
 
 	if (!(vcpu->arch.apf.msr_val & KVM_ASYNC_PF_ENABLED) ||
-	    kvm_x86_ops->get_cpl(vcpu) == 0)
+	    (vcpu->arch.apf.send_user_only &&
+	     kvm_x86_ops->get_cpl(vcpu) == 0))
 		kvm_make_request(KVM_REQ_APF_HALT, vcpu);
 	else if (!apf_put_user(vcpu, KVM_PV_REASON_PAGE_NOT_PRESENT)) {
 		vcpu->arch.fault.error_code = 0;
-- 
1.7.1

