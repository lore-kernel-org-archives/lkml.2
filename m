Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935689Ab1ETS4y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 14:56:54 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:35444 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935616Ab1ETS4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 14:56:42 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: v9fs-developer@lists.sourceforge.net
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 2/2] net/9p: p9_idpool_get return -1 on error
Date: Sat, 21 May 2011 00:25:52 +0530
Message-Id: <1305917752-16539-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1305917752-16539-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1305917752-16539-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to return -1 on error. Also handle error properly

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 net/9p/client.c |   20 ++++++++++++--------
 net/9p/util.c   |    2 +-
 2 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/net/9p/client.c b/net/9p/client.c
index a9aa2dd..e9d8de1 100644
--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -307,12 +307,13 @@ static int p9_tag_init(struct p9_client *c)
 	c->tagpool = p9_idpool_create();
 	if (IS_ERR(c->tagpool)) {
 		err = PTR_ERR(c->tagpool);
-		c->tagpool = NULL;
 		goto error;
 	}
-
-	p9_idpool_get(c->tagpool); /* reserve tag 0 */
-
+	err = p9_idpool_get(c->tagpool); /* reserve tag 0 */
+	if (err < 0) {
+		p9_idpool_destroy(c->tagpool);
+		goto error;
+	}
 	c->max_tag = 0;
 error:
 	return err;
@@ -789,11 +790,13 @@ struct p9_client *p9_client_create(const char *dev_name, char *options)
 	spin_lock_init(&clnt->lock);
 	INIT_LIST_HEAD(&clnt->fidlist);
 
-	p9_tag_init(clnt);
+	err = p9_tag_init(clnt);
+	if (err < 0)
+		goto free_client;
 
 	err = parse_opts(options, clnt);
 	if (err < 0)
-		goto free_client;
+		goto destroy_tagpool;
 
 	if (!clnt->trans_mod)
 		clnt->trans_mod = v9fs_get_default_trans();
@@ -802,13 +805,12 @@ struct p9_client *p9_client_create(const char *dev_name, char *options)
 		err = -EPROTONOSUPPORT;
 		P9_DPRINTK(P9_DEBUG_ERROR,
 				"No transport defined or default transport\n");
-		goto free_client;
+		goto destroy_tagpool;
 	}
 
 	clnt->fidpool = p9_idpool_create();
 	if (IS_ERR(clnt->fidpool)) {
 		err = PTR_ERR(clnt->fidpool);
-		clnt->fidpool = NULL;
 		goto put_trans;
 	}
 
@@ -834,6 +836,8 @@ destroy_fidpool:
 	p9_idpool_destroy(clnt->fidpool);
 put_trans:
 	v9fs_put_trans(clnt->trans_mod);
+destroy_tagpool:
+	p9_idpool_destroy(clnt->tagpool);
 free_client:
 	kfree(clnt);
 	return ERR_PTR(err);
diff --git a/net/9p/util.c b/net/9p/util.c
index da6af81..9c1c934 100644
--- a/net/9p/util.c
+++ b/net/9p/util.c
@@ -93,7 +93,7 @@ int p9_idpool_get(struct p9_idpool *p)
 
 retry:
 	if (idr_pre_get(&p->pool, GFP_NOFS) == 0)
-		return 0;
+		return -1;
 
 	spin_lock_irqsave(&p->lock, flags);
 
-- 
1.7.4.1

