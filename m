Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934257Ab0EZIsh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 04:48:37 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:65270 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932536Ab0EZIsd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 04:48:33 -0400
Message-ID: <4BFCE059.60502@cn.fujitsu.com>
Date: Wed, 26 May 2010 16:48:25 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       kvm@vger.kernel.org
Subject: [RESEND PATCH 2/3]  kvm, tdp: calculate correct base gfn for non-DIR
 level
References: <4BD8228D.7090708@cn.fujitsu.com> <20100429180955.GA17909@amt.cnet> <4BD9D35C.5090403@redhat.com> <20100430154427.GA32340@amt.cnet> <4BE269D4.9090108@cn.fujitsu.com> <20100506190402.GA3432@amt.cnet>
In-Reply-To: <20100506190402.GA3432@amt.cnet>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


In Document/kvm/mmu.txt:
  gfn:
    Either the guest page table containing the translations shadowed by this
    page, or the base page frame for linear translations. See role.direct.

But in __direct_map(), the base gfn calculation is incorrect,
it does not calculate correctly when level=3 or 4.

Reported-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index a5c6719..6986a6f 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1955,7 +1956,10 @@ static int __direct_map(struct kvm_vcpu *vcpu, gpa_t v, int write,
 		}
 
 		if (*iterator.sptep == shadow_trap_nonpresent_pte) {
-			pseudo_gfn = (iterator.addr & PT64_DIR_BASE_ADDR_MASK) >> PAGE_SHIFT;
+			u64 base_addr = iterator.addr;
+
+			base_addr &= PT64_LVL_ADDR_MASK(iterator.level);
+			pseudo_gfn = base_addr >> PAGE_SHIFT;
 			sp = kvm_mmu_get_page(vcpu, pseudo_gfn, iterator.addr,
 					      iterator.level - 1,
 					      1, ACC_ALL, iterator.sptep);




