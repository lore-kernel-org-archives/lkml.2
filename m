Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759471Ab1CDK62 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 05:58:28 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:60325 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752084Ab1CDK61 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 05:58:27 -0500
Message-ID: <4D70C609.9000700@cn.fujitsu.com>
Date: Fri, 04 Mar 2011 18:59:21 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH 5/10] KVM: MMU: move mmu pages calculated out of mmu lock
References: <4D70C569.1030107@cn.fujitsu.com>
In-Reply-To: <4D70C569.1030107@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-04 18:57:13,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-04 18:57:16,
	Serialize complete at 2011-03-04 18:57:16
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kvm_mmu_calculate_mmu_pages need to walk all memslots and it's protected by
kvm->slots_lock, so move it out of mmu spinlock

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/x86.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 785ae0c..b9c2b8e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6105,7 +6105,7 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 				int user_alloc)
 {
 
-	int npages = mem->memory_size >> PAGE_SHIFT;
+	int nr_mmu_pages = 0, npages = mem->memory_size >> PAGE_SHIFT;
 
 	if (!user_alloc && !old.user_alloc && old.rmap && !npages) {
 		int ret;
@@ -6120,12 +6120,12 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 			       "failed to munmap memory\n");
 	}
 
+	if (!kvm->arch.n_requested_mmu_pages)
+		nr_mmu_pages = kvm_mmu_calculate_mmu_pages(kvm);
+
 	spin_lock(&kvm->mmu_lock);
-	if (!kvm->arch.n_requested_mmu_pages) {
-		unsigned int nr_mmu_pages = kvm_mmu_calculate_mmu_pages(kvm);
+	if (nr_mmu_pages)
 		kvm_mmu_change_mmu_pages(kvm, nr_mmu_pages);
-	}
-
 	kvm_mmu_slot_remove_write_access(kvm, mem->slot);
 	spin_unlock(&kvm->mmu_lock);
 }
-- 
1.7.4

