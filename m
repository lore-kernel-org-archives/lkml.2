Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932607Ab2KZRFN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:05:13 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47420 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932562Ab2KZRFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:05:09 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Elder <elder@inktank.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 086/270] libceph: fully initialize connection in con_init()
Date: Mon, 26 Nov 2012 14:56:16 -0200
Message-Id: <1353949160-26803-87-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Elder <elder@inktank.com>

commit 1bfd89f4e6e1adc6a782d94aa5d4c53be1e404d7 upstream.

Move the initialization of a ceph connection's private pointer,
operations vector pointer, and peer name information into
ceph_con_init().  Rearrange the arguments so the connection pointer
is first.  Hide the byte-swapping of the peer entity number inside
ceph_con_init()

Signed-off-by: Alex Elder <elder@inktank.com>
Reviewed-by: Sage Weil <sage@inktank.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 fs/ceph/mds_client.c           |    7 ++-----
 include/linux/ceph/messenger.h |    6 ++++--
 net/ceph/messenger.c           |    9 ++++++++-
 net/ceph/mon_client.c          |    8 +++-----
 net/ceph/osd_client.c          |    7 ++-----
 5 files changed, 19 insertions(+), 18 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index ad30261..ecd7f15 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -394,11 +394,8 @@ static struct ceph_mds_session *register_session(struct ceph_mds_client *mdsc,
 	s->s_seq = 0;
 	mutex_init(&s->s_mutex);
 
-	ceph_con_init(&mdsc->fsc->client->msgr, &s->s_con);
-	s->s_con.private = s;
-	s->s_con.ops = &mds_con_ops;
-	s->s_con.peer_name.type = CEPH_ENTITY_TYPE_MDS;
-	s->s_con.peer_name.num = cpu_to_le64(mds);
+	ceph_con_init(&s->s_con, s, &mds_con_ops, &mdsc->fsc->client->msgr,
+		CEPH_ENTITY_TYPE_MDS, mds);
 
 	spin_lock_init(&s->s_gen_ttl_lock);
 	s->s_cap_gen = 0;
diff --git a/include/linux/ceph/messenger.h b/include/linux/ceph/messenger.h
index 5f30c81..7ed7a87 100644
--- a/include/linux/ceph/messenger.h
+++ b/include/linux/ceph/messenger.h
@@ -219,8 +219,10 @@ extern void ceph_messenger_init(struct ceph_messenger *msgr,
 			u32 required_features,
 			bool nocrc);
 
-extern void ceph_con_init(struct ceph_messenger *msgr,
-			  struct ceph_connection *con);
+extern void ceph_con_init(struct ceph_connection *con, void *private,
+			const struct ceph_connection_operations *ops,
+			struct ceph_messenger *msgr, __u8 entity_type,
+			__u64 entity_num);
 extern void ceph_con_open(struct ceph_connection *con,
 			  struct ceph_entity_addr *addr);
 extern bool ceph_con_opened(struct ceph_connection *con);
diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index 603d8b5..d8986e8 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -521,15 +521,22 @@ void ceph_con_put(struct ceph_connection *con)
 /*
  * initialize a new connection.
  */
-void ceph_con_init(struct ceph_messenger *msgr, struct ceph_connection *con)
+void ceph_con_init(struct ceph_connection *con, void *private,
+	const struct ceph_connection_operations *ops,
+	struct ceph_messenger *msgr, __u8 entity_type, __u64 entity_num)
 {
 	dout("con_init %p\n", con);
 	memset(con, 0, sizeof(*con));
+	con->private = private;
+	con->ops = ops;
 	atomic_set(&con->nref, 1);
 	con->msgr = msgr;
 
 	con_sock_state_init(con);
 
+	con->peer_name.type = (__u8) entity_type;
+	con->peer_name.num = cpu_to_le64(entity_num);
+
 	mutex_init(&con->mutex);
 	INIT_LIST_HEAD(&con->out_queue);
 	INIT_LIST_HEAD(&con->out_sent);
diff --git a/net/ceph/mon_client.c b/net/ceph/mon_client.c
index fec3147..dad0abb 100644
--- a/net/ceph/mon_client.c
+++ b/net/ceph/mon_client.c
@@ -142,11 +142,9 @@ static int __open_session(struct ceph_mon_client *monc)
 		monc->sub_renew_after = jiffies;  /* i.e., expired */
 		monc->want_next_osdmap = !!monc->want_next_osdmap;
 
-		ceph_con_init(&monc->client->msgr, &monc->con);
-		monc->con.private = monc;
-		monc->con.ops = &mon_con_ops;
-		monc->con.peer_name.type = CEPH_ENTITY_TYPE_MON;
-		monc->con.peer_name.num = cpu_to_le64(monc->cur_mon);
+		ceph_con_init(&monc->con, monc, &mon_con_ops,
+			&monc->client->msgr,
+			CEPH_ENTITY_TYPE_MON, monc->cur_mon);
 
 		dout("open_session mon%d opening\n", monc->cur_mon);
 		ceph_con_open(&monc->con,
diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index cb5b847..01ec0ac 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -640,11 +640,8 @@ static struct ceph_osd *create_osd(struct ceph_osd_client *osdc, int onum)
 	INIT_LIST_HEAD(&osd->o_osd_lru);
 	osd->o_incarnation = 1;
 
-	ceph_con_init(&osdc->client->msgr, &osd->o_con);
-	osd->o_con.private = osd;
-	osd->o_con.ops = &osd_con_ops;
-	osd->o_con.peer_name.type = CEPH_ENTITY_TYPE_OSD;
-	osd->o_con.peer_name.num = cpu_to_le64(onum);
+	ceph_con_init(&osd->o_con, osd, &osd_con_ops, &osdc->client->msgr,
+		CEPH_ENTITY_TYPE_OSD, onum);
 
 	INIT_LIST_HEAD(&osd->o_keepalive_item);
 	return osd;
-- 
1.7.9.5

