Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754961Ab0DIGHK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 02:07:10 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:25736 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806Ab0DIGHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 02:07:05 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 03/39] x86: Align e820 ram range to page
Date: Thu,  8 Apr 2010 23:03:32 -0700
Message-Id: <1270793048-23796-4-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1270793048-23796-1-git-send-email-yinghai@kernel.org>
References: <1270793048-23796-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4BBEC3E2.00EB,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

to workaround wrong BIOS memory map.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/kernel/e820.c |   44 ++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 44 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index 14d0a1a..73dc6a7 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -1044,6 +1044,47 @@ static int __init parse_memmap_opt(char *p)
 }
 early_param("memmap", parse_memmap_opt);
 
+static void __init e820_align_ram_page(void)
+{
+	int i;
+	bool changed = false;;
+
+	for (i = 0; i < e820.nr_map; i++) {
+		struct e820entry *entry = &e820.map[i];
+		u64 start, end;
+		u64 start_aligned, end_aligned;
+
+		if (entry->type != E820_RAM)
+			continue;
+
+		start = entry->addr;
+		end = start + entry->size;
+
+		start_aligned = round_up(start, PAGE_SIZE);
+		end_aligned = round_down(end, PAGE_SIZE);
+
+		if (end_aligned <= start_aligned) {
+			e820_update_range(start, end - start, E820_RAM, E820_RESERVED);
+			changed = true;
+			continue;
+		}
+		if (start < start_aligned) {
+			e820_update_range(start, start_aligned - start, E820_RAM, E820_RESERVED);
+			changed = true;
+		}
+		if (end_aligned < end) {
+			e820_update_range(end_aligned, end - end_aligned, E820_RAM, E820_RESERVED);
+			changed = true;
+		}
+	}
+
+	if (changed) {
+		sanitize_e820_map();
+		printk(KERN_INFO "aligned physical RAM map:\n");
+		e820_print_map("aligned");
+	}
+}
+
 void __init finish_e820_parsing(void)
 {
 	if (userdef) {
@@ -1056,6 +1097,9 @@ void __init finish_e820_parsing(void)
 		printk(KERN_INFO "user-defined physical RAM map:\n");
 		e820_print_map("user");
 	}
+
+	/* In case, We have RAM entres that are not PAGE aligned */
+	e820_align_ram_page();
 }
 
 static inline const char *e820_type_to_string(int e820_type)
-- 
1.6.4.2

