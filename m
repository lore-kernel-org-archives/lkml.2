Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753829Ab1EKCme (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 22:42:34 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:49274 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752859Ab1EKCmd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 22:42:33 -0400
Message-ID: <4DC9F803.3050602@cn.fujitsu.com>
Date: Wed, 11 May 2011 10:44:19 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH v2] KVM: MMU: optimize pte write path if don't have protected
 sp
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-05-11 10:42:45,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-05-11 10:42:45,
	Serialize complete at 2011-05-11 10:42:45
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simply return from kvm_mmu_pte_write path if no shadow page is
write-protected, then we can avoid to walk all shadow pages and hold
mmu-lock

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/include/asm/kvm_host.h |    1 +
 arch/x86/kvm/mmu.c              |   12 +++++++++++-
 2 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index d2ac8e2..d2e5fb8 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -442,6 +442,7 @@ struct kvm_arch {
 	unsigned int n_requested_mmu_pages;
 	unsigned int n_max_mmu_pages;
 	atomic_t invlpg_counter;
+	atomic_t indirect_shadow_pages;
 	struct hlist_head mmu_page_hash[KVM_NUM_MMU_PAGES];
 	/*
 	 * Hash table of struct kvm_mmu_page.
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 2841805..7e6117dc 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1038,8 +1038,10 @@ static void kvm_mmu_free_page(struct kvm *kvm, struct kvm_mmu_page *sp)
 	hlist_del(&sp->hash_link);
 	list_del(&sp->link);
 	free_page((unsigned long)sp->spt);
-	if (!sp->role.direct)
+	if (!sp->role.direct) {
 		free_page((unsigned long)sp->gfns);
+		atomic_dec(&kvm->arch.indirect_shadow_pages);
+	}
 	kmem_cache_free(mmu_page_header_cache, sp);
 	kvm_mod_used_mmu_pages(kvm, -1);
 }
@@ -1536,6 +1538,7 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 			kvm_sync_pages(vcpu, gfn);
 
 		account_shadowed(vcpu->kvm, gfn);
+		atomic_inc(&vcpu->kvm->arch.indirect_shadow_pages);
 	}
 	if (shadow_trap_nonpresent_pte != shadow_notrap_nonpresent_pte)
 		vcpu->arch.mmu.prefetch_page(vcpu, sp);
@@ -3233,6 +3236,13 @@ void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 	int level, npte, invlpg_counter, r, flooded = 0;
 	bool remote_flush, local_flush, zap_page;
 
+	/*
+	 * If we don't have indirect shadow pages, it means no page is
+	 * write-protected, so we can simply exit.
+	 */
+	if (!atomic_read(&vcpu->kvm->arch.indirect_shadow_pages))
+		return;
+
 	zap_page = remote_flush = local_flush = false;
 	offset = offset_in_page(gpa);
 
-- 
1.7.4.4
