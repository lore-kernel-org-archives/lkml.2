Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932599Ab1JCU7A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 16:59:00 -0400
Received: from mail09.linbit.com ([212.69.161.110]:41568 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757040Ab1JCU6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 16:58:36 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 01/10] drbd: allow status dump request all volumes of a specific resource
Date: Mon,  3 Oct 2011 22:58:24 +0200
Message-Id: <1317675513-12745-2-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1317675513-12745-1-git-send-email-philipp.reisner@linbit.com>
References: <1317675513-12745-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Ellenberg <lars.ellenberg@linbit.com>

We had drbd_adm_get_status (one single volume),
and drbd_adm_get_status_all (dump of all volumes of all resources).

This enhances the latter to be able to dump all volumes
of just one specific resource.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_nl.c |   70 +++++++++++++++++++++++++++++++++++++++--
 1 files changed, 66 insertions(+), 4 deletions(-)

diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index 77c0249..0b6b5d8 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -2647,7 +2647,7 @@ out:
 	return 0;
 }
 
-int drbd_adm_get_status_all(struct sk_buff *skb, struct netlink_callback *cb)
+int get_one_status(struct sk_buff *skb, struct netlink_callback *cb)
 {
 	struct drbd_conf *mdev;
 	struct drbd_genlmsghdr *dh;
@@ -2665,6 +2665,9 @@ int drbd_adm_get_status_all(struct sk_buff *skb, struct netlink_callback *cb)
 	 * where tconn is cb->args[0];
 	 * and i is cb->args[1];
 	 *
+	 * cb->args[2] indicates if we shall loop over all resources,
+	 * or just dump all volumes of a single resource.
+	 *
 	 * This may miss entries inserted after this dump started,
 	 * or entries deleted before they are reached.
 	 *
@@ -2675,7 +2678,6 @@ int drbd_adm_get_status_all(struct sk_buff *skb, struct netlink_callback *cb)
 
 	/* synchronize with drbd_new_tconn/drbd_free_tconn */
 	down_read(&drbd_cfg_rwsem);
-next_tconn:
 	/* revalidate iterator position */
 	list_for_each_entry(tmp, &drbd_tconns, all_tconn) {
 		if (pos == NULL) {
@@ -2690,16 +2692,22 @@ next_tconn:
 		}
 	}
 	if (tconn) {
+next_tconn:
 		mdev = idr_get_next(&tconn->volumes, &volume);
 		if (!mdev) {
 			/* No more volumes to dump on this tconn.
 			 * Advance tconn iterator. */
 			pos = list_entry(tconn->all_tconn.next,
 					struct drbd_tconn, all_tconn);
-			/* But, did we dump any volume on this tconn yet? */
+			/* Did we dump any volume on this tconn yet? */
 			if (volume != 0) {
-				tconn = NULL;
+				/* If we reached the end of the list,
+				 * or only a single resource dump was requested,
+				 * we are done. */
+				if (&pos->all_tconn == &drbd_tconns || cb->args[2])
+					goto out;
 				volume = 0;
+				tconn = pos;
 				goto next_tconn;
 			}
 		}
@@ -2747,6 +2755,60 @@ out:
         return skb->len;
 }
 
+/*
+ * Request status of all resources, or of all volumes within a single resource.
+ *
+ * This is a dump, as the answer may not fit in a single reply skb otherwise.
+ * Which means we cannot use the family->attrbuf or other such members, because
+ * dump is NOT protected by the genl_lock().  During dump, we only have access
+ * to the incoming skb, and need to opencode "parsing" of the nlattr payload.
+ *
+ * Once things are setup properly, we call into get_one_status().
+ */
+int drbd_adm_get_status_all(struct sk_buff *skb, struct netlink_callback *cb)
+{
+	const unsigned hdrlen = GENL_HDRLEN + GENL_MAGIC_FAMILY_HDRSZ;
+	struct nlattr *nla;
+	const char *conn_name;
+	struct drbd_tconn *tconn;
+
+	/* Is this a followup call? */
+	if (cb->args[0]) {
+		/* ... of a single resource dump,
+		 * and the resource iterator has been advanced already? */
+		if (cb->args[2] && cb->args[2] != cb->args[0])
+			return 0; /* DONE. */
+		goto dump;
+	}
+
+	/* First call (from netlink_dump_start).  We need to figure out
+	 * which resource(s) the user wants us to dump. */
+	nla = nla_find(nlmsg_attrdata(cb->nlh, hdrlen),
+			nlmsg_attrlen(cb->nlh, hdrlen),
+			DRBD_NLA_CFG_CONTEXT);
+
+	/* No explicit context given.  Dump all. */
+	if (!nla)
+		goto dump;
+	nla = nla_find_nested(nla, __nla_type(T_ctx_conn_name));
+	/* context given, but no name present? */
+	if (!nla)
+		return -EINVAL;
+	conn_name = nla_data(nla);
+	tconn = conn_by_name(conn_name);
+	if (!tconn)
+		return -ENODEV;
+
+	/* prime iterators, and set "filter" mode mark:
+	 * only dump this tconn. */
+	cb->args[0] = (long)tconn;
+	/* cb->args[1] = 0; passed in this way. */
+	cb->args[2] = (long)tconn;
+
+dump:
+	return get_one_status(skb, cb);
+}
+
 int drbd_adm_get_timeout_type(struct sk_buff *skb, struct genl_info *info)
 {
 	enum drbd_ret_code retcode;
-- 
1.7.4.1

