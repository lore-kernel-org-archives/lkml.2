Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754701Ab2GQOor (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 10:44:47 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:59569 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752258Ab2GQOop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 10:44:45 -0400
Message-ID: <50057A49.8070400@linux.vnet.ibm.com>
Date: Tue, 17 Jul 2012 22:44:25 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH 07/10] KVM: introduce readonly_fault_pfn
References: <5005791B.8040807@linux.vnet.ibm.com>
In-Reply-To: <5005791B.8040807@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12071714-5816-0000-0000-000003A01874
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce readonly_fault_pfn, in the later patch, it indicates failure
when we try to get a writable pfn from the readonly memslot

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 include/linux/kvm_host.h |    1 +
 virt/kvm/kvm_main.c      |   92 +++++++++++++++++++++++++++------------------
 2 files changed, 56 insertions(+), 37 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index e4815e9..a2302e7 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -385,6 +385,7 @@ extern struct page *bad_page;
 int is_error_page(struct page *page);
 int is_error_pfn(pfn_t pfn);
 int is_hwpoison_pfn(pfn_t pfn);
+int is_readonly_fault_pfn(pfn_t pfn);
 int is_noslot_pfn(pfn_t pfn);
 int is_invalid_pfn(pfn_t pfn);
 int kvm_is_error_hva(unsigned long addr);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index e9eab07..b70f1a4 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -109,6 +109,9 @@ static pfn_t hwpoison_pfn;
 static struct page *fault_page;
 static pfn_t fault_pfn;

+static struct page *readonly_fault_page;
+static pfn_t readonly_fault_pfn;
+
 inline int kvm_is_mmio_pfn(pfn_t pfn)
 {
 	if (pfn_valid(pfn)) {
@@ -949,13 +952,15 @@ EXPORT_SYMBOL_GPL(kvm_disable_largepages);

 int is_error_page(struct page *page)
 {
-	return page == bad_page || page == hwpoison_page || page == fault_page;
+	return page == bad_page || page == hwpoison_page || page == fault_page
+		|| page == readonly_fault_page;
 }
 EXPORT_SYMBOL_GPL(is_error_page);

 int is_error_pfn(pfn_t pfn)
 {
-	return pfn == bad_pfn || pfn == hwpoison_pfn || pfn == fault_pfn;
+	return pfn == bad_pfn || pfn == hwpoison_pfn || pfn == fault_pfn
+		|| pfn == readonly_fault_pfn;
 }
 EXPORT_SYMBOL_GPL(is_error_pfn);

@@ -965,6 +970,12 @@ int is_hwpoison_pfn(pfn_t pfn)
 }
 EXPORT_SYMBOL_GPL(is_hwpoison_pfn);

+int is_readonly_fault_pfn(pfn_t pfn)
+{
+	return pfn == readonly_fault_pfn;
+}
+EXPORT_SYMBOL_GPL(is_readonly_fault_pfn);
+
 int is_noslot_pfn(pfn_t pfn)
 {
 	return pfn == bad_pfn;
@@ -973,7 +984,8 @@ EXPORT_SYMBOL_GPL(is_noslot_pfn);

 int is_invalid_pfn(pfn_t pfn)
 {
-	return pfn == hwpoison_pfn || pfn == fault_pfn;
+	return pfn == hwpoison_pfn || pfn == fault_pfn ||
+			pfn == readonly_fault_pfn;
 }
 EXPORT_SYMBOL_GPL(is_invalid_pfn);

@@ -1076,6 +1088,12 @@ pfn_t get_fault_pfn(void)
 }
 EXPORT_SYMBOL_GPL(get_fault_pfn);

+static pfn_t get_readonly_fault_pfn(void)
+{
+	get_page(readonly_fault_page);
+	return readonly_fault_pfn;
+}
+
 int get_user_page_nowait(struct task_struct *tsk, struct mm_struct *mm,
 	unsigned long start, int write, struct page **page)
 {
@@ -2809,42 +2827,49 @@ static void kvm_sched_out(struct preempt_notifier *pn,
 	kvm_arch_vcpu_put(vcpu);
 }

-int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
-		  struct module *module)
+static void kvm_uninit_dummy_pages(void)
 {
-	int r;
-	int cpu;
-
-	r = kvm_arch_init(opaque);
-	if (r)
-		goto out_fail;
+	if (fault_page)
+		__free_page(fault_page);
+	if (readonly_fault_page)
+		__free_page(readonly_fault_page);
+	if (hwpoison_page)
+		__free_page(hwpoison_page);
+	if (bad_page)
+		__free_page(bad_page);
+}

+static int kvm_init_dummy_pages(void)
+{
 	bad_page = alloc_page(GFP_KERNEL | __GFP_ZERO);
+	hwpoison_page = alloc_page(GFP_KERNEL | __GFP_ZERO);
+	fault_page = alloc_page(GFP_KERNEL | __GFP_ZERO);
+	readonly_fault_page = alloc_page(GFP_KERNEL | __GFP_ZERO);

-	if (bad_page == NULL) {
-		r = -ENOMEM;
-		goto out;
-	}
+	if (!bad_page || !hwpoison_page || !fault_page || !readonly_fault_page)
+		return -ENOMEM;

 	bad_pfn = page_to_pfn(bad_page);
+	hwpoison_pfn = page_to_pfn(hwpoison_page);
+	fault_pfn = page_to_pfn(fault_page);
+	readonly_fault_pfn = page_to_pfn(readonly_fault_page);

-	hwpoison_page = alloc_page(GFP_KERNEL | __GFP_ZERO);
-
-	if (hwpoison_page == NULL) {
-		r = -ENOMEM;
-		goto out_free_0;
-	}
+	return 0;
+}

-	hwpoison_pfn = page_to_pfn(hwpoison_page);
+int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
+		  struct module *module)
+{
+	int r;
+	int cpu;

-	fault_page = alloc_page(GFP_KERNEL | __GFP_ZERO);
+	r = kvm_arch_init(opaque);
+	if (r)
+		goto out_fail;

-	if (fault_page == NULL) {
-		r = -ENOMEM;
+	r = kvm_init_dummy_pages();
+	if (r)
 		goto out_free_0;
-	}
-
-	fault_pfn = page_to_pfn(fault_page);

 	if (!zalloc_cpumask_var(&cpus_hardware_enabled, GFP_KERNEL)) {
 		r = -ENOMEM;
@@ -2920,12 +2945,7 @@ out_free_1:
 out_free_0a:
 	free_cpumask_var(cpus_hardware_enabled);
 out_free_0:
-	if (fault_page)
-		__free_page(fault_page);
-	if (hwpoison_page)
-		__free_page(hwpoison_page);
-	__free_page(bad_page);
-out:
+	kvm_uninit_dummy_pages();
 	kvm_arch_exit();
 out_fail:
 	return r;
@@ -2945,8 +2965,6 @@ void kvm_exit(void)
 	kvm_arch_hardware_unsetup();
 	kvm_arch_exit();
 	free_cpumask_var(cpus_hardware_enabled);
-	__free_page(fault_page);
-	__free_page(hwpoison_page);
-	__free_page(bad_page);
+	kvm_uninit_dummy_pages();
 }
 EXPORT_SYMBOL_GPL(kvm_exit);
-- 
1.7.7.6

