Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755085Ab0D0Knj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 06:43:39 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:59235 "EHLO
	TX2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754582Ab0D0Kix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 06:38:53 -0400
X-SpamScore: 11
X-BigFish: VPS11(z1857rzab9bhzz1202hzz6ff19hz32i2a8h87h43h62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L1J6WH-01-32L-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 09/22] KVM: MMU: Let is_rsvd_bits_set take mmu context instead of vcpu
Date: Tue, 27 Apr 2010 12:38:19 +0200
Message-ID: <1272364712-17425-10-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1272364712-17425-1-git-send-email-joerg.roedel@amd.com>
References: <1272364712-17425-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 27 Apr 2010 10:38:35.0808 (UTC) FILETIME=[CA595200:01CAE5F5]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes is_rsvd_bits_set() function prototype to
take only a kvm_mmu context instead of a full vcpu.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/mmu.c         |    4 ++--
 arch/x86/kvm/paging_tmpl.h |    3 ++-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index ef9d284..615c78f 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2252,12 +2252,12 @@ static void paging_free(struct kvm_vcpu *vcpu)
 	nonpaging_free(vcpu);
 }
 
-static bool is_rsvd_bits_set(struct kvm_vcpu *vcpu, u64 gpte, int level)
+static bool is_rsvd_bits_set(struct kvm_mmu *mmu, u64 gpte, int level)
 {
 	int bit7;
 
 	bit7 = (gpte >> 7) & 1;
-	return (gpte & vcpu->arch.mmu.rsvd_bits_mask[bit7][level-1]) != 0;
+	return (gpte & mmu->rsvd_bits_mask[bit7][level-1]) != 0;
 }
 
 #define PTTYPE 64
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 802c513..1975ab6 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -158,7 +158,8 @@ walk:
 		if (!is_present_gpte(pte))
 			goto not_present;
 
-		rsvd_fault = is_rsvd_bits_set(vcpu, pte, walker->level);
+		rsvd_fault = is_rsvd_bits_set(&vcpu->arch.mmu, pte,
+					      walker->level);
 		if (rsvd_fault)
 			goto access_error;
 
-- 
1.7.0.4


