Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756136Ab0GMJux (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 05:50:53 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:51509 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756054Ab0GMJuu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 05:50:50 -0400
Message-ID: <4C3C360B.1050002@cn.fujitsu.com>
Date: Tue, 13 Jul 2010 17:46:51 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>
Subject: [PATCH 4/4] KVM: MMU: remove valueless output message
References: <4C3C3518.7080505@cn.fujitsu.com>
In-Reply-To: <4C3C3518.7080505@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After commit 53383eaad08d, the '*spte' has updated before call
rmap_remove()(in most case it's 'shadow_trap_nonpresent_pte'), so
remove this information form error message

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/mmu.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 5e9d4a0..c07a5eb 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -662,18 +662,17 @@ static void rmap_remove(struct kvm *kvm, u64 *spte)
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
@@ -687,7 +686,7 @@ static void rmap_remove(struct kvm *kvm, u64 *spte)
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


