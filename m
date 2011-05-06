Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755828Ab1EFNHs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 09:07:48 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:39703 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755477Ab1EFNFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 09:05:37 -0400
Date: Fri, 6 May 2011 18:35:32 +0530
From: Prem Karat <prem.karat@linux.vnet.ibm.com>
To: v9fs-developer@lists.sourceforge.net
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] 9p: Clean up get_protocol_version to use strcmp
Message-ID: <20110506130531.GA9270@d6fc318.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

9p: Clean-up get_protocol_version() to use strcmp

Signed-off-by: Prem Karat <prem.karat@linux.vnet.ibm.com>
---
 include/net/9p/client.h    |    6 ++--
 include/net/9p/transport.h |    2 +-
 net/9p/client.c            |   47 ++++++++++++++++++++++++++++++-------------
 net/9p/mod.c               |    4 +-
 4 files changed, 39 insertions(+), 20 deletions(-)

diff --git a/include/net/9p/client.h b/include/net/9p/client.h
index 051a99f..0415ba1 100644
--- a/include/net/9p/client.h
+++ b/include/net/9p/client.h
@@ -36,9 +36,9 @@
  */
 
 enum p9_proto_versions{
-	p9_proto_legacy = 0,
-	p9_proto_2000u = 1,
-	p9_proto_2000L = 2,
+	p9_proto_legacy,
+	p9_proto_2000u,
+	p9_proto_2000L,
 };
 
 
diff --git a/include/net/9p/transport.h b/include/net/9p/transport.h
index 8f08c73..d32b472 100644
--- a/include/net/9p/transport.h
+++ b/include/net/9p/transport.h
@@ -66,7 +66,7 @@ struct p9_trans_module {
 
 void v9fs_register_trans(struct p9_trans_module *m);
 void v9fs_unregister_trans(struct p9_trans_module *m);
-struct p9_trans_module *v9fs_get_trans_by_name(const substring_t *name);
+struct p9_trans_module *v9fs_get_trans_by_name(char *s);
 struct p9_trans_module *v9fs_get_default_trans(void);
 void v9fs_put_trans(struct p9_trans_module *m);
 #endif /* NET_9P_TRANSPORT_H */
diff --git a/net/9p/client.c b/net/9p/client.c
index 7736774..4f51250 100644
--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -72,23 +72,22 @@ inline int p9_is_proto_dotu(struct p9_client *clnt)
 EXPORT_SYMBOL(p9_is_proto_dotu);
 
 /* Interpret mount option for protocol version */
-static int get_protocol_version(const substring_t *name)
+static int get_protocol_version(char *s)
 {
 	int version = -EINVAL;
 
-	if (!strncmp("9p2000", name->from, name->to-name->from)) {
+	if (!strcmp(s, "9p2000")) {
 		version = p9_proto_legacy;
 		P9_DPRINTK(P9_DEBUG_9P, "Protocol version: Legacy\n");
-	} else if (!strncmp("9p2000.u", name->from, name->to-name->from)) {
+	} else if (!strcmp(s, "9p2000.u")) {
 		version = p9_proto_2000u;
 		P9_DPRINTK(P9_DEBUG_9P, "Protocol version: 9P2000.u\n");
-	} else if (!strncmp("9p2000.L", name->from, name->to-name->from)) {
+	} else if (!strcmp(s, "9p2000.L")) {
 		version = p9_proto_2000L;
 		P9_DPRINTK(P9_DEBUG_9P, "Protocol version: 9P2000.L\n");
-	} else {
-		P9_DPRINTK(P9_DEBUG_ERROR, "Unknown protocol version %s. ",
-							name->from);
-	}
+	} else
+		printk(KERN_INFO "9p: Unknown protocol version %s.\n", s);
+
 	return version;
 }
 
@@ -109,6 +108,7 @@ static int parse_opts(char *opts, struct p9_client *clnt)
 	char *p;
 	substring_t args[MAX_OPT_ARGS];
 	int option;
+	char *s;
 	int ret = 0;
 
 	clnt->proto_version = p9_proto_2000u;
@@ -144,22 +144,41 @@ static int parse_opts(char *opts, struct p9_client *clnt)
 			clnt->msize = option;
 			break;
 		case Opt_trans:
-			clnt->trans_mod = v9fs_get_trans_by_name(&args[0]);
-			if(clnt->trans_mod == NULL) {
+			s = match_strdup(&args[0]);
+			if (!s) {
+				ret = -ENOMEM;
 				P9_DPRINTK(P9_DEBUG_ERROR,
-				   "Could not find request transport: %s\n",
-				   (char *) &args[0]);
+					"problem allocating copy of trans arg\n");
+				goto free_and_return;
+			 }
+			clnt->trans_mod = v9fs_get_trans_by_name(s);
+			if (clnt->trans_mod == NULL) {
+				printk(KERN_INFO
+					"9p: Could not find "
+					"request transport: %s\n", s);
 				ret = -EINVAL;
+				kfree(s);
 				goto free_and_return;
 			}
+			kfree(s);
 			break;
 		case Opt_legacy:
 			clnt->proto_version = p9_proto_legacy;
 			break;
 		case Opt_version:
-			ret = get_protocol_version(&args[0]);
-			if (ret == -EINVAL)
+			s = match_strdup(&args[0]);
+			if (!s) {
+				ret = -ENOMEM;
+				P9_DPRINTK(P9_DEBUG_ERROR,
+					"problem allocating copy of version arg\n");
+				goto free_and_return;
+			}
+			ret = get_protocol_version(s);
+			if (ret == -EINVAL) {
+				kfree(s);
 				goto free_and_return;
+			}
+			kfree(s);
 			clnt->proto_version = ret;
 			break;
 		default:
diff --git a/net/9p/mod.c b/net/9p/mod.c
index cf8a412..40b06ac 100644
--- a/net/9p/mod.c
+++ b/net/9p/mod.c
@@ -80,14 +80,14 @@ EXPORT_SYMBOL(v9fs_unregister_trans);
  * @name: string identifying transport
  *
  */
-struct p9_trans_module *v9fs_get_trans_by_name(const substring_t *name)
+struct p9_trans_module *v9fs_get_trans_by_name(char *s)
 {
 	struct p9_trans_module *t, *found = NULL;
 
 	spin_lock(&v9fs_trans_lock);
 
 	list_for_each_entry(t, &v9fs_trans_list, list)
-		if (strncmp(t->name, name->from, name->to-name->from) == 0 &&
+		if (strcmp(t->name, s) == 0 &&
 		    try_module_get(t->owner)) {
 			found = t;
 			break;
-- 
1.7.4

-- 
Cheers,
Prem
Linux Technology Center,
IBM Systems & Technology Labs
