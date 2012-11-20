Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753792Ab2KTXMf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 18:12:35 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:58639 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753423Ab2KTXMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 18:12:34 -0500
From: Stephen Warren <swarren@wwwdotorg.org>
To: Stephen Warren <swarren@wwwdotorg.org>, John Stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Josh Cartwright <josh.cartwright@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH V4 1/3] of: introduce for_each_matching_node_and_match()
Date: Tue, 20 Nov 2012 16:12:20 -0700
Message-Id: <1353453142-4973-1-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.10.4
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

The following pattern of code is tempting:

    for_each_matching_node(np, table) {
        match = of_match_node(table, np);

However, this results in iterating over table twice; the second time
inside of_match_node(). The implementation of for_each_matching_node()
already found the match, so this is redundant. Invent new function
of_find_matching_node_and_match() and macro
for_each_matching_node_and_match() to remove the double iteration,
thus transforming the above code to:

    for_each_matching_node_and_match(np, table, &match)

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
v4: New patch.

This series is based on the ARM sys_timer rework that I posted yesterday,
although patch 1/3 should be completely independant of that, and could
perhaps even be applied for 3.8 right now.

I hope that these patches can be taken through arm-soc tree for 3.9;
I will repost them based on 3.8-rc1 at the appropriate time.
---
 drivers/of/base.c  |   18 +++++++++++++-----
 include/linux/of.h |   15 +++++++++++++--
 2 files changed, 26 insertions(+), 7 deletions(-)

diff --git a/drivers/of/base.c b/drivers/of/base.c
index f2f63c8..094271e 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -594,27 +594,35 @@ const struct of_device_id *of_match_node(const struct of_device_id *matches,
 EXPORT_SYMBOL(of_match_node);
 
 /**
- *	of_find_matching_node - Find a node based on an of_device_id match
- *				table.
+ *	of_find_matching_node_and_match - Find a node based on an of_device_id
+ *					  match table.
  *	@from:		The node to start searching from or NULL, the node
  *			you pass will not be searched, only the next one
  *			will; typically, you pass what the previous call
  *			returned. of_node_put() will be called on it
  *	@matches:	array of of device match structures to search in
+ *	@match		Updated to point at the matches entry which matched
  *
  *	Returns a node pointer with refcount incremented, use
  *	of_node_put() on it when done.
  */
-struct device_node *of_find_matching_node(struct device_node *from,
-					  const struct of_device_id *matches)
+struct device_node *of_find_matching_node_and_match(struct device_node *from,
+					const struct of_device_id *matches,
+					const struct of_device_id **match)
 {
 	struct device_node *np;
 
+	if (match)
+		*match = NULL;
+
 	read_lock(&devtree_lock);
 	np = from ? from->allnext : allnodes;
 	for (; np; np = np->allnext) {
-		if (of_match_node(matches, np) && of_node_get(np))
+		if (of_match_node(matches, np) && of_node_get(np)) {
+			if (match)
+				*match = matches;
 			break;
+		}
 	}
 	of_node_put(from);
 	read_unlock(&devtree_lock);
diff --git a/include/linux/of.h b/include/linux/of.h
index 681a6c8..1000496 100644
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -180,11 +180,22 @@ extern struct device_node *of_find_compatible_node(struct device_node *from,
 #define for_each_compatible_node(dn, type, compatible) \
 	for (dn = of_find_compatible_node(NULL, type, compatible); dn; \
 	     dn = of_find_compatible_node(dn, type, compatible))
-extern struct device_node *of_find_matching_node(struct device_node *from,
-	const struct of_device_id *matches);
+extern struct device_node *of_find_matching_node_and_match(
+	struct device_node *from,
+	const struct of_device_id *matches,
+	const struct of_device_id **match);
+static inline struct device_node *of_find_matching_node(
+	struct device_node *from,
+	const struct of_device_id *matches)
+{
+	return of_find_matching_node_and_match(from, matches, NULL);
+}
 #define for_each_matching_node(dn, matches) \
 	for (dn = of_find_matching_node(NULL, matches); dn; \
 	     dn = of_find_matching_node(dn, matches))
+#define for_each_matching_node_and_match(dn, matches, match) \
+	for (dn = of_find_matching_node_and_match(NULL, matches, match); \
+	     dn; dn = of_find_matching_node_and_match(dn, matches, match))
 extern struct device_node *of_find_node_by_path(const char *path);
 extern struct device_node *of_find_node_by_phandle(phandle handle);
 extern struct device_node *of_get_parent(const struct device_node *node);
-- 
1.7.10.4

