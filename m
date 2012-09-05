Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758168Ab2IEFrl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 01:47:41 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:20563 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758174Ab2IEFrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 01:47:23 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH -v3 14/14] x86, mm: Map ISA area with connected ram range at the same time
Date: Tue,  4 Sep 2012 22:46:31 -0700
Message-Id: <1346823991-22911-15-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1346823991-22911-1-git-send-email-yinghai@kernel.org>
References: <1346823991-22911-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

so could reduce one loop.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/mm/init.c |   21 ++++++++++++++-------
 1 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 6663f61..e69f832 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -248,20 +248,27 @@ static void __init walk_ram_ranges(
 			void *data)
 {
 	unsigned long start_pfn, end_pfn;
+	bool isa_done = false;
 	int i;
 
-	/* the ISA range is always mapped regardless of memory holes */
-	work_fn(0, ISA_END_ADDRESS, data);
-
 	for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, NULL) {
 		u64 start = start_pfn << PAGE_SHIFT;
 		u64 end = end_pfn << PAGE_SHIFT;
 
-		if (end <= ISA_END_ADDRESS)
-			continue;
+		if (!isa_done && start > ISA_END_ADDRESS) {
+			work_fn(0, ISA_END_ADDRESS, data);
+			isa_done = true;
+		} else {
+			if (end < ISA_END_ADDRESS)
+				continue;
+
+			if (start <= ISA_END_ADDRESS &&
+			    end >= ISA_END_ADDRESS) {
+				start = 0;
+				isa_done = true;
+			}
+		}
 
-		if (start < ISA_END_ADDRESS)
-			start = ISA_END_ADDRESS;
 #ifdef CONFIG_X86_32
 		/* on 32 bit, we only map up to max_low_pfn */
 		if ((start >> PAGE_SHIFT) >= max_low_pfn)
-- 
1.7.7

