Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758810Ab1F3IW2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 04:22:28 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64385 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758530Ab1F3IWT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 04:22:19 -0400
Message-ID: <4E0C32A6.6080607@cn.fujitsu.com>
Date: Thu, 30 Jun 2011 16:24:06 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH v3 11/19] KVM: MMU: filter out the mmio pfn from the fault
 pfn
References: <4E0C3178.2080603@cn.fujitsu.com>
In-Reply-To: <4E0C3178.2080603@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-06-30 16:21:37,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-06-30 16:21:40,
	Serialize complete at 2011-06-30 16:21:40
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the page fault is caused by mmio, the gfn can not be found in memslots, and
'bad_pfn' is returned on gfn_to_hva path, so we can use 'bad_pfn' to identify
the mmio page fault.
And, to clarify the meaning of mmio pfn, we return fault page instead of bad
page when the gfn is not allowd to prefetch

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/mmu.c       |    4 ++--
 include/linux/kvm_host.h |    5 +++++
 virt/kvm/kvm_main.c      |   16 ++++++++++++++--
 3 files changed, 21 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 5334b4e..96a7ed4 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2085,8 +2085,8 @@ static pfn_t pte_prefetch_gfn_to_pfn(struct kvm_vcpu *vcpu, gfn_t gfn,
 
 	slot = gfn_to_memslot_dirty_bitmap(vcpu, gfn, no_dirty_log);
 	if (!slot) {
-		get_page(bad_page);
-		return page_to_pfn(bad_page);
+		get_page(fault_page);
+		return page_to_pfn(fault_page);
 	}
 
 	hva = gfn_to_hva_memslot(slot, gfn);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 31ebb59..3e548e8 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -326,12 +326,17 @@ static inline struct kvm_memslots *kvm_memslots(struct kvm *kvm)
 static inline int is_error_hpa(hpa_t hpa) { return hpa >> HPA_MSB; }
 
 extern struct page *bad_page;
+extern struct page *fault_page;
+
 extern pfn_t bad_pfn;
+extern pfn_t fault_pfn;
 
 int is_error_page(struct page *page);
 int is_error_pfn(pfn_t pfn);
 int is_hwpoison_pfn(pfn_t pfn);
 int is_fault_pfn(pfn_t pfn);
+int is_mmio_pfn(pfn_t pfn);
+int is_invalid_pfn(pfn_t pfn);
 int kvm_is_error_hva(unsigned long addr);
 int kvm_set_memory_region(struct kvm *kvm,
 			  struct kvm_userspace_memory_region *mem,
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 11d2783..c7d41d4 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -101,8 +101,8 @@ static bool largepages_enabled = true;
 static struct page *hwpoison_page;
 static pfn_t hwpoison_pfn;
 
-static struct page *fault_page;
-static pfn_t fault_pfn;
+struct page *fault_page;
+pfn_t fault_pfn;
 
 inline int kvm_is_mmio_pfn(pfn_t pfn)
 {
@@ -931,6 +931,18 @@ int is_fault_pfn(pfn_t pfn)
 }
 EXPORT_SYMBOL_GPL(is_fault_pfn);
 
+int is_mmio_pfn(pfn_t pfn)
+{
+	return pfn == bad_pfn;
+}
+EXPORT_SYMBOL_GPL(is_mmio_pfn);
+
+int is_invalid_pfn(pfn_t pfn)
+{
+	return pfn == hwpoison_pfn || pfn == fault_pfn;
+}
+EXPORT_SYMBOL_GPL(is_invalid_pfn);
+
 static inline unsigned long bad_hva(void)
 {
 	return PAGE_OFFSET;
-- 
1.7.5.4

