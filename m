Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932540Ab1CDTpS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 14:45:18 -0500
Received: from mail3.caviumnetworks.com ([12.108.191.235]:11794 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760014Ab1CDTmm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 14:42:42 -0500
From: David Daney <ddaney@caviumnetworks.com>
To: linux-mips@linux-mips.org, ralf@linux-mips.org,
        devicetree-discuss@lists.ozlabs.org, grant.likely@secretlab.ca,
        linux-kernel@vger.kernel.org
Cc: David Daney <ddaney@caviumnetworks.com>
Subject: [RFC PATCH v2 03/12] of: Make of_find_node_by_path() traverse /aliases for relative paths.
Date: Fri,  4 Mar 2011 11:42:15 -0800
Message-Id: <1299267744-17278-4-git-send-email-ddaney@caviumnetworks.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1299267744-17278-1-git-send-email-ddaney@caviumnetworks.com>
References: <1299267744-17278-1-git-send-email-ddaney@caviumnetworks.com>
X-OriginalArrivalTime: 04 Mar 2011 19:42:42.0403 (UTC) FILETIME=[53B4A330:01CBDAA4]
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

This patch is unchanged from the previous version I send separately.  I
have not forgotten about Grant's feedback, just deferred it to the
next version.

 drivers/of/base.c |   24 +++++++++++++++++++++++-
 1 files changed, 23 insertions(+), 1 deletions(-)

diff --git a/drivers/of/base.c b/drivers/of/base.c
index 710b53b..e63da9c 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -340,7 +340,10 @@ EXPORT_SYMBOL(of_get_next_child);
 
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
@@ -348,13 +351,32 @@ EXPORT_SYMBOL(of_get_next_child);
 struct device_node *of_find_node_by_path(const char *path)
 {
 	struct device_node *np = allnodes;
+	struct device_node *aliases = NULL;
 
 	read_lock(&devtree_lock);
+
+	if (path[0] != '/') {
+		aliases = of_find_node_by_path("/aliases");
+		if (!aliases)
+			goto out;
+		path = of_get_property(aliases, path, NULL);
+		/*
+		 * The alias must begin with '/', otherwise we could
+		 * get stuck in an endless loop and blow out the
+		 * stack.
+		 */
+		if (!path || path[0] != '/')
+			goto out;
+	}
+
 	for (; np; np = np->allnext) {
 		if (np->full_name && (of_node_cmp(np->full_name, path) == 0)
 		    && of_node_get(np))
 			break;
 	}
+out:
+	if (aliases)
+		of_node_put(aliases);
 	read_unlock(&devtree_lock);
 	return np;
 }
-- 
1.7.2.3

