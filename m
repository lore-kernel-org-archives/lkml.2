Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755860Ab1BXTpx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 14:45:53 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:56663 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753899Ab1BXTpw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 14:45:52 -0500
Date: Thu, 24 Feb 2011 11:45:48 -0800
From: Andres Salomon <dilinger@queued.net>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: dsd@laptop.org, sparclinux@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net
Subject: [PATCH v6] of/pdt: allow DT device matching by fixing 'name'
 brokenness
Message-ID: <20110224114548.6955127e@queued.net>
In-Reply-To: <20110224165917.3760.24493.stgit@localhost6.localdomain6>
References: <20110224165917.3760.24493.stgit@localhost6.localdomain6>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Commit e2f2a93b changed dp->name from using the 'name' property to
using package-to-path.  This fixed /proc/device-tree creation by
eliminating conflicts between names (the 'name' property provides
names like 'battery', whereas package-to-path provides names like
'/foo/bar/battery@0', which we stripped to 'battery@0').  However,
it also breaks of_device_id table matching.

The fix that we _really_ wanted was to keep dp->name based upon
the name property ('battery'), but based dp->full_name upon
package-to-path ('battery@0').  This patch does just that.

This also changes OLPC behavior to use the full result from
package-to-path for full_name, rather than stripping the directory
out.  In practice, the strings end up being exactly the same; this
change saves time, code, and memory.

v2: combine two patches and revert of_pdt_node_name to original version
v3: use dp->phandle instead of passing around node
v4: warn/bail out for non-sparc archs if pkg2path is not set
v6: rework functions based on Grant's suggestions; WARN_ON if no
pkg2path hook

Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 drivers/of/pdt.c |  125 ++++++++++++++++++++++++------------------------------
 1 files changed, 55 insertions(+), 70 deletions(-)

diff --git a/drivers/of/pdt.c b/drivers/of/pdt.c
index 28295d0..2c6be9c 100644
--- a/drivers/of/pdt.c
+++ b/drivers/of/pdt.c
@@ -36,19 +36,68 @@ unsigned int of_pdt_unique_id __initdata;
 	(p)->unique_id = of_pdt_unique_id++; \
 } while (0)
 
-static inline const char *of_pdt_node_name(struct device_node *dp)
+static char * __init of_pdt_build_full_name(struct device_node *dp)
 {
-	return dp->path_component_name;
+	int len, ourlen, plen;
+	char *n;
+
+	dp->path_component_name = build_path_component(dp);
+
+	plen = strlen(dp->parent->full_name);
+	ourlen = strlen(dp->path_component_name);
+	len = ourlen + plen + 2;
+
+	n = prom_early_alloc(len);
+	strcpy(n, dp->parent->full_name);
+	if (!of_node_is_root(dp->parent)) {
+		strcpy(n + plen, "/");
+		plen++;
+	}
+	strcpy(n + plen, dp->path_component_name);
+
+	return n;
 }
 
-#else
+#else /* CONFIG_SPARC */
 
 static inline void of_pdt_incr_unique_id(void *p) { }
 static inline void irq_trans_init(struct device_node *dp) { }
 
-static inline const char *of_pdt_node_name(struct device_node *dp)
+/*
+ * When fetching the full name we want the name we see with
+ * package-to-path (ie, '/foo/bar/battery@0') rather than what
+ * we see with the name property (ie, 'battery').
+ */
+static char * __init of_pdt_build_full_name(struct device_node *dp)
 {
-	return dp->name;
+	char *buf = NULL;
+	int len;
+
+	if (!of_pdt_prom_ops->pkg2path) {
+		/* pkg2path hook should be set for all non-sparc archs */
+		WARN_ON_ONCE(1);
+		goto fail;
+	}
+
+	if (of_pdt_prom_ops->pkg2path(dp->phandle, buf, 0, &len)) {
+		pr_err("PDT: package-to-path failed on %s\n", dp->name);
+		goto fail;
+	}
+
+	buf = prom_early_alloc(len + 1);
+	if (!buf)
+		/* we have larger problems than DT creation.. */
+		return NULL;
+
+	if (of_pdt_prom_ops->pkg2path(dp->phandle, buf, len, &len)) {
+		pr_err("PDT: package-to-path failed on %s\n", dp->name);
+		goto fail;
+	}
+	return buf;
+
+fail:
+	/* hobble along w/ dp->name if pkg2path fails; not ideal */
+	return (char *) dp->name;
 }
 
 #endif /* !CONFIG_SPARC */
@@ -132,47 +181,6 @@ static char * __init of_pdt_get_one_property(phandle node, const char *name)
 	return buf;
 }
 
-static char * __init of_pdt_try_pkg2path(phandle node)
-{
-	char *res, *buf = NULL;
-	int len;
-
-	if (!of_pdt_prom_ops->pkg2path)
-		return NULL;
-
-	if (of_pdt_prom_ops->pkg2path(node, buf, 0, &len))
-		return NULL;
-	buf = prom_early_alloc(len + 1);
-	if (of_pdt_prom_ops->pkg2path(node, buf, len, &len)) {
-		pr_err("%s: package-to-path failed\n", __func__);
-		return NULL;
-	}
-
-	res = strrchr(buf, '/');
-	if (!res) {
-		pr_err("%s: couldn't find / in %s\n", __func__, buf);
-		return NULL;
-	}
-	return res+1;
-}
-
-/*
- * When fetching the node's name, first try using package-to-path; if
- * that fails (either because the arch hasn't supplied a PROM callback,
- * or some other random failure), fall back to just looking at the node's
- * 'name' property.
- */
-static char * __init of_pdt_build_name(phandle node)
-{
-	char *buf;
-
-	buf = of_pdt_try_pkg2path(node);
-	if (!buf)
-		buf = of_pdt_get_one_property(node, "name");
-
-	return buf;
-}
-
 static struct device_node * __init of_pdt_create_node(phandle node,
 						    struct device_node *parent)
 {
@@ -187,7 +195,7 @@ static struct device_node * __init of_pdt_create_node(phandle node,
 
 	kref_init(&dp->kref);
 
-	dp->name = of_pdt_build_name(node);
+	dp->name = of_pdt_get_one_property(node, "name");
 	dp->type = of_pdt_get_one_property(node, "device_type");
 	dp->phandle = node;
 
@@ -198,26 +206,6 @@ static struct device_node * __init of_pdt_create_node(phandle node,
 	return dp;
 }
 
-static char * __init of_pdt_build_full_name(struct device_node *dp)
-{
-	int len, ourlen, plen;
-	char *n;
-
-	plen = strlen(dp->parent->full_name);
-	ourlen = strlen(of_pdt_node_name(dp));
-	len = ourlen + plen + 2;
-
-	n = prom_early_alloc(len);
-	strcpy(n, dp->parent->full_name);
-	if (!of_node_is_root(dp->parent)) {
-		strcpy(n + plen, "/");
-		plen++;
-	}
-	strcpy(n + plen, of_pdt_node_name(dp));
-
-	return n;
-}
-
 static struct device_node * __init of_pdt_build_tree(struct device_node *parent,
 						   phandle node,
 						   struct device_node ***nextp)
@@ -240,9 +228,6 @@ static struct device_node * __init of_pdt_build_tree(struct device_node *parent,
 		*(*nextp) = dp;
 		*nextp = &dp->allnext;
 
-#if defined(CONFIG_SPARC)
-		dp->path_component_name = build_path_component(dp);
-#endif
 		dp->full_name = of_pdt_build_full_name(dp);
 
 		dp->child = of_pdt_build_tree(dp,
-- 
1.7.2.3

