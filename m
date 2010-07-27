Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752775Ab0G0DZ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 23:25:28 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:53488 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752293Ab0G0DZ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 23:25:27 -0400
Message-ID: <4C4E50AE.3050902@cn.fujitsu.com>
Date: Tue, 27 Jul 2010 11:21:18 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>
Subject: [PATCH] KVM: MMU: remove valueless output message
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After commit 53383eaad08d, the '*spte' has updated before call
rmap_remove()(in most case it's 'shadow_trap_nonpresent_pte'), so
remove this information from error message

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/mmu.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 1a8f43f..bd82635 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -649,18 +649,17 @@ static void rmap_remove(struct kvm *kvm, u64 *spte)
 	gfn = kvm_mmu_page_get_gfn(sp, spte - sp->spt);
 	rmapp = gfn_to_rmap(kvm, gfn, sp->role.level);
 	if (!*rmapp) {
-		printk(KERN_ERR "rmap_remove: %p %llx 0->BUG\n", spte, *spte);
+		printk(KERN_ERR "rmap_remove: %p 0->BUG\n", spte);
 		BUG();
 	} else if (!(*rmapp & 1)) {
-		rmap_printk("rmap_remove:  %p %llx 1->0\n", spte, *spte);
+		rmap_printk("rmap_remove:  %p 1->0\n", spte);
 		if ((u64 *)*rmapp != spte) {
-			printk(KERN_ERR "rmap_remove:  %p %llx 1->BUG\n",
-			       spte, *spte);
+			printk(KERN_ERR "rmap_remove:  %p 1->BUG\n", spte);
 			BUG();
 		}
 		*rmapp = 0;
 	} else {
-		rmap_printk("rmap_remove:  %p %llx many->many\n", spte, *spte);
+		rmap_printk("rmap_remove:  %p many->many\n", spte);
 		desc = (struct kvm_rmap_desc *)(*rmapp & ~1ul);
 		prev_desc = NULL;
 		while (desc) {
@@ -674,7 +673,7 @@ static void rmap_remove(struct kvm *kvm, u64 *spte)
 			prev_desc = desc;
 			desc = desc->more;
 		}
-		pr_err("rmap_remove: %p %llx many->many\n", spte, *spte);
+		pr_err("rmap_remove: %p many->many\n", spte);
 		BUG();
 	}
 }
-- 
1.6.1.2

