Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754492Ab0ENAY0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 20:24:26 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:53622 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754315Ab0ENAYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 20:24:20 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 29/35] x86: Change e820_saved to __initdata
Date: Thu, 13 May 2010 17:19:50 -0700
Message-Id: <1273796396-29649-30-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1273796396-29649-1-git-send-email-yinghai@kernel.org>
References: <1273796396-29649-1-git-send-email-yinghai@kernel.org>
X-Auth-Type: Internal IP
X-Source-IP: rcsinet13.oracle.com [148.87.113.125]
X-CT-RefId: str=0001.0A090202.4BEC97CC.006C,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

for 2.6.34

Add save_e820_map() and change e820_saved to static
also make it to be __initdata to get some bytes memory back.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/include/asm/e820.h |    2 +-
 arch/x86/kernel/e820.c      |    9 +++++++--
 arch/x86/kernel/setup.c     |    2 +-
 3 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/e820.h b/arch/x86/include/asm/e820.h
index 25962e1..334281f 100644
--- a/arch/x86/include/asm/e820.h
+++ b/arch/x86/include/asm/e820.h
@@ -75,7 +75,6 @@ struct e820map {
 #ifdef __KERNEL__
 /* see comment in arch/x86/kernel/e820.c */
 extern struct e820map e820;
-extern struct e820map e820_saved;
 
 extern unsigned long pci_mem_start;
 extern int e820_any_mapped(u64 start, u64 end, unsigned type);
@@ -83,6 +82,7 @@ extern int e820_all_mapped(u64 start, u64 end, unsigned type);
 extern void e820_add_region(u64 start, u64 size, int type);
 extern void e820_print_map(char *who);
 int sanitize_e820_map(void);
+void save_e820_map(void);
 extern u64 e820_update_range(u64 start, u64 size, unsigned old_type,
 			       unsigned new_type);
 extern u64 e820_remove_range(u64 start, u64 size, unsigned old_type,
diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index 416acee..4bbbd6b 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -36,7 +36,7 @@
  * next kernel with full memory.
  */
 struct e820map e820;
-struct e820map e820_saved;
+static struct e820map __initdata e820_saved;
 
 /* For PCI or other memory-mapped resources */
 unsigned long pci_mem_start = 0xaeedbabe;
@@ -1072,12 +1072,17 @@ char *__init default_machine_specific_memory_setup(void)
 	return who;
 }
 
+void __init save_e820_map(void)
+{
+	memcpy(&e820_saved, &e820, sizeof(struct e820map));
+}
+
 void __init setup_memory_map(void)
 {
 	char *who;
 
 	who = x86_init.resources.memory_setup();
-	memcpy(&e820_saved, &e820, sizeof(struct e820map));
+	save_e820_map();
 	printk(KERN_INFO "BIOS-provided physical RAM map:\n");
 	e820_print_map(who);
 }
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 9d9890c..9083c9a 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -463,7 +463,7 @@ static void __init e820_reserve_setup_data(void)
 		return;
 
 	sanitize_e820_map();
-	memcpy(&e820_saved, &e820, sizeof(struct e820map));
+	save_e820_map();
 	printk(KERN_INFO "extended physical RAM map:\n");
 	e820_print_map("reserve setup_data");
 }
-- 
1.6.4.2

