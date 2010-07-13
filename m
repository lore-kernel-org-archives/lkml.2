Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754155Ab0GLGU7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 02:20:59 -0400
Received: from LUNGE.MIT.EDU ([18.54.1.69]:55001 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751326Ab0GLGU6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 02:20:58 -0400
Date: Tue, 13 Jul 2010 09:42:26 +0000
From: Andres Salomon <dilinger@queued.net>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: devicetree-discuss@lists.ozlabs.org, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net
Subject: [PATCH] sparc: move is_root_node from private header to of.h
Message-ID: <20100713094226.33b421dd@debxo>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Make is_root_node available for all archs to use, as it's not PROM-specific.
Also rename it to of_is_root_node, and a few other minor changes for
style/consistency.

Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 arch/sparc/kernel/prom.h        |    8 --------
 arch/sparc/kernel/prom_64.c     |    6 +++---
 arch/sparc/kernel/prom_common.c |    2 +-
 include/linux/of.h              |    8 ++++++++
 4 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/sparc/kernel/prom.h b/arch/sparc/kernel/prom.h
index a8591ef..eeb04a7 100644
--- a/arch/sparc/kernel/prom.h
+++ b/arch/sparc/kernel/prom.h
@@ -9,14 +9,6 @@ extern void irq_trans_init(struct device_node *dp);
 
 extern unsigned int prom_unique_id;
 
-static inline int is_root_node(const struct device_node *dp)
-{
-	if (!dp)
-		return 0;
-
-	return (dp->parent == NULL);
-}
-
 extern char *build_path_component(struct device_node *dp);
 extern void of_console_init(void);
 
diff --git a/arch/sparc/kernel/prom_64.c b/arch/sparc/kernel/prom_64.c
index fb06ac2..dd5e487 100644
--- a/arch/sparc/kernel/prom_64.c
+++ b/arch/sparc/kernel/prom_64.c
@@ -21,7 +21,7 @@
 #include <linux/mm.h>
 #include <linux/module.h>
 #include <linux/lmb.h>
-#include <linux/of_device.h>
+#include <linux/of.h>
 
 #include <asm/prom.h>
 #include <asm/oplib.h>
@@ -81,7 +81,7 @@ static void __init sun4v_path_component(struct device_node *dp, char *tmp_buf)
 		return;
 
 	regs = rprop->value;
-	if (!is_root_node(dp->parent)) {
+	if (!of_is_root_node(dp->parent)) {
 		sprintf(tmp_buf, "%s@%x,%x",
 			dp->name,
 			(unsigned int) (regs->phys_addr >> 32UL),
@@ -121,7 +121,7 @@ static void __init sun4u_path_component(struct device_node *dp, char *tmp_buf)
 		return;
 
 	regs = prop->value;
-	if (!is_root_node(dp->parent)) {
+	if (!of_is_root_node(dp->parent)) {
 		sprintf(tmp_buf, "%s@%x,%x",
 			dp->name,
 			(unsigned int) (regs->phys_addr >> 32UL),
diff --git a/arch/sparc/kernel/prom_common.c b/arch/sparc/kernel/prom_common.c
index 57ac9e2..40123a6 100644
--- a/arch/sparc/kernel/prom_common.c
+++ b/arch/sparc/kernel/prom_common.c
@@ -244,7 +244,7 @@ char * __init build_full_name(struct device_node *dp)
 
 	n = prom_early_alloc(len);
 	strcpy(n, dp->parent->full_name);
-	if (!is_root_node(dp->parent)) {
+	if (!of_is_root_node(dp->parent)) {
 		strcpy(n + plen, "/");
 		plen++;
 	}
diff --git a/include/linux/of.h b/include/linux/of.h
index a367e19..b38cdf7 100644
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -97,6 +97,14 @@ extern struct device_node *of_node_get(struct device_node *node);
 extern void of_node_put(struct device_node *node);
 #endif
 
+static inline bool of_is_root_node(const struct device_node *node)
+{
+	if (!node)
+		return false;
+
+	return (node->parent == NULL);
+}
+
 /*
  * OF address retreival & translation
  */
-- 
1.5.6.5

