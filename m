Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753231Ab1JLMaE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 08:30:04 -0400
Received: from mail09.linbit.com ([212.69.161.110]:33930 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753021Ab1JLM1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 08:27:40 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 06/13] drbd: Also need to check for DRBD_GENLA_F_MANDATORY flags before nla_find_nested()
Date: Wed, 12 Oct 2011 14:27:28 +0200
Message-Id: <1318422455-17539-7-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1318422455-17539-1-git-send-email-philipp.reisner@linbit.com>
References: <1318422455-17539-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

This is done by introducing drbd_nla_find_nested() which handles the flag
before calling nla_find_nested().

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_int.h   |    6 +++
 drivers/block/drbd/drbd_nl.c    |   96 +++++++++++++++++++++++++++++++--------
 include/linux/drbd_genl.h       |    2 +-
 include/linux/genl_magic_func.h |   37 ---------------
 4 files changed, 83 insertions(+), 58 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index c301973..c584301 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -1407,6 +1407,12 @@ extern bool conn_try_outdate_peer(struct drbd_tconn *tconn);
 extern void conn_try_outdate_peer_async(struct drbd_tconn *tconn);
 extern int drbd_khelper(struct drbd_conf *mdev, char *cmd);
 
+struct nla_policy;
+extern int drbd_nla_check_mandatory(int maxtype, struct nlattr *nla);
+extern int drbd_nla_parse_nested(struct nlattr *tb[], int maxtype, struct nlattr *nla,
+				 const struct nla_policy *policy);
+extern struct nlattr *drbd_nla_find_nested(int maxtype, struct nlattr *nla, int attrtype);
+
 /* drbd_worker.c */
 extern int drbd_worker(struct drbd_thread *thi);
 enum drbd_ret_code drbd_resync_after_valid(struct drbd_conf *mdev, int o_minor);
diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index 8be3bef..b75fde7 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -116,7 +116,7 @@ static struct drbd_config_context {
 #define VOLUME_UNSPECIFIED		(-1U)
 	/* pointer into the request skb,
 	 * limited lifetime! */
-	char *conn_name;
+	char *resource_name;
 
 	/* reply buffer */
 	struct sk_buff *reply_skb;
@@ -215,15 +215,15 @@ static int drbd_adm_prepare(struct sk_buff *skb, struct genl_info *info,
 		/* and assign stuff to the global adm_ctx */
 		nla = nested_attr_tb[__nla_type(T_ctx_volume)];
 		adm_ctx.volume = nla ? nla_get_u32(nla) : VOLUME_UNSPECIFIED;
-		nla = nested_attr_tb[__nla_type(T_ctx_conn_name)];
+		nla = nested_attr_tb[__nla_type(T_ctx_resource_name)];
 		if (nla)
-			adm_ctx.conn_name = nla_data(nla);
+			adm_ctx.resource_name = nla_data(nla);
 	} else
 		adm_ctx.volume = VOLUME_UNSPECIFIED;
 
 	adm_ctx.minor = d_in->minor;
 	adm_ctx.mdev = minor_to_mdev(d_in->minor);
-	adm_ctx.tconn = conn_get_by_name(adm_ctx.conn_name);
+	adm_ctx.tconn = conn_get_by_name(adm_ctx.resource_name);
 
 	if (!adm_ctx.mdev && (flags & DRBD_ADM_NEED_MINOR)) {
 		drbd_msg_put_info("unknown minor");
@@ -238,7 +238,8 @@ static int drbd_adm_prepare(struct sk_buff *skb, struct genl_info *info,
 	if (adm_ctx.mdev && adm_ctx.tconn &&
 	    adm_ctx.mdev->tconn != adm_ctx.tconn) {
 		pr_warning("request: minor=%u, conn=%s; but that minor belongs to connection %s\n",
-				adm_ctx.minor, adm_ctx.conn_name, adm_ctx.mdev->tconn->name);
+				adm_ctx.minor, adm_ctx.resource_name,
+				adm_ctx.mdev->tconn->name);
 		drbd_msg_put_info("minor exists in different connection");
 		return ERR_INVALID_REQUEST;
 	}
@@ -263,7 +264,7 @@ fail:
 static int drbd_adm_finish(struct genl_info *info, int retcode)
 {
 	struct nlattr *nla;
-	const char *conn_name = NULL;
+	const char *resource_name = NULL;
 
 	if (adm_ctx.tconn) {
 		kref_put(&adm_ctx.tconn->kref, &conn_destroy);
@@ -277,9 +278,10 @@ static int drbd_adm_finish(struct genl_info *info, int retcode)
 
 	nla = info->attrs[DRBD_NLA_CFG_CONTEXT];
 	if (nla) {
-		nla = nla_find_nested(nla, __nla_type(T_ctx_conn_name));
-		if (nla)
-			conn_name = nla_data(nla);
+		int maxtype = ARRAY_SIZE(drbd_cfg_context_nl_policy) - 1;
+		nla = drbd_nla_find_nested(maxtype, nla, __nla_type(T_ctx_resource_name));
+		if (nla && !IS_ERR(nla))
+			resource_name = nla_data(nla);
 	}
 
 	drbd_adm_send_reply(adm_ctx.reply_skb, info);
@@ -2575,7 +2577,7 @@ int drbd_adm_outdate(struct sk_buff *skb, struct genl_info *info)
 	return drbd_adm_simple_request_state(skb, info, NS(disk, D_OUTDATED));
 }
 
-int nla_put_drbd_cfg_context(struct sk_buff *skb, const char *conn_name, unsigned vnr)
+int nla_put_drbd_cfg_context(struct sk_buff *skb, const char *resource_name, unsigned vnr)
 {
 	struct nlattr *nla;
 	nla = nla_nest_start(skb, DRBD_NLA_CFG_CONTEXT);
@@ -2583,7 +2585,7 @@ int nla_put_drbd_cfg_context(struct sk_buff *skb, const char *conn_name, unsigne
 		goto nla_put_failure;
 	if (vnr != VOLUME_UNSPECIFIED)
 		NLA_PUT_U32(skb, T_ctx_volume, vnr);
-	NLA_PUT_STRING(skb, T_ctx_conn_name, conn_name);
+	NLA_PUT_STRING(skb, T_ctx_resource_name, resource_name);
 	nla_nest_end(skb, nla);
 	return 0;
 
@@ -2827,8 +2829,9 @@ int drbd_adm_get_status_all(struct sk_buff *skb, struct netlink_callback *cb)
 {
 	const unsigned hdrlen = GENL_HDRLEN + GENL_MAGIC_FAMILY_HDRSZ;
 	struct nlattr *nla;
-	const char *conn_name;
+	const char *resource_name;
 	struct drbd_tconn *tconn;
+	int maxtype;
 
 	/* Is this a followup call? */
 	if (cb->args[0]) {
@@ -2848,12 +2851,15 @@ int drbd_adm_get_status_all(struct sk_buff *skb, struct netlink_callback *cb)
 	/* No explicit context given.  Dump all. */
 	if (!nla)
 		goto dump;
-	nla = nla_find_nested(nla, __nla_type(T_ctx_conn_name));
+	maxtype = ARRAY_SIZE(drbd_cfg_context_nl_policy) - 1;
+	nla = drbd_nla_find_nested(maxtype, nla, __nla_type(T_ctx_resource_name));
+	if (IS_ERR(nla))
+		return PTR_ERR(nla);
 	/* context given, but no name present? */
 	if (!nla)
 		return -EINVAL;
-	conn_name = nla_data(nla);
-	tconn = conn_get_by_name(conn_name);
+	resource_name = nla_data(nla);
+	tconn = conn_get_by_name(resource_name);
 
 	if (!tconn)
 		return -ENODEV;
@@ -3006,16 +3012,16 @@ out_nolock:
 }
 
 static enum drbd_ret_code
-drbd_check_conn_name(const char *name)
+drbd_check_resource_name(const char *name)
 {
 	if (!name || !name[0]) {
-		drbd_msg_put_info("connection name missing");
+		drbd_msg_put_info("resource name missing");
 		return ERR_MANDATORY_TAG;
 	}
 	/* if we want to use these in sysfs/configfs/debugfs some day,
 	 * we must not allow slashes */
 	if (strchr(name, '/')) {
-		drbd_msg_put_info("invalid connection name");
+		drbd_msg_put_info("invalid resource name");
 		return ERR_INVALID_REQUEST;
 	}
 	return NO_ERROR;
@@ -3031,7 +3037,7 @@ int drbd_adm_new_resource(struct sk_buff *skb, struct genl_info *info)
 	if (retcode != NO_ERROR)
 		goto out;
 
-	retcode = drbd_check_conn_name(adm_ctx.conn_name);
+	retcode = drbd_check_resource_name(adm_ctx.resource_name);
 	if (retcode != NO_ERROR)
 		goto out;
 
@@ -3044,7 +3050,7 @@ int drbd_adm_new_resource(struct sk_buff *skb, struct genl_info *info)
 		goto out;
 	}
 
-	if (!conn_create(adm_ctx.conn_name))
+	if (!conn_create(adm_ctx.resource_name))
 		retcode = ERR_NOMEM;
 out:
 	drbd_adm_finish(info, retcode);
@@ -3260,3 +3266,53 @@ failed:
 			"Event seq:%u sib_reason:%u\n",
 			err, seq, sib->sib_reason);
 }
+
+int drbd_nla_check_mandatory(int maxtype, struct nlattr *nla)
+{
+	struct nlattr *head = nla_data(nla);
+	int len = nla_len(nla);
+	int rem;
+
+	/*
+	 * validate_nla (called from nla_parse_nested) ignores attributes
+	 * beyond maxtype, and does not understand the DRBD_GENLA_F_MANDATORY flag.
+	 * In order to have it validate attributes with the DRBD_GENLA_F_MANDATORY
+	 * flag set also, check and remove that flag before calling
+	 * nla_parse_nested.
+	 */
+
+	nla_for_each_attr(nla, head, len, rem) {
+		if (nla->nla_type & DRBD_GENLA_F_MANDATORY) {
+			nla->nla_type &= ~DRBD_GENLA_F_MANDATORY;
+			if (nla_type(nla) > maxtype)
+				return -EOPNOTSUPP;
+		}
+	}
+	return 0;
+}
+
+int drbd_nla_parse_nested(struct nlattr *tb[], int maxtype, struct nlattr *nla,
+			  const struct nla_policy *policy)
+{
+	int err;
+
+	err = drbd_nla_check_mandatory(maxtype, nla);
+	if (!err)
+		err = nla_parse_nested(tb, maxtype, nla, policy);
+
+	return err;
+}
+
+struct nlattr *drbd_nla_find_nested(int maxtype, struct nlattr *nla, int attrtype)
+{
+	int err;
+	/*
+	 * If any nested attribute has the DRBD_GENLA_F_MANDATORY flag set and
+	 * we don't know about that attribute, reject all the nested
+	 * attributes.
+	 */
+	err = drbd_nla_check_mandatory(maxtype, nla);
+	if (err)
+		return ERR_PTR(err);
+	return nla_find_nested(nla, attrtype);
+}
diff --git a/include/linux/drbd_genl.h b/include/linux/drbd_genl.h
index 47ef324..0c2102c 100644
--- a/include/linux/drbd_genl.h
+++ b/include/linux/drbd_genl.h
@@ -96,7 +96,7 @@ GENL_struct(DRBD_NLA_CFG_REPLY, 1, drbd_cfg_reply,
  * and the volume id within the resource. */
 GENL_struct(DRBD_NLA_CFG_CONTEXT, 2, drbd_cfg_context,
 	__u32_field(1, DRBD_GENLA_F_MANDATORY,	ctx_volume)
-	__str_field(2, DRBD_GENLA_F_MANDATORY,	ctx_conn_name, 128)
+	__str_field(2, DRBD_GENLA_F_MANDATORY,	ctx_resource_name, 128)
 )
 
 GENL_struct(DRBD_NLA_DISK_CONF, 3, disk_conf,
diff --git a/include/linux/genl_magic_func.h b/include/linux/genl_magic_func.h
index 2d38695..a0bb87f 100644
--- a/include/linux/genl_magic_func.h
+++ b/include/linux/genl_magic_func.h
@@ -142,43 +142,6 @@ static struct nlattr *nested_attr_tb[128];
 #define BUILD_BUG_ON_NULL(e) ((void *)sizeof(struct { int:-!!(e); }))
 #endif
 
-static inline int drbd_nla_check_mandatory(int maxtype, struct nlattr *nla)
-{
-	struct nlattr *head = nla_data(nla);
-	int len = nla_len(nla);
-	int rem;
-
-	/*
-	 * validate_nla (called from nla_parse_nested) ignores attributes
-	 * beyond maxtype, and does not understand the DRBD_GENLA_F_MANDATORY flag.
-	 * In order to have it validate attributes with the DRBD_GENLA_F_MANDATORY
-	 * flag set also, check and remove that flag before calling
-	 * nla_parse_nested.
-	 */
-
-	nla_for_each_attr(nla, head, len, rem) {
-		if (nla->nla_type & DRBD_GENLA_F_MANDATORY) {
-			nla->nla_type &= ~DRBD_GENLA_F_MANDATORY;
-			if (nla_type(nla) > maxtype)
-				return -EOPNOTSUPP;
-		}
-	}
-	return 0;
-}
-
-static inline int drbd_nla_parse_nested(struct nlattr *tb[], int maxtype,
-					struct nlattr *nla,
-					const struct nla_policy *policy)
-{
-	int err;
-
-	err = drbd_nla_check_mandatory(maxtype, nla);
-	if (!err)
-		err = nla_parse_nested(tb, maxtype, nla, policy);
-
-	return err;
-}
-
 #undef GENL_struct
 #define GENL_struct(tag_name, tag_number, s_name, s_fields)		\
 static int s_name ## _from_attrs(struct s_name *s, struct genl_info *info) __attribute__((unused)); \
-- 
1.7.4.1

