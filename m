Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753101Ab1JLMaB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 08:30:01 -0400
Received: from mail09.linbit.com ([212.69.161.110]:33943 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753032Ab1JLM1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 08:27:40 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 07/13] drbd: Split off netlink mandatory attribute handling into separate file
Date: Wed, 12 Oct 2011 14:27:29 +0200
Message-Id: <1318422455-17539-8-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1318422455-17539-1-git-send-email-philipp.reisner@linbit.com>
References: <1318422455-17539-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

Duplicate this file in the kernel module and in user space; both sides need it.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/Makefile        |    1 +
 drivers/block/drbd/drbd_int.h      |    6 ----
 drivers/block/drbd/drbd_nl.c       |   51 +--------------------------------
 drivers/block/drbd/drbd_nla.c      |   55 ++++++++++++++++++++++++++++++++++++
 drivers/block/drbd/drbd_nla.h      |    8 +++++
 drivers/block/drbd/drbd_wrappers.h |    1 +
 6 files changed, 66 insertions(+), 56 deletions(-)
 create mode 100644 drivers/block/drbd/drbd_nla.c
 create mode 100644 drivers/block/drbd/drbd_nla.h

diff --git a/drivers/block/drbd/Makefile b/drivers/block/drbd/Makefile
index 06fb445..8b45033 100644
--- a/drivers/block/drbd/Makefile
+++ b/drivers/block/drbd/Makefile
@@ -2,5 +2,6 @@ drbd-y := drbd_bitmap.o drbd_proc.o
 drbd-y += drbd_worker.o drbd_receiver.o drbd_req.o drbd_actlog.o
 drbd-y += drbd_main.o drbd_strings.o drbd_nl.o
 drbd-y += drbd_interval.o drbd_state.o
+drbd-y += drbd_nla.o
 
 obj-$(CONFIG_BLK_DEV_DRBD)     += drbd.o
diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index c584301..c301973 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -1407,12 +1407,6 @@ extern bool conn_try_outdate_peer(struct drbd_tconn *tconn);
 extern void conn_try_outdate_peer_async(struct drbd_tconn *tconn);
 extern int drbd_khelper(struct drbd_conf *mdev, char *cmd);
 
-struct nla_policy;
-extern int drbd_nla_check_mandatory(int maxtype, struct nlattr *nla);
-extern int drbd_nla_parse_nested(struct nlattr *tb[], int maxtype, struct nlattr *nla,
-				 const struct nla_policy *policy);
-extern struct nlattr *drbd_nla_find_nested(int maxtype, struct nlattr *nla, int attrtype);
-
 /* drbd_worker.c */
 extern int drbd_worker(struct drbd_thread *thi);
 enum drbd_ret_code drbd_resync_after_valid(struct drbd_conf *mdev, int o_minor);
diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index b75fde7..0c07baf 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -99,6 +99,7 @@ int drbd_adm_get_timeout_type(struct sk_buff *skb, struct genl_info *info);
 int drbd_adm_get_status_all(struct sk_buff *skb, struct netlink_callback *cb);
 
 #include <linux/drbd_genl_api.h>
+#include "drbd_nla.h"
 #include <linux/genl_magic_func.h>
 
 /* used blkdev_get_by_path, to claim our meta data device(s) */
@@ -3266,53 +3267,3 @@ failed:
 			"Event seq:%u sib_reason:%u\n",
 			err, seq, sib->sib_reason);
 }
-
-int drbd_nla_check_mandatory(int maxtype, struct nlattr *nla)
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
-int drbd_nla_parse_nested(struct nlattr *tb[], int maxtype, struct nlattr *nla,
-			  const struct nla_policy *policy)
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
-struct nlattr *drbd_nla_find_nested(int maxtype, struct nlattr *nla, int attrtype)
-{
-	int err;
-	/*
-	 * If any nested attribute has the DRBD_GENLA_F_MANDATORY flag set and
-	 * we don't know about that attribute, reject all the nested
-	 * attributes.
-	 */
-	err = drbd_nla_check_mandatory(maxtype, nla);
-	if (err)
-		return ERR_PTR(err);
-	return nla_find_nested(nla, attrtype);
-}
diff --git a/drivers/block/drbd/drbd_nla.c b/drivers/block/drbd/drbd_nla.c
new file mode 100644
index 0000000..fa672b6
--- /dev/null
+++ b/drivers/block/drbd/drbd_nla.c
@@ -0,0 +1,55 @@
+#include "drbd_wrappers.h"
+#include <linux/kernel.h>
+#include <net/netlink.h>
+#include <linux/drbd_genl_api.h>
+#include "drbd_nla.h"
+
+static int drbd_nla_check_mandatory(int maxtype, struct nlattr *nla)
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
diff --git a/drivers/block/drbd/drbd_nla.h b/drivers/block/drbd/drbd_nla.h
new file mode 100644
index 0000000..679c2d5
--- /dev/null
+++ b/drivers/block/drbd/drbd_nla.h
@@ -0,0 +1,8 @@
+#ifndef __DRBD_NLA_H
+#define __DRBD_NLA_H
+
+extern int drbd_nla_parse_nested(struct nlattr *tb[], int maxtype, struct nlattr *nla,
+				 const struct nla_policy *policy);
+extern struct nlattr *drbd_nla_find_nested(int maxtype, struct nlattr *nla, int attrtype);
+
+#endif  /* __DRBD_NLA_H */
diff --git a/drivers/block/drbd/drbd_wrappers.h b/drivers/block/drbd/drbd_wrappers.h
index 46a6d99..328f18e 100644
--- a/drivers/block/drbd/drbd_wrappers.h
+++ b/drivers/block/drbd/drbd_wrappers.h
@@ -3,6 +3,7 @@
 
 #include <linux/ctype.h>
 #include <linux/mm.h>
+#include "drbd_int.h"
 
 /* see get_sb_bdev and bd_claim */
 extern char *drbd_sec_holder;
-- 
1.7.4.1

