Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754404Ab2FYGdc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 02:33:32 -0400
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:37433
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751685Ab2FYGdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 02:33:31 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz154dMzz1202h1082kzz8275dhz2dh2a8h668h839hd24he5bhf0ah)
From: Dong Aisheng <b29396@freescale.com>
To: <linux-kernel@vger.kernel.org>
CC: <devicetree-discuss@lists.ozlabs.org>, <linuxppc-dev@lists.ozlabs.org>,
        <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>,
        <galak@kernel.crashing.org>, <benh@kernel.crashing.org>,
        <paulus@samba.org>
Subject: [PATCH v2 1/1] of: reform prom_update_property function
Date: Mon, 25 Jun 2012 14:28:34 +0800
Message-ID: <1340605714-25206-1-git-send-email-b29396@freescale.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dong Aisheng <dong.aisheng@linaro.org>

prom_update_property() currently fails if the property doesn't
actually exist yet which isn't what we want. Change to add-or-update
instead of update-only, then we can remove a lot duplicated lines.

Suggested-by: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>
---
ChangeLog v1->v2:
* keep reconfig.c behavior the same as before after changes
---
 arch/powerpc/platforms/85xx/p1022_ds.c    |    8 +-------
 arch/powerpc/platforms/pseries/mobility.c |    8 +-------
 arch/powerpc/platforms/pseries/reconfig.c |   16 ++++++----------
 drivers/of/base.c                         |   15 +++++++++++----
 fs/proc/proc_devtree.c                    |    5 +++++
 include/linux/of.h                        |    3 +--
 6 files changed, 25 insertions(+), 30 deletions(-)

diff --git a/arch/powerpc/platforms/85xx/p1022_ds.c b/arch/powerpc/platforms/85xx/p1022_ds.c
index f700c81..d66631c 100644
--- a/arch/powerpc/platforms/85xx/p1022_ds.c
+++ b/arch/powerpc/platforms/85xx/p1022_ds.c
@@ -348,13 +348,7 @@ void __init p1022_ds_pic_init(void)
  */
 static void __init disable_one_node(struct device_node *np, struct property *new)
 {
-	struct property *old;
-
-	old = of_find_property(np, new->name, NULL);
-	if (old)
-		prom_update_property(np, new, old);
-	else
-		prom_add_property(np, new);
+	prom_update_property(np, new);
 }
 
 /* TRUE if there is a "video=fslfb" command-line parameter. */
