Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755085Ab0IFPER (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 11:04:17 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:45917 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754267Ab0IFPCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 11:02:46 -0400
X-SpamScore: 1
X-BigFish: VS1(zzzz1202hzz8275bhz32i87h2a8h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L8BZ2P-01-AO5-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: <"http://kvm.qumranet.com"@osrc.amd.com>, <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 01/27] KVM: MMU: Check for root_level instead of long mode
Date: Mon, 6 Sep 2010 17:01:36 +0200
Message-ID: <1283785322-26898-2-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1283785322-26898-1-git-send-email-joerg.roedel@amd.com>
References: <1283785322-26898-1-git-send-email-joerg.roedel@amd.com>
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
index debe770..e4ad3dc 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -132,7 +132,7 @@ walk:
 	walker->level = vcpu->arch.mmu.root_level;
 	pte = vcpu->arch.cr3;
 #if PTTYPE == 64
-	if (!is_long_mode(vcpu)) {
+	if (vcpu->arch.mmu.root_level == PT32E_ROOT_LEVEL) {
 		pte = kvm_pdptr_read(vcpu, (addr >> 30) & 3);
 		trace_kvm_mmu_paging_element(pte, walker->level);
 		if (!is_present_gpte(pte)) {
@@ -205,7 +205,7 @@ walk:
 				(PTTYPE == 64 || is_pse(vcpu))) ||
 		    ((walker->level == PT_PDPE_LEVEL) &&
 				is_large_pte(pte) &&
-				is_long_mode(vcpu))) {
+				vcpu->arch.mmu.root_level == PT64_ROOT_LEVEL)) {
 			int lvl = walker->level;
 
 			walker->gfn = gpte_to_gfn_lvl(pte, lvl);
-- 
1.7.0.4


