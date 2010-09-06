Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755537Ab0IFQBn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 12:01:43 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:38449
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754950Ab0IFP5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 11:57:43 -0400
X-SpamScore: 1
X-BigFish: VS1(zzzz1202hzz8275bhz32i87h2a8h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L8C1L6-02-79U-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: Alexander Graf <agraf@suse.de>, <joro@8bytes.org>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 01/27] KVM: MMU: Check for root_level instead of long mode
Date: Mon, 6 Sep 2010 17:55:40 +0200
Message-ID: <1283788566-29186-2-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1283788566-29186-1-git-send-email-joerg.roedel@amd.com>
References: <1283788566-29186-1-git-send-email-joerg.roedel@amd.com>
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


