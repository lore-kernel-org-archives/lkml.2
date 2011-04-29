Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753201Ab1D2GMn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 02:12:43 -0400
Received: from mail-px0-f173.google.com ([209.85.212.173]:60344 "EHLO
	mail-px0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673Ab1D2GMm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 02:12:42 -0400
Subject: [PATCH] dt/flattree: explicitly pass command line pointer to
 early_init_dt_scan_chosen
To: devicetree-discuss@lists.ozlabs.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michal Simek <monstr@monstr.eu>, linux-kernel@vger.kernel.org,
        Ralf Baechle <ralf@linux-mips.org>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 29 Apr 2011 00:12:40 -0600
Message-ID: <20110429061240.16435.77158.stgit@ponder>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch drops the reference to a global 'cmd_line' variable from
early_init_dt_scan_chosen, and instead passes the pointer to the command
line string via the *data argument.  Each architecture does something
slightly different with the initial command line, so it makes sense for
the architecture to be able to specify the variable name.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---
 arch/microblaze/kernel/prom.c |    2 +-
 arch/mips/include/asm/prom.h  |    3 ---
 arch/mips/kernel/prom.c       |    3 ++-
 arch/powerpc/kernel/prom.c    |    2 +-
 drivers/of/fdt.c              |    8 ++++----
 5 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/arch/microblaze/kernel/prom.c b/arch/microblaze/kernel/prom.c
index 00ee90f..b15cc21 100644
--- a/arch/microblaze/kernel/prom.c
+++ b/arch/microblaze/kernel/prom.c
@@ -130,7 +130,7 @@ void __init early_init_devtree(void *params)
 	 * device-tree, including the platform type, initrd location and
 	 * size, TCE reserve, and more ...
 	 */
-	of_scan_flat_dt(early_init_dt_scan_chosen, NULL);
+	of_scan_flat_dt(early_init_dt_scan_chosen, cmd_line);
 
 	/* Scan memory nodes and rebuild MEMBLOCKs */
 	memblock_init();
diff --git a/arch/mips/include/asm/prom.h b/arch/mips/include/asm/prom.h
index f29b862..857d9b7 100644
--- a/arch/mips/include/asm/prom.h
+++ b/arch/mips/include/asm/prom.h
@@ -14,9 +14,6 @@
 #ifdef CONFIG_OF
 #include <asm/bootinfo.h>
 
-/* which is compatible with the flattened device tree (FDT) */
-#define cmd_line arcs_cmdline
-
 extern int early_init_dt_scan_memory_arch(unsigned long node,
 	const char *uname, int depth, void *data);
 
diff --git a/arch/mips/kernel/prom.c b/arch/mips/kernel/prom.c
index 0b82f98..010aaaf 100644
--- a/arch/mips/kernel/prom.c
+++ b/arch/mips/kernel/prom.c
@@ -69,7 +69,8 @@ void __init early_init_devtree(void *params)
 	 * device-tree, including the platform type, initrd location and
 	 * size, and more ...
 	 */
-	of_scan_flat_dt(early_init_dt_scan_chosen, NULL);
+	of_scan_flat_dt(early_init_dt_scan_chosen, arcs_cmdline);
+
 
 	/* Scan memory nodes */
 	of_scan_flat_dt(early_init_dt_scan_root, NULL);
diff --git a/arch/powerpc/kernel/prom.c b/arch/powerpc/kernel/prom.c
index e74fa12..c173bee 100644
--- a/arch/powerpc/kernel/prom.c
+++ b/arch/powerpc/kernel/prom.c
@@ -691,7 +691,7 @@ void __init early_init_devtree(void *params)
 	 * device-tree, including the platform type, initrd location and
 	 * size, TCE reserve, and more ...
 	 */
-	of_scan_flat_dt(early_init_dt_scan_chosen_ppc, NULL);
+	of_scan_flat_dt(early_init_dt_scan_chosen_ppc, cmd_line);
 
 	/* Scan memory nodes and rebuild MEMBLOCKs */
 	memblock_init();
diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
index 8b63a69..65200af 100644
--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -670,7 +670,7 @@ int __init early_init_dt_scan_chosen(unsigned long node, const char *uname,
 
 	pr_debug("search \"chosen\", depth: %d, uname: %s\n", depth, uname);
 
-	if (depth != 1 ||
+	if (depth != 1 || !data ||
 	    (strcmp(uname, "chosen") != 0 && strcmp(uname, "chosen@0") != 0))
 		return 0;
 
@@ -679,16 +679,16 @@ int __init early_init_dt_scan_chosen(unsigned long node, const char *uname,
 	/* Retrieve command line */
 	p = of_get_flat_dt_prop(node, "bootargs", &l);
 	if (p != NULL && l > 0)
-		strlcpy(cmd_line, p, min((int)l, COMMAND_LINE_SIZE));
+		strlcpy(data, p, min((int)l, COMMAND_LINE_SIZE));
 
 #ifdef CONFIG_CMDLINE
 #ifndef CONFIG_CMDLINE_FORCE
 	if (p == NULL || l == 0 || (l == 1 && (*p) == 0))
 #endif
-		strlcpy(cmd_line, CONFIG_CMDLINE, COMMAND_LINE_SIZE);
+		strlcpy(data, CONFIG_CMDLINE, COMMAND_LINE_SIZE);
 #endif /* CONFIG_CMDLINE */
 
-	pr_debug("Command line is: %s\n", cmd_line);
+	pr_debug("Command line is: %s\n", (char*)data);
 
 	/* break now */
 	return 1;

