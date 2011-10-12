Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753135Ab1JLM3X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 08:29:23 -0400
Received: from mail09.linbit.com ([212.69.161.110]:33955 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752990Ab1JLM1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 08:27:41 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 09/13] drbd: Convert the generic netlink interface to accept connection endpoints
Date: Wed, 12 Oct 2011 14:27:31 +0200
Message-Id: <1318422455-17539-10-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1318422455-17539-1-git-send-email-philipp.reisner@linbit.com>
References: <1318422455-17539-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_int.h      |    7 ++
 drivers/block/drbd/drbd_main.c     |   21 +++++
 drivers/block/drbd/drbd_nl.c       |  149 +++++++++++++++++++++---------------
 drivers/block/drbd/drbd_receiver.c |   21 ++---
 include/linux/drbd_genl.h          |   62 ++++++++--------
 5 files changed, 155 insertions(+), 105 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index c301973..6d6d105 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -836,6 +836,11 @@ struct drbd_tconn {			/* is a resource from the config file */
 	wait_queue_head_t ping_wait;	/* Woken upon reception of a ping, and a state change */
 	struct res_opts res_opts;
 
+	struct sockaddr_storage my_addr;
+	int my_addr_len;
+	struct sockaddr_storage peer_addr;
+	int peer_addr_len;
+
 	struct drbd_socket data;	/* data/barrier/cstate/parameter packets */
 	struct drbd_socket meta;	/* ping/ack (metadata) packets */
 	int agreed_pro_version;		/* actually used protocol version */
@@ -1377,6 +1382,8 @@ extern void drbd_minor_destroy(struct kref *kref);
 struct drbd_tconn *conn_create(const char *name);
 extern void conn_destroy(struct kref *kref);
 struct drbd_tconn *conn_get_by_name(const char *name);
+extern struct drbd_tconn *conn_get_by_addrs(void *my_addr, int my_addr_len,
+					    void *peer_addr, int peer_addr_len);
 extern void conn_free_crypto(struct drbd_tconn *tconn);
 
 extern int proc_details;
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 5b1865e..bfcd1dc 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -2420,6 +2420,27 @@ found:
 	return tconn;
 }
 
