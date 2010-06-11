Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759860Ab0FKLa6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 07:30:58 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64598 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755400Ab0FKLa5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 07:30:57 -0400
Message-ID: <4C121E50.6050402@cn.fujitsu.com>
Date: Fri, 11 Jun 2010 19:30:24 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
       kvm@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] kvm,ept: pass error code to handler
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

{
But because there is another bad code in the kvm, This endless page faulting
never occur. The bad code: kvm always set pte writable.

negative * negative = positive, WTF!!

Next patch will fix this bad code.
}

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index c7565ea..6362dcc 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -3470,7 +3470,7 @@ static int handle_ept_violation(struct kvm_vcpu *vcpu)
 
 	gpa = vmcs_read64(GUEST_PHYSICAL_ADDRESS);
 	trace_kvm_page_fault(gpa, exit_qualification);
-	return kvm_mmu_page_fault(vcpu, gpa & PAGE_MASK, 0);
+	return kvm_mmu_page_fault(vcpu, gpa & PAGE_MASK, exit_qualification);
 }
 
 static u64 ept_rsvd_mask(u64 spte, int level)

