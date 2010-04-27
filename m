Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650Ab0D0Kiy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 06:38:54 -0400
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:56058
	"EHLO VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754432Ab0D0Kiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 06:38:50 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzab9bhzz1202hzz6ff19hz32i2a8h87h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L1J6WF-01-32I-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 01/22] KVM: MMU: Check for root_level instead of long mode
Date: Tue, 27 Apr 2010 12:38:11 +0200
Message-ID: <1272364712-17425-2-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1272364712-17425-1-git-send-email-joerg.roedel@amd.com>
References: <1272364712-17425-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 27 Apr 2010 10:38:35.0527 (UTC) FILETIME=[CA2E7170:01CAE5F5]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The walk_addr function checks for !is_long_mode in its 64
bit version. But what is meant here is a check for pae
paging. Change the condition to really check for pae paging
so that it also works with nested nested paging.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/paging_tmpl.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index d0cc07e..b07cec6 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -128,7 +128,7 @@ walk:
 	walker->level = vcpu->arch.mmu.root_level;
 	pte = vcpu->arch.cr3;
 #if PTTYPE == 64
-	if (!is_long_mode(vcpu)) {
+	if (vcpu->arch.mmu.root_level == PT32E_ROOT_LEVEL) {
 		pte = kvm_pdptr_read(vcpu, (addr >> 30) & 3);
 		trace_kvm_mmu_paging_element(pte, walker->level);
 		if (!is_present_gpte(pte))
@@ -194,7 +194,7 @@ walk:
 				(PTTYPE == 64 || is_pse(vcpu))) ||
 		    ((walker->level == PT_PDPE_LEVEL) &&
 				is_large_pte(pte) &&
-				is_long_mode(vcpu))) {
+				vcpu->arch.mmu.root_level == PT64_ROOT_LEVEL)) {
 			int lvl = walker->level;
 
 			walker->gfn = gpte_to_gfn_lvl(pte, lvl);
-- 
1.7.0.4


