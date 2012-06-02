Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933006Ab2FBREE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2012 13:04:04 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:59681 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932880Ab2FBREB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2012 13:04:01 -0400
From: Devendra Naga <devendra.aaru@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org
Cc: Devendra Naga <devendra.aaru@gmail.com>
Subject: [PATCH 1/2] pinctrl: free allocated pinctrl_map structure only once and use kernel facilities for IMX_PMX_DUMP
Date: Sat,  2 Jun 2012 22:33:53 +0530
Message-Id: <1338656634-3870-1-git-send-email-devendra.aaru@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

a) as we allocate the pinctrl_map structure at imx_dt_node_to_map at  line 167, anyway
if its an element, or a num_elements * (sizeof(type)) elements allocated to one single
pointer must be freed only once.

CASE. A)

as new_map is not moved and allocated like,

for (i = 0; i < MAX_ELEMS; i++) {
	new_map[i] = kmalloc(numelems * size, GFP_KERNEL);
}

its freed as

for (i = 0; i < MAX_ELEMS; i++) {
	kfree(new_map[i]);
}

CASE. B)
and its allocated like
	new_map = kmalloc(numelems * size, GFP_KERNEL);

it just needs kfree not as case A's.

b) use KERN_DEBUG facility for the IMX_PMX_DUMP macro.

Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
---
 drivers/pinctrl/pinctrl-imx.c |   23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-imx.c b/drivers/pinctrl/pinctrl-imx.c
index f6e7c67..553ed95 100644
--- a/drivers/pinctrl/pinctrl-imx.c
+++ b/drivers/pinctrl/pinctrl-imx.c
@@ -27,16 +27,16 @@
 #include "core.h"
 #include "pinctrl-imx.h"
 
-#define IMX_PMX_DUMP(info, p, m, c, n)		\
-{						\
-	int i, j;				\
-	printk("Format: Pin Mux Config\n");	\
-	for (i = 0; i < n; i++) {		\
-		j = p[i];			\
-		printk("%s %d 0x%lx\n",		\
-			info->pins[j].name,	\
-			m[i], c[i]);		\
-	}					\
+#define IMX_PMX_DUMP(info, p, m, c, n)			\
+{							\
+	int i, j;					\
+	printk(KERN_DEBUG "Format: Pin Mux Config\n");	\
+	for (i = 0; i < n; i++) {			\
+		j = p[i];				\
+		printk(KERN_DEBUG "%s %d 0x%lx\n",	\
+			info->pins[j].name,		\
+			m[i], c[i]);			\
+	}						\
 }
 
 /* The bits in CONFIG cell defined in binding doc*/
@@ -203,8 +203,7 @@ static void imx_dt_free_map(struct pinctrl_dev *pctldev,
 {
 	int i;
 
-	for (i = 0; i < num_maps; i++)
-		kfree(map);
+	kfree(map);
 }
 
 static struct pinctrl_ops imx_pctrl_ops = {
-- 
1.7.9.5

