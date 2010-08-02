Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753709Ab0HBIST (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 04:18:19 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:49485 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753029Ab0HBISR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 04:18:17 -0400
Message-ID: <4C567E4C.9030406@cn.fujitsu.com>
Date: Mon, 02 Aug 2010 16:14:04 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>
Subject: [PATCH v2 2/3] KVM: MMU: move bits lost judgement into a separate
 function
References: <4C4E5313.1080308@cn.fujitsu.com> <4C4E536E.7030109@cn.fujitsu.com>
In-Reply-To: <4C4E536E.7030109@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce spte_has_volatile_bits() function to judge whether spte
bits will miss, it's more readable and can help us to cleanup code
later

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/mmu.c |   20 +++++++++++++++++---
 1 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index f7b379a..e18834c 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -303,6 +303,20 @@ static u64 __xchg_spte(u64 *sptep, u64 new_spte)
 #endif
 }
 
+static bool spte_has_volatile_bits(u64 spte)
+{
+	if (!shadow_accessed_mask)
+		return false;
+
+	if (!is_shadow_present_pte(spte))
+		return false;
+
+	if (spte & shadow_accessed_mask)
+		return false;
+
+	return true;
+}
+
 static void update_spte(u64 *sptep, u64 new_spte)
 {
 	u64 old_spte;
@@ -683,14 +697,14 @@ static void set_spte_track_bits(u64 *sptep, u64 new_spte)
 	pfn_t pfn;
 	u64 old_spte = *sptep;
 
-	if (!shadow_accessed_mask || !is_shadow_present_pte(old_spte) ||
-	      old_spte & shadow_accessed_mask) {
+	if (!spte_has_volatile_bits(old_spte))
 		__set_spte(sptep, new_spte);
-	} else
+	else
 		old_spte = __xchg_spte(sptep, new_spte);
 
 	if (!is_rmap_spte(old_spte))
 		return;
+
 	pfn = spte_to_pfn(old_spte);
 	if (!shadow_accessed_mask || old_spte & shadow_accessed_mask)
 		kvm_set_pfn_accessed(pfn);
-- 
1.6.1.2


