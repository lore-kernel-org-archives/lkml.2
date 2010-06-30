Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753444Ab0F3IFz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 04:05:55 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59175 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752475Ab0F3IFv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 04:05:51 -0400
Message-ID: <4C2AF9FA.9020601@cn.fujitsu.com>
Date: Wed, 30 Jun 2010 16:02:02 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: [PATCH v3 1/11] KVM: MMU: fix writable sync sp mapping
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While we sync many unsync sp at one time(in mmu_sync_children()),
we may mapping the spte writable, it's dangerous, if one unsync
sp's mapping gfn is another unsync page's gfn.

For example:

SP1.pte[0] = P
SP2.gfn's pfn = P
[SP1.pte[0] = SP2.gfn's pfn]

First, we write protected SP1 and SP2, but SP1 and SP2 are still the
unsync sp.

Then, sync SP1 first, it will detect SP1.pte[0].gfn only has one unsync-sp,
that is SP2, so it will mapping it writable, but we plan to sync SP2 soon,
at this point, the SP2->unsync is not reliable since later we sync SP2 but
SP2->gfn is already writable.

So the final result is: SP2 is the sync page but SP2.gfn is writable.

This bug will corrupt guest's page table, fixed by mark read-only mapping
if the mapped gfn has shadow pages.

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/mmu.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 045a0f9..24290f8 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1810,11 +1810,14 @@ static int mmu_need_write_protect(struct kvm_vcpu *vcpu, gfn_t gfn,
 	bool need_unsync = false;
 
 	for_each_gfn_indirect_valid_sp(vcpu->kvm, s, gfn, node) {
+		if (!can_unsync)
+			return 1;
+
 		if (s->role.level != PT_PAGE_TABLE_LEVEL)
 			return 1;
 
 		if (!need_unsync && !s->unsync) {
-			if (!can_unsync || !oos_shadow)
+			if (!oos_shadow)
 				return 1;
 			need_unsync = true;
 		}
-- 
1.6.1.2

