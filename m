Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932232Ab1FVOdP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 10:33:15 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60618 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758296Ab1FVOdN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 10:33:13 -0400
Message-ID: <4E01FD9F.9000908@cn.fujitsu.com>
Date: Wed, 22 Jun 2011 22:35:11 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH 18/22] KVM: MMU: do not need atomicly to set/clear spte
References: <4E01FBC9.3020009@cn.fujitsu.com>
In-Reply-To: <4E01FBC9.3020009@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-06-22 22:32:46,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-06-22 22:32:46,
	Serialize complete at 2011-06-22 22:32:46
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now, the spte is just from nonprsent to present or present to nonprsent, so
we can use some trick to set/clear spte non-atomicly as linux kernel does

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/mmu.c |   82 +++++++++++++++++++++++++++++++++++++++++++--------
 1 files changed, 69 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 339e1a3..0ba94e9 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -259,26 +259,82 @@ static gfn_t pse36_gfn_delta(u32 gpte)
 	return (gpte & PT32_DIR_PSE36_MASK) << shift;
 }
 
+#ifdef CONFIG_X86_64
 static void __set_spte(u64 *sptep, u64 spte)
 {
-	set_64bit(sptep, spte);
+	*sptep = spte;
 }
 
-static u64 __xchg_spte(u64 *sptep, u64 new_spte)
+static void __update_clear_spte_fast(u64 *sptep, u64 spte)
 {
-#ifdef CONFIG_X86_64
-	return xchg(sptep, new_spte);
+	*sptep = spte;
+}
+
+static u64 __update_clear_spte_slow(u64 *sptep, u64 spte)
+{
+	return xchg(sptep, spte);
+}
 #else
-	u64 old_spte;
+union split_spte {
+	struct {
+		u32 spte_low;
+		u32 spte_high;
+	};
+	u64 spte;
+};
 
-	do {
-		old_spte = *sptep;
-	} while (cmpxchg64(sptep, old_spte, new_spte) != old_spte);
+static void __set_spte(u64 *sptep, u64 spte)
+{
+	union split_spte *ssptep, sspte;
 
-	return old_spte;
-#endif
+	ssptep = (union split_spte *)sptep;
+	sspte = (union split_spte)spte;
+
+	ssptep->spte_high = sspte.spte_high;
+
+	/*
+	 * If we map the spte from nonpresent to present, We should store
+	 * the high bits firstly, then set present bit, so cpu can not
+	 * fetch this spte while we are setting the spte.
+	 */
+	smp_wmb();
+
+	ssptep->spte_low = sspte.spte_low;
 }
 
+static void __update_clear_spte_fast(u64 *sptep, u64 spte)
+{
+	union split_spte *ssptep, sspte;
+
+	ssptep = (union split_spte *)sptep;
+	sspte = (union split_spte)spte;
+
+	ssptep->spte_low = sspte.spte_low;
+
+	/*
+	 * If we map the spte from present to nonpresent, we should clear
+	 * present bit firstly to avoid vcpu fetch the old high bits.
+	 */
+	smp_wmb();
+
+	ssptep->spte_high = sspte.spte_high;
+}
+
+static u64 __update_clear_spte_slow(u64 *sptep, u64 spte)
+{
+	union split_spte *ssptep, sspte, orig;
+
+	ssptep = (union split_spte *)sptep;
+	sspte = (union split_spte)spte;
+
+	/* xchg acts as a barrier before the setting of the high bits */
+	orig.spte_low = xchg(&ssptep->spte_low, sspte.spte_low);
+	orig.spte_high = ssptep->spte_high = sspte.spte_high;
+
+	return orig.spte;
+}
+#endif
+
 static bool spte_is_bit_cleared(u64 old_spte, u64 new_spte, u64 bit_mask)
 {
 	return (old_spte & bit_mask) && !(new_spte & bit_mask);
@@ -319,9 +375,9 @@ static u64 spte_get_and_update_clear(u64 *sptep, u64 new_spte)
 	u64 old_spte = *sptep;
 
 	if (!spte_has_volatile_bits(old_spte, new_spte))
-		__set_spte(sptep, new_spte);
+		__update_clear_spte_fast(sptep, new_spte);
 	else
-		old_spte = __xchg_spte(sptep, new_spte);
+		old_spte = __update_clear_spte_slow(sptep, new_spte);
 
 	return old_spte;
 }
@@ -379,7 +435,7 @@ static int mmu_spte_clear_track_bits(u64 *sptep)
  */
 static void mmu_spte_clear_no_track(u64 *sptep)
 {
-	__set_spte(sptep, 0ull);
+	__update_clear_spte_fast(sptep, 0ull);
 }
 
 static int mmu_topup_memory_cache(struct kvm_mmu_memory_cache *cache,
-- 
1.7.5.4

