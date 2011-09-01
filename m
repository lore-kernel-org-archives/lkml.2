Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932283Ab1IAMwY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 08:52:24 -0400
Received: from mail09.linbit.com ([212.69.161.110]:55662 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932151Ab1IAMtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 08:49:12 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 09/18] drbd: switch configuration interface from connector to genetlink
Date: Thu,  1 Sep 2011 14:48:56 +0200
Message-Id: <1314881345-6420-10-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314881345-6420-1-git-send-email-philipp.reisner@linbit.com>
References: <1314881345-6420-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Ellenberg <lars.ellenberg@linbit.com>

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_actlog.c |    3 +-
 drivers/block/drbd/drbd_int.h    |   36 +-
 drivers/block/drbd/drbd_main.c   |   27 +-
 drivers/block/drbd/drbd_nl.c     | 1569 +++++++++++++++++++-------------------
 drivers/block/drbd/drbd_state.c  |    7 +-
 include/linux/drbd.h             |   35 +-
 6 files changed, 839 insertions(+), 838 deletions(-)

diff --git a/drivers/block/drbd/drbd_actlog.c b/drivers/block/drbd/drbd_actlog.c
index 9ab6365..6d1e892 100644
--- a/drivers/block/drbd/drbd_actlog.c
+++ b/drivers/block/drbd/drbd_actlog.c
@@ -692,6 +692,7 @@ static int w_update_odbm(struct drbd_work *w, int unused)
 {
 	struct update_odbm_work *udw = container_of(w, struct update_odbm_work, w);
 	struct drbd_conf *mdev = w->mdev;
+	struct sib_info sib = { .sib_reason = SIB_SYNC_PROGRESS, };
 
 	if (!get_ldev(mdev)) {
 		if (__ratelimit(&drbd_ratelimit_state))
@@ -715,7 +716,7 @@ static int w_update_odbm(struct drbd_work *w, int unused)
 			break;
 		}
 	}
-	drbd_bcast_sync_progress(mdev);
+	drbd_bcast_event(mdev, &sib);
 
 	return 1;
 }
diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 5d90b9d..acd2877 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -44,6 +44,7 @@
 #include <net/tcp.h>
 #include <linux/lru_cache.h>
 #include <linux/prefetch.h>
+#include <linux/drbd_genl_api.h>
 #include <linux/drbd.h>
 #include "drbd_state.h"
 
@@ -65,7 +66,6 @@
 extern unsigned int minor_count;
 extern int disable_sendpage;
 extern int allow_oos;
-extern unsigned int cn_idx;
 
 #ifdef CONFIG_DRBD_FAULT_INJECTION
 extern int enable_faults;
@@ -865,14 +865,6 @@ struct drbd_md {
 	 */
 };
 
