Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753752Ab2LOHAm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2012 02:00:42 -0500
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:56913 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752684Ab2LOHAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2012 02:00:41 -0500
Message-ID: <50CC2008.1000800@linux.vnet.ibm.com>
Date: Sat, 15 Dec 2012 15:00:24 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH v3 4/5] KVM: x86: let reexecute_instruction work for tdp
References: <50CC1F62.4050701@linux.vnet.ibm.com>
In-Reply-To: <50CC1F62.4050701@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12121507-8256-0000-0000-0000057302B1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, reexecute_instruction refused to retry all instructions. If
nested npt is used, the emulation may be caused by shadow page, it can
be fixed by dropping the shadow page

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/x86.c |   19 +++++++++++++------
 1 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index eccd040..bf66169 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4753,17 +4753,24 @@ static int handle_emulation_failure(struct kvm_vcpu *vcpu)
 	return r;
 }

-static bool reexecute_instruction(struct kvm_vcpu *vcpu, gva_t gva)
+static bool reexecute_instruction(struct kvm_vcpu *vcpu, unsigned long cr2)
 {
-	gpa_t gpa;
+	gpa_t gpa = cr2;
 	pfn_t pfn;
+	unsigned int indirect_shadow_pages;
+
+	spin_lock(&vcpu->kvm->mmu_lock);
+	indirect_shadow_pages = vcpu->kvm->arch.indirect_shadow_pages;
+	spin_unlock(&vcpu->kvm->mmu_lock);

-	if (tdp_enabled)
+	if (!indirect_shadow_pages)
 		return false;

-	gpa = kvm_mmu_gva_to_gpa_read(vcpu, gva, NULL);
-	if (gpa == UNMAPPED_GVA)
-		return true; /* let cpu generate fault */
+	if (!vcpu->arch.mmu.direct_map) {
+		gpa = kvm_mmu_gva_to_gpa_read(vcpu, cr2, NULL);
+		if (gpa == UNMAPPED_GVA)
+			return true; /* let cpu generate fault */
+	}

 	/*
 	 * if emulation was due to access to shadowed page table
-- 
1.7.7.6

