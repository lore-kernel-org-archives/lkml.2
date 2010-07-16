Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935570Ab0GPDbN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 23:31:13 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60643 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S935392Ab0GPDbL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 23:31:11 -0400
Message-ID: <4C3FD18E.1010908@cn.fujitsu.com>
Date: Fri, 16 Jul 2010 11:27:10 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>
Subject: [PATCH v2 4/6] KVM: MMU: don't atomicly set spte if it's not present
References: <4C3FCFD7.5070005@cn.fujitsu.com> <4C3FD11D.1060104@cn.fujitsu.com>
In-Reply-To: <4C3FD11D.1060104@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the old mapping is not present, the spte.a is not lost, so no need
atomic operation to set it

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/mmu.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index b3896bf..4123e8e 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -307,9 +307,10 @@ static void update_spte(u64 *sptep, u64 new_spte)
 {
 	u64 old_spte;
 
-	if (!shadow_accessed_mask || (new_spte & shadow_accessed_mask)) {
+	if (!shadow_accessed_mask || (new_spte & shadow_accessed_mask) ||
+	      !is_rmap_spte(*sptep))
 		__set_spte(sptep, new_spte);
-	} else {
+	else {
 		old_spte = __xchg_spte(sptep, new_spte);
 		if (old_spte & shadow_accessed_mask)
 			mark_page_accessed(pfn_to_page(spte_to_pfn(old_spte)));
-- 
1.6.1.2


