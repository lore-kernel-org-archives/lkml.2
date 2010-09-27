Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933045Ab0I0KCm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 06:02:42 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:52550 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932816Ab0I0KCl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 06:02:41 -0400
Message-ID: <4CA06CCB.4010603@cn.fujitsu.com>
Date: Mon, 27 Sep 2010 18:07:07 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH 5/7] KVM: MMU: audit: unregister audit tracepoints before
 module unloaded
References: <4CA06BA4.4090303@cn.fujitsu.com>
In-Reply-To: <4CA06BA4.4090303@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix:

Call Trace:
 [<ffffffffa01e46ba>] ? kvm_mmu_pte_write+0x229/0x911 [kvm]
 [<ffffffffa01c6ba9>] ? gfn_to_memslot+0x39/0xa0 [kvm]
 [<ffffffffa01c6c26>] ? mark_page_dirty+0x16/0x2e [kvm]
 [<ffffffffa01c6d6f>] ? kvm_write_guest_page+0x67/0x7f [kvm]
 [<ffffffff81066fbd>] ? local_clock+0x2a/0x3b
 [<ffffffffa01d52ce>] emulator_write_phys+0x46/0x54 [kvm]
 ......
Code:  Bad RIP value.
RIP  [<ffffffffa0172056>] 0xffffffffa0172056
 RSP <ffff880134f69a70>
CR2: ffffffffa0172056

Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/mmu.c |   21 ++++++++++++---------
 1 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 88203fa..afde64b 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -3355,15 +3355,6 @@ int kvm_mmu_setup(struct kvm_vcpu *vcpu)
 	return init_kvm_mmu(vcpu);
 }
 
-void kvm_mmu_destroy(struct kvm_vcpu *vcpu)
-{
-	ASSERT(vcpu);
-
-	destroy_kvm_mmu(vcpu);
-	free_mmu_pages(vcpu);
-	mmu_free_memory_caches(vcpu);
-}
-
 void kvm_mmu_slot_remove_write_access(struct kvm *kvm, int slot)
 {
 	struct kvm_mmu_page *sp;
@@ -3662,4 +3653,16 @@ EXPORT_SYMBOL_GPL(kvm_mmu_get_spte_hierarchy);
 
 #ifdef CONFIG_KVM_MMU_AUDIT
 #include "mmu_audit.c"
+#else
+static void mmu_audit_disable(void) { }
 #endif
+
+void kvm_mmu_destroy(struct kvm_vcpu *vcpu)
+{
+	ASSERT(vcpu);
+
+	destroy_kvm_mmu(vcpu);
+	free_mmu_pages(vcpu);
+	mmu_free_memory_caches(vcpu);
+	mmu_audit_disable();
+}
-- 
1.7.0.4

