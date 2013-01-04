Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755457Ab3ADA4H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 19:56:07 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:26720 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754386Ab3ADAtc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 19:49:32 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Jan Kiszka <jan.kiszka@web.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v7u1 01/31] x86, mm: Fix page table early allocation offset checking
Date: Thu,  3 Jan 2013 16:48:21 -0800
Message-Id: <1357260531-11115-2-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1357260531-11115-1-git-send-email-yinghai@kernel.org>
References: <1357260531-11115-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During debugging loading kernel above 4G, found one page if is not used
in BRK with early page allocation.

pgt_buf_top is address that can not be used, so should check if that new
end is above that top, otherwise last page will not be used.

Fix that checking and also add print out for every allocation from BRK.

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

