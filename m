Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933652Ab0EZCt6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 22:49:58 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62945 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932105Ab0EZCt5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 22:49:57 -0400
Message-ID: <4BFC8B8C.7010402@cn.fujitsu.com>
Date: Wed, 26 May 2010 10:46:36 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: [PATCH 2/2] KVM: MMU: fix relaxing permission
References: <4BFC8B0D.2060106@cn.fujitsu.com>
In-Reply-To: <4BFC8B0D.2060106@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a relaxing permission operation in set_spte():

if guest's CR0.WP is not set and R/W #PF occurs in supervisor-level,
the mapping path might set to writable, then user can allow to write.

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/mmu.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index bfd8382..ccbc98b 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1859,8 +1859,7 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 
 	spte |= (u64)pfn << PAGE_SHIFT;
 
-	if ((pte_access & ACC_WRITE_MASK)
-	    || (write_fault && !is_write_protection(vcpu) && !user_fault)) {
+	if (pte_access & ACC_WRITE_MASK) {
 
 		if (level > PT_PAGE_TABLE_LEVEL &&
 		    has_wrprotected_page(vcpu->kvm, gfn, level)) {
-- 
1.6.1.2


