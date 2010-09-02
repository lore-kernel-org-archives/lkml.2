Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755735Ab0IBPeX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 11:34:23 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:57538
	"EHLO VA3EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755450Ab0IBPeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 11:34:21 -0400
X-SpamScore: 1
X-BigFish: VS1(zzzz1202hzz8275bhz32i2a8h87h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L84LPJ-02-7LZ-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 1/3] KVM: MMU: Fix 32 bit legacy paging with NPT
Date: Thu, 2 Sep 2010 17:29:45 +0200
Message-ID: <1283441387-7378-2-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1283441387-7378-1-git-send-email-joerg.roedel@amd.com>
References: <1283441387-7378-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes 32 bit legacy paging with NPT enabled. The
mmu_check_root call on the top-level of the loop causes
root_gfn to take values (in the tdp_enabled path) which are
outside of guest memory. So the mmu_check_root call fails at
some point in the loop interation causing the guest to
tiple-fault.
This patch changes the mmu_check_root calls to the places
where they are really necessary. As a side-effect it
introduces a check for the root of a pae page table too.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/mmu.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index d2dad65..b2136f9 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2387,6 +2387,10 @@ static int mmu_alloc_roots(struct kvm_vcpu *vcpu)
 		return 0;
 	}
 	direct = !is_paging(vcpu);
+
+	if (mmu_check_root(vcpu, root_gfn))
+		return 1;
+
 	for (i = 0; i < 4; ++i) {
 		hpa_t root = vcpu->arch.mmu.pae_root[i];
 
@@ -2398,10 +2402,10 @@ static int mmu_alloc_roots(struct kvm_vcpu *vcpu)
 				continue;
 			}
 			root_gfn = pdptr >> PAGE_SHIFT;
+			if (mmu_check_root(vcpu, root_gfn))
+				return 1;
 		} else if (vcpu->arch.mmu.root_level == 0)
 			root_gfn = 0;
-		if (mmu_check_root(vcpu, root_gfn))
-			return 1;
 		if (tdp_enabled) {
 			direct = 1;
 			root_gfn = i << 30;
-- 
1.7.0.4


