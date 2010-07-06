Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756207Ab0GFQ1g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 12:27:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16192 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753891Ab0GFQZ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 12:25:28 -0400
From: Gleb Natapov <gleb@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, avi@redhat.com,
       mingo@elte.hu, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       hpa@zytor.com, riel@redhat.com, cl@linux-foundation.org,
       mtosatti@redhat.com
Subject: [PATCH v4 12/12] Send async PF when guest is not in userspace too.
Date: Tue,  6 Jul 2010 19:25:00 +0300
Message-Id: <1278433500-29884-13-git-send-email-gleb@redhat.com>
In-Reply-To: <1278433500-29884-1-git-send-email-gleb@redhat.com>
References: <1278433500-29884-1-git-send-email-gleb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Gleb Natapov <gleb@redhat.com>
---
 arch/x86/kvm/mmu.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 95a0a8b..297f399 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2280,7 +2280,13 @@ static bool can_do_async_pf(struct kvm_vcpu *vcpu)
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

