Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935588Ab0GPDeT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 23:34:19 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:55849 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S935497Ab0GPDeS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 23:34:18 -0400
Message-ID: <4C3FD24A.9020605@cn.fujitsu.com>
Date: Fri, 16 Jul 2010 11:30:18 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>
Subject: [PATCH v2 6/6] KVM: MMU: using __xchg_spte more smarter
References: <4C3FCFD7.5070005@cn.fujitsu.com> <4C3FD1C9.5010909@cn.fujitsu.com>
In-Reply-To: <4C3FD1C9.5010909@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sometimes, atomically set spte is not needed, this patch call __xchg_spte()
more smartly

Note: if the old mapping's access bit is already set, we no need atomic operation
since the access bit is not lost

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/mmu.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index fb3ae54..71e9268 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -682,9 +682,14 @@ static void rmap_remove(struct kvm *kvm, u64 *spte)
 static void set_spte_track_bits(u64 *sptep, u64 new_spte)
 {
 	pfn_t pfn;
-	u64 old_spte;
+	u64 old_spte = *sptep;
+
+	if (!shadow_accessed_mask || !is_shadow_present_pte(old_spte) ||
+	      old_spte & shadow_accessed_mask) {
+		__set_spte(sptep, new_spte);
+	} else
+		old_spte = __xchg_spte(sptep, new_spte);
 
-	old_spte = __xchg_spte(sptep, new_spte);
 	if (!is_rmap_spte(old_spte))
 		return;
 	pfn = spte_to_pfn(old_spte);
-- 
1.6.1.2


