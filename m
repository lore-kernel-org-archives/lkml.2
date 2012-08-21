Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756089Ab2HUDA7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 23:00:59 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:43944 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755487Ab2HUDA4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 23:00:56 -0400
Message-ID: <5032F9E1.3080000@linux.vnet.ibm.com>
Date: Tue, 21 Aug 2012 11:00:49 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH v6 07/12] KVM: use 'writable' as a hint to map writable pfn
References: <5032F8FD.2020306@linux.vnet.ibm.com>
In-Reply-To: <5032F8FD.2020306@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12082103-8878-0000-0000-000003AE20DE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In current code, we always map writable pfn for the read fault, in order
to support readonly memslot, we map writable pfn only if 'writable'
is not NULL

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 virt/kvm/kvm_main.c |   24 +++++++++++++++++++++++-
 1 files changed, 23 insertions(+), 1 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index aa4a38a..c89d1b5 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1054,6 +1054,14 @@ static bool hva_to_pfn_fast(unsigned long addr, bool atomic, bool *async,
 	if (!(async || atomic))
 		return false;

+	/*
+	 * Fast pin a writable pfn only if it is a write fault request
+	 * or the caller allows to map a writable pfn for a read fault
+	 * request.
+	 */
+	if (!(write_fault || writable))
+		return false;
+
 	npages = __get_user_pages_fast(addr, 1, 1, page);
 	if (npages == 1) {
 		*pfn = page_to_pfn(page[0]);
@@ -1093,7 +1101,7 @@ static int hva_to_pfn_slow(unsigned long addr, bool *async, bool write_fault,
 		return npages;

 	/* map read fault as writable if possible */
-	if (unlikely(!write_fault)) {
+	if (unlikely(!write_fault) && writable) {
 		struct page *wpage[1];

 		npages = __get_user_pages_fast(addr, 1, 1, wpage);
@@ -1109,6 +1117,20 @@ static int hva_to_pfn_slow(unsigned long addr, bool *async, bool write_fault,
 	return npages;
 }

+/*
+ * Pin guest page in memory and return its pfn.
+ * @addr: host virtual address which maps memory to the guest
+ * @atomic: whether this function can sleep
+ * @async: whether this function need to wait IO complete if the
+ *         host page is not in the memory
+ * @write_fault: whether we should get a writable host page
+ * @writable: whether it allows to map a writable host page for !@write_fault
+ *
+ * The function will map a writable host page for these two cases:
+ * 1): @write_fault = true
+ * 2): @write_fault = false && @writable, @writable will tell the caller
+ *     whether the mapping is writable.
+ */
 static pfn_t hva_to_pfn(unsigned long addr, bool atomic, bool *async,
 			bool write_fault, bool *writable)
 {
-- 
1.7.7.6

