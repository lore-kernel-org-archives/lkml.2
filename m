Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757346Ab1ETW0N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 18:26:13 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:2111 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757297Ab1ETWZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 18:25:56 -0400
From: David Daney <ddaney@caviumnetworks.com>
To: linux-mips@linux-mips.org, ralf@linux-mips.org,
        devicetree-discuss@lists.ozlabs.org, grant.likely@secretlab.ca,
        linux-kernel@vger.kernel.org
Cc: David Daney <ddaney@caviumnetworks.com>
Subject: [RFC PATCH v4 2/6] of: Make of_find_node_by_path() traverse /aliases for relative paths.
Date: Fri, 20 May 2011 15:25:39 -0700
Message-Id: <1305930343-31259-3-git-send-email-ddaney@caviumnetworks.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1305930343-31259-1-git-send-email-ddaney@caviumnetworks.com>
References: <1305930343-31259-1-git-send-email-ddaney@caviumnetworks.com>
X-OriginalArrivalTime: 20 May 2011 22:25:56.0048 (UTC) FILETIME=[E2FB0500:01CC173C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently all paths passed to of_find_node_by_path() must begin with a
'/', indicating a full path to the desired node.

Augment the look-up code so that if a path does *not* begin with '/',
the path is used as the name of an /aliases property.  The value of
this alias is then used as the full node path to be found.

Signed-off-by: David Daney <ddaney@caviumnetworks.com>
---
 drivers/of/base.c |   48 +++++++++++++++++++++++++++++++++++++++++++++---
 1 files changed, 45 insertions(+), 3 deletions(-)

diff --git a/drivers/of/base.c b/drivers/of/base.c
index 632ebae..279134b 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -340,22 +340,64 @@ EXPORT_SYMBOL(of_get_next_child);
 
 /**
  *	of_find_node_by_path - Find a node matching a full OF path
- *	@path:	The full path to match
+ *	@path: Either the full path to match, or if the path does not
+ *	       start with '/', the name of a property of the /aliases
+ *	       node (an alias).  In the case of an alias, the node
+ *	       matching the alias' value will be returned.
  *
  *	Returns a node pointer with refcount incremented, use
  *	of_node_put() on it when done.
  */
 struct device_node *of_find_node_by_path(const char *path)
 {
-	struct device_node *np = allnodes;
+	struct device_node *np = NULL;
+	struct device_node *aliases = NULL;
+	char *alias = NULL;
+	char *new_path = NULL;
 
 	read_lock(&devtree_lock);
-	for (; np; np = np->allnext) {
+
+	if (path[0] != '/') {
+		const char *ps;
+		aliases = of_find_node_by_path("/aliases");
+		if (!aliases)
+			goto out;
+
+		ps = strchr(path, '/');
+		if (ps) {
+			size_t len = ps - path;
+			alias = kstrndup(path, len, GFP_KERNEL);
+			if (!alias)
+				goto out;
+			path = of_get_property(aliases, alias, NULL);
+			if (!path)
+				goto out;
+
+			len = strlen(path) + strlen(ps) + 1;
+			new_path = kmalloc(len, GFP_KERNEL);
+			if (!new_path)
+				goto out;
+			strcpy(new_path, path);
+			strcat(new_path, ps);
+			path = new_path;
+		} else {
+			path = of_get_property(aliases, path, NULL);
+		}
+		if (!path)
+			goto out;
+	}
+
+	for (np = allnodes; np; np = np->allnext) {
 		if (np->full_name && (of_node_cmp(np->full_name, path) == 0)
 		    && of_node_get(np))
 			break;
 	}
+out:
+	if (aliases)
+		of_node_put(aliases);
 	read_unlock(&devtree_lock);
+	kfree(alias);
+	kfree(new_path);
 	return np;
 }
 EXPORT_SYMBOL(of_find_node_by_path);
-- 
1.7.2.3

