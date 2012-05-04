Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758462Ab2EDOKX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 10:10:23 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:18085 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758338Ab2EDOKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 10:10:19 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 3/4] xen/pte: Fix crashes when trying to see non-existent PGD/PMD/PUD/PTEs
Date: Fri,  4 May 2012 10:04:26 -0400
Message-Id: <1336140267-7399-4-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.5
In-Reply-To: <1336140267-7399-1-git-send-email-konrad.wilk@oracle.com>
References: <1336140267-7399-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If I try to do "cat /sys/kernel/debug/kernel_page_tables"
I end up with:

BUG: unable to handle kernel paging request at ffffc7fffffff000
IP: [<ffffffff8106aa51>] ptdump_show+0x221/0x480
PGD 0
Oops: 0000 [#1] SMP
CPU 0
.. snip..
RAX: 0000000000000000 RBX: ffffc00000000fff RCX: 0000000000000000
RDX: 0000800000000000 RSI: 0000000000000000 RDI: ffffc7fffffff000

which is due to the fact we are trying to access a PFN that is not
accessible to us. The reason (at least in this case) was that
PGD[256] is set to __HYPERVISOR_VIRT_START which setup (by the
hypervisor) to point to a read-only linear map of the MFN->PFN array.
During our parsing we would get the MFN (a valid one), try to look
it up in the MFN->PFN tree and find it invalid and return ~0 as PFN.
Then pte_mfn_to_pfn would happilly feed that in, attach the flags
and return it back to the caller. In this case the ptdump_show
bitshifts it and we get this invalid value.

Instead of doing all of that, we detect the ~0 case and just return
!_PAGE_PRESENT.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/mmu.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index b8e2794..69f5857 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -353,8 +353,13 @@ static pteval_t pte_mfn_to_pfn(pteval_t val)
 {
 	if (val & _PAGE_PRESENT) {
 		unsigned long mfn = (val & PTE_PFN_MASK) >> PAGE_SHIFT;
+		unsigned long pfn = mfn_to_pfn(mfn);
+
 		pteval_t flags = val & PTE_FLAGS_MASK;
-		val = ((pteval_t)mfn_to_pfn(mfn) << PAGE_SHIFT) | flags;
+		if (unlikely(pfn == ~0))
+			val = flags & ~_PAGE_PRESENT;
+		else
+			val = ((pteval_t)pfn << PAGE_SHIFT) | flags;
 	}
 
 	return val;
-- 
1.7.7.5

