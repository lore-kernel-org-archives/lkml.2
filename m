Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932472Ab2KZREo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:04:44 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47388 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932412Ab2KZREh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:04:37 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Elder <elder@inktank.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 078/270] libceph: embed ceph messenger structure in ceph_client
Date: Mon, 26 Nov 2012 14:56:08 -0200
Message-Id: <1353949160-26803-79-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Elder <elder@inktank.com>

commit 15d9882c336db2db73ccf9871ae2398e452f694c upstream.

A ceph client has a pointer to a ceph messenger structure in it.
There is always exactly one ceph messenger for a ceph client, so
there is no need to allocate it separate from the ceph client
structure.

Switch the ceph_client structure to embed its ceph_messenger
structure.

Signed-off-by: Alex Elder <elder@inktank.com>
Reviewed-by: Yehuda Sadeh <yehuda@inktank.com>
Reviewed-by: Sage Weil <sage@inktank.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 fs/ceph/mds_client.c           |    2 +-
 include/linux/ceph/libceph.h   |    2 +-
 include/linux/ceph/messenger.h |    9 +++++----
 net/ceph/ceph_common.c         |   18 +++++-------------
 net/ceph/messenger.c           |   30 +++++++++---------------------
 net/ceph/mon_client.c          |    6 +++---
 net/ceph/osd_client.c          |    4 ++--
 7 files changed, 26 insertions(+), 45 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 200bc87..ad30261 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -394,7 +394,7 @@ static struct ceph_mds_session *register_session(struct ceph_mds_client *mdsc,
 	s->s_seq = 0;
 	mutex_init(&s->s_mutex);
 
-	ceph_con_init(mdsc->fsc->client->msgr, &s->s_con);
+	ceph_con_init(&mdsc->fsc->client->msgr, &s->s_con);
 	s->s_con.private = s;
 	s->s_con.ops = &mds_con_ops;
 	s->s_con.peer_name.type = CEPH_ENTITY_TYPE_MDS;
diff --git a/include/linux/ceph/libceph.h b/include/linux/ceph/libceph.h
index e71d683..98ec36a 100644
--- a/include/linux/ceph/libceph.h
+++ b/include/linux/ceph/libceph.h
@@ -132,7 +132,7 @@ struct ceph_client {
 	u32 supported_features;
 	u32 required_features;
 
-	struct ceph_messenger *msgr;   /* messenger instance */
+	struct ceph_messenger msgr;   /* messenger instance */
 	struct ceph_mon_client monc;
 	struct ceph_osd_client osdc;
 
diff --git a/include/linux/ceph/messenger.h b/include/linux/ceph/messenger.h
index ce7a483..771b2ed 100644
--- a/include/linux/ceph/messenger.h
+++ b/include/linux/ceph/messenger.h
@@ -203,10 +203,11 @@ extern int ceph_msgr_init(void);
 extern void ceph_msgr_exit(void);
 extern void ceph_msgr_flush(void);
 
-extern struct ceph_messenger *ceph_messenger_create(
-	struct ceph_entity_addr *myaddr,
-	u32 features, u32 required);
-extern void ceph_messenger_destroy(struct ceph_messenger *);
+extern void ceph_messenger_init(struct ceph_messenger *msgr,
+			struct ceph_entity_addr *myaddr,
+			u32 supported_features,
+			u32 required_features,
+			bool nocrc);
 
 extern void ceph_con_init(struct ceph_messenger *msgr,
 			  struct ceph_connection *con);
diff --git a/net/ceph/ceph_common.c b/net/ceph/ceph_common.c
index ba4323b..58b09ef 100644
--- a/net/ceph/ceph_common.c
+++ b/net/ceph/ceph_common.c
@@ -468,19 +468,15 @@ struct ceph_client *ceph_create_client(struct ceph_options *opt, void *private,
 	/* msgr */
 	if (ceph_test_opt(client, MYIP))
 		myaddr = &client->options->my_addr;
-	client->msgr = ceph_messenger_create(myaddr,
-					     client->supported_features,
-					     client->required_features);
-	if (IS_ERR(client->msgr)) {
-		err = PTR_ERR(client->msgr);
-		goto fail;
-	}
-	client->msgr->nocrc = ceph_test_opt(client, NOCRC);
+	ceph_messenger_init(&client->msgr, myaddr,
+		client->supported_features,
+		client->required_features,
+		ceph_test_opt(client, NOCRC));
 
 	/* subsystems */
 	err = ceph_monc_init(&client->monc, client);
 	if (err < 0)
-		goto fail_msgr;
+		goto fail;
 	err = ceph_osdc_init(&client->osdc, client);
 	if (err < 0)
 		goto fail_monc;
@@ -489,8 +485,6 @@ struct ceph_client *ceph_create_client(struct ceph_options *opt, void *private,
 
 fail_monc:
 	ceph_monc_stop(&client->monc);
-fail_msgr:
-	ceph_messenger_destroy(client->msgr);
 fail:
 	kfree(client);
 	return ERR_PTR(err);
@@ -508,8 +502,6 @@ void ceph_destroy_client(struct ceph_client *client)
 
 	ceph_debugfs_client_cleanup(client);
 
-	ceph_messenger_destroy(client->msgr);
-
 	ceph_destroy_options(client->options);
 
 	kfree(client);
diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index d0b27e9..a04557e 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -2249,18 +2249,14 @@ out:
 
 
 /*
- * create a new messenger instance
+ * initialize a new messenger instance
  */
-struct ceph_messenger *ceph_messenger_create(struct ceph_entity_addr *myaddr,
-					     u32 supported_features,
-					     u32 required_features)
+void ceph_messenger_init(struct ceph_messenger *msgr,
+			struct ceph_entity_addr *myaddr,
+			u32 supported_features,
+			u32 required_features,
+			bool nocrc)
 {
-	struct ceph_messenger *msgr;
-
-	msgr = kzalloc(sizeof(*msgr), GFP_KERNEL);
-	if (msgr == NULL)
-		return ERR_PTR(-ENOMEM);
-
 	msgr->supported_features = supported_features;
 	msgr->required_features = required_features;
 
@@ -2273,19 +2269,11 @@ struct ceph_messenger *ceph_messenger_create(struct ceph_entity_addr *myaddr,
 	msgr->inst.addr.type = 0;
 	get_random_bytes(&msgr->inst.addr.nonce, sizeof(msgr->inst.addr.nonce));
 	encode_my_addr(msgr);
+	msgr->nocrc = nocrc;
 
-	dout("messenger_create %p\n", msgr);
-	return msgr;
-}
-EXPORT_SYMBOL(ceph_messenger_create);
-
-void ceph_messenger_destroy(struct ceph_messenger *msgr)
-{
-	dout("destroy %p\n", msgr);
-	kfree(msgr);
-	dout("destroyed messenger %p\n", msgr);
+	dout("%s %p\n", __func__, msgr);
 }
-EXPORT_SYMBOL(ceph_messenger_destroy);
+EXPORT_SYMBOL(ceph_messenger_init);
 
 static void clear_standby(struct ceph_connection *con)
 {
diff --git a/net/ceph/mon_client.c b/net/ceph/mon_client.c
index d0649a9..37c4cd7 100644
--- a/net/ceph/mon_client.c
+++ b/net/ceph/mon_client.c
@@ -763,7 +763,7 @@ int ceph_monc_init(struct ceph_mon_client *monc, struct ceph_client *cl)
 	monc->con = kmalloc(sizeof(*monc->con), GFP_KERNEL);
 	if (!monc->con)
 		goto out_monmap;
-	ceph_con_init(monc->client->msgr, monc->con);
+	ceph_con_init(&monc->client->msgr, monc->con);
 	monc->con->private = monc;
 	monc->con->ops = &mon_con_ops;
 
@@ -888,8 +888,8 @@ static void handle_auth_reply(struct ceph_mon_client *monc,
 	} else if (!was_auth && monc->auth->ops->is_authenticated(monc->auth)) {
 		dout("authenticated, starting session\n");
 
-		monc->client->msgr->inst.name.type = CEPH_ENTITY_TYPE_CLIENT;
-		monc->client->msgr->inst.name.num =
+		monc->client->msgr.inst.name.type = CEPH_ENTITY_TYPE_CLIENT;
+		monc->client->msgr.inst.name.num =
 					cpu_to_le64(monc->auth->global_id);
 
 		__send_subscribe(monc);
diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index ca59e66..dc532c5 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -639,7 +639,7 @@ static struct ceph_osd *create_osd(struct ceph_osd_client *osdc)
 	INIT_LIST_HEAD(&osd->o_osd_lru);
 	osd->o_incarnation = 1;
 
-	ceph_con_init(osdc->client->msgr, &osd->o_con);
+	ceph_con_init(&osdc->client->msgr, &osd->o_con);
 	osd->o_con.private = osd;
 	osd->o_con.ops = &osd_con_ops;
 	osd->o_con.peer_name.type = CEPH_ENTITY_TYPE_OSD;
@@ -1391,7 +1391,7 @@ void ceph_osdc_handle_map(struct ceph_osd_client *osdc, struct ceph_msg *msg)
 			     epoch, maplen);
 			newmap = osdmap_apply_incremental(&p, next,
 							  osdc->osdmap,
-							  osdc->client->msgr);
+							  &osdc->client->msgr);
 			if (IS_ERR(newmap)) {
 				err = PTR_ERR(newmap);
 				goto bad;
-- 
1.7.9.5

