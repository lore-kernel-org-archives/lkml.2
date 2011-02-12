Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753124Ab1BLIPs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Feb 2011 03:15:48 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:52155 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676Ab1BLIOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Feb 2011 03:14:47 -0500
Subject: [PATCH v3 3/6] arm/dt: consolidate atags setup into
	setup_machine_atags
To: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
From: Grant Likely <grant.likely@secretlab.ca>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Rob Herring <robherring2@gmail.com>, Olof Johansson <olof@lixom.net>,
        Jeremy Kerr <jeremy.kerr@canonical.com>, john.linn@xilinx.com,
        buytenh@wantstofly.org
Date: Sat, 12 Feb 2011 01:14:42 -0700
Message-ID: <20110212081442.15682.82412.stgit@localhost6.localdomain6>
In-Reply-To: <20110212080634.15682.21141.stgit@localhost6.localdomain6>
References: <20110212080634.15682.21141.stgit@localhost6.localdomain6>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In preparation for adding device tree support, this patch consolidates
all of the atag-specific setup into a single function.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---
 arch/arm/kernel/setup.c |   68 ++++++++++++++++++++++++-----------------------
 1 files changed, 35 insertions(+), 33 deletions(-)

diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
index 0c692c7..7bc7a27 100644
--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -461,25 +461,6 @@ void cpu_init(void)
 	    : "r14");
 }
 
-static struct machine_desc * __init setup_machine(unsigned int nr)
-{
-	struct machine_desc *list;
-
-	/*
-	 * locate machine in the list of supported machines.
-	 */
-	list = lookup_machine_type(nr);
-	if (!list) {
-		printk("Machine configuration botched (nr %d), unable "
-		       "to continue.\n", nr);
-		while (1);
-	}
-
-	printk("Machine: %s\n", list->name);
-
-	return list;
-}
-
 int __init arm_add_memory(unsigned long start, unsigned long size)
 {
 	struct membank *bank = &meminfo.bank[meminfo.nr_banks];
@@ -833,21 +814,23 @@ static void __init squash_mem_tags(struct tag *tag)
 			tag->hdr.tag = ATAG_NONE;
 }
 
-void __init setup_arch(char **cmdline_p)
+static struct machine_desc * __init setup_machine_tags(unsigned int nr)
 {
 	struct tag *tags = (struct tag *)&init_tags;
 	struct machine_desc *mdesc;
 	char *from = default_command_line;
 
-	unwind_init();
-
-	setup_processor();
-	mdesc = setup_machine(machine_arch_type);
-	machine_desc = mdesc;
-	machine_name = mdesc->name;
+	/*
+	 * locate machine in the list of supported machines.
+	 */
+	mdesc = lookup_machine_type(nr);
+	if (!mdesc) {
+		printk("Machine configuration botched (nr %d), unable "
+		       "to continue.\n", nr);
+		while (1);
+	}
 
-	if (mdesc->soft_reboot)
-		reboot_setup("s");
+	printk("Machine: %s\n", mdesc->name);
 
 	if (__atags_pointer)
 		tags = phys_to_virt(__atags_pointer);
@@ -875,16 +858,35 @@ void __init setup_arch(char **cmdline_p)
 		parse_tags(tags);
 	}
 
-	init_mm.start_code = (unsigned long) _text;
-	init_mm.end_code   = (unsigned long) _etext;
-	init_mm.end_data   = (unsigned long) _edata;
-	init_mm.brk	   = (unsigned long) _end;
-
 	/* parse_early_param needs a boot_command_line */
 	strlcpy(boot_command_line, from, COMMAND_LINE_SIZE);
 
 	/* populate cmd_line too for later use, preserving boot_command_line */
 	strlcpy(cmd_line, boot_command_line, COMMAND_LINE_SIZE);
+
+	return mdesc;
+}
+
+
+void __init setup_arch(char **cmdline_p)
+{
+	struct machine_desc *mdesc;
+
+	unwind_init();
+
+	setup_processor();
+	mdesc = setup_machine_tags(machine_arch_type);
+	machine_desc = mdesc;
+	machine_name = mdesc->name;
+
+	if (mdesc->soft_reboot)
+		reboot_setup("s");
+
+	init_mm.start_code = (unsigned long) _text;
+	init_mm.end_code   = (unsigned long) _etext;
+	init_mm.end_data   = (unsigned long) _edata;
+	init_mm.brk	   = (unsigned long) _end;
+
 	*cmdline_p = cmd_line;
 
 	parse_early_param();

