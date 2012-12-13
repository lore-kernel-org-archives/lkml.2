Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932227Ab2LMWJ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 17:09:29 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:26642 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756464Ab2LMWCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 17:02:49 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v6 01/27] x86, mm: Fix page table early allocation offset checking
Date: Thu, 13 Dec 2012 14:01:55 -0800
Message-Id: <1355436141-8668-2-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1355436141-8668-1-git-send-email-yinghai@kernel.org>
References: <1355436141-8668-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During debug load kernel above 4G, found one page if is not used in BRK
and it should be with early page allocation.

Fix that checking and also add print out for every allocation from BRK
page table allocation.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/mm/init.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 6f85de8..c4293cf 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -47,7 +47,7 @@ __ref void *alloc_low_pages(unsigned int num)
 						__GFP_ZERO, order);
 	}
 
-	if ((pgt_buf_end + num) >= pgt_buf_top) {
+	if ((pgt_buf_end + num) > pgt_buf_top) {
 		unsigned long ret;
 		if (min_pfn_mapped >= max_pfn_mapped)
 			panic("alloc_low_page: ran out of memory");
@@ -61,6 +61,8 @@ __ref void *alloc_low_pages(unsigned int num)
 	} else {
 		pfn = pgt_buf_end;
 		pgt_buf_end += num;
+		printk(KERN_DEBUG "BRK [%#010lx, %#010lx] PGTABLE\n",
+			pfn << PAGE_SHIFT, (pgt_buf_end << PAGE_SHIFT) - 1);
 	}
 
 	for (i = 0; i < num; i++) {
-- 
1.7.10.4

