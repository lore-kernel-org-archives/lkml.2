Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755469Ab1BVUIO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 15:08:14 -0500
Received: from www.tglx.de ([62.245.132.106]:38433 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753177Ab1BVUIL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 15:08:11 -0500
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-kernel@vger.kernel.org
Cc: sodaville@linutronix.de, devicetree-discuss@lists.ozlabs.org,
        x86@kernel.org, Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Dirk Brandewie <dirk.brandewie@gmail.com>
Subject: [PATCH 01/11] x86/e820: remove conditional early mapping in parse_e820_ext
Date: Tue, 22 Feb 2011 21:07:36 +0100
Message-Id: <1298405266-1624-2-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1298405266-1624-1-git-send-email-bigeasy@linutronix.de>
References: <1298405266-1624-1-git-send-email-bigeasy@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch ensures that the memory passed from parse_setup_data() is
large enough to cover the complete data structure. That means that the
conditional mapping in parse_e820_ext() can go.

While here, I also attempt not to map two pages if the address is not
aligned to a page boundary.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Dirk Brandewie <dirk.brandewie@gmail.com>
---
 arch/x86/include/asm/e820.h |    2 +-
 arch/x86/kernel/e820.c      |    8 +-------
 arch/x86/kernel/setup.c     |   18 +++++++++++++++---
 3 files changed, 17 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/e820.h b/arch/x86/include/asm/e820.h
index e99d55d..908b969 100644
--- a/arch/x86/include/asm/e820.h
+++ b/arch/x86/include/asm/e820.h
@@ -96,7 +96,7 @@ extern void e820_setup_gap(void);
 extern int e820_search_gap(unsigned long *gapstart, unsigned long *gapsize,
 			unsigned long start_addr, unsigned long long end_addr);
 struct setup_data;
-extern void parse_e820_ext(struct setup_data *data, unsigned long pa_data);
+extern void parse_e820_ext(struct setup_data *data);
 
 #if defined(CONFIG_X86_64) || \
 	(defined(CONFIG_X86_32) && defined(CONFIG_HIBERNATION))
diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index 294f26d..5fad626 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -667,21 +667,15 @@ __init void e820_setup_gap(void)
  * boot_params.e820_map, others are passed via SETUP_E820_EXT node of
  * linked list of struct setup_data, which is parsed here.
  */
-void __init parse_e820_ext(struct setup_data *sdata, unsigned long pa_data)
+void __init parse_e820_ext(struct setup_data *sdata)
 {
-	u32 map_len;
 	int entries;
 	struct e820entry *extmap;
 
 	entries = sdata->len / sizeof(struct e820entry);
-	map_len = sdata->len + sizeof(struct setup_data);
-	if (map_len > PAGE_SIZE)
-		sdata = early_ioremap(pa_data, map_len);
 	extmap = (struct e820entry *)(sdata->data);
 	__append_e820_map(extmap, entries);
 	sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &e820.nr_map);
-	if (map_len > PAGE_SIZE)
-		early_iounmap(sdata, map_len);
 	printk(KERN_INFO "extended physical RAM map:\n");
 	e820_print_map("extended");
 }
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index ca2f106..96cdb9c 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -429,16 +429,28 @@ static void __init parse_setup_data(void)
 		return;
 	pa_data = boot_params.hdr.setup_data;
 	while (pa_data) {
-		data = early_memremap(pa_data, PAGE_SIZE);
+		u32 data_len;
+		u32 map_len;
+
+		map_len = max(PAGE_SIZE - (pa_data & ~PAGE_MASK),
+				(u64)sizeof(struct setup_data));
+		data = early_memremap(pa_data, map_len);
+		data_len = data->len + sizeof(struct setup_data);
+		if (data_len > map_len) {
+			early_iounmap(data, map_len);
+			data = early_memremap(pa_data, data_len);
+			map_len = data_len;
+		}
+
 		switch (data->type) {
 		case SETUP_E820_EXT:
-			parse_e820_ext(data, pa_data);
+			parse_e820_ext(data);
 			break;
 		default:
 			break;
 		}
 		pa_data = data->next;
-		early_iounmap(data, PAGE_SIZE);
+		early_iounmap(data, map_len);
 	}
 }
 
-- 
1.7.4

