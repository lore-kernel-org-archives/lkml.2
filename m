Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753759Ab1BEOXi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 09:23:38 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52225 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753659Ab1BEOXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 09:23:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=JmBfujaF0WTqSySClSpr9nDF76t0qb15Ya4iaq/dBTQjutDMACglbpFUk4Ezwp+rc5
         AjdIZw1Mkdth7ASdsG9nktJzqOFEA5ogvg4erK5XOeUL6wS2TB+gNXZIISDA0RvubM/a
         J3Mzv3DQTb+bzYWMg/3Eb493GaUjUabLRjsHY=
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, adobriyan@gmail.com
Subject: [PATCH 50/52] kstrtox: convert tile
Date: Sat,  5 Feb 2011 16:20:53 +0200
Message-Id: <1296915654-7458-50-git-send-email-adobriyan@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1296915654-7458-1-git-send-email-adobriyan@gmail.com>
References: <1296915654-7458-1-git-send-email-adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 arch/tile/kernel/setup.c       |   15 ++++++++-------
 arch/tile/kernel/single_step.c |    4 +---
 arch/tile/kernel/traps.c       |    4 +---
 arch/tile/mm/init.c            |    9 +++------
 4 files changed, 13 insertions(+), 19 deletions(-)

diff --git a/arch/tile/kernel/setup.c b/arch/tile/kernel/setup.c
index f185736..cf3f155 100644
--- a/arch/tile/kernel/setup.c
+++ b/arch/tile/kernel/setup.c
@@ -101,8 +101,9 @@ unsigned long __initdata pci_reserve_end_pfn = -1U;
 
 static int __init setup_maxmem(char *str)
 {
-	long maxmem_mb;
-	if (str == NULL || strict_strtol(str, 0, &maxmem_mb) != 0 ||
+	unsigned int maxmem_mb;
+
+	if (str == NULL || kstrtouint(str, 0, &maxmem_mb) != 0 ||
 	    maxmem_mb == 0)
 		return -EINVAL;
 
@@ -117,16 +118,16 @@ early_param("maxmem", setup_maxmem);
 static int __init setup_maxnodemem(char *str)
 {
 	char *endp;
-	long maxnodemem_mb, node;
+	unsigned int maxnodemem_mb, node;
 
 	node = str ? simple_strtoul(str, &endp, 0) : INT_MAX;
 	if (node >= MAX_NUMNODES || *endp != ':' ||
-	    strict_strtol(endp+1, 0, &maxnodemem_mb) != 0)
+	    kstrtouint(endp+1, 0, &maxnodemem_mb) != 0)
 		return -EINVAL;
 
 	maxnodemem_pfn[node] = (maxnodemem_mb >> (HPAGE_SHIFT - 20)) <<
 		(HPAGE_SHIFT - PAGE_SHIFT);
-	pr_info("Forcing RAM used on node %ld to no more than %dMB\n",
+	pr_info("Forcing RAM used on node %u to no more than %uMB\n",
 	       node, maxnodemem_pfn[node] >> (20 - PAGE_SHIFT));
 	return 0;
 }
@@ -147,9 +148,9 @@ early_param("isolnodes", setup_isolnodes);
 #ifdef CONFIG_PCI
 static int __init setup_pci_reserve(char* str)
 {
-	unsigned long mb;
+	unsigned int mb;
 
-	if (str == NULL || strict_strtoul(str, 0, &mb) != 0 ||
+	if (str == NULL || kstrtouint(str, 0, &mb) != 0 ||
 	    mb > 3 * 1024)
 		return -EINVAL;
 
diff --git a/arch/tile/kernel/single_step.c b/arch/tile/kernel/single_step.c
index 1eb3b39..1e7bb00 100644
--- a/arch/tile/kernel/single_step.c
+++ b/arch/tile/kernel/single_step.c
@@ -36,10 +36,8 @@ int unaligned_printk;
 
 static int __init setup_unaligned_printk(char *str)
 {
-	long val;
-	if (strict_strtol(str, 0, &val) != 0)
+	if (kstrtoint(str, 0, &unaligned_printk) != 0)
 		return 0;
-	unaligned_printk = val;
 	pr_info("Printk for each unaligned data accesses is %s\n",
 		unaligned_printk ? "enabled" : "disabled");
 	return 1;
diff --git a/arch/tile/kernel/traps.c b/arch/tile/kernel/traps.c
index 5474fc2..e7e1319 100644
--- a/arch/tile/kernel/traps.c
+++ b/arch/tile/kernel/traps.c
@@ -41,10 +41,8 @@ static int __init setup_unaligned_fixup(char *str)
 	 * will still parse the instruction, then fire a SIGBUS with
 	 * the correct address from inside the single_step code.
 	 */
-	long val;
-	if (strict_strtol(str, 0, &val) != 0)
+	if (kstrtoint(str, 0, &unaligned_fixup) != 0)
 		return 0;
-	unaligned_fixup = val;
 	pr_info("Fixups for unaligned data accesses are %s\n",
 	       unaligned_fixup >= 0 ?
 	       (unaligned_fixup ? "enabled" : "disabled") :
diff --git a/arch/tile/mm/init.c b/arch/tile/mm/init.c
index 0b9ce69..8339a64 100644
--- a/arch/tile/mm/init.c
+++ b/arch/tile/mm/init.c
@@ -988,12 +988,9 @@ static long __write_once initfree = 1;
 /* Select whether to free (1) or mark unusable (0) the __init pages. */
 static int __init set_initfree(char *str)
 {
-	long val;
-	if (strict_strtol(str, 0, &val)) {
-		initfree = val;
-		pr_info("initfree: %s free init pages\n",
-			initfree ? "will" : "won't");
-	}
+	if (kstrtoint(str, 0, &initfree) < 0)
+		return 0;
+	pr_info("initfree: %s free init pages\n", initfree ? "will" : "won't");
 	return 1;
 }
 __setup("initfree=", set_initfree);
-- 
1.7.3.4

