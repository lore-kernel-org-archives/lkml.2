Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756255Ab0GAOA3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 10:00:29 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:16760
	"EHLO VA3EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752015Ab0GAOAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 10:00:23 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzzz32i2a8h87h43h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L4VTKC-01-9QF-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 1/2] KVM: Remove unnecessary divide operations
Date: Thu, 1 Jul 2010 16:00:11 +0200
Message-ID: <1277992812-31945-2-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1277992812-31945-1-git-send-email-joerg.roedel@amd.com>
References: <1277992812-31945-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts unnecessary divide and modulo operations
in the KVM large page related code into logical operations.
This allows to convert gfn_t to u64 while not breaking 32
bit builds.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/ia64/include/asm/kvm_host.h    |    1 +
 arch/powerpc/include/asm/kvm_host.h |    1 +
 arch/s390/include/asm/kvm_host.h    |    3 ++-
 arch/x86/include/asm/kvm_host.h     |    3 ++-
 arch/x86/kvm/mmu.c                  |    8 ++++----
 virt/kvm/kvm_main.c                 |   10 +++++-----
 6 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/arch/ia64/include/asm/kvm_host.h b/arch/ia64/include/asm/kvm_host.h
index a362e67..2f229e5 100644
--- a/arch/ia64/include/asm/kvm_host.h
+++ b/arch/ia64/include/asm/kvm_host.h
@@ -235,6 +235,7 @@ struct kvm_vm_data {
 #define KVM_REQ_PTC_G		32
 #define KVM_REQ_RESUME		33
 
+#define KVM_HPAGE_GFN_SHIFT(x)	0
 #define KVM_NR_PAGE_SIZES	1
 #define KVM_PAGES_PER_HPAGE(x)	1
 
diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
index 0c9ad86..3452dac 100644
--- a/arch/powerpc/include/asm/kvm_host.h
+++ b/arch/powerpc/include/asm/kvm_host.h
@@ -35,6 +35,7 @@
 #define KVM_COALESCED_MMIO_PAGE_OFFSET 1
 
 /* We don't currently support large pages. */
+#define KVM_HPAGE_GFN_SHIFT(x)	0
 #define KVM_NR_PAGE_SIZES	1
 #define KVM_PAGES_PER_HPAGE(x)	(1UL<<31)
 
diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index b95710a..cef7dbf 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -41,7 +41,8 @@ struct sca_block {
 } __attribute__((packed));
 
 #define KVM_NR_PAGE_SIZES 2
-#define KVM_HPAGE_SHIFT(x) (PAGE_SHIFT + ((x) - 1) * 8)
+#define KVM_HPAGE_GFN_SHIFT(x) (((x) - 1) * 8)
+#define KVM_HPAGE_SHIFT(x) (PAGE_SHIFT + KVM_HPAGE_GFN_SHIFT(x))
 #define KVM_HPAGE_SIZE(x) (1UL << KVM_HPAGE_SHIFT(x))
 #define KVM_HPAGE_MASK(x)	(~(KVM_HPAGE_SIZE(x) - 1))
 #define KVM_PAGES_PER_HPAGE(x)	(KVM_HPAGE_SIZE(x) / PAGE_SIZE)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index a57cdea..2b3452f 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -43,7 +43,8 @@
 
 /* KVM Hugepage definitions for x86 */
 #define KVM_NR_PAGE_SIZES	3
-#define KVM_HPAGE_SHIFT(x)	(PAGE_SHIFT + (((x) - 1) * 9))
+#define KVM_HPAGE_GFN_SHIFT(x)	(((x) - 1) * 9)
+#define KVM_HPAGE_SHIFT(x)	(PAGE_SHIFT + KVM_HPAGE_GFN_SHIFT(x))
 #define KVM_HPAGE_SIZE(x)	(1UL << KVM_HPAGE_SHIFT(x))
 #define KVM_HPAGE_MASK(x)	(~(KVM_HPAGE_SIZE(x) - 1))
 #define KVM_PAGES_PER_HPAGE(x)	(KVM_HPAGE_SIZE(x) / PAGE_SIZE)
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 045a0f9..8e0a325 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -423,8 +423,8 @@ static int *slot_largepage_idx(gfn_t gfn,
 {
 	unsigned long idx;
 
-	idx = (gfn / KVM_PAGES_PER_HPAGE(level)) -
-	      (slot->base_gfn / KVM_PAGES_PER_HPAGE(level));
+	idx = (gfn >> KVM_HPAGE_GFN_SHIFT(level)) -
+	      (slot->base_gfn >> KVM_HPAGE_GFN_SHIFT(level));
 	return &slot->lpage_info[level - 2][idx].write_count;
 }
 
@@ -528,8 +528,8 @@ static unsigned long *gfn_to_rmap(struct kvm *kvm, gfn_t gfn, int level)
 	if (likely(level == PT_PAGE_TABLE_LEVEL))
 		return &slot->rmap[gfn - slot->base_gfn];
 
-	idx = (gfn / KVM_PAGES_PER_HPAGE(level)) -
-		(slot->base_gfn / KVM_PAGES_PER_HPAGE(level));
+	idx = (gfn >> KVM_HPAGE_GFN_SHIFT(level)) -
+		(slot->base_gfn >> KVM_HPAGE_GFN_SHIFT(level));
 
 	return &slot->lpage_info[level - 2][idx].rmap_pde;
 }
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 885d3f5..57e3a6b 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -626,9 +626,9 @@ int __kvm_set_memory_region(struct kvm *kvm,
 		if (new.lpage_info[i])
 			continue;
 
-		lpages = 1 + (base_gfn + npages - 1) /
-			     KVM_PAGES_PER_HPAGE(level);
-		lpages -= base_gfn / KVM_PAGES_PER_HPAGE(level);
+		lpages = 1 + ((base_gfn + npages - 1)
+			     >> KVM_HPAGE_GFN_SHIFT(level));
+		lpages -= base_gfn >> KVM_HPAGE_GFN_SHIFT(level);
 
 		new.lpage_info[i] = vmalloc(lpages * sizeof(*new.lpage_info[i]));
 
@@ -638,9 +638,9 @@ int __kvm_set_memory_region(struct kvm *kvm,
 		memset(new.lpage_info[i], 0,
 		       lpages * sizeof(*new.lpage_info[i]));
 
-		if (base_gfn % KVM_PAGES_PER_HPAGE(level))
+		if (base_gfn & (KVM_PAGES_PER_HPAGE(level) - 1))
 			new.lpage_info[i][0].write_count = 1;
-		if ((base_gfn+npages) % KVM_PAGES_PER_HPAGE(level))
+		if ((base_gfn+npages) & (KVM_PAGES_PER_HPAGE(level) - 1))
 			new.lpage_info[i][lpages - 1].write_count = 1;
 		ugfn = new.userspace_addr >> PAGE_SHIFT;
 		/*
-- 
1.7.0.4


