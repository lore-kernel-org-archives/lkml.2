Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754047Ab2HGJvs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 05:51:48 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:43711 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753977Ab2HGJvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 05:51:45 -0400
Message-ID: <5020E528.20309@linux.vnet.ibm.com>
Date: Tue, 07 Aug 2012 17:51:36 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH v5 06/12] KVM: use 'writable' as a hint to map writable pfn
References: <5020E423.9080004@linux.vnet.ibm.com>
In-Reply-To: <5020E423.9080004@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12080709-8256-0000-0000-0000039D3F88
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In current code, we always map writable pfn for the read-fault, in order
to support readonly memslot, we map writable pfn only if 'writable'
is not NULL

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 virt/kvm/kvm_main.c |   24 +++++++++++++++++++++++-
 1 files changed, 23 insertions(+), 1 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index dd01bcb..bf6dede 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1056,6 +1056,14 @@ static bool hva_to_pfn_fast(unsigned long addr, bool atomic, bool *async,
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
@@ -1095,7 +1103,7 @@ static int hva_to_pfn_slow(unsigned long addr, bool *async, bool write_fault,
 		return npages;

 	/* map read fault as writable if possible */
-	if (unlikely(!write_fault)) {
+	if (unlikely(!write_fault) && writable) {
 		struct page *wpage[1];

 		npages = __get_user_pages_fast(addr, 1, 1, wpage);
@@ -1111,6 +1119,20 @@ static int hva_to_pfn_slow(unsigned long addr, bool *async, bool write_fault,
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