-/* for sync_conf and other types... */
-#define NL_PACKET(name, number, fields) struct name { fields };
-#define NL_INTEGER(pn,pr,member) int member;
-#define NL_INT64(pn,pr,member) __u64 member;
-#define NL_BIT(pn,pr,member)   unsigned member:1;
-#define NL_STRING(pn,pr,member,len) unsigned char member[len]; int member ## _len;
-#include "linux/drbd_nl.h"
-
 struct drbd_backing_dev {
 	struct block_device *backing_bdev;
 	struct block_device *md_bdev;
@@ -1502,7 +1494,7 @@ enum drbd_ret_code conn_new_minor(struct drbd_tconn *tconn, unsigned int minor,
 extern void drbd_free_mdev(struct drbd_conf *mdev);
 extern void drbd_delete_device(unsigned int minor);
 
-struct drbd_tconn *drbd_new_tconn(char *name);
+struct drbd_tconn *drbd_new_tconn(const char *name);
 extern void drbd_free_tconn(struct drbd_tconn *tconn);
 struct drbd_tconn *conn_by_name(const char *name);
 
@@ -1679,16 +1671,22 @@ extern int __drbd_set_out_of_sync(struct drbd_conf *mdev, sector_t sector,
 extern void drbd_al_apply_to_bm(struct drbd_conf *mdev);
 extern void drbd_al_shrink(struct drbd_conf *mdev);
 
-
 /* drbd_nl.c */
-
-void drbd_nl_cleanup(void);
-int __init drbd_nl_init(void);
-void drbd_bcast_state(struct drbd_conf *mdev, union drbd_state);
-void drbd_bcast_sync_progress(struct drbd_conf *mdev);
-void drbd_bcast_ee(struct drbd_conf *, const char *, const int, const char *,
-		   const char *, const struct drbd_peer_request *);
-
+/* state info broadcast */
+struct sib_info {
+	enum drbd_state_info_bcast_reason sib_reason;
+	union {
+		struct {
+			char *helper_name;
+			unsigned helper_exit_code;
+		};
+		struct {
+			union drbd_state os;
+			union drbd_state ns;
+		};
+	};
+};
+void drbd_bcast_event(struct drbd_conf *mdev, const struct sib_info *sib);
 
 /*
  * inline helper functions
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 21914f4..9b41213 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -86,7 +86,6 @@ MODULE_PARM_DESC(allow_oos, "DONT USE!");
 module_param(minor_count, uint, 0444);
 module_param(disable_sendpage, bool, 0644);
 module_param(allow_oos, bool, 0);
-module_param(cn_idx, uint, 0444);
 module_param(proc_details, int, 0644);
 
 #ifdef CONFIG_DRBD_FAULT_INJECTION
@@ -108,7 +107,6 @@ module_param(fault_devs, int, 0644);
 unsigned int minor_count = DRBD_MINOR_COUNT_DEF;
 int disable_sendpage;
 int allow_oos;
-unsigned int cn_idx = CN_IDX_DRBD;
 int proc_details;       /* Detail level in proc drbd*/
 
 /* Module parameter for setting the user mode helper program
@@ -2175,7 +2173,7 @@ static void drbd_cleanup(void)
 	if (drbd_proc)
 		remove_proc_entry("drbd", NULL);
 
-	drbd_nl_cleanup();
+	drbd_genl_unregister();
 
 	idr_for_each_entry(&minors, mdev, i)
 		drbd_delete_device(i);
@@ -2237,6 +2235,9 @@ struct drbd_tconn *conn_by_name(const char *name)
 {
 	struct drbd_tconn *tconn;
 
+	if (!name || !name[0])
+		return NULL;
+
 	write_lock_irq(&global_state_lock);
 	list_for_each_entry(tconn, &drbd_tconns, all_tconn) {
 		if (!strcmp(tconn->name, name))
@@ -2248,7 +2249,7 @@ found:
 	return tconn;
 }
 
-struct drbd_tconn *drbd_new_tconn(char *name)
+struct drbd_tconn *drbd_new_tconn(const char *name)
 {
 	struct drbd_tconn *tconn;
 
@@ -2333,6 +2334,7 @@ enum drbd_ret_code conn_new_minor(struct drbd_tconn *tconn, unsigned int minor,
 
 	mdev->tconn = tconn;
 	mdev->minor = minor;
+	mdev->vnr = vnr;
 
 	drbd_init_set_defaults(mdev);
 
@@ -2462,10 +2464,6 @@ int __init drbd_init(void)
 #endif
 	}
 
-	err = drbd_nl_init();
-	if (err)
-		return err;
-
 	err = register_blkdev(DRBD_MAJOR, "drbd");
 	if (err) {
 		printk(KERN_ERR
@@ -2474,6 +2472,13 @@ int __init drbd_init(void)
 		return err;
 	}
 
+	err = drbd_genl_register();
+	if (err) {
+		pr_err("drbd: unable to register generic netlink family\n");
+		goto fail;
+	}
+
+
 	register_reboot_notifier(&drbd_notifier);
 
 	/*
@@ -2488,12 +2493,12 @@ int __init drbd_init(void)
 
 	err = drbd_create_mempools();
 	if (err)
-		goto Enomem;
+		goto fail;
 
 	drbd_proc = proc_create_data("drbd", S_IFREG | S_IRUGO , NULL, &drbd_proc_fops, NULL);
 	if (!drbd_proc)	{
 		printk(KERN_ERR "drbd: unable to register proc file\n");
-		goto Enomem;
+		goto fail;
 	}
 
 	rwlock_init(&global_state_lock);
@@ -2508,7 +2513,7 @@ int __init drbd_init(void)
 
 	return 0; /* Success! */
 
-Enomem:
+fail:
 	drbd_cleanup();
 	if (err == -ENOMEM)
 		/* currently always the case */
diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index f2739fd..a8f27cb 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -29,110 +29,258 @@
 #include <linux/fs.h>
 #include <linux/file.h>
 #include <linux/slab.h>
-#include <linux/connector.h>
 #include <linux/blkpg.h>
 #include <linux/cpumask.h>
 #include "drbd_int.h"
 #include "drbd_req.h"
 #include "drbd_wrappers.h"
 #include <asm/unaligned.h>
-#include <linux/drbd_tag_magic.h>
 #include <linux/drbd_limits.h>
-#include <linux/compiler.h>
 #include <linux/kthread.h>
 
-static unsigned short *tl_add_blob(unsigned short *, enum drbd_tags, const void *, int);
-static unsigned short *tl_add_str(unsigned short *, enum drbd_tags, const char *);
-static unsigned short *tl_add_int(unsigned short *, enum drbd_tags, const void *);
+#include <net/genetlink.h>
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,31)
+/*
+ * copied from more recent kernel source
+ */
+int genl_register_family_with_ops(struct genl_family *family,
+	struct genl_ops *ops, size_t n_ops)
+{
+	int err, i;
 
-/* see get_sb_bdev and bd_claim */
+	err = genl_register_family(family);
+	if (err)
+		return err;
+
+	for (i = 0; i < n_ops; ++i, ++ops) {
+		err = genl_register_ops(family, ops);
+		if (err)
+			goto err_out;
+	}
+	return 0;
+err_out:
+	genl_unregister_family(family);
+	return err;
+}
+#endif
+
+/* .doit */
+// int drbd_adm_create_resource(struct sk_buff *skb, struct genl_info *info);
+// int drbd_adm_delete_resource(struct sk_buff *skb, struct genl_info *info);
+
+int drbd_adm_add_minor(struct sk_buff *skb, struct genl_info *info);
+int drbd_adm_delete_minor(struct sk_buff *skb, struct genl_info *info);
+
+int drbd_adm_create_connection(struct sk_buff *skb, struct genl_info *info);
+int drbd_adm_delete_connection(struct sk_buff *skb, struct genl_info *info);
+
+int drbd_adm_set_role(struct sk_buff *skb, struct genl_info *info);
+int drbd_adm_attach(struct sk_buff *skb, struct genl_info *info);
+int drbd_adm_detach(struct sk_buff *skb, struct genl_info *info);
+int drbd_adm_connect(struct sk_buff *skb, struct genl_info *info);
+int drbd_adm_resize(struct sk_buff *skb, struct genl_info *info);
+int drbd_adm_start_ov(struct sk_buff *skb, struct genl_info *info);
+int drbd_adm_new_c_uuid(struct sk_buff *skb, struct genl_info *info);
+int drbd_adm_disconnect(struct sk_buff *skb, struct genl_info *info);
+int drbd_adm_invalidate(struct sk_buff *skb, struct genl_info *info);
+int drbd_adm_invalidate_peer(struct sk_buff *skb, struct genl_info *info);
+int drbd_adm_pause_sync(struct sk_buff *skb, struct genl_info *info);
+int drbd_adm_resume_sync(struct sk_buff *skb, struct genl_info *info);
+int drbd_adm_suspend_io(struct sk_buff *skb, struct genl_info *info);
+int drbd_adm_resume_io(struct sk_buff *skb, struct genl_info *info);
+int drbd_adm_outdate(struct sk_buff *skb, struct genl_info *info);
+int drbd_adm_syncer(struct sk_buff *skb, struct genl_info *info);
+int drbd_adm_get_status(struct sk_buff *skb, struct genl_info *info);
+int drbd_adm_get_timeout_type(struct sk_buff *skb, struct genl_info *info);
+/* .dumpit */
+int drbd_adm_get_status_all(struct sk_buff *skb, struct netlink_callback *cb);
+
+#include <linux/drbd_genl_api.h>
+#include <linux/genl_magic_func.h>
+
+/* used blkdev_get_by_path, to claim our meta data device(s) */
 static char *drbd_m_holder = "Hands off! this is DRBD's meta data device.";
 
-/* Generate the tag_list to struct functions */
-#define NL_PACKET(name, number, fields) \
-static int name ## _from_tags( \
-	unsigned short *tags, struct name *arg) __attribute__ ((unused)); \
-static int name ## _from_tags( \
-	unsigned short *tags, struct name *arg) \
-{ \
-	int tag; \
-	int dlen; \
-	\
-	while ((tag = get_unaligned(tags++)) != TT_END) {	\
-		dlen = get_unaligned(tags++);			\
-		switch (tag_number(tag)) { \
-		fields \
-		default: \
-			if (tag & T_MANDATORY) { \
-				printk(KERN_ERR "drbd: Unknown tag: %d\n", tag_number(tag)); \
-				return 0; \
-			} \
-		} \
-		tags = (unsigned short *)((char *)tags + dlen); \
-	} \
-	return 1; \
+/* Configuration is strictly serialized, because generic netlink message
+ * processing is strictly serialized by the genl_lock().
+ * Which means we can use one static global drbd_config_context struct.
+ */
+static struct drbd_config_context {
+	/* assigned from drbd_genlmsghdr */
+	unsigned int minor;
+	/* assigned from request attributes, if present */
+	unsigned int volume;
+#define VOLUME_UNSPECIFIED		(-1U)
+	/* pointer into the request skb,
+	 * limited lifetime! */
+	char *conn_name;
+
+	/* reply buffer */
+	struct sk_buff *reply_skb;
+	/* pointer into reply buffer */
+	struct drbd_genlmsghdr *reply_dh;
+	/* resolved from attributes, if possible */
+	struct drbd_conf *mdev;
+	struct drbd_tconn *tconn;
+} adm_ctx;
+
+static void drbd_adm_send_reply(struct sk_buff *skb, struct genl_info *info)
+{
+	genlmsg_end(skb, genlmsg_data(nlmsg_data(nlmsg_hdr(skb))));
+	if (genlmsg_reply(skb, info))
+		printk(KERN_ERR "drbd: error sending genl reply\n");
 }
-#define NL_INTEGER(pn, pr, member) \
-	case pn: /* D_ASSERT( tag_type(tag) == TT_INTEGER ); */ \
-		arg->member = get_unaligned((int *)(tags));	\
-		break;
-#define NL_INT64(pn, pr, member) \
-	case pn: /* D_ASSERT( tag_type(tag) == TT_INT64 ); */ \
-		arg->member = get_unaligned((u64 *)(tags));	\
-		break;
-#define NL_BIT(pn, pr, member) \
-	case pn: /* D_ASSERT( tag_type(tag) == TT_BIT ); */ \
-		arg->member = *(char *)(tags) ? 1 : 0; \
-		break;
-#define NL_STRING(pn, pr, member, len) \
-	case pn: /* D_ASSERT( tag_type(tag) == TT_STRING ); */ \
-		if (dlen > len) { \
-			printk(KERN_ERR "drbd: arg too long: %s (%u wanted, max len: %u bytes)\n", \
-				#member, dlen, (unsigned int)len); \
-			return 0; \
-		} \
-		 arg->member ## _len = dlen; \
-		 memcpy(arg->member, tags, min_t(size_t, dlen, len)); \
-		 break;
-#include "linux/drbd_nl.h"
-
-/* Generate the struct to tag_list functions */
-#define NL_PACKET(name, number, fields) \
-static unsigned short* \
-name ## _to_tags( \
-	struct name *arg, unsigned short *tags) __attribute__ ((unused)); \
-static unsigned short* \
-name ## _to_tags( \
-	struct name *arg, unsigned short *tags) \
-{ \
-	fields \
-	return tags; \
+
+/* Used on a fresh "drbd_adm_prepare"d reply_skb, this cannot fail: The only
+ * reason it could fail was no space in skb, and there are 4k available. */
+static int drbd_msg_put_info(const char *info)
+{
+	struct sk_buff *skb = adm_ctx.reply_skb;
+	struct nlattr *nla;
+	int err = -EMSGSIZE;
+
+	if (!info || !info[0])
+		return 0;
+
+	nla = nla_nest_start(skb, DRBD_NLA_CFG_REPLY);
+	if (!nla)
+		return err;
+
+	err = nla_put_string(skb, T_info_text, info);
+	if (err) {
+		nla_nest_cancel(skb, nla);
+		return err;
+	} else
+		nla_nest_end(skb, nla);
+	return 0;
+}
+
+/* This would be a good candidate for a "pre_doit" hook,
+ * and per-family private info->pointers.
+ * But we need to stay compatible with older kernels.
+ * If it returns successfully, adm_ctx members are valid.
+ */
+#define DRBD_ADM_NEED_MINOR	1
+#define DRBD_ADM_NEED_CONN	2
+static int drbd_adm_prepare(struct sk_buff *skb, struct genl_info *info,
+		unsigned flags)
+{
+	struct drbd_genlmsghdr *d_in = info->userhdr;
+	const u8 cmd = info->genlhdr->cmd;
+	int err;
+
+	memset(&adm_ctx, 0, sizeof(adm_ctx));
+
+	/* genl_rcv_msg only checks for CAP_NET_ADMIN on "GENL_ADMIN_PERM" :( */
+	if (cmd != DRBD_ADM_GET_STATUS
+	&& security_netlink_recv(skb, CAP_SYS_ADMIN))
+	       return -EPERM;
+
+	adm_ctx.reply_skb = genlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
+	if (!adm_ctx.reply_skb)
+		goto fail;
+
+	adm_ctx.reply_dh = genlmsg_put_reply(adm_ctx.reply_skb,
+					info, &drbd_genl_family, 0, cmd);
+	/* put of a few bytes into a fresh skb of >= 4k will always succeed.
+	 * but anyways */
+	if (!adm_ctx.reply_dh)
+		goto fail;
+
+	adm_ctx.reply_dh->minor = d_in->minor;
+	adm_ctx.reply_dh->ret_code = NO_ERROR;
+
+	if (info->attrs[DRBD_NLA_CFG_CONTEXT]) {
+		struct nlattr *nla;
+		/* parse and validate only */
+		err = drbd_cfg_context_from_attrs(NULL, info->attrs);
+		if (err)
+			goto fail;
+
+		/* It was present, and valid,
+		 * copy it over to the reply skb. */
+		err = nla_put_nohdr(adm_ctx.reply_skb,
+				info->attrs[DRBD_NLA_CFG_CONTEXT]->nla_len,
+				info->attrs[DRBD_NLA_CFG_CONTEXT]);
+		if (err)
+			goto fail;
+
+		/* and assign stuff to the global adm_ctx */
+		nla = nested_attr_tb[__nla_type(T_ctx_volume)];
+		adm_ctx.volume = nla ? nla_get_u32(nla) : VOLUME_UNSPECIFIED;
+		nla = nested_attr_tb[__nla_type(T_ctx_conn_name)];
+		if (nla)
+			adm_ctx.conn_name = nla_data(nla);
+	} else
+		adm_ctx.volume = VOLUME_UNSPECIFIED;
+
+	adm_ctx.minor = d_in->minor;
+	adm_ctx.mdev = minor_to_mdev(d_in->minor);
+	adm_ctx.tconn = conn_by_name(adm_ctx.conn_name);
+
+	pr_info("adm request: cmd=%u[%s], flags=0x%x, minor=%d, conn=%s\n",
+		cmd, drbd_genl_cmd_to_str(cmd), d_in->flags,
+		d_in->minor, adm_ctx.conn_name ?: "n/a");
+
+	if (!adm_ctx.mdev && (flags & DRBD_ADM_NEED_MINOR)) {
+		drbd_msg_put_info("unknown minor");
+		return ERR_MINOR_INVALID;
+	}
+	if (!adm_ctx.tconn && (flags & DRBD_ADM_NEED_CONN)) {
+		drbd_msg_put_info("unknown connection");
+		return ERR_INVALID_REQUEST;
+	}
+
+	/* some more paranoia, if the request was over-determined */
+	if (adm_ctx.mdev &&
+	    adm_ctx.volume != VOLUME_UNSPECIFIED &&
+	    adm_ctx.volume != adm_ctx.mdev->vnr) {
+		pr_warning("request: minor=%u, volume=%u; but that minor is volume %u in %s\n",
+				adm_ctx.minor, adm_ctx.volume,
+				adm_ctx.mdev->vnr, adm_ctx.mdev->tconn->name);
+		drbd_msg_put_info("over-determined configuration context mismatch");
+		return ERR_INVALID_REQUEST;
+	}
+	if (adm_ctx.mdev && adm_ctx.tconn &&
+	    adm_ctx.mdev->tconn != adm_ctx.tconn) {
+		pr_warning("request: minor=%u, conn=%s; but that minor belongs to connection %s\n",
+				adm_ctx.minor, adm_ctx.conn_name, adm_ctx.mdev->tconn->name);
+		drbd_msg_put_info("over-determined configuration context mismatch");
+		return ERR_INVALID_REQUEST;
+	}
+	return NO_ERROR;
+
+fail:
+	nlmsg_free(adm_ctx.reply_skb);
+	adm_ctx.reply_skb = NULL;
+	return -ENOMEM;
 }
 
-#define NL_INTEGER(pn, pr, member) \
-	put_unaligned(pn | pr | TT_INTEGER, tags++);	\
-	put_unaligned(sizeof(int), tags++);		\
-	put_unaligned(arg->member, (int *)tags);	\
-	tags = (unsigned short *)((char *)tags+sizeof(int));
-#define NL_INT64(pn, pr, member) \
-	put_unaligned(pn | pr | TT_INT64, tags++);	\
-	put_unaligned(sizeof(u64), tags++);		\
-	put_unaligned(arg->member, (u64 *)tags);	\
-	tags = (unsigned short *)((char *)tags+sizeof(u64));
-#define NL_BIT(pn, pr, member) \
-	put_unaligned(pn | pr | TT_BIT, tags++);	\
-	put_unaligned(sizeof(char), tags++);		\
-	*(char *)tags = arg->member; \
-	tags = (unsigned short *)((char *)tags+sizeof(char));
-#define NL_STRING(pn, pr, member, len) \
-	put_unaligned(pn | pr | TT_STRING, tags++);	\
-	put_unaligned(arg->member ## _len, tags++);	\
-	memcpy(tags, arg->member, arg->member ## _len); \
-	tags = (unsigned short *)((char *)tags + arg->member ## _len);
-#include "linux/drbd_nl.h"
-
-void drbd_bcast_ev_helper(struct drbd_conf *mdev, char *helper_name);
-void drbd_nl_send_reply(struct cn_msg *, int);
+static int drbd_adm_finish(struct genl_info *info, int retcode)
+{
+	struct nlattr *nla;
+	const char *conn_name = NULL;
+	const u8 cmd = info->genlhdr->cmd;
+
+	if (!adm_ctx.reply_skb)
+		return -ENOMEM;
+
+	adm_ctx.reply_dh->ret_code = retcode;
+
+	nla = info->attrs[DRBD_NLA_CFG_CONTEXT];
+	if (nla) {
+		nla = nla_find_nested(nla, __nla_type(T_ctx_conn_name));
+		if (nla)
+			conn_name = nla_data(nla);
+	}
+
+	pr_info("adm reply: cmd=%u[%s], retcode=%d, minor=%d, conn=%s\n",
+		cmd, drbd_genl_cmd_to_str(cmd), retcode,
+		adm_ctx.minor, adm_ctx.conn_name ?: "n/a");
+
+	drbd_adm_send_reply(adm_ctx.reply_skb, info);
+	return 0;
+}
 
 int drbd_khelper(struct drbd_conf *mdev, char *cmd)
 {
@@ -142,9 +290,9 @@ int drbd_khelper(struct drbd_conf *mdev, char *cmd)
 			NULL, /* Will be set to address family */
 			NULL, /* Will be set to address */
 			NULL };
-
 	char mb[12], af[20], ad[60], *afs;
 	char *argv[] = {usermode_helper, cmd, mb, NULL };
+	struct sib_info sib;
 	int ret;
 
 	snprintf(mb, 12, "minor-%d", mdev_to_minor(mdev));
@@ -177,8 +325,9 @@ int drbd_khelper(struct drbd_conf *mdev, char *cmd)
 	drbd_md_sync(mdev);
 
 	dev_info(DEV, "helper command: %s %s %s\n", usermode_helper, cmd, mb);
-
-	drbd_bcast_ev_helper(mdev, cmd);
+	sib.sib_reason = SIB_HELPER_PRE;
+	sib.helper_name = cmd;
+	drbd_bcast_event(mdev, &sib);
 	ret = call_usermodehelper(usermode_helper, argv, envp, 1);
 	if (ret)
 		dev_warn(DEV, "helper command: %s %s %s exit code %u (0x%x)\n",
@@ -188,6 +337,9 @@ int drbd_khelper(struct drbd_conf *mdev, char *cmd)
 		dev_info(DEV, "helper command: %s %s %s exit code %u (0x%x)\n",
 				usermode_helper, cmd, mb,
 				(ret >> 8) & 0xff, ret);
+	sib.sib_reason = SIB_HELPER_POST;
+	sib.helper_exit_code = ret;
+	drbd_bcast_event(mdev, &sib);
 
 	if (ret < 0) /* Ignore any ERRNOs we got. */
 		ret = 0;
@@ -362,7 +514,7 @@ drbd_set_role(struct drbd_conf *mdev, enum drbd_role new_role, int force)
 		}
 
 		if (rv == SS_NOTHING_TO_DO)
-			goto fail;
+			goto out;
 		if (rv == SS_PRIMARY_NOP && mask.pdsk == 0) {
 			nps = drbd_try_outdate_peer(mdev);
 
@@ -388,13 +540,13 @@ drbd_set_role(struct drbd_conf *mdev, enum drbd_role new_role, int force)
 			rv = _drbd_request_state(mdev, mask, val,
 						CS_VERBOSE + CS_WAIT_COMPLETE);
 			if (rv < SS_SUCCESS)
-				goto fail;
+				goto out;
 		}
 		break;
 	}
 
 	if (rv < SS_SUCCESS)
-		goto fail;
+		goto out;
 
 	if (forced)
 		dev_warn(DEV, "Forced to consider local data as UpToDate!\n");
@@ -438,33 +590,46 @@ drbd_set_role(struct drbd_conf *mdev, enum drbd_role new_role, int force)
 	drbd_md_sync(mdev);
 
 	kobject_uevent(&disk_to_dev(mdev->vdisk)->kobj, KOBJ_CHANGE);
- fail:
+out:
 	mutex_unlock(mdev->state_mutex);
 	return rv;
 }
 
-static int drbd_nl_primary(struct drbd_conf *mdev, struct drbd_nl_cfg_req *nlp,
-			   struct drbd_nl_cfg_reply *reply)
+static const char *from_attrs_err_to_txt(int err)
 {
-	struct primary primary_args;
-
-	memset(&primary_args, 0, sizeof(struct primary));
-	if (!primary_from_tags(nlp->tag_list, &primary_args)) {
-		reply->ret_code = ERR_MANDATORY_TAG;
-		return 0;
-	}
-
-	reply->ret_code =
-		drbd_set_role(mdev, R_PRIMARY, primary_args.primary_force);
-
-	return 0;
+	return	err == -ENOMSG ? "required attribute missing" :
+		err == -EOPNOTSUPP ? "unknown mandatory attribute" :
+		"invalid attribute value";
 }
 
-static int drbd_nl_secondary(struct drbd_conf *mdev, struct drbd_nl_cfg_req *nlp,
-			     struct drbd_nl_cfg_reply *reply)
+int drbd_adm_set_role(struct sk_buff *skb, struct genl_info *info)
 {
-	reply->ret_code = drbd_set_role(mdev, R_SECONDARY, 0);
+	struct set_role_parms parms;
+	int err;
+	enum drbd_ret_code retcode;
 
+	retcode = drbd_adm_prepare(skb, info, DRBD_ADM_NEED_MINOR);
+	if (!adm_ctx.reply_skb)
+		return retcode;
+	if (retcode != NO_ERROR)
+		goto out;
+
+	memset(&parms, 0, sizeof(parms));
+	if (info->attrs[DRBD_NLA_SET_ROLE_PARMS]) {
+		err = set_role_parms_from_attrs(&parms, info->attrs);
+		if (err) {
+			retcode = ERR_MANDATORY_TAG;
+			drbd_msg_put_info(from_attrs_err_to_txt(err));
+			goto out;
+		}
+	}
+
+	if (info->genlhdr->cmd == DRBD_ADM_PRIMARY)
+		retcode = drbd_set_role(adm_ctx.mdev, R_PRIMARY, parms.assume_uptodate);
+	else
+		retcode = drbd_set_role(adm_ctx.mdev, R_SECONDARY, 0);
+out:
+	drbd_adm_finish(info, retcode);
 	return 0;
 }
 
@@ -541,6 +706,12 @@ char *ppsize(char *buf, unsigned long long size)
  *  R_PRIMARY D_INCONSISTENT, and C_SYNC_TARGET:
  *  peer may not initiate a resize.
  */
+/* Note these are not to be confused with
+ * drbd_adm_suspend_io/drbd_adm_resume_io,
+ * which are (sub) state changes triggered by admin (drbdsetup),
+ * and can be long lived.
+ * This changes an mdev->flag, is triggered by drbd internals,
+ * and should be short-lived. */
 void drbd_suspend_io(struct drbd_conf *mdev)
 {
 	set_bit(SUSPEND_IO, &mdev->flags);
@@ -881,11 +1052,10 @@ static void drbd_suspend_al(struct drbd_conf *mdev)
 		dev_info(DEV, "Suspended AL updates\n");
 }
 
-/* does always return 0;
- * interesting return code is in reply->ret_code */
-static int drbd_nl_disk_conf(struct drbd_conf *mdev, struct drbd_nl_cfg_req *nlp,
-			     struct drbd_nl_cfg_reply *reply)
+int drbd_adm_attach(struct sk_buff *skb, struct genl_info *info)
 {
+	struct drbd_conf *mdev;
+	int err;
 	enum drbd_ret_code retcode;
 	enum determine_dev_size dd;
 	sector_t max_possible_sectors;
@@ -897,6 +1067,13 @@ static int drbd_nl_disk_conf(struct drbd_conf *mdev, struct drbd_nl_cfg_req *nlp
 	enum drbd_state_rv rv;
 	int cp_discovered = 0;
 
+	retcode = drbd_adm_prepare(skb, info, DRBD_ADM_NEED_MINOR);
+	if (!adm_ctx.reply_skb)
+		return retcode;
+	if (retcode != NO_ERROR)
+		goto fail;
+
+	mdev = adm_ctx.mdev;
 	conn_reconfig_start(mdev->tconn);
 
 	/* if you want to reconfigure, please tear down first */
@@ -910,7 +1087,7 @@ static int drbd_nl_disk_conf(struct drbd_conf *mdev, struct drbd_nl_cfg_req *nlp
 	 * to realize a "hot spare" feature (not that I'd recommend that) */
 	wait_event(mdev->misc_wait, !atomic_read(&mdev->local_cnt));
 
-	/* allocation not in the IO path, cqueue thread context */
+	/* allocation not in the IO path, drbdsetup context */
 	nbc = kzalloc(sizeof(struct drbd_backing_dev), GFP_KERNEL);
 	if (!nbc) {
 		retcode = ERR_NOMEM;
@@ -922,12 +1099,14 @@ static int drbd_nl_disk_conf(struct drbd_conf *mdev, struct drbd_nl_cfg_req *nlp
 	nbc->dc.fencing       = DRBD_FENCING_DEF;
 	nbc->dc.max_bio_bvecs = DRBD_MAX_BIO_BVECS_DEF;
 
-	if (!disk_conf_from_tags(nlp->tag_list, &nbc->dc)) {
+	err = disk_conf_from_attrs(&nbc->dc, info->attrs);
+	if (err) {
 		retcode = ERR_MANDATORY_TAG;
+		drbd_msg_put_info(from_attrs_err_to_txt(err));
 		goto fail;
 	}
 
-	if (nbc->dc.meta_dev_idx < DRBD_MD_INDEX_FLEX_INT) {
+	if ((int)nbc->dc.meta_dev_idx < DRBD_MD_INDEX_FLEX_INT) {
 		retcode = ERR_MD_IDX_INVALID;
 		goto fail;
 	}
@@ -961,7 +1140,7 @@ static int drbd_nl_disk_conf(struct drbd_conf *mdev, struct drbd_nl_cfg_req *nlp
 	 */
 	bdev = blkdev_get_by_path(nbc->dc.meta_dev,
 				  FMODE_READ | FMODE_WRITE | FMODE_EXCL,
-				  (nbc->dc.meta_dev_idx < 0) ?
+				  ((int)nbc->dc.meta_dev_idx < 0) ?
 				  (void *)mdev : (void *)drbd_m_holder);
 	if (IS_ERR(bdev)) {
 		dev_err(DEV, "open(\"%s\") failed with %ld\n", nbc->dc.meta_dev,
@@ -997,7 +1176,7 @@ static int drbd_nl_disk_conf(struct drbd_conf *mdev, struct drbd_nl_cfg_req *nlp
 		goto fail;
 	}
 
-	if (nbc->dc.meta_dev_idx < 0) {
+	if ((int)nbc->dc.meta_dev_idx < 0) {
 		max_possible_sectors = DRBD_MAX_SECTORS_FLEX;
 		/* at least one MB, otherwise it does not make sense */
 		min_md_device_sectors = (2<<10);
@@ -1028,7 +1207,7 @@ static int drbd_nl_disk_conf(struct drbd_conf *mdev, struct drbd_nl_cfg_req *nlp
 		dev_warn(DEV, "==> truncating very big lower level device "
 			"to currently maximum possible %llu sectors <==\n",
 			(unsigned long long) max_possible_sectors);
-		if (nbc->dc.meta_dev_idx >= 0)
+		if ((int)nbc->dc.meta_dev_idx >= 0)
 			dev_warn(DEV, "==>> using internal or flexible "
 				      "meta data may help <<==\n");
 	}
@@ -1242,8 +1421,8 @@ static int drbd_nl_disk_conf(struct drbd_conf *mdev, struct drbd_nl_cfg_req *nlp
 
 	kobject_uevent(&disk_to_dev(mdev->vdisk)->kobj, KOBJ_CHANGE);
 	put_ldev(mdev);
-	reply->ret_code = retcode;
 	conn_reconfig_done(mdev->tconn);
+	drbd_adm_finish(info, retcode);
 	return 0;
 
  force_diskless_dec:
@@ -1251,6 +1430,7 @@ static int drbd_nl_disk_conf(struct drbd_conf *mdev, struct drbd_nl_cfg_req *nlp
  force_diskless:
 	drbd_force_state(mdev, NS(disk, D_FAILED));
 	drbd_md_sync(mdev);
+	conn_reconfig_done(mdev->tconn);
  fail:
 	if (nbc) {
 		if (nbc->backing_bdev)
@@ -1263,8 +1443,7 @@ static int drbd_nl_disk_conf(struct drbd_conf *mdev, struct drbd_nl_cfg_req *nlp
 	}
 	lc_destroy(resync_lru);
 
-	reply->ret_code = retcode;
-	conn_reconfig_done(mdev->tconn);
+	drbd_adm_finish(info, retcode);
 	return 0;
 }
 
@@ -1273,42 +1452,54 @@ static int drbd_nl_disk_conf(struct drbd_conf *mdev, struct drbd_nl_cfg_req *nlp
  * Then we transition to D_DISKLESS, and wait for put_ldev() to return all
  * internal references as well.
  * Only then we have finally detached. */
-static int drbd_nl_detach(struct drbd_conf *mdev, struct drbd_nl_cfg_req *nlp,
-			  struct drbd_nl_cfg_reply *reply)
+int drbd_adm_detach(struct sk_buff *skb, struct genl_info *info)
 {
+	struct drbd_conf *mdev;
 	enum drbd_ret_code retcode;
-	int ret;
+
+	retcode = drbd_adm_prepare(skb, info, DRBD_ADM_NEED_MINOR);
+	if (!adm_ctx.reply_skb)
+		return retcode;
+	if (retcode != NO_ERROR)
+		goto out;
+
+	mdev = adm_ctx.mdev;
 	drbd_suspend_io(mdev); /* so no-one is stuck in drbd_al_begin_io */
-	retcode = drbd_request_state(mdev, NS(disk, D_FAILED));
-	/* D_FAILED will transition to DISKLESS. */
-	ret = wait_event_interruptible(mdev->misc_wait,
-			mdev->state.disk != D_FAILED);
+	retcode = drbd_request_state(mdev, NS(disk, D_DISKLESS));
+	wait_event(mdev->misc_wait,
+			mdev->state.disk != D_DISKLESS ||
+			!atomic_read(&mdev->local_cnt));
 	drbd_resume_io(mdev);
-	if ((int)retcode == (int)SS_IS_DISKLESS)
-		retcode = SS_NOTHING_TO_DO;
-	if (ret)
-		retcode = ERR_INTR;
-	reply->ret_code = retcode;
+out:
+	drbd_adm_finish(info, retcode);
 	return 0;
 }
 
-static int drbd_nl_net_conf(struct drbd_tconn *tconn, struct drbd_nl_cfg_req *nlp,
-			    struct drbd_nl_cfg_reply *reply)
+int drbd_adm_connect(struct sk_buff *skb, struct genl_info *info)
 {
-	int i;
-	enum drbd_ret_code retcode;
+	char hmac_name[CRYPTO_MAX_ALG_NAME];
+	struct drbd_conf *mdev;
 	struct net_conf *new_conf = NULL;
 	struct crypto_hash *tfm = NULL;
 	struct crypto_hash *integrity_w_tfm = NULL;
 	struct crypto_hash *integrity_r_tfm = NULL;
-	struct drbd_conf *mdev;
-	char hmac_name[CRYPTO_MAX_ALG_NAME];
 	void *int_dig_out = NULL;
 	void *int_dig_in = NULL;
 	void *int_dig_vv = NULL;
 	struct drbd_tconn *oconn;
+	struct drbd_tconn *tconn;
 	struct sockaddr *new_my_addr, *new_peer_addr, *taken_addr;
+	enum drbd_ret_code retcode;
+	int i;
+	int err;
+
+	retcode = drbd_adm_prepare(skb, info, DRBD_ADM_NEED_CONN);
+	if (!adm_ctx.reply_skb)
+		return retcode;
+	if (retcode != NO_ERROR)
+		goto out;
 
+	tconn = adm_ctx.tconn;
 	conn_reconfig_start(tconn);
 
 	if (tconn->cstate > C_STANDALONE) {
@@ -1343,8 +1534,10 @@ static int drbd_nl_net_conf(struct drbd_tconn *tconn, struct drbd_nl_cfg_req *nl
 	new_conf->on_congestion    = DRBD_ON_CONGESTION_DEF;
 	new_conf->cong_extents     = DRBD_CONG_EXTENTS_DEF;
 
-	if (!net_conf_from_tags(nlp->tag_list, new_conf)) {
+	err = net_conf_from_attrs(new_conf, info->attrs);
+	if (err) {
 		retcode = ERR_MANDATORY_TAG;
+		drbd_msg_put_info(from_attrs_err_to_txt(err));
 		goto fail;
 	}
 
@@ -1495,8 +1688,8 @@ static int drbd_nl_net_conf(struct drbd_tconn *tconn, struct drbd_nl_cfg_req *nl
 		mdev->recv_cnt = 0;
 		kobject_uevent(&disk_to_dev(mdev->vdisk)->kobj, KOBJ_CHANGE);
 	}
-	reply->ret_code = retcode;
 	conn_reconfig_done(tconn);
+	drbd_adm_finish(info, retcode);
 	return 0;
 
 fail:
@@ -1508,24 +1701,37 @@ fail:
 	crypto_free_hash(integrity_r_tfm);
 	kfree(new_conf);
 
-	reply->ret_code = retcode;
 	conn_reconfig_done(tconn);
+out:
+	drbd_adm_finish(info, retcode);
 	return 0;
 }
 
-static int drbd_nl_disconnect(struct drbd_tconn *tconn, struct drbd_nl_cfg_req *nlp,
-			      struct drbd_nl_cfg_reply *reply)
+int drbd_adm_disconnect(struct sk_buff *skb, struct genl_info *info)
 {
-	int retcode;
-	struct disconnect dc;
+	struct disconnect_parms parms;
+	struct drbd_tconn *tconn;
+	enum drbd_ret_code retcode;
+	int err;
 
-	memset(&dc, 0, sizeof(struct disconnect));
-	if (!disconnect_from_tags(nlp->tag_list, &dc)) {
-		retcode = ERR_MANDATORY_TAG;
+	retcode = drbd_adm_prepare(skb, info, DRBD_ADM_NEED_CONN);
+	if (!adm_ctx.reply_skb)
+		return retcode;
+	if (retcode != NO_ERROR)
 		goto fail;
+
+	tconn = adm_ctx.tconn;
+	memset(&parms, 0, sizeof(parms));
+	if (info->attrs[DRBD_NLA_DISCONNECT_PARMS]) {
+		err = disconnect_parms_from_attrs(&parms, info->attrs);
+		if (err) {
+			retcode = ERR_MANDATORY_TAG;
+			drbd_msg_put_info(from_attrs_err_to_txt(err));
+			goto fail;
+		}
 	}
 
-	if (dc.force) {
+	if (parms.force_disconnect) {
 		spin_lock_irq(&tconn->req_lock);
 		if (tconn->cstate >= C_WF_CONNECTION)
 			_conn_request_state(tconn, NS(conn, C_DISCONNECTING), CS_HARD);
@@ -1567,7 +1773,7 @@ static int drbd_nl_disconnect(struct drbd_tconn *tconn, struct drbd_nl_cfg_req *
  done:
 	retcode = NO_ERROR;
  fail:
-	reply->ret_code = retcode;
+	drbd_adm_finish(info, retcode);
 	return 0;
 }
 
@@ -1587,20 +1793,32 @@ void resync_after_online_grow(struct drbd_conf *mdev)
 		_drbd_request_state(mdev, NS(conn, C_WF_SYNC_UUID), CS_VERBOSE + CS_SERIALIZE);
 }
 
-static int drbd_nl_resize(struct drbd_conf *mdev, struct drbd_nl_cfg_req *nlp,
-			  struct drbd_nl_cfg_reply *reply)
+int drbd_adm_resize(struct sk_buff *skb, struct genl_info *info)
 {
-	struct resize rs;
-	int retcode = NO_ERROR;
+	struct resize_parms rs;
+	struct drbd_conf *mdev;
+	enum drbd_ret_code retcode;
 	enum determine_dev_size dd;
 	enum dds_flags ddsf;
+	int err;
 
-	memset(&rs, 0, sizeof(struct resize));
-	if (!resize_from_tags(nlp->tag_list, &rs)) {
-		retcode = ERR_MANDATORY_TAG;
+	retcode = drbd_adm_prepare(skb, info, DRBD_ADM_NEED_MINOR);
+	if (!adm_ctx.reply_skb)
+		return retcode;
+	if (retcode != NO_ERROR)
 		goto fail;
+
+	memset(&rs, 0, sizeof(struct resize_parms));
+	if (info->attrs[DRBD_NLA_RESIZE_PARMS]) {
+		err = resize_parms_from_attrs(&rs, info->attrs);
+		if (err) {
+			retcode = ERR_MANDATORY_TAG;
+			drbd_msg_put_info(from_attrs_err_to_txt(err));
+			goto fail;
+		}
 	}
 
+	mdev = adm_ctx.mdev;
 	if (mdev->state.conn > C_CONNECTED) {
 		retcode = ERR_RESIZE_RESYNC;
 		goto fail;
@@ -1644,14 +1862,14 @@ static int drbd_nl_resize(struct drbd_conf *mdev, struct drbd_nl_cfg_req *nlp,
 	}
 
  fail:
-	reply->ret_code = retcode;
+	drbd_adm_finish(info, retcode);
 	return 0;
 }
 
-static int drbd_nl_syncer_conf(struct drbd_conf *mdev, struct drbd_nl_cfg_req *nlp,
-			       struct drbd_nl_cfg_reply *reply)
+int drbd_adm_syncer(struct sk_buff *skb, struct genl_info *info)
 {
-	int retcode = NO_ERROR;
+	struct drbd_conf *mdev;
+	enum drbd_ret_code retcode;
 	int err;
 	int ovr; /* online verify running */
 	int rsr; /* re-sync running */
@@ -1662,12 +1880,21 @@ static int drbd_nl_syncer_conf(struct drbd_conf *mdev, struct drbd_nl_cfg_req *n
 	int *rs_plan_s = NULL;
 	int fifo_size;
 
+	retcode = drbd_adm_prepare(skb, info, DRBD_ADM_NEED_MINOR);
+	if (!adm_ctx.reply_skb)
+		return retcode;
+	if (retcode != NO_ERROR)
+		goto fail;
+	mdev = adm_ctx.mdev;
+
 	if (!zalloc_cpumask_var(&new_cpu_mask, GFP_KERNEL)) {
 		retcode = ERR_NOMEM;
+		drbd_msg_put_info("unable to allocate cpumask");
 		goto fail;
 	}
 
-	if (nlp->flags & DRBD_NL_SET_DEFAULTS) {
+	if (((struct drbd_genlmsghdr*)info->userhdr)->flags
+			& DRBD_GENL_F_SET_DEFAULTS) {
 		memset(&sc, 0, sizeof(struct syncer_conf));
 		sc.rate       = DRBD_RATE_DEF;
 		sc.after      = DRBD_AFTER_DEF;
@@ -1681,8 +1908,10 @@ static int drbd_nl_syncer_conf(struct drbd_conf *mdev, struct drbd_nl_cfg_req *n
 	} else
 		memcpy(&sc, &mdev->sync_conf, sizeof(struct syncer_conf));
 
-	if (!syncer_conf_from_tags(nlp->tag_list, &sc)) {
+	err = syncer_conf_from_attrs(&sc, info->attrs);
+	if (err) {
 		retcode = ERR_MANDATORY_TAG;
+		drbd_msg_put_info(from_attrs_err_to_txt(err));
 		goto fail;
 	}
 
@@ -1832,14 +2061,23 @@ fail:
 	free_cpumask_var(new_cpu_mask);
 	crypto_free_hash(csums_tfm);
 	crypto_free_hash(verify_tfm);
-	reply->ret_code = retcode;
+
+	drbd_adm_finish(info, retcode);
 	return 0;
 }
 
-static int drbd_nl_invalidate(struct drbd_conf *mdev, struct drbd_nl_cfg_req *nlp,
-			      struct drbd_nl_cfg_reply *reply)
+int drbd_adm_invalidate(struct sk_buff *skb, struct genl_info *info)
 {
-	int retcode;
+	struct drbd_conf *mdev;
+	enum drbd_ret_code retcode;
+
+	retcode = drbd_adm_prepare(skb, info, DRBD_ADM_NEED_MINOR);
+	if (!adm_ctx.reply_skb)
+		return retcode;
+	if (retcode != NO_ERROR)
+		goto out;
+
+	mdev = adm_ctx.mdev;
 
 	/* If there is still bitmap IO pending, probably because of a previous
 	 * resync just being finished, wait for it before requesting a new resync. */
@@ -1862,7 +2100,8 @@ static int drbd_nl_invalidate(struct drbd_conf *mdev, struct drbd_nl_cfg_req *nl
 		retcode = drbd_request_state(mdev, NS(conn, C_STARTING_SYNC_T));
 	}
 
-	reply->ret_code = retcode;
+out:
+	drbd_adm_finish(info, retcode);
 	return 0;
 }
 
@@ -1875,56 +2114,58 @@ static int drbd_bmio_set_susp_al(struct drbd_conf *mdev)
 	return rv;
 }
 
-static int drbd_nl_invalidate_peer(struct drbd_conf *mdev, struct drbd_nl_cfg_req *nlp,
-				   struct drbd_nl_cfg_reply *reply)
+static int drbd_adm_simple_request_state(struct sk_buff *skb, struct genl_info *info,
+		union drbd_state mask, union drbd_state val)
 {
-	int retcode;
-
-	/* If there is still bitmap IO pending, probably because of a previous
-	 * resync just being finished, wait for it before requesting a new resync. */
-	wait_event(mdev->misc_wait, !test_bit(BITMAP_IO, &mdev->flags));
+	enum drbd_ret_code retcode;
 
-	retcode = _drbd_request_state(mdev, NS(conn, C_STARTING_SYNC_S), CS_ORDERED);
-
-	if (retcode < SS_SUCCESS) {
-		if (retcode == SS_NEED_CONNECTION && mdev->state.role == R_PRIMARY) {
-			/* The peer will get a resync upon connect anyways. Just make that
-			   into a full resync. */
-			retcode = drbd_request_state(mdev, NS(pdsk, D_INCONSISTENT));
-			if (retcode >= SS_SUCCESS) {
-				if (drbd_bitmap_io(mdev, &drbd_bmio_set_susp_al,
-					"set_n_write from invalidate_peer",
-					BM_LOCKED_SET_ALLOWED))
-					retcode = ERR_IO_MD_DISK;
-			}
-		} else
-			retcode = drbd_request_state(mdev, NS(conn, C_STARTING_SYNC_S));
-	}
+	retcode = drbd_adm_prepare(skb, info, DRBD_ADM_NEED_MINOR);
+	if (!adm_ctx.reply_skb)
+		return retcode;
+	if (retcode != NO_ERROR)
+		goto out;
 
-	reply->ret_code = retcode;
+	retcode = drbd_request_state(adm_ctx.mdev, mask, val);
+out:
+	drbd_adm_finish(info, retcode);
 	return 0;
 }
 
-static int drbd_nl_pause_sync(struct drbd_conf *mdev, struct drbd_nl_cfg_req *nlp,
-			      struct drbd_nl_cfg_reply *reply)
+int drbd_adm_invalidate_peer(struct sk_buff *skb, struct genl_info *info)
 {
-	int retcode = NO_ERROR;
+	return drbd_adm_simple_request_state(skb, info, NS(conn, C_STARTING_SYNC_S));
+}
 
-	if (drbd_request_state(mdev, NS(user_isp, 1)) == SS_NOTHING_TO_DO)
-		retcode = ERR_PAUSE_IS_SET;
+int drbd_adm_pause_sync(struct sk_buff *skb, struct genl_info *info)
+{
+	enum drbd_ret_code retcode;
+
+	retcode = drbd_adm_prepare(skb, info, DRBD_ADM_NEED_MINOR);
+	if (!adm_ctx.reply_skb)
+		return retcode;
+	if (retcode != NO_ERROR)
+		goto out;
 
-	reply->ret_code = retcode;
+	if (drbd_request_state(adm_ctx.mdev, NS(user_isp, 1)) == SS_NOTHING_TO_DO)
+		retcode = ERR_PAUSE_IS_SET;
+out:
+	drbd_adm_finish(info, retcode);
 	return 0;
 }
 
-static int drbd_nl_resume_sync(struct drbd_conf *mdev, struct drbd_nl_cfg_req *nlp,
-			       struct drbd_nl_cfg_reply *reply)
+int drbd_adm_resume_sync(struct sk_buff *skb, struct genl_info *info)
 {
-	int retcode = NO_ERROR;
 	union drbd_state s;
+	enum drbd_ret_code retcode;
+
+	retcode = drbd_adm_prepare(skb, info, DRBD_ADM_NEED_MINOR);
+	if (!adm_ctx.reply_skb)
+		return retcode;
+	if (retcode != NO_ERROR)
+		goto out;
 
-	if (drbd_request_state(mdev, NS(user_isp, 0)) == SS_NOTHING_TO_DO) {
-		s = mdev->state;
+	if (drbd_request_state(adm_ctx.mdev, NS(user_isp, 0)) == SS_NOTHING_TO_DO) {
+		s = adm_ctx.mdev->state;
 		if (s.conn == C_PAUSED_SYNC_S || s.conn == C_PAUSED_SYNC_T) {
 			retcode = s.aftr_isp ? ERR_PIC_AFTER_DEP :
 				  s.peer_isp ? ERR_PIC_PEER_DEP : ERR_PAUSE_IS_CLEAR;
@@ -1933,28 +2174,35 @@ static int drbd_nl_resume_sync(struct drbd_conf *mdev, struct drbd_nl_cfg_req *n
 		}
 	}
 
-	reply->ret_code = retcode;
+out:
+	drbd_adm_finish(info, retcode);
 	return 0;
 }
 
-static int drbd_nl_suspend_io(struct drbd_conf *mdev, struct drbd_nl_cfg_req *nlp,
-			      struct drbd_nl_cfg_reply *reply)
+int drbd_adm_suspend_io(struct sk_buff *skb, struct genl_info *info)
 {
-	reply->ret_code = drbd_request_state(mdev, NS(susp, 1));
-
-	return 0;
+	return drbd_adm_simple_request_state(skb, info, NS(susp, 1));
 }
 
-static int drbd_nl_resume_io(struct drbd_conf *mdev, struct drbd_nl_cfg_req *nlp,
-			     struct drbd_nl_cfg_reply *reply)
+int drbd_adm_resume_io(struct sk_buff *skb, struct genl_info *info)
 {
+	struct drbd_conf *mdev;
+	enum drbd_ret_code retcode;
+
+	retcode = drbd_adm_prepare(skb, info, DRBD_ADM_NEED_MINOR);
+	if (!adm_ctx.reply_skb)
+		return retcode;
+	if (retcode != NO_ERROR)
+		goto out;
+
+	mdev = adm_ctx.mdev;
 	if (test_bit(NEW_CUR_UUID, &mdev->flags)) {
 		drbd_uuid_new_current(mdev);
 		clear_bit(NEW_CUR_UUID, &mdev->flags);
 	}
 	drbd_suspend_io(mdev);
-	reply->ret_code = drbd_request_state(mdev, NS3(susp, 0, susp_nod, 0, susp_fen, 0));
-	if (reply->ret_code == SS_SUCCESS) {
+	retcode = drbd_request_state(mdev, NS3(susp, 0, susp_nod, 0, susp_fen, 0));
+	if (retcode == SS_SUCCESS) {
 		if (mdev->state.conn < C_CONNECTED)
 			tl_clear(mdev->tconn);
 		if (mdev->state.disk == D_DISKLESS || mdev->state.disk == D_FAILED)
@@ -1962,138 +2210,261 @@ static int drbd_nl_resume_io(struct drbd_conf *mdev, struct drbd_nl_cfg_req *nlp
 	}
 	drbd_resume_io(mdev);
 
+out:
+	drbd_adm_finish(info, retcode);
 	return 0;
 }
 
-static int drbd_nl_outdate(struct drbd_conf *mdev, struct drbd_nl_cfg_req *nlp,
-			   struct drbd_nl_cfg_reply *reply)
+int drbd_adm_outdate(struct sk_buff *skb, struct genl_info *info)
 {
-	reply->ret_code = drbd_request_state(mdev, NS(disk, D_OUTDATED));
-	return 0;
+	return drbd_adm_simple_request_state(skb, info, NS(disk, D_OUTDATED));
 }
 
-static int drbd_nl_get_config(struct drbd_conf *mdev, struct drbd_nl_cfg_req *nlp,
-			   struct drbd_nl_cfg_reply *reply)
+int nla_put_status_info(struct sk_buff *skb, struct drbd_conf *mdev,
+		const struct sib_info *sib)
 {
-	unsigned short *tl;
-
-	tl = reply->tag_list;
-
-	if (get_ldev(mdev)) {
-		tl = disk_conf_to_tags(&mdev->ldev->dc, tl);
-		put_ldev(mdev);
+	struct state_info *si = NULL; /* for sizeof(si->member); */
+	struct nlattr *nla;
+	int got_ldev;
+	int got_net;
+	int err = 0;
+	int exclude_sensitive;
+
+	/* If sib != NULL, this is drbd_bcast_event, which anyone can listen
+	 * to.  So we better exclude_sensitive information.
+	 *
+	 * If sib == NULL, this is drbd_adm_get_status, executed synchronously
+	 * in the context of the requesting user process. Exclude sensitive
+	 * information, unless current has superuser.
+	 *
+	 * NOTE: for drbd_adm_get_status_all(), this is a netlink dump, and
+	 * relies on the current implementation of netlink_dump(), which
+	 * executes the dump callback successively from netlink_recvmsg(),
+	 * always in the context of the receiving process */
+	exclude_sensitive = sib || !capable(CAP_SYS_ADMIN);
+
+	got_ldev = get_ldev(mdev);
+	got_net = get_net_conf(mdev->tconn);
+
+	/* We need to add connection name and volume number information still.
+	 * Minor number is in drbd_genlmsghdr. */
+	nla = nla_nest_start(skb, DRBD_NLA_CFG_CONTEXT);
+	if (!nla)
+		goto nla_put_failure;
+	NLA_PUT_U32(skb, T_ctx_volume, mdev->vnr);
+	NLA_PUT_STRING(skb, T_ctx_conn_name, mdev->tconn->name);
+	nla_nest_end(skb, nla);
+
+	if (got_ldev)
+		if (disk_conf_to_skb(skb, &mdev->ldev->dc, exclude_sensitive))
+			goto nla_put_failure;
+	if (got_net)
+		if (net_conf_to_skb(skb, mdev->tconn->net_conf, exclude_sensitive))
+			goto nla_put_failure;
+
+	if (syncer_conf_to_skb(skb, &mdev->sync_conf, exclude_sensitive))
+			goto nla_put_failure;
+
+	nla = nla_nest_start(skb, DRBD_NLA_STATE_INFO);
+	if (!nla)
+		goto nla_put_failure;
+	NLA_PUT_U32(skb, T_sib_reason, sib ? sib->sib_reason : SIB_GET_STATUS_REPLY);
+	NLA_PUT_U32(skb, T_current_state, mdev->state.i);
+	NLA_PUT_U64(skb, T_ed_uuid, mdev->ed_uuid);
+	NLA_PUT_U64(skb, T_capacity, drbd_get_capacity(mdev->this_bdev));
+
+	if (got_ldev) {
+		NLA_PUT_U32(skb, T_disk_flags, mdev->ldev->md.flags);
+		NLA_PUT(skb, T_uuids, sizeof(si->uuids), mdev->ldev->md.uuid);
+		NLA_PUT_U64(skb, T_bits_total, drbd_bm_bits(mdev));
+		NLA_PUT_U64(skb, T_bits_oos, drbd_bm_total_weight(mdev));
+		if (C_SYNC_SOURCE <= mdev->state.conn &&
+		    C_PAUSED_SYNC_T >= mdev->state.conn) {
+			NLA_PUT_U64(skb, T_bits_rs_total, mdev->rs_total);
+			NLA_PUT_U64(skb, T_bits_rs_failed, mdev->rs_failed);
+		}
 	}
 
-	if (get_net_conf(mdev->tconn)) {
-		tl = net_conf_to_tags(mdev->tconn->net_conf, tl);
-		put_net_conf(mdev->tconn);
+	if (sib) {
+		switch(sib->sib_reason) {
+		case SIB_SYNC_PROGRESS:
+		case SIB_GET_STATUS_REPLY:
+			break;
+		case SIB_STATE_CHANGE:
+			NLA_PUT_U32(skb, T_prev_state, sib->os.i);
+			NLA_PUT_U32(skb, T_new_state, sib->ns.i);
+			break;
+		case SIB_HELPER_POST:
+			NLA_PUT_U32(skb,
+				T_helper_exit_code, sib->helper_exit_code);
+			/* fall through */
+		case SIB_HELPER_PRE:
+			NLA_PUT_STRING(skb, T_helper, sib->helper_name);
+			break;
+		}
 	}
-	tl = syncer_conf_to_tags(&mdev->sync_conf, tl);
-
-	put_unaligned(TT_END, tl++); /* Close the tag list */
+	nla_nest_end(skb, nla);
 
-	return (int)((char *)tl - (char *)reply->tag_list);
+	if (0)
+nla_put_failure:
+		err = -EMSGSIZE;
+	if (got_ldev)
+		put_ldev(mdev);
+	if (got_net)
+		put_net_conf(mdev->tconn);
+	return err;
 }
 
-static int drbd_nl_get_state(struct drbd_conf *mdev, struct drbd_nl_cfg_req *nlp,
-			     struct drbd_nl_cfg_reply *reply)
+int drbd_adm_get_status(struct sk_buff *skb, struct genl_info *info)
 {
-	unsigned short *tl = reply->tag_list;
-	union drbd_state s = mdev->state;
-	unsigned long rs_left;
-	unsigned int res;
+	enum drbd_ret_code retcode;
+	int err;
 
-	tl = get_state_to_tags((struct get_state *)&s, tl);
+	retcode = drbd_adm_prepare(skb, info, DRBD_ADM_NEED_MINOR);
+	if (!adm_ctx.reply_skb)
+		return retcode;
+	if (retcode != NO_ERROR)
+		goto out;
 
-	/* no local ref, no bitmap, no syncer progress. */
-	if (s.conn >= C_SYNC_SOURCE && s.conn <= C_PAUSED_SYNC_T) {
-		if (get_ldev(mdev)) {
-			drbd_get_syncer_progress(mdev, &rs_left, &res);
-			tl = tl_add_int(tl, T_sync_progress, &res);
-			put_ldev(mdev);
-		}
+	err = nla_put_status_info(adm_ctx.reply_skb, adm_ctx.mdev, NULL);
+	if (err) {
+		nlmsg_free(adm_ctx.reply_skb);
+		return err;
 	}
-	put_unaligned(TT_END, tl++); /* Close the tag list */
-
-	return (int)((char *)tl - (char *)reply->tag_list);
+out:
+	drbd_adm_finish(info, retcode);
+	return 0;
 }
 
-static int drbd_nl_get_uuids(struct drbd_conf *mdev, struct drbd_nl_cfg_req *nlp,
-			     struct drbd_nl_cfg_reply *reply)
+int drbd_adm_get_status_all(struct sk_buff *skb, struct netlink_callback *cb)
 {
-	unsigned short *tl;
-
-	tl = reply->tag_list;
+	struct drbd_conf *mdev;
+	struct drbd_genlmsghdr *dh;
+	int minor = cb->args[0];
+
+	/* Open coded deferred single idr_for_each_entry iteration.
+	 * This may miss entries inserted after this dump started,
+	 * or entries deleted before they are reached.
+	 * But we need to make sure the mdev won't disappear while
+	 * we are looking at it. */
+
+	rcu_read_lock();
+	mdev = idr_get_next(&minors, &minor);
+	if (mdev) {
+		dh = genlmsg_put(skb, NETLINK_CB(cb->skb).pid,
+				cb->nlh->nlmsg_seq, &drbd_genl_family,
+				NLM_F_MULTI, DRBD_ADM_GET_STATUS);
+		if (!dh)
+			goto errout;
+
+		D_ASSERT(mdev->minor == minor);
+
+		dh->minor = minor;
+		dh->ret_code = NO_ERROR;
+
+		pr_info("dump: minor=%u, conn=%s[%u]\n",
+			dh->minor, mdev->tconn->name, mdev->vnr);
+		if (nla_put_status_info(skb, mdev, NULL)) {
+			genlmsg_cancel(skb, dh);
+			goto errout;
+		}
+		genlmsg_end(skb, dh);
+        }
 
-	if (get_ldev(mdev)) {
-		tl = tl_add_blob(tl, T_uuids, mdev->ldev->md.uuid, UI_SIZE*sizeof(u64));
-		tl = tl_add_int(tl, T_uuids_flags, &mdev->ldev->md.flags);
-		put_ldev(mdev);
-	}
-	put_unaligned(TT_END, tl++); /* Close the tag list */
+errout:
+	rcu_read_unlock();
+	/* where to start idr_get_next with the next iteration */
+        cb->args[0] = minor+1;
 
-	return (int)((char *)tl - (char *)reply->tag_list);
+	/* No more minors found: empty skb. Which will terminate the dump. */
+        return skb->len;
 }
 
-/**
- * drbd_nl_get_timeout_flag() - Used by drbdsetup to find out which timeout value to use
- * @mdev:	DRBD device.
- * @nlp:	Netlink/connector packet from drbdsetup
- * @reply:	Reply packet for drbdsetup
- */
-static int drbd_nl_get_timeout_flag(struct drbd_conf *mdev, struct drbd_nl_cfg_req *nlp,
-				    struct drbd_nl_cfg_reply *reply)
+int drbd_adm_get_timeout_type(struct sk_buff *skb, struct genl_info *info)
 {
-	unsigned short *tl;
-	char rv;
-
-	tl = reply->tag_list;
+	enum drbd_ret_code retcode;
+	struct timeout_parms tp;
+	int err;
 
-	rv = mdev->state.pdsk == D_OUTDATED        ? UT_PEER_OUTDATED :
-	  test_bit(USE_DEGR_WFC_T, &mdev->flags) ? UT_DEGRADED : UT_DEFAULT;
+	retcode = drbd_adm_prepare(skb, info, DRBD_ADM_NEED_MINOR);
+	if (!adm_ctx.reply_skb)
+		return retcode;
+	if (retcode != NO_ERROR)
+		goto out;
 
-	tl = tl_add_blob(tl, T_use_degraded, &rv, sizeof(rv));
-	put_unaligned(TT_END, tl++); /* Close the tag list */
+	tp.timeout_type =
+		adm_ctx.mdev->state.pdsk == D_OUTDATED ? UT_PEER_OUTDATED :
+		test_bit(USE_DEGR_WFC_T, &adm_ctx.mdev->flags) ? UT_DEGRADED :
+		UT_DEFAULT;
 
-	return (int)((char *)tl - (char *)reply->tag_list);
+	err = timeout_parms_to_priv_skb(adm_ctx.reply_skb, &tp);
+	if (err) {
+		nlmsg_free(adm_ctx.reply_skb);
+		return err;
+	}
+out:
+	drbd_adm_finish(info, retcode);
+	return 0;
 }
 
-static int drbd_nl_start_ov(struct drbd_conf *mdev, struct drbd_nl_cfg_req *nlp,
-				    struct drbd_nl_cfg_reply *reply)
+int drbd_adm_start_ov(struct sk_buff *skb, struct genl_info *info)
 {
-	/* default to resume from last known position, if possible */
-	struct start_ov args =
-		{ .start_sector = mdev->ov_start_sector };
+	struct drbd_conf *mdev;
+	enum drbd_ret_code retcode;
 
-	if (!start_ov_from_tags(nlp->tag_list, &args)) {
-		reply->ret_code = ERR_MANDATORY_TAG;
-		return 0;
-	}
+	retcode = drbd_adm_prepare(skb, info, DRBD_ADM_NEED_MINOR);
+	if (!adm_ctx.reply_skb)
+		return retcode;
+	if (retcode != NO_ERROR)
+		goto out;
 
+	mdev = adm_ctx.mdev;
+	if (info->attrs[DRBD_NLA_START_OV_PARMS]) {
+		/* resume from last known position, if possible */
+		struct start_ov_parms parms =
+			{ .ov_start_sector = mdev->ov_start_sector };
+		int err = start_ov_parms_from_attrs(&parms, info->attrs);
+		if (err) {
+			retcode = ERR_MANDATORY_TAG;
+			drbd_msg_put_info(from_attrs_err_to_txt(err));
+			goto out;
+		}
+		/* w_make_ov_request expects position to be aligned */
+		mdev->ov_start_sector = parms.ov_start_sector & ~BM_SECT_PER_BIT;
+	}
 	/* If there is still bitmap IO pending, e.g. previous resync or verify
 	 * just being finished, wait for it before requesting a new resync. */
 	wait_event(mdev->misc_wait, !test_bit(BITMAP_IO, &mdev->flags));
-
-	/* w_make_ov_request expects position to be aligned */
-	mdev->ov_start_sector = args.start_sector & ~BM_SECT_PER_BIT;
-	reply->ret_code = drbd_request_state(mdev,NS(conn,C_VERIFY_S));
+	retcode = drbd_request_state(mdev,NS(conn,C_VERIFY_S));
+out:
+	drbd_adm_finish(info, retcode);
 	return 0;
 }
 
 
-static int drbd_nl_new_c_uuid(struct drbd_conf *mdev, struct drbd_nl_cfg_req *nlp,
-			      struct drbd_nl_cfg_reply *reply)
+int drbd_adm_new_c_uuid(struct sk_buff *skb, struct genl_info *info)
 {
-	int retcode = NO_ERROR;
+	struct drbd_conf *mdev;
+	enum drbd_ret_code retcode;
 	int skip_initial_sync = 0;
 	int err;
+	struct new_c_uuid_parms args;
 
-	struct new_c_uuid args;
+	retcode = drbd_adm_prepare(skb, info, DRBD_ADM_NEED_MINOR);
+	if (!adm_ctx.reply_skb)
+		return retcode;
+	if (retcode != NO_ERROR)
+		goto out_nolock;
 
-	memset(&args, 0, sizeof(struct new_c_uuid));
-	if (!new_c_uuid_from_tags(nlp->tag_list, &args)) {
-		reply->ret_code = ERR_MANDATORY_TAG;
-		return 0;
+	mdev = adm_ctx.mdev;
+	memset(&args, 0, sizeof(args));
+	if (info->attrs[DRBD_NLA_NEW_C_UUID_PARMS]) {
+		err = new_c_uuid_parms_from_attrs(&args, info->attrs);
+		if (err) {
+			retcode = ERR_MANDATORY_TAG;
+			drbd_msg_put_info(from_attrs_err_to_txt(err));
+			goto out_nolock;
+		}
 	}
 
 	mutex_lock(mdev->state_mutex); /* Protects us against serialized state changes. */
@@ -2139,510 +2510,164 @@ out_dec:
 	put_ldev(mdev);
 out:
 	mutex_unlock(mdev->state_mutex);
-
-	reply->ret_code = retcode;
-	return 0;
-}
-
-static int drbd_nl_new_conn(struct drbd_nl_cfg_req *nlp, struct drbd_nl_cfg_reply *reply)
-{
-	struct new_connection args;
-
-	if (!new_connection_from_tags(nlp->tag_list, &args)) {
-		reply->ret_code = ERR_MANDATORY_TAG;
-		return 0;
-	}
-
-	reply->ret_code = NO_ERROR;
-	if (!drbd_new_tconn(args.name))
-		reply->ret_code = ERR_NOMEM;
-
-	return 0;
-}
-
-static int drbd_nl_new_minor(struct drbd_tconn *tconn,
-		      struct drbd_nl_cfg_req *nlp, struct drbd_nl_cfg_reply *reply)
-{
-	struct new_minor args;
-
-	args.vol_nr = 0;
-	args.minor = 0;
-
-	if (!new_minor_from_tags(nlp->tag_list, &args)) {
-		reply->ret_code = ERR_MANDATORY_TAG;
-		return 0;
-	}
-
-	reply->ret_code = conn_new_minor(tconn, args.minor, args.vol_nr);
-
+out_nolock:
+	drbd_adm_finish(info, retcode);
 	return 0;
 }
 
-static int drbd_nl_del_minor(struct drbd_conf *mdev, struct drbd_nl_cfg_req *nlp,
-			     struct drbd_nl_cfg_reply *reply)
+static enum drbd_ret_code
+drbd_check_conn_name(const char *name)
 {
-	if (mdev->state.disk == D_DISKLESS &&
-	    mdev->state.conn == C_STANDALONE &&
-	    mdev->state.role == R_SECONDARY) {
-		drbd_delete_device(mdev_to_minor(mdev));
-		reply->ret_code = NO_ERROR;
-	} else {
-		reply->ret_code = ERR_MINOR_CONFIGURED;
+	if (!name || !name[0]) {
+		drbd_msg_put_info("connection name missing");
+		return ERR_MANDATORY_TAG;
 	}
-	return 0;
-}
-
-static int drbd_nl_del_conn(struct drbd_tconn *tconn,
-			    struct drbd_nl_cfg_req *nlp, struct drbd_nl_cfg_reply *reply)
-{
-	if (conn_lowest_minor(tconn) < 0) {
-		drbd_free_tconn(tconn);
-		reply->ret_code = NO_ERROR;
-	} else {
-		reply->ret_code = ERR_CONN_IN_USE;
+	/* if we want to use these in sysfs/configfs/debugfs some day,
+	 * we must not allow slashes */
+	if (strchr(name, '/')) {
+		drbd_msg_put_info("invalid connection name");
+		return ERR_INVALID_REQUEST;
 	}
-
-	return 0;
+	return NO_ERROR;
 }
 
-enum cn_handler_type {
-	CHT_MINOR,
-	CHT_CONN,
-	CHT_CTOR,
-	/* CHT_RES, later */
-};
-struct cn_handler_struct {
-	enum cn_handler_type type;
-	union {
-		int (*minor_based)(struct drbd_conf *,
-				   struct drbd_nl_cfg_req *,
-				   struct drbd_nl_cfg_reply *);
-		int (*conn_based)(struct drbd_tconn *,
-				  struct drbd_nl_cfg_req *,
-				  struct drbd_nl_cfg_reply *);
-		int (*constructor)(struct drbd_nl_cfg_req *,
-				   struct drbd_nl_cfg_reply *);
-	};
-	int reply_body_size;
-};
-
-static struct cn_handler_struct cnd_table[] = {
-	[ P_primary ]		= { CHT_MINOR, { &drbd_nl_primary },	0 },
-	[ P_secondary ]		= { CHT_MINOR, { &drbd_nl_secondary },	0 },
-	[ P_disk_conf ]		= { CHT_MINOR, { &drbd_nl_disk_conf },	0 },
-	[ P_detach ]		= { CHT_MINOR, { &drbd_nl_detach },	0 },
-	[ P_net_conf ]		= { CHT_CONN,  { .conn_based = &drbd_nl_net_conf },	0 },
-	[ P_disconnect ]	= { CHT_CONN,  { .conn_based = &drbd_nl_disconnect },	0 },
-	[ P_resize ]		= { CHT_MINOR, { &drbd_nl_resize },	0 },
-	[ P_syncer_conf ]	= { CHT_MINOR, { &drbd_nl_syncer_conf },0 },
-	[ P_invalidate ]	= { CHT_MINOR, { &drbd_nl_invalidate },	0 },
-	[ P_invalidate_peer ]	= { CHT_MINOR, { &drbd_nl_invalidate_peer },0 },
-	[ P_pause_sync ]	= { CHT_MINOR, { &drbd_nl_pause_sync },	0 },
-	[ P_resume_sync ]	= { CHT_MINOR, { &drbd_nl_resume_sync },0 },
-	[ P_suspend_io ]	= { CHT_MINOR, { &drbd_nl_suspend_io },	0 },
-	[ P_resume_io ]		= { CHT_MINOR, { &drbd_nl_resume_io },	0 },
-	[ P_outdate ]		= { CHT_MINOR, { &drbd_nl_outdate },	0 },
-	[ P_get_config ]	= { CHT_MINOR, { &drbd_nl_get_config },
-				    sizeof(struct syncer_conf_tag_len_struct) +
-				    sizeof(struct disk_conf_tag_len_struct) +
-				    sizeof(struct net_conf_tag_len_struct) },
-	[ P_get_state ]		= { CHT_MINOR, { &drbd_nl_get_state },
-				    sizeof(struct get_state_tag_len_struct) +
-				    sizeof(struct sync_progress_tag_len_struct)	},
-	[ P_get_uuids ]		= { CHT_MINOR, { &drbd_nl_get_uuids },
-				    sizeof(struct get_uuids_tag_len_struct) },
-	[ P_get_timeout_flag ]	= { CHT_MINOR, { &drbd_nl_get_timeout_flag },
-				    sizeof(struct get_timeout_flag_tag_len_struct)},
-	[ P_start_ov ]		= { CHT_MINOR, { &drbd_nl_start_ov },	0 },
-	[ P_new_c_uuid ]	= { CHT_MINOR, { &drbd_nl_new_c_uuid },	0 },
-	[ P_new_connection ]	= { CHT_CTOR,  { .constructor = &drbd_nl_new_conn }, 0 },
-	[ P_new_minor ]		= { CHT_CONN,  { .conn_based = &drbd_nl_new_minor }, 0 },
-	[ P_del_minor ]		= { CHT_MINOR, { &drbd_nl_del_minor },	0 },
-	[ P_del_connection ]    = { CHT_CONN,  { .conn_based = &drbd_nl_del_conn }, 0 },
-};
-
-static void drbd_connector_callback(struct cn_msg *req, struct netlink_skb_parms *nsp)
+int drbd_adm_create_connection(struct sk_buff *skb, struct genl_info *info)
 {
-	struct drbd_nl_cfg_req *nlp = (struct drbd_nl_cfg_req *)req->data;
-	struct cn_handler_struct *cm;
-	struct cn_msg *cn_reply;
-	struct drbd_nl_cfg_reply *reply;
-	struct drbd_conf *mdev;
-	struct drbd_tconn *tconn;
-	int retcode, rr;
-	int reply_size = sizeof(struct cn_msg)
-		+ sizeof(struct drbd_nl_cfg_reply)
-		+ sizeof(short int);
-
-	if (!try_module_get(THIS_MODULE)) {
-		printk(KERN_ERR "drbd: try_module_get() failed!\n");
-		return;
-	}
-
-	if (!cap_raised(current_cap(), CAP_SYS_ADMIN)) {
-		retcode = ERR_PERM;
-		goto fail;
-	}
+	enum drbd_ret_code retcode;
 
-	if (nlp->packet_type >= P_nl_after_last_packet ||
-	    nlp->packet_type == P_return_code_only) {
-		retcode = ERR_PACKET_NR;
-		goto fail;
-	}
+	retcode = drbd_adm_prepare(skb, info, 0);
+	if (!adm_ctx.reply_skb)
+		return retcode;
+	if (retcode != NO_ERROR)
+		goto out;
 
-	cm = cnd_table + nlp->packet_type;
+	retcode = drbd_check_conn_name(adm_ctx.conn_name);
+	if (retcode != NO_ERROR)
+		goto out;
 
-	/* This may happen if packet number is 0: */
-	if (cm->minor_based == NULL) {
-		retcode = ERR_PACKET_NR;
-		goto fail;
+	if (adm_ctx.tconn) {
+		retcode = ERR_INVALID_REQUEST;
+		drbd_msg_put_info("connection exists");
+		goto out;
 	}
 
-	reply_size += cm->reply_body_size;
-
-	/* allocation not in the IO path, cqueue thread context */
-	cn_reply = kzalloc(reply_size, GFP_KERNEL);
-	if (!cn_reply) {
+	if (!drbd_new_tconn(adm_ctx.conn_name))
 		retcode = ERR_NOMEM;
-		goto fail;
-	}
-	reply = (struct drbd_nl_cfg_reply *) cn_reply->data;
-
-	reply->packet_type =
-		cm->reply_body_size ? nlp->packet_type : P_return_code_only;
-	reply->minor = nlp->drbd_minor;
-	reply->ret_code = NO_ERROR; /* Might by modified by cm->function. */
-	/* reply->tag_list; might be modified by cm->function. */
-
-	retcode = ERR_MINOR_INVALID;
-	rr = 0;
-	switch (cm->type) {
-	case CHT_MINOR:
-		mdev = minor_to_mdev(nlp->drbd_minor);
-		if (!mdev)
-			goto fail;
-		rr = cm->minor_based(mdev, nlp, reply);
-		break;
-	case CHT_CONN:
-		tconn = conn_by_name(nlp->obj_name);
-		if (!tconn) {
-			retcode = ERR_CONN_NOT_KNOWN;
-			goto fail;
-		}
-		rr = cm->conn_based(tconn, nlp, reply);
-		break;
-	case CHT_CTOR:
-		rr = cm->constructor(nlp, reply);
-		break;
-	/* case CHT_RES: */
-	}
-
-	cn_reply->id = req->id;
-	cn_reply->seq = req->seq;
-	cn_reply->ack = req->ack  + 1;
-	cn_reply->len = sizeof(struct drbd_nl_cfg_reply) + rr;
-	cn_reply->flags = 0;
-
-	rr = cn_netlink_send(cn_reply, CN_IDX_DRBD, GFP_KERNEL);
-	if (rr && rr != -ESRCH)
-		printk(KERN_INFO "drbd: cn_netlink_send()=%d\n", rr);
-
-	kfree(cn_reply);
-	module_put(THIS_MODULE);
-	return;
- fail:
-	drbd_nl_send_reply(req, retcode);
-	module_put(THIS_MODULE);
-}
-
-static atomic_t drbd_nl_seq = ATOMIC_INIT(2); /* two. */
-
-static unsigned short *
-__tl_add_blob(unsigned short *tl, enum drbd_tags tag, const void *data,
-	unsigned short len, int nul_terminated)
-{
-	unsigned short l = tag_descriptions[tag_number(tag)].max_len;
-	len = (len < l) ? len :  l;
-	put_unaligned(tag, tl++);
-	put_unaligned(len, tl++);
-	memcpy(tl, data, len);
-	tl = (unsigned short*)((char*)tl + len);
-	if (nul_terminated)
-		*((char*)tl - 1) = 0;
-	return tl;
-}
-
-static unsigned short *
-tl_add_blob(unsigned short *tl, enum drbd_tags tag, const void *data, int len)
-{
-	return __tl_add_blob(tl, tag, data, len, 0);
-}
-
-static unsigned short *
-tl_add_str(unsigned short *tl, enum drbd_tags tag, const char *str)
-{
-	return __tl_add_blob(tl, tag, str, strlen(str)+1, 0);
-}
-
-static unsigned short *
-tl_add_int(unsigned short *tl, enum drbd_tags tag, const void *val)
-{
-	put_unaligned(tag, tl++);
-	switch(tag_type(tag)) {
-	case TT_INTEGER:
-		put_unaligned(sizeof(int), tl++);
-		put_unaligned(*(int *)val, (int *)tl);
-		tl = (unsigned short*)((char*)tl+sizeof(int));
-		break;
-	case TT_INT64:
-		put_unaligned(sizeof(u64), tl++);
-		put_unaligned(*(u64 *)val, (u64 *)tl);
-		tl = (unsigned short*)((char*)tl+sizeof(u64));
-		break;
-	default:
-		/* someone did something stupid. */
-		;
-	}
-	return tl;
-}
-
-void drbd_bcast_state(struct drbd_conf *mdev, union drbd_state state)
-{
-	char buffer[sizeof(struct cn_msg)+
-		    sizeof(struct drbd_nl_cfg_reply)+
-		    sizeof(struct get_state_tag_len_struct)+
-		    sizeof(short int)];
-	struct cn_msg *cn_reply = (struct cn_msg *) buffer;
-	struct drbd_nl_cfg_reply *reply =
-		(struct drbd_nl_cfg_reply *)cn_reply->data;
-	unsigned short *tl = reply->tag_list;
-
-	/* dev_warn(DEV, "drbd_bcast_state() got called\n"); */
-
-	tl = get_state_to_tags((struct get_state *)&state, tl);
-
-	put_unaligned(TT_END, tl++); /* Close the tag list */
-
-	cn_reply->id.idx = CN_IDX_DRBD;
-	cn_reply->id.val = CN_VAL_DRBD;
-
-	cn_reply->seq = atomic_inc_return(&drbd_nl_seq);
-	cn_reply->ack = 0; /* not used here. */
-	cn_reply->len = sizeof(struct drbd_nl_cfg_reply) +
-		(int)((char *)tl - (char *)reply->tag_list);
-	cn_reply->flags = 0;
-
-	reply->packet_type = P_get_state;
-	reply->minor = mdev_to_minor(mdev);
-	reply->ret_code = NO_ERROR;
-
-	cn_netlink_send(cn_reply, CN_IDX_DRBD, GFP_NOIO);
-}
-
-void drbd_bcast_ev_helper(struct drbd_conf *mdev, char *helper_name)
-{
-	char buffer[sizeof(struct cn_msg)+
-		    sizeof(struct drbd_nl_cfg_reply)+
-		    sizeof(struct call_helper_tag_len_struct)+
-		    sizeof(short int)];
-	struct cn_msg *cn_reply = (struct cn_msg *) buffer;
-	struct drbd_nl_cfg_reply *reply =
-		(struct drbd_nl_cfg_reply *)cn_reply->data;
-	unsigned short *tl = reply->tag_list;
-
-	/* dev_warn(DEV, "drbd_bcast_state() got called\n"); */
-
-	tl = tl_add_str(tl, T_helper, helper_name);
-	put_unaligned(TT_END, tl++); /* Close the tag list */
-
-	cn_reply->id.idx = CN_IDX_DRBD;
-	cn_reply->id.val = CN_VAL_DRBD;
-
-	cn_reply->seq = atomic_inc_return(&drbd_nl_seq);
-	cn_reply->ack = 0; /* not used here. */
-	cn_reply->len = sizeof(struct drbd_nl_cfg_reply) +
-		(int)((char *)tl - (char *)reply->tag_list);
-	cn_reply->flags = 0;
-
-	reply->packet_type = P_call_helper;
-	reply->minor = mdev_to_minor(mdev);
-	reply->ret_code = NO_ERROR;
-
-	cn_netlink_send(cn_reply, CN_IDX_DRBD, GFP_NOIO);
+out:
+	drbd_adm_finish(info, retcode);
+	return 0;
 }
 
-void drbd_bcast_ee(struct drbd_conf *mdev, const char *reason, const int dgs,
-		   const char *seen_hash, const char *calc_hash,
-			   const struct drbd_peer_request *peer_req)
+int drbd_adm_add_minor(struct sk_buff *skb, struct genl_info *info)
 {
-	struct cn_msg *cn_reply;
-	struct drbd_nl_cfg_reply *reply;
-	unsigned short *tl;
-	struct page *page;
-	unsigned len;
+	struct drbd_genlmsghdr *dh = info->userhdr;
+	enum drbd_ret_code retcode;
 
-	if (!peer_req)
-		return;
-	if (!reason || !reason[0])
-		return;
+	retcode = drbd_adm_prepare(skb, info, DRBD_ADM_NEED_CONN);
+	if (!adm_ctx.reply_skb)
+		return retcode;
+	if (retcode != NO_ERROR)
+		goto out;
 
-	/* apparently we have to memcpy twice, first to prepare the data for the
-	 * struct cn_msg, then within cn_netlink_send from the cn_msg to the
-	 * netlink skb. */
-	/* receiver thread context, which is not in the writeout path (of this node),
-	 * but may be in the writeout path of the _other_ node.
-	 * GFP_NOIO to avoid potential "distributed deadlock". */
-	cn_reply = kzalloc(
-		sizeof(struct cn_msg)+
-		sizeof(struct drbd_nl_cfg_reply)+
-		sizeof(struct dump_ee_tag_len_struct)+
-		sizeof(short int),
-		GFP_NOIO);
-
-	if (!cn_reply) {
-		dev_err(DEV, "could not kmalloc buffer for drbd_bcast_ee, "
-			     "sector %llu, size %u\n",
-			(unsigned long long)peer_req->i.sector,
-			peer_req->i.size);
-		return;
+	/* FIXME drop minor_count parameter, limit to MINORMASK */
+	if (dh->minor >= minor_count) {
+		drbd_msg_put_info("requested minor out of range");
+		return ERR_INVALID_REQUEST;
 	}
-
-	reply = (struct drbd_nl_cfg_reply*)cn_reply->data;
-	tl = reply->tag_list;
-
-	tl = tl_add_str(tl, T_dump_ee_reason, reason);
-	tl = tl_add_blob(tl, T_seen_digest, seen_hash, dgs);
-	tl = tl_add_blob(tl, T_calc_digest, calc_hash, dgs);
-	tl = tl_add_int(tl, T_ee_sector, &peer_req->i.sector);
-	tl = tl_add_int(tl, T_ee_block_id, &peer_req->block_id);
-
-	/* dump the first 32k */
-	len = min_t(unsigned, peer_req->i.size, 32 << 10);
-	put_unaligned(T_ee_data, tl++);
-	put_unaligned(len, tl++);
-
-	page = peer_req->pages;
-	page_chain_for_each(page) {
-		void *d = kmap_atomic(page, KM_USER0);
-		unsigned l = min_t(unsigned, len, PAGE_SIZE);
-		memcpy(tl, d, l);
-		kunmap_atomic(d, KM_USER0);
-		tl = (unsigned short*)((char*)tl + l);
-		len -= l;
-		if (len == 0)
-			break;
+	/* FIXME we need a define here */
+	if (adm_ctx.volume >= 256) {
+		drbd_msg_put_info("requested volume id out of range");
+		return ERR_INVALID_REQUEST;
 	}
-	put_unaligned(TT_END, tl++); /* Close the tag list */
-
-	cn_reply->id.idx = CN_IDX_DRBD;
-	cn_reply->id.val = CN_VAL_DRBD;
-
-	cn_reply->seq = atomic_inc_return(&drbd_nl_seq);
-	cn_reply->ack = 0; // not used here.
-	cn_reply->len = sizeof(struct drbd_nl_cfg_reply) +
-		(int)((char*)tl - (char*)reply->tag_list);
-	cn_reply->flags = 0;
 
-	reply->packet_type = P_dump_ee;
-	reply->minor = mdev_to_minor(mdev);
-	reply->ret_code = NO_ERROR;
-
-	cn_netlink_send(cn_reply, CN_IDX_DRBD, GFP_NOIO);
-	kfree(cn_reply);
+	retcode = conn_new_minor(adm_ctx.tconn, dh->minor, adm_ctx.volume);
+out:
+	drbd_adm_finish(info, retcode);
+	return 0;
 }
 
-void drbd_bcast_sync_progress(struct drbd_conf *mdev)
+int drbd_adm_delete_minor(struct sk_buff *skb, struct genl_info *info)
 {
-	char buffer[sizeof(struct cn_msg)+
-		    sizeof(struct drbd_nl_cfg_reply)+
-		    sizeof(struct sync_progress_tag_len_struct)+
-		    sizeof(short int)];
-	struct cn_msg *cn_reply = (struct cn_msg *) buffer;
-	struct drbd_nl_cfg_reply *reply =
-		(struct drbd_nl_cfg_reply *)cn_reply->data;
-	unsigned short *tl = reply->tag_list;
-	unsigned long rs_left;
-	unsigned int res;
-
-	/* no local ref, no bitmap, no syncer progress, no broadcast. */
-	if (!get_ldev(mdev))
-		return;
-	drbd_get_syncer_progress(mdev, &rs_left, &res);
-	put_ldev(mdev);
-
-	tl = tl_add_int(tl, T_sync_progress, &res);
-	put_unaligned(TT_END, tl++); /* Close the tag list */
-
-	cn_reply->id.idx = CN_IDX_DRBD;
-	cn_reply->id.val = CN_VAL_DRBD;
-
-	cn_reply->seq = atomic_inc_return(&drbd_nl_seq);
-	cn_reply->ack = 0; /* not used here. */
-	cn_reply->len = sizeof(struct drbd_nl_cfg_reply) +
-		(int)((char *)tl - (char *)reply->tag_list);
-	cn_reply->flags = 0;
+	struct drbd_conf *mdev;
+	enum drbd_ret_code retcode;
 
-	reply->packet_type = P_sync_progress;
-	reply->minor = mdev_to_minor(mdev);
-	reply->ret_code = NO_ERROR;
+	retcode = drbd_adm_prepare(skb, info, DRBD_ADM_NEED_MINOR);
+	if (!adm_ctx.reply_skb)
+		return retcode;
+	if (retcode != NO_ERROR)
+		goto out;
 
-	cn_netlink_send(cn_reply, CN_IDX_DRBD, GFP_NOIO);
+	mdev = adm_ctx.mdev;
+	if (mdev->state.disk == D_DISKLESS &&
+	    mdev->state.conn == C_STANDALONE &&
+	    mdev->state.role == R_SECONDARY) {
+		drbd_delete_device(mdev_to_minor(mdev));
+		retcode = NO_ERROR;
+	} else
+		retcode = ERR_MINOR_CONFIGURED;
+out:
+	drbd_adm_finish(info, retcode);
+	return 0;
 }
 
-int __init drbd_nl_init(void)
+int drbd_adm_delete_connection(struct sk_buff *skb, struct genl_info *info)
 {
-	static struct cb_id cn_id_drbd;
-	int err, try=10;
-
-	cn_id_drbd.val = CN_VAL_DRBD;
-	do {
-		cn_id_drbd.idx = cn_idx;
-		err = cn_add_callback(&cn_id_drbd, "cn_drbd", &drbd_connector_callback);
-		if (!err)
-			break;
-		cn_idx = (cn_idx + CN_IDX_STEP);
-	} while (try--);
+	enum drbd_ret_code retcode;
 
-	if (err) {
-		printk(KERN_ERR "drbd: cn_drbd failed to register\n");
-		return err;
+	retcode = drbd_adm_prepare(skb, info, DRBD_ADM_NEED_CONN);
+	if (!adm_ctx.reply_skb)
+		return retcode;
+	if (retcode != NO_ERROR)
+		goto out;
+
+	if (conn_lowest_minor(adm_ctx.tconn) < 0) {
+		drbd_free_tconn(adm_ctx.tconn);
+		retcode = NO_ERROR;
+	} else {
+		retcode = ERR_CONN_IN_USE;
 	}
 
+out:
+	drbd_adm_finish(info, retcode);
 	return 0;
 }
 
-void drbd_nl_cleanup(void)
+void drbd_bcast_event(struct drbd_conf *mdev, const struct sib_info *sib)
 {
-	static struct cb_id cn_id_drbd;
-
-	cn_id_drbd.idx = cn_idx;
-	cn_id_drbd.val = CN_VAL_DRBD;
+	static atomic_t drbd_genl_seq = ATOMIC_INIT(2); /* two. */
+	struct sk_buff *msg;
+	struct drbd_genlmsghdr *d_out;
+	unsigned seq;
+	int err = -ENOMEM;
+
+	seq = atomic_inc_return(&drbd_genl_seq);
+	msg = genlmsg_new(NLMSG_GOODSIZE, GFP_NOIO);
+	if (!msg)
+		goto failed;
+
+	err = -EMSGSIZE;
+	d_out = genlmsg_put(msg, 0, seq, &drbd_genl_family, 0, DRBD_EVENT);
+	if (!d_out) /* cannot happen, but anyways. */
+		goto nla_put_failure;
+	d_out->minor = mdev_to_minor(mdev);
+	d_out->ret_code = 0;
+
+	pr_info("event: minor=%u, conn=%s\n", d_out->minor, mdev->tconn->name);
+
+	if (nla_put_status_info(msg, mdev, sib))
+		goto nla_put_failure;
+	genlmsg_end(msg, d_out);
+	err = drbd_genl_multicast_events(msg, 0);
+	/* msg has been consumed or freed in netlink_broadcast() */
+	if (err && err != -ESRCH)
+		goto failed;
 
-	cn_del_callback(&cn_id_drbd);
-}
+	return;
 
-void drbd_nl_send_reply(struct cn_msg *req, int ret_code)
-{
-	char buffer[sizeof(struct cn_msg)+sizeof(struct drbd_nl_cfg_reply)];
-	struct cn_msg *cn_reply = (struct cn_msg *) buffer;
-	struct drbd_nl_cfg_reply *reply =
-		(struct drbd_nl_cfg_reply *)cn_reply->data;
-	int rr;
-
-	memset(buffer, 0, sizeof(buffer));
-	cn_reply->id = req->id;
-
-	cn_reply->seq = req->seq;
-	cn_reply->ack = req->ack  + 1;
-	cn_reply->len = sizeof(struct drbd_nl_cfg_reply);
-	cn_reply->flags = 0;
-
-	reply->packet_type = P_return_code_only;
-	reply->minor = ((struct drbd_nl_cfg_req *)req->data)->drbd_minor;
-	reply->ret_code = ret_code;
-
-	rr = cn_netlink_send(cn_reply, CN_IDX_DRBD, GFP_NOIO);
-	if (rr && rr != -ESRCH)
-		printk(KERN_INFO "drbd: cn_netlink_send()=%d\n", rr);
+nla_put_failure:
+	nlmsg_free(msg);
+failed:
+	dev_err(DEV, "Error %d while broadcasting event. "
+			"Event seq:%u sib_reason:%u\n",
+			err, seq, sib->sib_reason);
 }
-
diff --git a/drivers/block/drbd/drbd_state.c b/drivers/block/drbd/drbd_state.c
index 100d48b..34be2ef 100644
--- a/drivers/block/drbd/drbd_state.c
+++ b/drivers/block/drbd/drbd_state.c
@@ -971,6 +971,11 @@ static void after_state_ch(struct drbd_conf *mdev, union drbd_state os,
 	enum drbd_fencing_p fp;
 	enum drbd_req_event what = NOTHING;
 	union drbd_state nsm = (union drbd_state){ .i = -1 };
+	struct sib_info sib;
+
+	sib.sib_reason = SIB_STATE_CHANGE;
+	sib.os = os;
+	sib.ns = ns;
 
 	if (os.conn != C_CONNECTED && ns.conn == C_CONNECTED) {
 		clear_bit(CRASHED_PRIMARY, &mdev->flags);
@@ -985,7 +990,7 @@ static void after_state_ch(struct drbd_conf *mdev, union drbd_state os,
 	}
 
 	/* Inform userspace about the change... */
-	drbd_bcast_state(mdev, ns);
+	drbd_bcast_event(mdev, &sib);
 
 	if (!(os.role == R_PRIMARY && os.disk < D_UP_TO_DATE && os.pdsk < D_UP_TO_DATE) &&
 	    (ns.role == R_PRIMARY && ns.disk < D_UP_TO_DATE && ns.pdsk < D_UP_TO_DATE))
diff --git a/include/linux/drbd.h b/include/linux/drbd.h
index e192167..d28fdd8 100644
--- a/include/linux/drbd.h
+++ b/include/linux/drbd.h
@@ -51,7 +51,6 @@
 
 #endif
 
-
 extern const char *drbd_buildtag(void);
 #define REL_VERSION "8.3.11"
 #define API_VERSION 88
@@ -159,6 +158,7 @@ enum drbd_ret_code {
 	ERR_CONN_IN_USE         = 159,
 	ERR_MINOR_CONFIGURED    = 160,
 	ERR_MINOR_EXISTS	= 161,
+	ERR_INVALID_REQUEST	= 162,
 
 	/* insert new ones above this line */
 	AFTER_LAST_ERR_CODE
@@ -349,37 +349,4 @@ enum drbd_timeout_flag {
 #define DRBD_MD_INDEX_FLEX_EXT -2
 #define DRBD_MD_INDEX_FLEX_INT -3
 
-/* Start of the new netlink/connector stuff */
-
-enum drbd_ncr_flags {
-	DRBD_NL_CREATE_DEVICE = 0x01,
-	DRBD_NL_SET_DEFAULTS =  0x02,
-};
-#define DRBD_NL_OBJ_NAME_LEN 32
-
-
-/* For searching a vacant cn_idx value */
-#define CN_IDX_STEP			6977
-
-struct drbd_nl_cfg_req {
-	int packet_type;
-	union {
-		struct {
-			unsigned int drbd_minor;
-			enum drbd_ncr_flags flags;
-		};
-		struct {
-			char obj_name[DRBD_NL_OBJ_NAME_LEN];
-		};
-	};
-	unsigned short tag_list[];
-};
-
-struct drbd_nl_cfg_reply {
-	int packet_type;
-	unsigned int minor;
-	int ret_code; /* enum ret_code or set_st_err_t */
-	unsigned short tag_list[]; /* only used with get_* calls */
-};
-
 #endif
-- 
1.7.4.1

