Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936166Ab0GSPb2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 11:31:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4545 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935962Ab0GSPb1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 11:31:27 -0400
From: Gleb Natapov <gleb@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, avi@redhat.com,
        mingo@elte.hu, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        hpa@zytor.com, riel@redhat.com, cl@linux-foundation.org,
        mtosatti@redhat.com
Subject: [PATCH v5 12/12] Send async PF when guest is not in userspace too.
Date: Mon, 19 Jul 2010 18:31:02 +0300
Message-Id: <1279553462-7036-13-git-send-email-gleb@redhat.com>
In-Reply-To: <1279553462-7036-1-git-send-email-gleb@redhat.com>
References: <1279553462-7036-1-git-send-email-gleb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If guest indicates that it can handle async pf in kernel mode too send
it, but only if interrupt are enabled.

Reviewed-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Gleb Natapov <gleb@redhat.com>
---
 arch/x86/kvm/mmu.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 12d1a7b..ed87b1c 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2361,7 +2361,13 @@ static bool can_do_async_pf(struct kvm_vcpu *vcpu)
 	if (!vcpu->arch.apf_data || kvm_event_needs_reinjection(vcpu))
 		return false;
 
-	return !!kvm_x86_ops->get_cpl(vcpu);
+	if (vcpu->arch.apf_send_user_only)
+		return !!kvm_x86_ops->get_cpl(vcpu);
+
+	if (!kvm_x86_ops->interrupt_allowed(vcpu))
+		return false;
+
+	return true;
 }
 
 static int tdp_page_fault(struct kvm_vcpu *vcpu, gva_t gpa, u32 error_code,
-- 
1.7.1

