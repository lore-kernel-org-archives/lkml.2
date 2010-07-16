Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935327Ab0GPCMb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 22:12:31 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63291 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S935168Ab0GPCM3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 22:12:29 -0400
Message-ID: <4C3FC025.9070707@cn.fujitsu.com>
Date: Fri, 16 Jul 2010 10:12:53 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH 1/6] kvm: pass error code to handler
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

handle_ept_violation() does not pass error code to
the handler tdp_page_fault().

It means tdp_page_fault() handles the page fault with ignoring
the error code, It will not handle the page fault completely correctly,
and may causes endless page fault.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 856e427..b40731e 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -3521,7 +3521,8 @@ static int handle_ept_violation(struct kvm_vcpu *vcpu)
 
 	gpa = vmcs_read64(GUEST_PHYSICAL_ADDRESS);
 	trace_kvm_page_fault(gpa, exit_qualification);
-	return kvm_mmu_page_fault(vcpu, gpa & PAGE_MASK, 0);
+	return kvm_mmu_page_fault(vcpu, gpa & PAGE_MASK,
+			exit_qualification & 0x2);
 }
 
 static u64 ept_rsvd_mask(u64 spte, int level)