+struct drbd_tconn *conn_get_by_addrs(void *my_addr, int my_addr_len,
+				     void *peer_addr, int peer_addr_len)
+{
+	struct drbd_tconn *tconn;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(tconn, &drbd_tconns, all_tconn) {
+		if (tconn->my_addr_len == my_addr_len &&
+		    tconn->peer_addr_len == peer_addr_len &&
+		    !memcmp(&tconn->my_addr, my_addr, my_addr_len) &&
+		    !memcmp(&tconn->peer_addr, peer_addr, peer_addr_len)) {
+			kref_get(&tconn->kref);
+			goto found;
+		}
+	}
+	tconn = NULL;
+found:
+	rcu_read_unlock();
+	return tconn;
+}
+
 static int drbd_alloc_socket(struct drbd_socket *socket)
 {
 	socket->rbuf = (void *) __get_free_page(GFP_KERNEL);
diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index a834097..50f0980 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -118,6 +118,8 @@ static struct drbd_config_context {
 	/* pointer into the request skb,
 	 * limited lifetime! */
 	char *resource_name;
+	struct nlattr *my_addr;
+	struct nlattr *peer_addr;
 
 	/* reply buffer */
 	struct sk_buff *reply_skb;
@@ -166,6 +168,7 @@ int drbd_msg_put_info(const char *info)
  */
 #define DRBD_ADM_NEED_MINOR	1
 #define DRBD_ADM_NEED_RESOURCE	2
+#define DRBD_ADM_NEED_CONNECTION 4
 static int drbd_adm_prepare(struct sk_buff *skb, struct genl_info *info,
 		unsigned flags)
 {
@@ -198,6 +201,7 @@ static int drbd_adm_prepare(struct sk_buff *skb, struct genl_info *info,
 	adm_ctx.reply_dh->minor = d_in->minor;
 	adm_ctx.reply_dh->ret_code = NO_ERROR;
 
+	adm_ctx.volume = VOLUME_UNSPECIFIED;
 	if (info->attrs[DRBD_NLA_CFG_CONTEXT]) {
 		struct nlattr *nla;
 		/* parse and validate only */
@@ -215,12 +219,21 @@ static int drbd_adm_prepare(struct sk_buff *skb, struct genl_info *info,
 
 		/* and assign stuff to the global adm_ctx */
 		nla = nested_attr_tb[__nla_type(T_ctx_volume)];
-		adm_ctx.volume = nla ? nla_get_u32(nla) : VOLUME_UNSPECIFIED;
+		if (nla)
+			adm_ctx.volume = nla_get_u32(nla);
 		nla = nested_attr_tb[__nla_type(T_ctx_resource_name)];
 		if (nla)
 			adm_ctx.resource_name = nla_data(nla);
-	} else
-		adm_ctx.volume = VOLUME_UNSPECIFIED;
+		adm_ctx.my_addr = nested_attr_tb[__nla_type(T_ctx_my_addr)];
+		adm_ctx.peer_addr = nested_attr_tb[__nla_type(T_ctx_peer_addr)];
+		if ((adm_ctx.my_addr &&
+		     nla_len(adm_ctx.my_addr) > sizeof(adm_ctx.tconn->my_addr)) ||
+		    (adm_ctx.peer_addr &&
+		     nla_len(adm_ctx.peer_addr) > sizeof(adm_ctx.tconn->peer_addr))) {
+			err = -EINVAL;
+			goto fail;
+		}
+	}
 
 	adm_ctx.minor = d_in->minor;
 	adm_ctx.mdev = minor_to_mdev(d_in->minor);
@@ -235,6 +248,26 @@ static int drbd_adm_prepare(struct sk_buff *skb, struct genl_info *info,
 		return ERR_INVALID_REQUEST;
 	}
 
+	if (flags & DRBD_ADM_NEED_CONNECTION) {
+		if (adm_ctx.tconn && !(flags & DRBD_ADM_NEED_RESOURCE)) {
+			drbd_msg_put_info("no resource name expected");
+			return ERR_INVALID_REQUEST;
+		}
+		if (adm_ctx.mdev) {
+			drbd_msg_put_info("no minor number expected");
+			return ERR_INVALID_REQUEST;
+		}
+		if (adm_ctx.my_addr && adm_ctx.peer_addr)
+			adm_ctx.tconn = conn_get_by_addrs(nla_data(adm_ctx.my_addr),
+							  nla_len(adm_ctx.my_addr),
+							  nla_data(adm_ctx.peer_addr),
+							  nla_len(adm_ctx.peer_addr));
+		if (!adm_ctx.tconn) {
+			drbd_msg_put_info("unknown connection");
+			return ERR_INVALID_REQUEST;
+		}
+	}
+
 	/* some more paranoia, if the request was over-determined */
 	if (adm_ctx.mdev && adm_ctx.tconn &&
 	    adm_ctx.mdev->tconn != adm_ctx.tconn) {
@@ -292,32 +325,30 @@ static int drbd_adm_finish(struct genl_info *info, int retcode)
 static void setup_khelper_env(struct drbd_tconn *tconn, char **envp)
 {
 	char af[20], ad[60], *afs;
-	struct net_conf *nc;
 
-	rcu_read_lock();
-	nc = rcu_dereference(tconn->net_conf);
-	if (nc) {
-		switch (((struct sockaddr *)nc->peer_addr)->sa_family) {
-		case AF_INET6:
-			afs = "ipv6";
-			snprintf(ad, 60, "DRBD_PEER_ADDRESS=%pI6",
-				 &((struct sockaddr_in6 *)nc->peer_addr)->sin6_addr);
-			break;
-		case AF_INET:
-			afs = "ipv4";
-			snprintf(ad, 60, "DRBD_PEER_ADDRESS=%pI4",
-				 &((struct sockaddr_in *)nc->peer_addr)->sin_addr);
-			break;
-		default:
-			afs = "ssocks";
-			snprintf(ad, 60, "DRBD_PEER_ADDRESS=%pI4",
-				 &((struct sockaddr_in *)nc->peer_addr)->sin_addr);
-		}
-		snprintf(af, 20, "DRBD_PEER_AF=%s", afs);
-		envp[3]=af;
-		envp[4]=ad;
+	/* FIXME: A future version will not allow this case. */
+	if (tconn->my_addr_len == 0 || tconn->peer_addr_len == 0)
+		return;
+
+	switch (((struct sockaddr *)&tconn->peer_addr)->sa_family) {
+	case AF_INET6:
+		afs = "ipv6";
+		snprintf(ad, 60, "DRBD_PEER_ADDRESS=%pI6",
+			 &((struct sockaddr_in6 *)&tconn->peer_addr)->sin6_addr);
+		break;
+	case AF_INET:
+		afs = "ipv4";
+		snprintf(ad, 60, "DRBD_PEER_ADDRESS=%pI4",
+			 &((struct sockaddr_in *)&tconn->peer_addr)->sin_addr);
+		break;
+	default:
+		afs = "ssocks";
+		snprintf(ad, 60, "DRBD_PEER_ADDRESS=%pI4",
+			 &((struct sockaddr_in *)&tconn->peer_addr)->sin_addr);
 	}
-	rcu_read_unlock();
+	snprintf(af, 20, "DRBD_PEER_AF=%s", afs);
+	envp[3]=af;
+	envp[4]=ad;
 }
 
 int drbd_khelper(struct drbd_conf *mdev, char *cmd)
@@ -1909,7 +1940,7 @@ int drbd_adm_net_opts(struct sk_buff *skb, struct genl_info *info)
 	int rsr; /* re-sync running */
 	struct crypto crypto = { };
 
-	retcode = drbd_adm_prepare(skb, info, DRBD_ADM_NEED_RESOURCE);
+	retcode = drbd_adm_prepare(skb, info, DRBD_ADM_NEED_CONNECTION);
 	if (!adm_ctx.reply_skb)
 		return retcode;
 	if (retcode != NO_ERROR)
@@ -2035,18 +2066,38 @@ int drbd_adm_connect(struct sk_buff *skb, struct genl_info *info)
 	struct drbd_conf *mdev;
 	struct net_conf *old_conf, *new_conf = NULL;
 	struct crypto crypto = { };
-	struct drbd_tconn *oconn;
 	struct drbd_tconn *tconn;
-	struct sockaddr *new_my_addr, *new_peer_addr, *taken_addr;
 	enum drbd_ret_code retcode;
 	int i;
 	int err;
 
 	retcode = drbd_adm_prepare(skb, info, DRBD_ADM_NEED_RESOURCE);
+
 	if (!adm_ctx.reply_skb)
 		return retcode;
 	if (retcode != NO_ERROR)
 		goto out;
+	if (!(adm_ctx.my_addr && adm_ctx.peer_addr)) {
+		drbd_msg_put_info("connection endpoint(s) missing");
+		return ERR_INVALID_REQUEST;
+	}
+
+	/* No need for _rcu here. All reconfiguration is
+	 * strictly serialized on genl_lock(). We are protected against
+	 * concurrent reconfiguration/addition/deletion */
+	list_for_each_entry(tconn, &drbd_tconns, all_tconn) {
+		if (nla_len(adm_ctx.my_addr) == tconn->my_addr_len &&
+		    !memcmp(nla_data(adm_ctx.my_addr), &tconn->my_addr, tconn->my_addr_len)) {
+			retcode = ERR_LOCAL_ADDR;
+			goto out;
+		}
+
+		if (nla_len(adm_ctx.peer_addr) == tconn->peer_addr_len &&
+		    !memcmp(nla_data(adm_ctx.peer_addr), &tconn->peer_addr, tconn->peer_addr_len)) {
+			retcode = ERR_PEER_ADDR;
+			goto out;
+		}
+	}
 
 	tconn = adm_ctx.tconn;
 	conn_reconfig_start(tconn);
@@ -2076,37 +2127,6 @@ int drbd_adm_connect(struct sk_buff *skb, struct genl_info *info)
 	if (retcode != NO_ERROR)
 		goto fail;
 
-	retcode = NO_ERROR;
-
-	new_my_addr = (struct sockaddr *)&new_conf->my_addr;
-	new_peer_addr = (struct sockaddr *)&new_conf->peer_addr;
-
-	/* No need for _rcu here. All reconfiguration is
-	 * strictly serialized on genl_lock(). We are protected against
-	 * concurrent reconfiguration/addition/deletion */
-	list_for_each_entry(oconn, &drbd_tconns, all_tconn) {
-		struct net_conf *nc;
-		if (oconn == tconn)
-			continue;
-
-		rcu_read_lock();
-		nc = rcu_dereference(oconn->net_conf);
-		if (nc) {
-			taken_addr = (struct sockaddr *)&nc->my_addr;
-			if (new_conf->my_addr_len == nc->my_addr_len &&
-			    !memcmp(new_my_addr, taken_addr, new_conf->my_addr_len))
-				retcode = ERR_LOCAL_ADDR;
-
-			taken_addr = (struct sockaddr *)&nc->peer_addr;
-			if (new_conf->peer_addr_len == nc->peer_addr_len &&
-			    !memcmp(new_peer_addr, taken_addr, new_conf->peer_addr_len))
-				retcode = ERR_PEER_ADDR;
-		}
-		rcu_read_unlock();
-		if (retcode != NO_ERROR)
-			goto fail;
-	}
-
 	retcode = alloc_crypto(&crypto, new_conf);
 	if (retcode != NO_ERROR)
 		goto fail;
@@ -2132,6 +2152,11 @@ int drbd_adm_connect(struct sk_buff *skb, struct genl_info *info)
 	tconn->csums_tfm = crypto.csums_tfm;
 	tconn->verify_tfm = crypto.verify_tfm;
 
+	tconn->my_addr_len = nla_len(adm_ctx.my_addr);
+	memcpy(&tconn->my_addr, nla_data(adm_ctx.my_addr), tconn->my_addr_len);
+	tconn->peer_addr_len = nla_len(adm_ctx.peer_addr);
+	memcpy(&tconn->peer_addr, nla_data(adm_ctx.peer_addr), tconn->peer_addr_len);
+
 	mutex_unlock(&tconn->conf_update);
 
 	rcu_read_lock();
@@ -2219,7 +2244,7 @@ int drbd_adm_disconnect(struct sk_buff *skb, struct genl_info *info)
 	enum drbd_ret_code retcode;
 	int err;
 
-	retcode = drbd_adm_prepare(skb, info, DRBD_ADM_NEED_RESOURCE);
+	retcode = drbd_adm_prepare(skb, info, DRBD_ADM_NEED_CONNECTION);
 	if (!adm_ctx.reply_skb)
 		return retcode;
 	if (retcode != NO_ERROR)
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 4ba0972..ab1d36c 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -626,23 +626,21 @@ static struct socket *drbd_try_connect(struct drbd_tconn *tconn)
 		rcu_read_unlock();
 		return NULL;
 	}
-
 	sndbuf_size = nc->sndbuf_size;
 	rcvbuf_size = nc->rcvbuf_size;
 	connect_int = nc->connect_int;
+	rcu_read_unlock();
 
-	my_addr_len = min_t(int, nc->my_addr_len, sizeof(src_in6));
-	memcpy(&src_in6, nc->my_addr, my_addr_len);
+	my_addr_len = min_t(int, tconn->my_addr_len, sizeof(src_in6));
+	memcpy(&src_in6, &tconn->my_addr, my_addr_len);
 
-	if (((struct sockaddr *)nc->my_addr)->sa_family == AF_INET6)
+	if (((struct sockaddr *)&tconn->my_addr)->sa_family == AF_INET6)
 		src_in6.sin6_port = 0;
 	else
 		((struct sockaddr_in *)&src_in6)->sin_port = 0; /* AF_INET & AF_SCI */
 
-	peer_addr_len = min_t(int, nc->peer_addr_len, sizeof(src_in6));
-	memcpy(&peer_in6, nc->peer_addr, peer_addr_len);
-
-	rcu_read_unlock();
+	peer_addr_len = min_t(int, tconn->peer_addr_len, sizeof(src_in6));
+	memcpy(&peer_in6, &tconn->peer_addr, peer_addr_len);
 
 	what = "sock_create_kern";
 	err = sock_create_kern(((struct sockaddr *)&src_in6)->sa_family,
@@ -714,15 +712,14 @@ static struct socket *drbd_wait_for_connect(struct drbd_tconn *tconn)
 		rcu_read_unlock();
 		return NULL;
 	}
-
 	sndbuf_size = nc->sndbuf_size;
 	rcvbuf_size = nc->rcvbuf_size;
 	connect_int = nc->connect_int;
-
-	my_addr_len = min_t(int, nc->my_addr_len, sizeof(struct sockaddr_in6));
-	memcpy(&my_addr, nc->my_addr, my_addr_len);
 	rcu_read_unlock();
 
+	my_addr_len = min_t(int, tconn->my_addr_len, sizeof(struct sockaddr_in6));
+	memcpy(&my_addr, &tconn->my_addr, my_addr_len);
+
 	what = "sock_create_kern";
 	err = sock_create_kern(((struct sockaddr *)&my_addr)->sa_family,
 		SOCK_STREAM, IPPROTO_TCP, &s_listen);
diff --git a/include/linux/drbd_genl.h b/include/linux/drbd_genl.h
index 0c2102c..b93db6c 100644
--- a/include/linux/drbd_genl.h
+++ b/include/linux/drbd_genl.h
@@ -97,6 +97,8 @@ GENL_struct(DRBD_NLA_CFG_REPLY, 1, drbd_cfg_reply,
 GENL_struct(DRBD_NLA_CFG_CONTEXT, 2, drbd_cfg_context,
 	__u32_field(1, DRBD_GENLA_F_MANDATORY,	ctx_volume)
 	__str_field(2, DRBD_GENLA_F_MANDATORY,	ctx_resource_name, 128)
+	__bin_field(3, DRBD_GENLA_F_MANDATORY,	ctx_my_addr, 128)
+	__bin_field(4, DRBD_GENLA_F_MANDATORY,	ctx_peer_addr, 128)
 )
 
 GENL_struct(DRBD_NLA_DISK_CONF, 3, disk_conf,
@@ -134,38 +136,36 @@ GENL_struct(DRBD_NLA_RESOURCE_OPTS, 4, res_opts,
 )
 
 GENL_struct(DRBD_NLA_NET_CONF, 5, net_conf,
-	__bin_field(1,	DRBD_F_REQUIRED | DRBD_F_INVARIANT,	my_addr,	128)
-	__bin_field(2,	DRBD_F_REQUIRED | DRBD_F_INVARIANT,	peer_addr,	128)
-	__str_field_def(3,	DRBD_GENLA_F_MANDATORY | DRBD_F_SENSITIVE,
+	__str_field_def(1,	DRBD_GENLA_F_MANDATORY | DRBD_F_SENSITIVE,
 						shared_secret,	SHARED_SECRET_MAX)
-	__str_field_def(4,	DRBD_GENLA_F_MANDATORY,	cram_hmac_alg,	SHARED_SECRET_MAX)
-	__str_field_def(5,	DRBD_GENLA_F_MANDATORY,	integrity_alg,	SHARED_SECRET_MAX)
-	__str_field_def(6,	DRBD_GENLA_F_MANDATORY,	verify_alg,     SHARED_SECRET_MAX)
-	__str_field_def(7,	DRBD_GENLA_F_MANDATORY,	csums_alg,	SHARED_SECRET_MAX)
-	__u32_field_def(8,	DRBD_GENLA_F_MANDATORY,	wire_protocol, DRBD_PROTOCOL_DEF)
-	__u32_field_def(9,	DRBD_GENLA_F_MANDATORY,	connect_int, DRBD_CONNECT_INT_DEF)
-	__u32_field_def(10,	DRBD_GENLA_F_MANDATORY,	timeout, DRBD_TIMEOUT_DEF)
-	__u32_field_def(11,	DRBD_GENLA_F_MANDATORY,	ping_int, DRBD_PING_INT_DEF)
-	__u32_field_def(12,	DRBD_GENLA_F_MANDATORY,	ping_timeo, DRBD_PING_TIMEO_DEF)
-	__u32_field_def(13,	DRBD_GENLA_F_MANDATORY,	sndbuf_size, DRBD_SNDBUF_SIZE_DEF)
-	__u32_field_def(14,	DRBD_GENLA_F_MANDATORY,	rcvbuf_size, DRBD_RCVBUF_SIZE_DEF)
-	__u32_field_def(15,	DRBD_GENLA_F_MANDATORY,	ko_count, DRBD_KO_COUNT_DEF)
-	__u32_field_def(16,	DRBD_GENLA_F_MANDATORY,	max_buffers, DRBD_MAX_BUFFERS_DEF)
-	__u32_field_def(17,	DRBD_GENLA_F_MANDATORY,	max_epoch_size, DRBD_MAX_EPOCH_SIZE_DEF)
-	__u32_field_def(18,	DRBD_GENLA_F_MANDATORY,	unplug_watermark, DRBD_UNPLUG_WATERMARK_DEF)
-	__u32_field_def(19,	DRBD_GENLA_F_MANDATORY,	after_sb_0p, DRBD_AFTER_SB_0P_DEF)
-	__u32_field_def(20,	DRBD_GENLA_F_MANDATORY,	after_sb_1p, DRBD_AFTER_SB_1P_DEF)
-	__u32_field_def(21,	DRBD_GENLA_F_MANDATORY,	after_sb_2p, DRBD_AFTER_SB_2P_DEF)
-	__u32_field_def(22,	DRBD_GENLA_F_MANDATORY,	rr_conflict, DRBD_RR_CONFLICT_DEF)
-	__u32_field_def(23,	DRBD_GENLA_F_MANDATORY,	on_congestion, DRBD_ON_CONGESTION_DEF)
-	__u32_field_def(24,	DRBD_GENLA_F_MANDATORY,	cong_fill, DRBD_CONG_FILL_DEF)
-	__u32_field_def(25,	DRBD_GENLA_F_MANDATORY,	cong_extents, DRBD_CONG_EXTENTS_DEF)
-	__flg_field_def(26, DRBD_GENLA_F_MANDATORY,	two_primaries, DRBD_ALLOW_TWO_PRIMARIES_DEF)
-	__flg_field(27, DRBD_GENLA_F_MANDATORY | DRBD_F_INVARIANT,	discard_my_data)
-	__flg_field_def(28, DRBD_GENLA_F_MANDATORY,	tcp_cork, DRBD_TCP_CORK_DEF)
-	__flg_field_def(29, DRBD_GENLA_F_MANDATORY,	always_asbp, DRBD_ALWAYS_ASBP_DEF)
-	__flg_field(30, DRBD_GENLA_F_MANDATORY | DRBD_F_INVARIANT,	dry_run)
-	__flg_field_def(31,	DRBD_GENLA_F_MANDATORY,	use_rle, DRBD_USE_RLE_DEF)
+	__str_field_def(2,	DRBD_GENLA_F_MANDATORY,	cram_hmac_alg,	SHARED_SECRET_MAX)
+	__str_field_def(3,	DRBD_GENLA_F_MANDATORY,	integrity_alg,	SHARED_SECRET_MAX)
+	__str_field_def(4,	DRBD_GENLA_F_MANDATORY,	verify_alg,     SHARED_SECRET_MAX)
+	__str_field_def(5,	DRBD_GENLA_F_MANDATORY,	csums_alg,	SHARED_SECRET_MAX)
+	__u32_field_def(6,	DRBD_GENLA_F_MANDATORY,	wire_protocol, DRBD_PROTOCOL_DEF)
+	__u32_field_def(7,	DRBD_GENLA_F_MANDATORY,	connect_int, DRBD_CONNECT_INT_DEF)
+	__u32_field_def(8,	DRBD_GENLA_F_MANDATORY,	timeout, DRBD_TIMEOUT_DEF)
+	__u32_field_def(9,	DRBD_GENLA_F_MANDATORY,	ping_int, DRBD_PING_INT_DEF)
+	__u32_field_def(10,	DRBD_GENLA_F_MANDATORY,	ping_timeo, DRBD_PING_TIMEO_DEF)
+	__u32_field_def(11,	DRBD_GENLA_F_MANDATORY,	sndbuf_size, DRBD_SNDBUF_SIZE_DEF)
+	__u32_field_def(12,	DRBD_GENLA_F_MANDATORY,	rcvbuf_size, DRBD_RCVBUF_SIZE_DEF)
+	__u32_field_def(13,	DRBD_GENLA_F_MANDATORY,	ko_count, DRBD_KO_COUNT_DEF)
+	__u32_field_def(14,	DRBD_GENLA_F_MANDATORY,	max_buffers, DRBD_MAX_BUFFERS_DEF)
+	__u32_field_def(15,	DRBD_GENLA_F_MANDATORY,	max_epoch_size, DRBD_MAX_EPOCH_SIZE_DEF)
+	__u32_field_def(16,	DRBD_GENLA_F_MANDATORY,	unplug_watermark, DRBD_UNPLUG_WATERMARK_DEF)
+	__u32_field_def(17,	DRBD_GENLA_F_MANDATORY,	after_sb_0p, DRBD_AFTER_SB_0P_DEF)
+	__u32_field_def(18,	DRBD_GENLA_F_MANDATORY,	after_sb_1p, DRBD_AFTER_SB_1P_DEF)
+	__u32_field_def(19,	DRBD_GENLA_F_MANDATORY,	after_sb_2p, DRBD_AFTER_SB_2P_DEF)
+	__u32_field_def(20,	DRBD_GENLA_F_MANDATORY,	rr_conflict, DRBD_RR_CONFLICT_DEF)
+	__u32_field_def(21,	DRBD_GENLA_F_MANDATORY,	on_congestion, DRBD_ON_CONGESTION_DEF)
+	__u32_field_def(22,	DRBD_GENLA_F_MANDATORY,	cong_fill, DRBD_CONG_FILL_DEF)
+	__u32_field_def(23,	DRBD_GENLA_F_MANDATORY,	cong_extents, DRBD_CONG_EXTENTS_DEF)
+	__flg_field_def(24, DRBD_GENLA_F_MANDATORY,	two_primaries, DRBD_ALLOW_TWO_PRIMARIES_DEF)
+	__flg_field(25, DRBD_GENLA_F_MANDATORY | DRBD_F_INVARIANT,	discard_my_data)
+	__flg_field_def(26, DRBD_GENLA_F_MANDATORY,	tcp_cork, DRBD_TCP_CORK_DEF)
+	__flg_field_def(27, DRBD_GENLA_F_MANDATORY,	always_asbp, DRBD_ALWAYS_ASBP_DEF)
+	__flg_field(28, DRBD_GENLA_F_MANDATORY | DRBD_F_INVARIANT,	dry_run)
+	__flg_field_def(29,	DRBD_GENLA_F_MANDATORY,	use_rle, DRBD_USE_RLE_DEF)
 )
 
 GENL_struct(DRBD_NLA_SET_ROLE_PARMS, 6, set_role_parms,
-- 
1.7.4.1

