Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758490Ab1JFNlT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 09:41:19 -0400
Received: from mail09.linbit.com ([212.69.161.110]:34151 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758276Ab1JFNiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 09:38:08 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 06/15] drbd: Introduce __s32_field in the genetlink macro magic
Date: Thu,  6 Oct 2011 15:37:51 +0200
Message-Id: <1317908280-28951-7-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1317908280-28951-1-git-send-email-philipp.reisner@linbit.com>
References: <1317908280-28951-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Ellenberg <lars.ellenberg@linbit.com>

...and drop explicit typecasts (int)meta_dev_idx < 0.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_nl.c      |    8 ++++----
 include/linux/drbd_genl.h         |    2 +-
 include/linux/genl_magic_struct.h |    3 +++
 3 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index 4efeffa..84b055f 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -1289,7 +1289,7 @@ int drbd_adm_attach(struct sk_buff *skb, struct genl_info *info)
 		goto fail;
 	}
 
-	if ((int)nbc->dc.meta_dev_idx < DRBD_MD_INDEX_FLEX_INT) {
+	if (nbc->dc.meta_dev_idx < DRBD_MD_INDEX_FLEX_INT) {
 		retcode = ERR_MD_IDX_INVALID;
 		goto fail;
 	}
@@ -1325,7 +1325,7 @@ int drbd_adm_attach(struct sk_buff *skb, struct genl_info *info)
 	 */
 	bdev = blkdev_get_by_path(nbc->dc.meta_dev,
 				  FMODE_READ | FMODE_WRITE | FMODE_EXCL,
-				  ((int)nbc->dc.meta_dev_idx < 0) ?
+				  (nbc->dc.meta_dev_idx < 0) ?
 				  (void *)mdev : (void *)drbd_m_holder);
 	if (IS_ERR(bdev)) {
 		dev_err(DEV, "open(\"%s\") failed with %ld\n", nbc->dc.meta_dev,
@@ -1361,7 +1361,7 @@ int drbd_adm_attach(struct sk_buff *skb, struct genl_info *info)
 		goto fail;
 	}
 
-	if ((int)nbc->dc.meta_dev_idx < 0) {
+	if (nbc->dc.meta_dev_idx < 0) {
 		max_possible_sectors = DRBD_MAX_SECTORS_FLEX;
 		/* at least one MB, otherwise it does not make sense */
 		min_md_device_sectors = (2<<10);
@@ -1392,7 +1392,7 @@ int drbd_adm_attach(struct sk_buff *skb, struct genl_info *info)
 		dev_warn(DEV, "==> truncating very big lower level device "
 			"to currently maximum possible %llu sectors <==\n",
 			(unsigned long long) max_possible_sectors);
-		if ((int)nbc->dc.meta_dev_idx >= 0)
+		if (nbc->dc.meta_dev_idx >= 0)
 			dev_warn(DEV, "==>> using internal or flexible "
 				      "meta data may help <<==\n");
 	}
diff --git a/include/linux/drbd_genl.h b/include/linux/drbd_genl.h
index 8cad681..529627b 100644
--- a/include/linux/drbd_genl.h
+++ b/include/linux/drbd_genl.h
@@ -104,7 +104,7 @@ GENL_struct(DRBD_NLA_CFG_CONTEXT, 2, drbd_cfg_context,
 GENL_struct(DRBD_NLA_DISK_CONF, 3, disk_conf,
 	__str_field(1, GENLA_F_REQUIRED | GENLA_F_INVARIANT,	backing_dev,	128)
 	__str_field(2, GENLA_F_REQUIRED | GENLA_F_INVARIANT,	meta_dev,	128)
-	__u32_field(3, GENLA_F_REQUIRED | GENLA_F_INVARIANT,	meta_dev_idx)
+	__s32_field(3, GENLA_F_REQUIRED | GENLA_F_INVARIANT,	meta_dev_idx)
 
 	/* use the resize command to try and change the disk_size */
 	__u64_field(4, GENLA_F_MANDATORY | GENLA_F_INVARIANT,	disk_size)
diff --git a/include/linux/genl_magic_struct.h b/include/linux/genl_magic_struct.h
index f2c7cc7..ddbdd0a 100644
--- a/include/linux/genl_magic_struct.h
+++ b/include/linux/genl_magic_struct.h
@@ -97,6 +97,9 @@ enum {
 #define __u32_field(attr_nr, attr_flag, name)	\
 	__field(attr_nr, attr_flag, name, NLA_U32, __u32, \
 			nla_get_u32, NLA_PUT_U32)
+#define __s32_field(attr_nr, attr_flag, name)	\
+	__field(attr_nr, attr_flag, name, NLA_U32, __s32, \
+			nla_get_u32, NLA_PUT_U32)
 #define __u64_field(attr_nr, attr_flag, name)	\
 	__field(attr_nr, attr_flag, name, NLA_U64, __u64, \
 			nla_get_u64, NLA_PUT_U64)
-- 
1.7.4.1

