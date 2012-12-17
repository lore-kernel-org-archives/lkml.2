Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753397Ab2LQPCv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 10:02:51 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:18169 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753159Ab2LQPCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 10:02:46 -0500
From: Sasha Levin <sasha.levin@oracle.com>
To: "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <levinsasha928@gmail.com>,
        Eric Van Hensbergen <ericvh@gmail.com>, Joe Perches <joe@perches.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH 06/15] net,9p: use new hashtable implementation
Date: Mon, 17 Dec 2012 10:01:26 -0500
Message-Id: <1355756497-15834-6-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1355756497-15834-1-git-send-email-sasha.levin@oracle.com>
References: <1355756497-15834-1-git-send-email-sasha.levin@oracle.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Switch 9p error table to use the new hashtable implementation. This reduces
the amount of generic unrelated code in 9p.

This patch depends on d9b482c ("hashtable: introduce a small and naive
hashtable") which was merged in v3.6.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 net/9p/error.c | 21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/net/9p/error.c b/net/9p/error.c
index 2ab2de7..a394b37 100644
--- a/net/9p/error.c
+++ b/net/9p/error.c
@@ -34,6 +34,7 @@
 #include <linux/jhash.h>
 #include <linux/errno.h>
 #include <net/9p/9p.h>
+#include <linux/hashtable.h>
 
 /**
  * struct errormap - map string errors from Plan 9 to Linux numeric ids
@@ -50,8 +51,8 @@ struct errormap {
 	struct hlist_node list;
 };
 
-#define ERRHASHSZ		32
-static struct hlist_head hash_errmap[ERRHASHSZ];
+#define ERR_HASH_BITS 5
+static DEFINE_HASHTABLE(hash_errmap, ERR_HASH_BITS);
 
 /* FixMe - reduce to a reasonable size */
 static struct errormap errmap[] = {
@@ -193,18 +194,14 @@ static struct errormap errmap[] = {
 int p9_error_init(void)
 {
 	struct errormap *c;
-	int bucket;
-
-	/* initialize hash table */
-	for (bucket = 0; bucket < ERRHASHSZ; bucket++)
-		INIT_HLIST_HEAD(&hash_errmap[bucket]);
+	u32 hash;
 
 	/* load initial error map into hash table */
 	for (c = errmap; c->name != NULL; c++) {
 		c->namelen = strlen(c->name);
-		bucket = jhash(c->name, c->namelen, 0) % ERRHASHSZ;
+		hash = jhash(c->name, c->namelen, 0);
 		INIT_HLIST_NODE(&c->list);
-		hlist_add_head(&c->list, &hash_errmap[bucket]);
+		hash_add(hash_errmap, &c->list, hash);
 	}
 
 	return 1;
@@ -223,13 +220,13 @@ int p9_errstr2errno(char *errstr, int len)
 	int errno;
 	struct hlist_node *p;
 	struct errormap *c;
-	int bucket;
+	u32 hash;
 
 	errno = 0;
 	p = NULL;
 	c = NULL;
-	bucket = jhash(errstr, len, 0) % ERRHASHSZ;
-	hlist_for_each_entry(c, p, &hash_errmap[bucket], list) {
+	hash = jhash(errstr, len, 0);
+	hash_for_each_possible(hash_errmap, c, p, list, hash) {
 		if (c->namelen == len && !memcmp(c->name, errstr, len)) {
 			errno = c->val;
 			break;
-- 
1.8.0

