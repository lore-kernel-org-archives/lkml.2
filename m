Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756628Ab0DIGJd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 02:09:33 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:19180 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756536Ab0DIGJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 02:09:28 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 34/39] x86: Use walk_system_ream_range() instead of referring e820.map directly for tboot
Date: Thu,  8 Apr 2010 23:04:03 -0700
Message-Id: <1270793048-23796-35-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1270793048-23796-1-git-send-email-yinghai@kernel.org>
References: <1270793048-23796-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4BBEC45F.0077,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So we can make e820 to be __initdata

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/kernel/tboot.c |   22 +++++++++-------------
 1 files changed, 9 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kernel/tboot.c b/arch/x86/kernel/tboot.c
index cc2c604..cf27d64 100644
--- a/arch/x86/kernel/tboot.c
+++ b/arch/x86/kernel/tboot.c
@@ -170,34 +170,30 @@ static void tboot_create_trampoline(void)
 
 #ifdef CONFIG_ACPI_SLEEP
 
-static void add_mac_region(phys_addr_t start, unsigned long size)
+static int
+add_mac_region(unsigned long start_pfn, unsigned long nr_pages, void  *arg)
 {
+	u64 start = start_pfn;
+	u64 size = nr_pages;
 	struct tboot_mac_region *mr;
-	phys_addr_t end = start + size;
 
 	if (tboot->num_mac_regions >= MAX_TB_MAC_REGIONS)
 		panic("tboot: Too many MAC regions\n");
 
 	if (start && size) {
 		mr = &tboot->mac_regions[tboot->num_mac_regions++];
-		mr->start = round_down(start, PAGE_SIZE);
-		mr->size  = round_up(end, PAGE_SIZE) - mr->start;
+		mr->start = start << PAGE_SHIFT;
+		mr->size  = (u32) (size << PAGE_SHIFT);
 	}
+
+	return 0;
 }
 
 static int tboot_setup_sleep(void)
 {
-	int i;
-
 	tboot->num_mac_regions = 0;
 
-	for (i = 0; i < e820.nr_map; i++) {
-		if ((e820.map[i].type != E820_RAM)
-		 && (e820.map[i].type != E820_RESERVED_KERN))
-			continue;
-
-		add_mac_region(e820.map[i].addr, e820.map[i].size);
-	}
+	walk_system_ram_range(0, max_pfn, NULL, add_mac_region);
 
 	tboot->acpi_sinfo.kernel_s3_resume_vector = acpi_wakeup_address;
 
-- 
1.6.4.2

