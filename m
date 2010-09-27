Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932970Ab0I0J7F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 05:59:05 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57162 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932343Ab0I0J7C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 05:59:02 -0400
Message-ID: <4CA06BEF.7060401@cn.fujitsu.com>
Date: Mon, 27 Sep 2010 18:03:27 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH 2/7] KVM: MMU: cleanup for error mask set while walk guest
 page table
References: <4CA06BA4.4090303@cn.fujitsu.com>
In-Reply-To: <4CA06BA4.4090303@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Small cleanup for set page fault error code

Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/paging_tmpl.h |   17 +++++++----------
 1 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 2bdd843..a83ff37 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -224,9 +224,7 @@ walk:
 			    is_cpuid_PSE36())
 				gfn += pse36_gfn_delta(pte);
 
-			access |= write_fault ? PFERR_WRITE_MASK : 0;
-			access |= fetch_fault ? PFERR_FETCH_MASK : 0;
-			access |= user_fault  ? PFERR_USER_MASK  : 0;
+			access |= write_fault | fetch_fault | user_fault;
 
 			real_gpa = mmu->translate_gpa(vcpu, gfn_to_gpa(gfn),
 						      access);
@@ -268,10 +266,9 @@ error:
 	walker->error_code = 0;
 	if (present)
 		walker->error_code |= PFERR_PRESENT_MASK;
-	if (write_fault)
-		walker->error_code |= PFERR_WRITE_MASK;
-	if (user_fault)
-		walker->error_code |= PFERR_USER_MASK;
+
+	walker->error_code |= write_fault | user_fault;
+
 	if (fetch_fault && mmu->nx)
 		walker->error_code |= PFERR_FETCH_MASK;
 	if (rsvd_fault)
@@ -673,9 +670,9 @@ static gpa_t FNAME(gva_to_gpa)(struct kvm_vcpu *vcpu, gva_t vaddr, u32 access,
 	int r;
 
 	r = FNAME(walk_addr)(&walker, vcpu, vaddr,
-			     !!(access & PFERR_WRITE_MASK),
-			     !!(access & PFERR_USER_MASK),
-			     !!(access & PFERR_FETCH_MASK));
+			     access & PFERR_WRITE_MASK,
+			     access & PFERR_USER_MASK,
+			     access & PFERR_FETCH_MASK);
 
 	if (r) {
 		gpa = gfn_to_gpa(walker.gfn);
-- 
1.7.0.4

