Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756296Ab2EWJMO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 05:12:14 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:36089 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895Ab2EWJMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 05:12:12 -0400
Message-ID: <4FBCA665.5000601@linux.vnet.ibm.com>
Date: Wed, 23 May 2012 16:57:09 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH v5 8/9] KVM: MMU: fix kvm_mmu_pagetable_walk tracepoint
References: <4FBCA4FB.8050501@linux.vnet.ibm.com>
In-Reply-To: <4FBCA4FB.8050501@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12052309-2000-0000-0000-000007AB3BC0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The P bit of page fault error code is missed in this tracepoint, fix it by
passing the full error code

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmutrace.h    |    7 +++----
 arch/x86/kvm/paging_tmpl.h |    3 +--
 2 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/mmutrace.h b/arch/x86/kvm/mmutrace.h
index 84da94f..e762d35 100644
--- a/arch/x86/kvm/mmutrace.h
+++ b/arch/x86/kvm/mmutrace.h
@@ -54,8 +54,8 @@
  */
 TRACE_EVENT(
 	kvm_mmu_pagetable_walk,
-	TP_PROTO(u64 addr, int write_fault, int user_fault, int fetch_fault),
-	TP_ARGS(addr, write_fault, user_fault, fetch_fault),
+	TP_PROTO(u64 addr, u32 pferr),
+	TP_ARGS(addr, pferr),

 	TP_STRUCT__entry(
 		__field(__u64, addr)
@@ -64,8 +64,7 @@ TRACE_EVENT(

 	TP_fast_assign(
 		__entry->addr = addr;
-		__entry->pferr = (!!write_fault << 1) | (!!user_fault << 2)
-		                 | (!!fetch_fault << 4);
+		__entry->pferr = pferr;
 	),

 	TP_printk("addr %llx pferr %x %s", __entry->addr, __entry->pferr,
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 6127326..df546fd 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -154,8 +154,7 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
 	const int fetch_fault = access & PFERR_FETCH_MASK;
 	u16 errcode = 0;

-	trace_kvm_mmu_pagetable_walk(addr, write_fault, user_fault,
-				     fetch_fault);
+	trace_kvm_mmu_pagetable_walk(addr, access);
 retry_walk:
 	eperm = false;
 	walker->level = mmu->root_level;
-- 
1.7.7.6

