Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755791Ab1BXGid (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 01:38:33 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:39209 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754161Ab1BXGib (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 01:38:31 -0500
Date: Wed, 23 Feb 2011 22:38:22 -0800
From: Andres Salomon <dilinger@queued.net>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Daniel Drake <dsd@laptop.org>, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        "David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org
Subject: [PATCH] of/pdt: allow DT device matching by fixing 'name'
 brokenness (v4)
Message-ID: <20110223223822.48718b63@queued.net>
In-Reply-To: <20110224053814.GA6046@angua.secretlab.ca>
References: <20110223150357.5a40793d@queued.net>
	<20110223232815.GC5404@angua.secretlab.ca>
	<20110223161630.3ae470bf@queued.net>
	<20110224040638.GB22111@angua.secretlab.ca>
	<20110223203649.4fcbe1db@queued.net>
	<20110224053814.GA6046@angua.secretlab.ca>
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

Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 drivers/of/pdt.c |   50 ++++++++++++++++++++++----------------------------
 1 files changed, 22 insertions(+), 28 deletions(-)

diff --git a/drivers/of/pdt.c b/drivers/of/pdt.c
index 28295d0..61f6308 100644
--- a/drivers/of/pdt.c
+++ b/drivers/of/pdt.c
@@ -48,7 +48,9 @@ static inline void irq_trans_init(struct device_node *dp) { }
 
 static inline const char *of_pdt_node_name(struct device_node *dp)
 {
-	return dp->name;
+	/* non-sparc archs should be setting a pkg2path hook */
+	WARN_ON(1);
+	return NULL;
 }
 
 #endif /* !CONFIG_SPARC */
@@ -134,7 +136,7 @@ static char * __init of_pdt_get_one_property(phandle node, const char *name)
 
 static char * __init of_pdt_try_pkg2path(phandle node)
 {
-	char *res, *buf = NULL;
+	char *buf = NULL;
 	int len;
 
 	if (!of_pdt_prom_ops->pkg2path)
@@ -147,29 +149,6 @@ static char * __init of_pdt_try_pkg2path(phandle node)
 		pr_err("%s: package-to-path failed\n", __func__);
 		return NULL;
 	}
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
 	return buf;
 }
 
@@ -187,7 +166,7 @@ static struct device_node * __init of_pdt_create_node(phandle node,
 
 	kref_init(&dp->kref);
 
-	dp->name = of_pdt_build_name(node);
+	dp->name = of_pdt_get_one_property(node, "name");
 	dp->type = of_pdt_get_one_property(node, "device_type");
 	dp->phandle = node;
 
@@ -201,10 +180,25 @@ static struct device_node * __init of_pdt_create_node(phandle node,
 static char * __init of_pdt_build_full_name(struct device_node *dp)
 {
 	int len, ourlen, plen;
+	const char *name;
 	char *n;
 
+	/*
+	 * When fetching the full name we want the name we see with
+	 * package-to-path (ie, '/foo/bar/battery@0') rather than what
+	 * we see with the name property (ie, 'battery').
+	 */
+	n = of_pdt_try_pkg2path(dp->phandle);
+	if (n)
+		return n;
+
+	name = of_pdt_node_name(dp);
+	if (!name)
+		return NULL;
+
+	/* Older method for determining full name */
 	plen = strlen(dp->parent->full_name);
-	ourlen = strlen(of_pdt_node_name(dp));
+	ourlen = strlen(name);
 	len = ourlen + plen + 2;
 
 	n = prom_early_alloc(len);
@@ -213,7 +207,7 @@ static char * __init of_pdt_build_full_name(struct device_node *dp)
 		strcpy(n + plen, "/");
 		plen++;
 	}
-	strcpy(n + plen, of_pdt_node_name(dp));
+	strcpy(n + plen, name);
 
 	return n;
 }
-- 
1.7.2.3

