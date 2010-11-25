Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754665Ab0KYRn6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 12:43:58 -0500
Received: from www.tglx.de ([62.245.132.106]:50934 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754609Ab0KYRnx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 12:43:53 -0500
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-kernel@vger.kernel.org
Cc: sodaville@linutronix.de, x86@kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Dirk Brandewie <dirk.brandewie@gmail.com>
Subject: [PATCH 01/11] x86/kernel: remove conditional early remap in parse_e820_ext
Date: Thu, 25 Nov 2010 18:39:51 +0100
Message-Id: <1290706801-7323-2-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1290706801-7323-1-git-send-email-bigeasy@linutronix.de>
References: <1290706801-7323-1-git-send-email-bigeasy@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

parse_setup_data() uses early_memremap() for a PAGE_SIZE mapping in
order to figure out the type & size. If this mapping is not large enough
then parse_e820_ext() will remap this area again via early_ioremap()
since the first mapping is still in use.

This patch attempts to simplify the handling and parse_e820_ext() does
not need to worry about the mapping anymore.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: x86@kernel.org
Signed-off-by: Dirk Brandewie <dirk.brandewie@gmail.com>
---
 arch/x86/include/asm/e820.h |    2 +-
 arch/x86/kernel/e820.c      |    8 +-------
 arch/x86/kernel/setup.c     |   11 +++++++++--
 3 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/e820.h b/arch/x86/include/asm/e820.h
index 5be1542..e956492 100644
--- a/arch/x86/include/asm/e820.h
+++ b/arch/x86/include/asm/e820.h
@@ -93,7 +93,7 @@ extern void e820_setup_gap(void);
 extern int e820_search_gap(unsigned long *gapstart, unsigned long *gapsize,
 			unsigned long start_addr, unsigned long long end_addr);
 struct setup_data;
-extern void parse_e820_ext(struct setup_data *data, unsigned long pa_data);
+extern void parse_e820_ext(struct setup_data *data);
 
 #if defined(CONFIG_X86_64) || \
 	(defined(CONFIG_X86_32) && defined(CONFIG_HIBERNATION))
diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index 0c2b7ef..33f6361 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -666,21 +666,15 @@ __init void e820_setup_gap(void)
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
index 000e4a1..52f10e6 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -429,16 +429,23 @@ static void __init parse_setup_data(void)
 		return;
 	pa_data = boot_params.hdr.setup_data;
 	while (pa_data) {
+		u32 len;
+
 		data = early_memremap(pa_data, PAGE_SIZE);
+		len = data->len + sizeof(struct setup_data);
+		early_iounmap(data, PAGE_SIZE);
+
+		data = early_memremap(pa_data, len);
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
+		early_iounmap(data, len);
 	}
 }
 
-- 
1.7.3.2

