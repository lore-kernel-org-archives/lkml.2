Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752859Ab0ENA2w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 20:28:52 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:53039 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754050Ab0ENAYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 20:24:09 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 30/35] x86: Align e820 ram range to page
Date: Thu, 13 May 2010 17:19:51 -0700
Message-Id: <1273796396-29649-31-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1273796396-29649-1-git-send-email-yinghai@kernel.org>
References: <1273796396-29649-1-git-send-email-yinghai@kernel.org>
X-Auth-Type: Internal IP
X-Source-IP: rcsinet13.oracle.com [148.87.113.125]
X-CT-RefId: str=0001.0A090203.4BEC97CA.00E2,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

for 2.6.34

To workaround wrong BIOS memory map.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/kernel/e820.c |   44 ++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 44 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index 4bbbd6b..78ca7ce 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -910,6 +910,47 @@ static int __init parse_memmap_opt(char *p)
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
@@ -922,6 +963,9 @@ void __init finish_e820_parsing(void)
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