diff --git a/arch/powerpc/platforms/pseries/mobility.c b/arch/powerpc/platforms/pseries/mobility.c
index 029a562..dd30b12 100644
--- a/arch/powerpc/platforms/pseries/mobility.c
+++ b/arch/powerpc/platforms/pseries/mobility.c
@@ -67,7 +67,6 @@ static int update_dt_property(struct device_node *dn, struct property **prop,
 			      const char *name, u32 vd, char *value)
 {
 	struct property *new_prop = *prop;
-	struct property *old_prop;
 	int more = 0;
 
 	/* A negative 'vd' value indicates that only part of the new property
@@ -117,12 +116,7 @@ static int update_dt_property(struct device_node *dn, struct property **prop,
 	}
 
 	if (!more) {
-		old_prop = of_find_property(dn, new_prop->name, NULL);
-		if (old_prop)
-			prom_update_property(dn, new_prop, old_prop);
-		else
-			prom_add_property(dn, new_prop);
-
+		prom_update_property(dn, new_prop);
 		new_prop = NULL;
 	}
 
diff --git a/arch/powerpc/platforms/pseries/reconfig.c b/arch/powerpc/platforms/pseries/reconfig.c
index 7b3bf76..db1b7b1 100644
--- a/arch/powerpc/platforms/pseries/reconfig.c
+++ b/arch/powerpc/platforms/pseries/reconfig.c
@@ -432,7 +432,7 @@ static int do_update_property(char *buf, size_t bufsize)
 	unsigned char *value;
 	char *name, *end, *next_prop;
 	int rc, length;
-	struct property *newprop, *oldprop;
+	struct property *newprop;
 	buf = parse_node(buf, bufsize, &np);
 	end = buf + bufsize;
 
@@ -443,6 +443,9 @@ static int do_update_property(char *buf, size_t bufsize)
 	if (!next_prop)
 		return -EINVAL;
 
+	if (!strlen(name)
+		return -ENODEV;
+
 	newprop = new_property(name, length, value, NULL);
 	if (!newprop)
 		return -ENOMEM;
@@ -450,18 +453,11 @@ static int do_update_property(char *buf, size_t bufsize)
 	if (!strcmp(name, "slb-size") || !strcmp(name, "ibm,slb-size"))
 		slb_set_size(*(int *)value);
 
-	oldprop = of_find_property(np, name,NULL);
-	if (!oldprop) {
-		if (strlen(name))
-			return prom_add_property(np, newprop);
-		return -ENODEV;
-	}
-
 	upd_value.node = np;
 	upd_value.property = newprop;
 	pSeries_reconfig_notify(PSERIES_UPDATE_PROPERTY, &upd_value);
 
-	rc = prom_update_property(np, newprop, oldprop);
+	rc = prom_update_property(np, newprop);
 	if (rc)
 		return rc;
 
@@ -486,7 +482,7 @@ static int do_update_property(char *buf, size_t bufsize)
 
 		rc = pSeries_reconfig_notify(action, value);
 		if (rc) {
-			prom_update_property(np, oldprop, newprop);
+			prom_update_property(np, newprop);
 			return rc;
 		}
 	}
diff --git a/drivers/of/base.c b/drivers/of/base.c
index d9bfd49..a14f109 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -1051,7 +1051,8 @@ int prom_remove_property(struct device_node *np, struct property *prop)
 }
 
 /*
- * prom_update_property - Update a property in a node.
+ * prom_update_property - Update a property in a node, if the property does
+ * not exist, add it.
  *
  * Note that we don't actually remove it, since we have given out
  * who-knows-how-many pointers to the data using get-property.
@@ -1059,13 +1060,19 @@ int prom_remove_property(struct device_node *np, struct property *prop)
  * and add the new property to the property list
  */
 int prom_update_property(struct device_node *np,
-			 struct property *newprop,
-			 struct property *oldprop)
+			 struct property *newprop)
 {
-	struct property **next;
+	struct property **next, *oldprop;
 	unsigned long flags;
 	int found = 0;
 
+	if (!newprop->name)
+		return -EINVAL;
+
+	oldprop = of_find_property(np, newprop->name, NULL);
+	if (!oldprop)
+		return prom_add_property(np, newprop);
+
 	write_lock_irqsave(&devtree_lock, flags);
 	next = &np->properties;
 	while (*next) {
diff --git a/fs/proc/proc_devtree.c b/fs/proc/proc_devtree.c
index 927cbd1..df7dd08 100644
--- a/fs/proc/proc_devtree.c
+++ b/fs/proc/proc_devtree.c
@@ -101,6 +101,11 @@ void proc_device_tree_update_prop(struct proc_dir_entry *pde,
 {
 	struct proc_dir_entry *ent;
 
+	if (!oldprop) {
+		proc_device_tree_add_prop(pde, newprop);
+		return;
+	}
+
 	for (ent = pde->subdir; ent != NULL; ent = ent->next)
 		if (ent->data == oldprop)
 			break;
diff --git a/include/linux/of.h b/include/linux/of.h
index 2ec1083..b27c871 100644
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -260,8 +260,7 @@ extern int of_machine_is_compatible(const char *compat);
 extern int prom_add_property(struct device_node* np, struct property* prop);
 extern int prom_remove_property(struct device_node *np, struct property *prop);
 extern int prom_update_property(struct device_node *np,
-				struct property *newprop,
-				struct property *oldprop);
+				struct property *newprop);
 
 #if defined(CONFIG_OF_DYNAMIC)
 /* For updating the device tree at runtime */
-- 
1.7.0.4


