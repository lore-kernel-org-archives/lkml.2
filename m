Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749Ab2K1Hvf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 02:51:35 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:40433 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752668Ab2K1Hvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 02:51:31 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v5 13/13] x86, mm: Fix page table early allocation offset checking
Date: Tue, 27 Nov 2012 23:50:42 -0800
Message-Id: <1354089042-10023-14-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1354089042-10023-1-git-send-email-yinghai@kernel.org>
References: <1354089042-10023-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
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
 1 files changed, 3 insertions(+), 1 deletions(-)

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
1.7.7

