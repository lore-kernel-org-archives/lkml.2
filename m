Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752312Ab0CZQla (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 12:41:30 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:3965 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950Ab0CZQl3 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:2:1>);
	Fri, 26 Mar 2010 12:41:29 -0400
Message-Id: <4BACF1CB020000780003737A@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Fri, 26 Mar 2010 16:41:31 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: <yinghai@kernel.org>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] fix allocation done in get_free_all_memory_range()
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Even when get_max_mapped() returns a value beyond the DMA32 range,
this can't be taken to mean an alocation from that range will succeed.
Hence, the code should still fall back to an allocation starting at
the bottom of memory if the first one failed.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 kernel/early_res.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- linux-2.6.34-rc2/kernel/early_res.c	2010-03-25 15:23:45.000000000 +0100
+++ 2.6.34-rc2-get_free_all_memory_range-retry-alloc/kernel/early_res.c	2010-03-26 14:49:41.000000000 +0100
@@ -387,9 +387,7 @@ static void __init subtract_early_res(st
 int __init get_free_all_memory_range(struct range **rangep, int nodeid)
 {
 	int i, count;
-	u64 start = 0, end;
-	u64 size;
-	u64 mem;
+	u64 end, size, mem = -1ULL;
 	struct range *range;
 	int nr_range;
 
@@ -403,9 +401,11 @@ int __init get_free_all_memory_range(str
 	end = get_max_mapped();
 #ifdef MAX_DMA32_PFN
 	if (end > (MAX_DMA32_PFN << PAGE_SHIFT))
-		start = MAX_DMA32_PFN << PAGE_SHIFT;
+		mem = find_fw_memmap_area(MAX_DMA32_PFN << PAGE_SHIFT, end,
+					  size, sizeof(struct range));
 #endif
-	mem = find_fw_memmap_area(start, end, size, sizeof(struct range));
+	if (mem == -1ULL)
+		mem = find_fw_memmap_area(0, end, size, sizeof(struct range));
 	if (mem == -1ULL)
 		panic("can not find more space for range free");
 



