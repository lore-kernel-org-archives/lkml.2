Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756285Ab0ENTuj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 15:50:39 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:17892 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757054Ab0ENTub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 15:50:31 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 36/37] x86: Use walk_system_ream_range() instead of referring e820.map directly for tboot
Date: Fri, 14 May 2010 12:46:02 -0700
Message-Id: <1273866363-14249-37-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1273866363-14249-1-git-send-email-yinghai@kernel.org>
References: <1273866363-14249-1-git-send-email-yinghai@kernel.org>
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090201.4BEDA952.0068,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So we can make e820 to be __initdata

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/kernel/tboot.c |   22 +++++++++-------------
 1 files changed, 9 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kernel/tboot.c b/arch/x86/kernel/tboot.c
index c2f1b26..20b9531 100644
--- a/arch/x86/kernel/tboot.c
+++ b/arch/x86/kernel/tboot.c
@@ -171,34 +171,30 @@ static void tboot_create_trampoline(void)
 
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

