Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758896Ab0FKLbW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 07:31:22 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62291 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1760127Ab0FKLbT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 07:31:19 -0400
Message-ID: <4C121E6A.9000009@cn.fujitsu.com>
Date: Fri, 11 Jun 2010 19:30:50 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
       kvm@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] kvm, ept: remove the default write bit
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When ept enabled, current code set shadow_base_present_pte
including the write bit, thus all pte entries have
writabe bit, and it means guest os can always
write to any mapped page (even VMM maps RO pages for
the guest.)

We always use get_user_pages(write=1), so this bad code does not
cause any bad result currently.

But it is really bad, so fix it, and we will use RO pages future.

We will set writabe bit when it is really writable (determined by
the parameters of the set_spte())

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index fdb18cf..c7565ea 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -4365,8 +4365,7 @@ static int __init vmx_init(void)
 
 	if (enable_ept) {
 		bypass_guest_pf = 0;
-		kvm_mmu_set_base_ptes(VMX_EPT_READABLE_MASK |
-			VMX_EPT_WRITABLE_MASK);
+		kvm_mmu_set_base_ptes(VMX_EPT_READABLE_MASK);
 		kvm_mmu_set_mask_ptes(0ull, 0ull, 0ull, 0ull,
 				VMX_EPT_EXECUTABLE_MASK);
 		kvm_enable_tdp();
