Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932400Ab1IAMxB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 08:53:01 -0400
Received: from mail09.linbit.com ([212.69.161.110]:55673 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932129Ab1IAMtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 08:49:11 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 08/18] drbd: prepare the transition from connector to genetlink
Date: Thu,  1 Sep 2011 14:48:55 +0200
Message-Id: <1314881345-6420-9-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314881345-6420-1-git-send-email-philipp.reisner@linbit.com>
References: <1314881345-6420-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Ellenberg <lars.ellenberg@linbit.com>

This adds the new API header and helper files.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 include/linux/drbd_genl.h         |  349 +++++++++++++++++++++++++++++++
 include/linux/drbd_genl_api.h     |   55 +++++
 include/linux/genl_magic_func.h   |  417 +++++++++++++++++++++++++++++++++++++
 include/linux/genl_magic_struct.h |  260 +++++++++++++++++++++++
 4 files changed, 1081 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/drbd_genl.h
 create mode 100644 include/linux/drbd_genl_api.h
 create mode 100644 include/linux/genl_magic_func.h
 create mode 100644 include/linux/genl_magic_struct.h

diff --git a/include/linux/drbd_genl.h b/include/linux/drbd_genl.h
new file mode 100644
index 0000000..84e1684
--- /dev/null
+++ b/include/linux/drbd_genl.h
@@ -0,0 +1,349 @@
+/*
+ * General overview:
+ * full generic netlink message:
+ * |nlmsghdr|genlmsghdr|<payload>
+ *
+ * payload:
+ * |optional fixed size family header|<sequence of netlink attributes>
+ *
+ * sequence of netlink attributes:
+ * I chose to have all "top level" attributes NLA_NESTED,
+ * corresponding to some real struct.
+ * So we have a sequence of |tla, len|<nested nla sequence>
+ *
+ * nested nla sequence:
+ * may be empty, or contain a sequence of netlink attributes
+ * representing the struct fields.
+ *
+ * The tag number of any field (regardless of containing struct)
+ * will be available as T_ ## field_name,
+ * so you cannot have the same field name in two differnt structs.
+ *
+ * The tag numbers themselves are per struct, though,
+ * so should always begin at 1 (not 0, that is the special "NLA_UNSPEC" type,
+ * which we won't use here).
+ * The tag numbers are used as index in the respective nla_policy array.
+ *
+ * GENL_struct(tag_name, tag_number, struct name, struct fields) - struct and policy
+ *	genl_magic_struct.h
+ *		generates the struct declaration,
+ *		generates an entry in the tla enum,
+ *	genl_magic_func.h
+ *		generates an entry in the static tla policy
+ *		with .type = NLA_NESTED
+ *		generates the static <struct_name>_nl_policy definition,
+ *		and static conversion functions
+ *
+ *	genl_magic_func.h
+ *
+ * GENL_mc_group(group)
+ *	genl_magic_struct.h
+ *		does nothing
+ *	genl_magic_func.h
+ *		defines and registers the mcast group,
+ *		and provides a send helper
+ *
+ * GENL_notification(op_name, op_num, mcast_group, tla list)
+ *	These are notifications to userspace.
+ *
+ *	genl_magic_struct.h
+ *		generates an entry in the genl_ops enum,
+ *	genl_magic_func.h
+ *		does nothing
+ *
+ *	mcast group: the name of the mcast group this notification should be
+ *	expected on
+ *	tla list: the list of expected top level attributes,
+ *	for documentation and sanity checking.
+ *
+ * GENL_op(op_name, op_num, flags and handler, tla list) - "genl operations"
+ *	These are requests from userspace.
+ *
+ *	_op and _notification share the same "number space",
+ *	op_nr will be assigned to "genlmsghdr->cmd"
+ *
+ *	genl_magic_struct.h
+ *		generates an entry in the genl_ops enum,
+ *	genl_magic_func.h
+ *		generates an entry in the static genl_ops array,
+ *		and static register/unregister functions to
+ *		genl_register_family_with_ops().
+ *
+ *	flags and handler:
+ *		GENL_op_init( .doit = x, .dumpit = y, .flags = something)
+ *		GENL_doit(x) => .dumpit = NULL, .flags = GENL_ADMIN_PERM
+ *	tla list: the list of expected top level attributes,
+ *	for documentation and sanity checking.
+ */
+
+/*
+ * STRUCTS
+ */
+
+/* this is sent kernel -> userland on various error conditions, and contains
+ * informational textual info, which is supposedly human readable.
+ * The computer relevant return code is in the drbd_genlmsghdr.
+ */
+GENL_struct(DRBD_NLA_CFG_REPLY, 1, drbd_cfg_reply,
+		/* "arbitrary" size strings, nla_policy.len = 0 */
+	__str_field(1, GENLA_F_MANDATORY,	info_text, 0)
+)
+
+/* Configuration requests typically need a context to operate on.
+ * Possible keys are device minor (fits in the drbd_genlmsghdr),
+ * the replication link (aka connection) name,
+ * and/or the replication group (aka resource) name,
+ * and the volume id within the resource. */
+GENL_struct(DRBD_NLA_CFG_CONTEXT, 2, drbd_cfg_context,
+		/* currently only 256 volumes per group,
+		 * but maybe we still change that */
+	__u32_field(1, GENLA_F_MANDATORY,	ctx_volume)
+	__str_field(2, GENLA_F_MANDATORY,	ctx_conn_name, 128)
+)
+
+GENL_struct(DRBD_NLA_DISK_CONF, 3, disk_conf,
+	__u64_field(1, GENLA_F_MANDATORY,	disk_size)
+	__str_field(2, GENLA_F_REQUIRED,	backing_dev,	128)
+	__str_field(3, GENLA_F_REQUIRED,	meta_dev,	128)
+	__u32_field(4, GENLA_F_REQUIRED,	meta_dev_idx)
+	__u32_field(5, GENLA_F_MANDATORY,	max_bio_bvecs)
+	__u32_field(6, GENLA_F_MANDATORY,	on_io_error)
+	__u32_field(7, GENLA_F_MANDATORY,	fencing)
+	__flg_field(8, GENLA_F_MANDATORY,	no_disk_barrier)
+	__flg_field(9, GENLA_F_MANDATORY,	no_disk_flush)
+	__flg_field(10, GENLA_F_MANDATORY,	no_disk_drain)
+	__flg_field(11, GENLA_F_MANDATORY,	no_md_flush)
+	__flg_field(12, GENLA_F_MANDATORY,	use_bmbv)
+)
+
+GENL_struct(DRBD_NLA_SYNCER_CONF, 4, syncer_conf,
+	__u32_field(1,	GENLA_F_MANDATORY,	rate)
+	__u32_field(2,	GENLA_F_MANDATORY,	after)
+	__u32_field(3,	GENLA_F_MANDATORY,	al_extents)
+	__str_field(4,	GENLA_F_MANDATORY,	cpu_mask,       32)
+	__str_field(5,	GENLA_F_MANDATORY,	verify_alg,     SHARED_SECRET_MAX)
+	__str_field(6,	GENLA_F_MANDATORY,	csums_alg,	SHARED_SECRET_MAX)
+	__flg_field(7,	GENLA_F_MANDATORY,	use_rle)
+	__u32_field(8,	GENLA_F_MANDATORY,	on_no_data)
+	__u32_field(9,	GENLA_F_MANDATORY,	c_plan_ahead)
+	__u32_field(10,	GENLA_F_MANDATORY,	c_delay_target)
+	__u32_field(11,	GENLA_F_MANDATORY,	c_fill_target)
+	__u32_field(12,	GENLA_F_MANDATORY,	c_max_rate)
+	__u32_field(13,	GENLA_F_MANDATORY,	c_min_rate)
+)
+
+GENL_struct(DRBD_NLA_NET_CONF, 5, net_conf,
+	__str_field(1,	GENLA_F_MANDATORY | GENLA_F_SENSITIVE,
+						shared_secret,	SHARED_SECRET_MAX)
+	__str_field(2,	GENLA_F_MANDATORY,	cram_hmac_alg,	SHARED_SECRET_MAX)
+	__str_field(3,	GENLA_F_MANDATORY,	integrity_alg,	SHARED_SECRET_MAX)
+	__str_field(4,	GENLA_F_REQUIRED,	my_addr,	128)
+	__str_field(5,	GENLA_F_REQUIRED,	peer_addr,	128)
+	__u32_field(6,	GENLA_F_REQUIRED,	wire_protocol)
+	__u32_field(7,	GENLA_F_MANDATORY,	try_connect_int)
+	__u32_field(8,	GENLA_F_MANDATORY,	timeout)
+	__u32_field(9,	GENLA_F_MANDATORY,	ping_int)
+	__u32_field(10,	GENLA_F_MANDATORY,	ping_timeo)
+	__u32_field(11,	GENLA_F_MANDATORY,	sndbuf_size)
+	__u32_field(12,	GENLA_F_MANDATORY,	rcvbuf_size)
+	__u32_field(13,	GENLA_F_MANDATORY,	ko_count)
+	__u32_field(14,	GENLA_F_MANDATORY,	max_buffers)
+	__u32_field(15,	GENLA_F_MANDATORY,	max_epoch_size)
+	__u32_field(16,	GENLA_F_MANDATORY,	unplug_watermark)
+	__u32_field(17,	GENLA_F_MANDATORY,	after_sb_0p)
+	__u32_field(18,	GENLA_F_MANDATORY,	after_sb_1p)
+	__u32_field(19,	GENLA_F_MANDATORY,	after_sb_2p)
+	__u32_field(20,	GENLA_F_MANDATORY,	rr_conflict)
+	__u32_field(21,	GENLA_F_MANDATORY,	on_congestion)
+	__u32_field(22,	GENLA_F_MANDATORY,	cong_fill)
+	__u32_field(23,	GENLA_F_MANDATORY,	cong_extents)
+	__flg_field(24, GENLA_F_MANDATORY,	two_primaries)
+	__flg_field(25, GENLA_F_MANDATORY,	want_lose)
+	__flg_field(26, GENLA_F_MANDATORY,	no_cork)
+	__flg_field(27, GENLA_F_MANDATORY,	always_asbp)
+	__flg_field(28, GENLA_F_MANDATORY,	dry_run)
+)
+
+GENL_struct(DRBD_NLA_SET_ROLE_PARMS, 6, set_role_parms,
+	__flg_field(1, GENLA_F_MANDATORY,	assume_uptodate)
+)
+
+GENL_struct(DRBD_NLA_RESIZE_PARMS, 7, resize_parms,
+	__u64_field(1, GENLA_F_MANDATORY,	resize_size)
+	__flg_field(2, GENLA_F_MANDATORY,	resize_force)
+	__flg_field(3, GENLA_F_MANDATORY,	no_resync)
+)
+
+GENL_struct(DRBD_NLA_STATE_INFO, 8, state_info,
+	/* the reason of the broadcast,
+	 * if this is an event triggered broadcast. */
+	__u32_field(1, GENLA_F_MANDATORY,	sib_reason)
+	__u32_field(2, GENLA_F_REQUIRED,	current_state)
+	__u64_field(3, GENLA_F_MANDATORY,	capacity)
+	__u64_field(4, GENLA_F_MANDATORY,	ed_uuid)
+
+	/* These are for broadcast from after state change work.
+	 * prev_state and new_state are from the moment the state change took
+	 * place, new_state is not neccessarily the same as current_state,
+	 * there may have been more state changes since.  Which will be
+	 * broadcasted soon, in their respective after state change work.  */
+	__u32_field(5, GENLA_F_MANDATORY,	prev_state)
+	__u32_field(6, GENLA_F_MANDATORY,	new_state)
+
+	/* if we have a local disk: */
+	__bin_field(7, GENLA_F_MANDATORY,	uuids, (UI_SIZE*sizeof(__u64)))
+	__u32_field(8, GENLA_F_MANDATORY,	disk_flags)
+	__u64_field(9, GENLA_F_MANDATORY,	bits_total)
+	__u64_field(10, GENLA_F_MANDATORY,	bits_oos)
+	/* and in case resync or online verify is active */
+	__u64_field(11, GENLA_F_MANDATORY,	bits_rs_total)
+	__u64_field(12, GENLA_F_MANDATORY,	bits_rs_failed)
+
+	/* for pre and post notifications of helper execution */
+	__str_field(13, GENLA_F_MANDATORY,	helper, 32)
+	__u32_field(14, GENLA_F_MANDATORY,	helper_exit_code)
+)
+
+GENL_struct(DRBD_NLA_START_OV_PARMS, 9, start_ov_parms,
+	__u64_field(1, GENLA_F_MANDATORY,	ov_start_sector)
+)
+
+GENL_struct(DRBD_NLA_NEW_C_UUID_PARMS, 10, new_c_uuid_parms,
+	__flg_field(1, GENLA_F_MANDATORY, clear_bm)
+)
+
+GENL_struct(DRBD_NLA_TIMEOUT_PARMS, 11, timeout_parms,
+	__u32_field(1,	GENLA_F_REQUIRED,	timeout_type)
+)
+
+GENL_struct(DRBD_NLA_DISCONNECT_PARMS, 12, disconnect_parms,
+	__flg_field(1, GENLA_F_MANDATORY,	force_disconnect)
+)
+
+/*
+ * Notifications and commands (genlmsghdr->cmd)
+ */
+GENL_mc_group(events)
+
+	/* kernel -> userspace announcement of changes */
+GENL_notification(
+	DRBD_EVENT, 1, events,
+	GENL_tla_expected(DRBD_NLA_CFG_CONTEXT, GENLA_F_REQUIRED)
+	GENL_tla_expected(DRBD_NLA_STATE_INFO, GENLA_F_REQUIRED)
+	GENL_tla_expected(DRBD_NLA_NET_CONF, GENLA_F_MANDATORY)
+	GENL_tla_expected(DRBD_NLA_DISK_CONF, GENLA_F_MANDATORY)
+	GENL_tla_expected(DRBD_NLA_SYNCER_CONF, GENLA_F_MANDATORY)
+)
+
+	/* query kernel for specific or all info */
+GENL_op(
+	DRBD_ADM_GET_STATUS, 2,
+	GENL_op_init(
+		.doit = drbd_adm_get_status,
+		.dumpit = drbd_adm_get_status_all,
+		/* anyone may ask for the status,
+		 * it is broadcasted anyways */
+	),
+	/* To select the object .doit.
+	 * Or a subset of objects in .dumpit. */
+	GENL_tla_expected(DRBD_NLA_CFG_CONTEXT, GENLA_F_MANDATORY)
+)
+
+#if 0
+	/* TO BE DONE */
+	/* create or destroy resources, aka replication groups */
+GENL_op(DRBD_ADM_CREATE_RESOURCE, 3, GENL_doit(drbd_adm_create_resource),
+	GENL_tla_expected(DRBD_NLA_CFG_CONTEXT, GENLA_F_REQUIRED))
+GENL_op(DRBD_ADM_DELETE_RESOURCE, 4, GENL_doit(drbd_adm_delete_resource),
+	GENL_tla_expected(DRBD_NLA_CFG_CONTEXT, GENLA_F_REQUIRED))
+#endif
+
+	/* add DRBD minor devices as volumes to resources */
+GENL_op(DRBD_ADM_ADD_MINOR, 5, GENL_doit(drbd_adm_add_minor),
+	GENL_tla_expected(DRBD_NLA_CFG_CONTEXT, GENLA_F_REQUIRED))
+GENL_op(DRBD_ADM_DEL_MINOR, 6, GENL_doit(drbd_adm_delete_minor),
+	GENL_tla_expected(DRBD_NLA_CFG_CONTEXT, GENLA_F_REQUIRED))
+
+	/* add or delete replication links to resources */
+GENL_op(DRBD_ADM_ADD_LINK, 7, GENL_doit(drbd_adm_create_connection),
+	GENL_tla_expected(DRBD_NLA_CFG_CONTEXT, GENLA_F_REQUIRED))
+GENL_op(DRBD_ADM_DEL_LINK, 8, GENL_doit(drbd_adm_delete_connection),
+	GENL_tla_expected(DRBD_NLA_CFG_CONTEXT, GENLA_F_REQUIRED))
+
+	/* operates on replication links */
+GENL_op(DRBD_ADM_SYNCER, 9,
+	GENL_doit(drbd_adm_syncer),
+	GENL_tla_expected(DRBD_NLA_CFG_CONTEXT, GENLA_F_REQUIRED)
+	GENL_tla_expected(DRBD_NLA_SYNCER_CONF, GENLA_F_MANDATORY)
+)
+
+GENL_op(
+	DRBD_ADM_CONNECT, 10,
+	GENL_doit(drbd_adm_connect),
+	GENL_tla_expected(DRBD_NLA_CFG_CONTEXT, GENLA_F_REQUIRED)
+	GENL_tla_expected(DRBD_NLA_NET_CONF, GENLA_F_REQUIRED)
+)
+
+GENL_op(DRBD_ADM_DISCONNECT, 11, GENL_doit(drbd_adm_disconnect),
+	GENL_tla_expected(DRBD_NLA_CFG_CONTEXT, GENLA_F_REQUIRED))
+
+	/* operates on minors */
+GENL_op(DRBD_ADM_ATTACH, 12,
+	GENL_doit(drbd_adm_attach),
+	GENL_tla_expected(DRBD_NLA_CFG_CONTEXT, GENLA_F_REQUIRED)
+	GENL_tla_expected(DRBD_NLA_DISK_CONF, GENLA_F_REQUIRED)
+)
+
+GENL_op(
+	DRBD_ADM_RESIZE, 13,
+	GENL_doit(drbd_adm_resize),
+	GENL_tla_expected(DRBD_NLA_CFG_CONTEXT, GENLA_F_REQUIRED)
+	GENL_tla_expected(DRBD_NLA_RESIZE_PARMS, GENLA_F_MANDATORY)
+)
+
+	/* operates on all volumes within a resource */
+GENL_op(
+	DRBD_ADM_PRIMARY, 14,
+	GENL_doit(drbd_adm_set_role),
+	GENL_tla_expected(DRBD_NLA_CFG_CONTEXT, GENLA_F_REQUIRED)
+	GENL_tla_expected(DRBD_NLA_SET_ROLE_PARMS, GENLA_F_REQUIRED)
+)
+
+GENL_op(
+	DRBD_ADM_SECONDARY, 15,
+	GENL_doit(drbd_adm_set_role),
+	GENL_tla_expected(DRBD_NLA_CFG_CONTEXT, GENLA_F_REQUIRED)
+	GENL_tla_expected(DRBD_NLA_SET_ROLE_PARMS, GENLA_F_REQUIRED)
+)
+
+GENL_op(
+	DRBD_ADM_NEW_C_UUID, 16,
+	GENL_doit(drbd_adm_new_c_uuid),
+	GENL_tla_expected(DRBD_NLA_CFG_CONTEXT, GENLA_F_REQUIRED)
+	GENL_tla_expected(DRBD_NLA_NEW_C_UUID_PARMS, GENLA_F_MANDATORY)
+)
+
+GENL_op(
+	DRBD_ADM_START_OV, 17,
+	GENL_doit(drbd_adm_start_ov),
+	GENL_tla_expected(DRBD_NLA_START_OV_PARMS, GENLA_F_MANDATORY)
+)
+
+GENL_op(DRBD_ADM_DETACH,	18, GENL_doit(drbd_adm_detach),
+	GENL_tla_expected(DRBD_NLA_CFG_CONTEXT, GENLA_F_REQUIRED))
+GENL_op(DRBD_ADM_INVALIDATE,	19, GENL_doit(drbd_adm_invalidate),
+	GENL_tla_expected(DRBD_NLA_CFG_CONTEXT, GENLA_F_REQUIRED))
+GENL_op(DRBD_ADM_INVAL_PEER,	20, GENL_doit(drbd_adm_invalidate_peer),
+	GENL_tla_expected(DRBD_NLA_CFG_CONTEXT, GENLA_F_REQUIRED))
+GENL_op(DRBD_ADM_PAUSE_SYNC,	21, GENL_doit(drbd_adm_pause_sync),
+	GENL_tla_expected(DRBD_NLA_CFG_CONTEXT, GENLA_F_REQUIRED))
+GENL_op(DRBD_ADM_RESUME_SYNC,	22, GENL_doit(drbd_adm_resume_sync),
+	GENL_tla_expected(DRBD_NLA_CFG_CONTEXT, GENLA_F_REQUIRED))
+GENL_op(DRBD_ADM_SUSPEND_IO,	23, GENL_doit(drbd_adm_suspend_io),
+	GENL_tla_expected(DRBD_NLA_CFG_CONTEXT, GENLA_F_REQUIRED))
+GENL_op(DRBD_ADM_RESUME_IO,	24, GENL_doit(drbd_adm_resume_io),
+	GENL_tla_expected(DRBD_NLA_CFG_CONTEXT, GENLA_F_REQUIRED))
+GENL_op(DRBD_ADM_OUTDATE,	25, GENL_doit(drbd_adm_outdate),
+	GENL_tla_expected(DRBD_NLA_CFG_CONTEXT, GENLA_F_REQUIRED))
+GENL_op(DRBD_ADM_GET_TIMEOUT_TYPE, 26, GENL_doit(drbd_adm_get_timeout_type),
+	GENL_tla_expected(DRBD_NLA_CFG_CONTEXT, GENLA_F_REQUIRED))
diff --git a/include/linux/drbd_genl_api.h b/include/linux/drbd_genl_api.h
new file mode 100644
index 0000000..9ef50d5
--- /dev/null
+++ b/include/linux/drbd_genl_api.h
@@ -0,0 +1,55 @@
+#ifndef DRBD_GENL_STRUCT_H
+#define DRBD_GENL_STRUCT_H
+
+/**
+ * struct drbd_genlmsghdr - DRBD specific header used in NETLINK_GENERIC requests
+ * @minor:
+ *     For admin requests (user -> kernel): which minor device to operate on.
+ *     For (unicast) replies or informational (broadcast) messages
+ *     (kernel -> user): which minor device the information is about.
+ *     If we do not operate on minors, but on connections or resources,
+ *     the minor value shall be (~0), and the attribute DRBD_NLA_CFG_CONTEXT
+ *     is used instead.
+ * @flags: possible operation modifiers (relevant only for user->kernel):
+ *     DRBD_GENL_F_SET_DEFAULTS
+ * @volume:
+ *     When creating a new minor (adding it to a resource), the resource needs
+ *     to know which volume number within the resource this is supposed to be.
+ *     The volume number corresponds to the same volume number on the remote side,
+ *     whereas the minor number on the remote side may be different
+ *     (union with flags).
+ * @ret_code: kernel->userland unicast cfg reply return code (union with flags);
+ */
+struct drbd_genlmsghdr {
+	__u32 minor;
+	union {
+	__u32 flags;
+	__s32 ret_code;
+	};
+};
+
+/* To be used in drbd_genlmsghdr.flags */
+enum {
+	DRBD_GENL_F_SET_DEFAULTS = 1,
+};
+
+enum drbd_state_info_bcast_reason {
+	SIB_GET_STATUS_REPLY = 1,
+	SIB_STATE_CHANGE = 2,
+	SIB_HELPER_PRE = 3,
+	SIB_HELPER_POST = 4,
+	SIB_SYNC_PROGRESS = 5,
+};
+
+/* hack around predefined gcc/cpp "linux=1",
+ * we cannot possibly include <1/drbd_genl.h> */
+#undef linux
+
+#include <linux/drbd.h>
+#define GENL_MAGIC_VERSION	API_VERSION
+#define GENL_MAGIC_FAMILY	drbd
+#define GENL_MAGIC_FAMILY_HDRSZ	sizeof(struct drbd_genlmsghdr)
+#define GENL_MAGIC_INCLUDE_FILE <linux/drbd_genl.h>
+#include <linux/genl_magic_struct.h>
+
+#endif
diff --git a/include/linux/genl_magic_func.h b/include/linux/genl_magic_func.h
new file mode 100644
index 0000000..8a86f65
--- /dev/null
+++ b/include/linux/genl_magic_func.h
@@ -0,0 +1,417 @@
+#ifndef GENL_MAGIC_FUNC_H
+#define GENL_MAGIC_FUNC_H
+
+#include <linux/genl_magic_struct.h>
+
+/*
+ * Extension of genl attribute validation policies			{{{1
+ *									{{{2
+ */
+
+/**
+ * nla_is_required - return true if this attribute is required
+ * @nla: netlink attribute
+ */
+static inline int nla_is_required(const struct nlattr *nla)
+{
+        return nla->nla_type & GENLA_F_REQUIRED;
+}
+
+/**
+ * nla_is_mandatory - return true if understanding this attribute is mandatory
+ * @nla: netlink attribute
+ * Note: REQUIRED attributes are implicitly MANDATORY as well
+ */
+static inline int nla_is_mandatory(const struct nlattr *nla)
+{
+        return nla->nla_type & (GENLA_F_MANDATORY | GENLA_F_REQUIRED);
+}
+
+/* Functionality to be integrated into nla_parse(), and validate_nla(),
+ * respectively.
+ *
+ * Enforcing the "mandatory" bit is done here,
+ * by rejecting unknown mandatory attributes.
+ *
+ * Part of enforcing the "required" flag would mean to embed it into
+ * nla_policy.type, and extending validate_nla(), which currently does
+ * BUG_ON(pt->type > NLA_TYPE_MAX); we have to work on existing kernels,
+ * so we cannot do that.  Thats why enforcing "required" is done in the
+ * generated assignment functions below. */
+static int nla_check_unknown(int maxtype, struct nlattr *head, int len)
+{
+	struct nlattr *nla;
+	int rem;
+        nla_for_each_attr(nla, head, len, rem) {
+		__u16 type = nla_type(nla);
+		if (type > maxtype && nla_is_mandatory(nla))
+			return -EOPNOTSUPP;
+	}
+	return 0;
+}
+
+/*
+ * Magic: declare tla policy						{{{1
+ * Magic: declare nested policies
+ *									{{{2
+ */
+#undef GENL_mc_group
+#define GENL_mc_group(group)
+
+#undef GENL_notification
+#define GENL_notification(op_name, op_num, mcast_group, tla_list)
+
+#undef GENL_op
+#define GENL_op(op_name, op_num, handler, tla_list)
+
+#undef GENL_struct
+#define GENL_struct(tag_name, tag_number, s_name, s_fields)		\
+	[tag_name] = { .type = NLA_NESTED },
+
+static struct nla_policy CONCAT_(GENL_MAGIC_FAMILY, _tla_nl_policy)[] = {
+#include GENL_MAGIC_INCLUDE_FILE
+};
+
+#undef GENL_struct
+#define GENL_struct(tag_name, tag_number, s_name, s_fields)		\
+static struct nla_policy s_name ## _nl_policy[] __read_mostly =		\
+{ s_fields };
+
+#undef __field
+#define __field(attr_nr, attr_flag, name, nla_type, _type, __get, __put) \
+	[__nla_type(attr_nr)] = { .type = nla_type },
+
+#undef __array
+#define __array(attr_nr, attr_flag, name, nla_type, _type, maxlen,	\
+		__get, __put)						\
+	[__nla_type(attr_nr)] = { .type = nla_type,			\
+		.len = maxlen - (nla_type == NLA_NUL_STRING) },
+
+#include GENL_MAGIC_INCLUDE_FILE
+
+#ifndef __KERNEL__
+#ifndef pr_info
+#define pr_info(args...)	fprintf(stderr, args);
+#endif
+#endif
+
+#if 1
+static void dprint_field(const char *dir, int nla_type,
+		const char *name, void *valp)
+{
+	__u64 val = valp ? *(__u32 *)valp : 1;
+	switch (nla_type) {
+	case NLA_U8:  val = (__u8)val;
+	case NLA_U16: val = (__u16)val;
+	case NLA_U32: val = (__u32)val;
+		pr_info("%s attr %s: %d 0x%08x\n", dir,
+			name, (int)val, (unsigned)val);
+		break;
+	case NLA_U64:
+		val = *(__u64*)valp;
+		pr_info("%s attr %s: %lld 0x%08llx\n", dir,
+			name, (long long)val, (unsigned long long)val);
+		break;
+	case NLA_FLAG:
+		if (val)
+			pr_info("%s attr %s: set\n", dir, name);
+		break;
+	}
+}
+
+static void dprint_array(const char *dir, int nla_type,
+		const char *name, const char *val, unsigned len)
+{
+	switch (nla_type) {
+	case NLA_NUL_STRING:
+		if (len && val[len-1] == '\0')
+			len--;
+		pr_info("%s attr %s: [len:%u] '%s'\n", dir, name, len, val);
+		break;
+	default:
+		/* we can always show 4 byte,
+		 * thats what nlattr are aligned to. */
+		pr_info("%s attr %s: [len:%u] %02x%02x%02x%02x ...\n",
+			dir, name, len, val[0], val[1], val[2], val[3]);
+	}
+}
+
+#define DPRINT_TLA(a, op, b) pr_info("%s %s %s\n", a, op, b);
+
+/* Name is a member field name of the struct s.
+ * If s is NULL (only parsing, no copy requested in *_from_attrs()),
+ * nla is supposed to point to the attribute containing the information
+ * corresponding to that struct member. */
+#define DPRINT_FIELD(dir, nla_type, name, s, nla)			\
+	do {								\
+		if (s)							\
+			dprint_field(dir, nla_type, #name, &s->name);	\
+		else if (nla)						\
+			dprint_field(dir, nla_type, #name,		\
+				(nla_type == NLA_FLAG) ? NULL		\
+						: nla_data(nla));	\
+	} while (0)
+
+#define	DPRINT_ARRAY(dir, nla_type, name, s, nla)			\
+	do {								\
+		if (s)							\
+			dprint_array(dir, nla_type, #name,		\
+					s->name, s->name ## _len);	\
+		else if (nla)						\
+			dprint_array(dir, nla_type, #name,		\
+					nla_data(nla), nla_len(nla));	\
+	} while (0)
+#else
+#define DPRINT_TLA(a, op, b) do {} while (0)
+#define DPRINT_FIELD(dir, nla_type, name, s, nla) do {} while (0)
+#define	DPRINT_ARRAY(dir, nla_type, name, s, nla) do {} while (0)
+#endif
+
+/*
+ * Magic: provide conversion functions					{{{1
+ * populate struct from attribute table:
+ *									{{{2
+ */
+
+/* processing of generic netlink messages is serialized.
+ * use one static buffer for parsing of nested attributes */
+static struct nlattr *nested_attr_tb[128];
+
+#ifndef BUILD_BUG_ON
+/* Force a compilation error if condition is true */
+#define BUILD_BUG_ON(condition) ((void)BUILD_BUG_ON_ZERO(condition))
+/* Force a compilation error if condition is true, but also produce a
+   result (of value 0 and type size_t), so the expression can be used
+   e.g. in a structure initializer (or where-ever else comma expressions
+   aren't permitted). */
+#define BUILD_BUG_ON_ZERO(e) (sizeof(struct { int:-!!(e); }))
+#define BUILD_BUG_ON_NULL(e) ((void *)sizeof(struct { int:-!!(e); }))
+#endif
+
+#undef GENL_struct
+#define GENL_struct(tag_name, tag_number, s_name, s_fields)		\
+	/* static, potentially unused */				\
+int s_name ## _from_attrs(struct s_name *s, struct nlattr *tb[])	\
+{									\
+	const int maxtype = ARRAY_SIZE(s_name ## _nl_policy)-1;		\
+	struct nlattr *tla = tb[tag_number];				\
+	struct nlattr **ntb = nested_attr_tb;				\
+	struct nlattr *nla;						\
+	int err;							\
+	BUILD_BUG_ON(ARRAY_SIZE(s_name ## _nl_policy) > ARRAY_SIZE(nested_attr_tb));	\
+	if (!tla)							\
+		return -ENOMSG;						\
+	DPRINT_TLA(#s_name, "<=-", #tag_name);				\
+	err = nla_parse_nested(ntb, maxtype, tla, s_name ## _nl_policy); \
+	if (err)							\
+		return err;						\
+	err = nla_check_unknown(maxtype, nla_data(tla), nla_len(tla));	\
+	if (err)							\
+	      return err;						\
+									\
+	s_fields							\
+	return 0;							\
+}
+
+#undef __field
+#define __field(attr_nr, attr_flag, name, nla_type, type, __get, __put)	\
+		nla = ntb[__nla_type(attr_nr)];				\
+		if (nla) {						\
+			if (s)						\
+				s->name = __get(nla);			\
+			DPRINT_FIELD("<<", nla_type, name, s, nla);	\
+		} else if ((attr_flag) & GENLA_F_REQUIRED) {		\
+			pr_info("<< missing attr: %s\n", #name);	\
+			return -ENOMSG;					\
+		}
+
+/* validate_nla() already checked nla_len <= maxlen appropriately. */
+#undef __array
+#define __array(attr_nr, attr_flag, name, nla_type, type, maxlen, __get, __put) \
+		nla = ntb[__nla_type(attr_nr)];				\
+		if (nla) {						\
+			if (s)						\
+				s->name ## _len =			\
+					__get(s->name, nla, maxlen);	\
+			DPRINT_ARRAY("<<", nla_type, name, s, nla);	\
+		} else if ((attr_flag) & GENLA_F_REQUIRED) {		\
+			pr_info("<< missing attr: %s\n", #name);	\
+			return -ENOMSG;					\
+		}							\
+
+#include GENL_MAGIC_INCLUDE_FILE
+
+#undef GENL_struct
+#define GENL_struct(tag_name, tag_number, s_name, s_fields)
+
+/*
+ * Magic: define op number to op name mapping				{{{1
+ *									{{{2
+ */
+const char *CONCAT_(GENL_MAGIC_FAMILY, _genl_cmd_to_str)(__u8 cmd)
+{
+	switch (cmd) {
+#undef GENL_op
+#define GENL_op(op_name, op_num, handler, tla_list)		\
+	case op_num: return #op_name;
+#include GENL_MAGIC_INCLUDE_FILE
+	default:
+		     return "unknown";
+	}
+}
+
+#ifdef __KERNEL__
+#include <linux/stringify.h>
+/*
+ * Magic: define genl_ops						{{{1
+ *									{{{2
+ */
+
+#undef GENL_op
+#define GENL_op(op_name, op_num, handler, tla_list)		\
+{								\
+	handler							\
+	.cmd = op_name,						\
+	.policy	= CONCAT_(GENL_MAGIC_FAMILY, _tla_nl_policy),	\
+},
+
+#define ZZZ_genl_ops		CONCAT_(GENL_MAGIC_FAMILY, _genl_ops)
+static struct genl_ops ZZZ_genl_ops[] __read_mostly = {
+#include GENL_MAGIC_INCLUDE_FILE
+};
+
+#undef GENL_op
+#define GENL_op(op_name, op_num, handler, tla_list)
+
+/*
+ * Define the genl_family, multicast groups,				{{{1
+ * and provide register/unregister functions.
+ *									{{{2
+ */
+#define ZZZ_genl_family		CONCAT_(GENL_MAGIC_FAMILY, _genl_family)
+static struct genl_family ZZZ_genl_family __read_mostly = {
+	.id = GENL_ID_GENERATE,
+	.name = __stringify(GENL_MAGIC_FAMILY),
+	.version = GENL_MAGIC_VERSION,
+#ifdef GENL_MAGIC_FAMILY_HDRSZ
+	.hdrsize = NLA_ALIGN(GENL_MAGIC_FAMILY_HDRSZ),
+#endif
+	.maxattr = ARRAY_SIZE(drbd_tla_nl_policy)-1,
+};
+
+/*
+ * Magic: define multicast groups
+ * Magic: define multicast group registration helper
+ */
+#undef GENL_mc_group
+#define GENL_mc_group(group)						\
+static struct genl_multicast_group					\
+CONCAT_(GENL_MAGIC_FAMILY, _mcg_ ## group) __read_mostly = {		\
+	.name = #group,							\
+};									\
+static int CONCAT_(GENL_MAGIC_FAMILY, _genl_multicast_ ## group)(	\
+	struct sk_buff *skb, gfp_t flags)				\
+{									\
+	unsigned int group_id =						\
+		CONCAT_(GENL_MAGIC_FAMILY, _mcg_ ## group).id;	\
+	if (!group_id)							\
+		return -EINVAL;						\
+	return genlmsg_multicast(skb, 0, group_id, flags);		\
+}
+
+#include GENL_MAGIC_INCLUDE_FILE
+
+int CONCAT_(GENL_MAGIC_FAMILY, _genl_register)(void)
+{
+	int err = genl_register_family_with_ops(&ZZZ_genl_family,
+		ZZZ_genl_ops, ARRAY_SIZE(ZZZ_genl_ops));
+	if (err)
+		return err;
+#undef GENL_mc_group
+#define GENL_mc_group(group)						\
+	err = genl_register_mc_group(&ZZZ_genl_family,			\
+		&CONCAT_(GENL_MAGIC_FAMILY, _mcg_ ## group));		\
+	if (err)							\
+		goto fail;						\
+	else								\
+		pr_info("%s: mcg %s: %u\n", #group,			\
+			__stringify(GENL_MAGIC_FAMILY),			\
+			CONCAT_(GENL_MAGIC_FAMILY, _mcg_ ## group).id);
+
+#include GENL_MAGIC_INCLUDE_FILE
+
+#undef GENL_mc_group
+#define GENL_mc_group(group)
+	return 0;
+fail:
+	genl_unregister_family(&ZZZ_genl_family);
+	return err;
+}
+
+void CONCAT_(GENL_MAGIC_FAMILY, _genl_unregister)(void)
+{
+	genl_unregister_family(&ZZZ_genl_family);
+}
+
+/*
+ * Magic: provide conversion functions					{{{1
+ * populate skb from struct.
+ *									{{{2
+ */
+
+#undef GENL_op
+#define GENL_op(op_name, op_num, handler, tla_list)
+
+#undef GENL_struct
+#define GENL_struct(tag_name, tag_number, s_name, s_fields)		\
+static int s_name ## _to_skb(struct sk_buff *skb, struct s_name *s,	\
+		const bool exclude_sensitive)				\
+{									\
+	struct nlattr *tla = nla_nest_start(skb, tag_number);		\
+	if (!tla)							\
+		goto nla_put_failure;					\
+	DPRINT_TLA(#s_name, "-=>", #tag_name);				\
+	s_fields							\
+	nla_nest_end(skb, tla);						\
+	return 0;							\
+									\
+nla_put_failure:							\
+	if (tla)							\
+		nla_nest_cancel(skb, tla);				\
+        return -EMSGSIZE;						\
+}									\
+static inline int s_name ## _to_priv_skb(struct sk_buff *skb,		\
+		struct s_name *s)					\
+{									\
+	return s_name ## _to_skb(skb, s, 0);				\
+}									\
+static inline int s_name ## _to_unpriv_skb(struct sk_buff *skb,		\
+		struct s_name *s)					\
+{									\
+	return s_name ## _to_skb(skb, s, 1);				\
+}
+
+
+#undef __field
+#define __field(attr_nr, attr_flag, name, nla_type, type, __get, __put)	\
+	if (!exclude_sensitive || !((attr_flag) & GENLA_F_SENSITIVE)) {	\
+		DPRINT_FIELD(">>", nla_type, name, s, NULL);		\
+		__put(skb, attr_nr, s->name);				\
+	}
+
+#undef __array
+#define __array(attr_nr, attr_flag, name, nla_type, type, maxlen, __get, __put) \
+	if (!exclude_sensitive || !((attr_flag) & GENLA_F_SENSITIVE)) {	\
+		DPRINT_ARRAY(">>",nla_type, name, s, NULL);		\
+		__put(skb, attr_nr, min_t(int, maxlen,			\
+			s->name ## _len + (nla_type == NLA_NUL_STRING)),\
+						s->name);		\
+	}
+
+#include GENL_MAGIC_INCLUDE_FILE
+
+#endif /* __KERNEL__ */
+
+/* }}}1 */
+#endif /* GENL_MAGIC_FUNC_H */
+/* vim: set foldmethod=marker foldlevel=1 nofoldenable : */
diff --git a/include/linux/genl_magic_struct.h b/include/linux/genl_magic_struct.h
new file mode 100644
index 0000000..745ebfd
--- /dev/null
+++ b/include/linux/genl_magic_struct.h
@@ -0,0 +1,260 @@
+#ifndef GENL_MAGIC_STRUCT_H
+#define GENL_MAGIC_STRUCT_H
+
+#ifndef GENL_MAGIC_FAMILY
+# error "you need to define GENL_MAGIC_FAMILY before inclusion"
+#endif
+
+#ifndef GENL_MAGIC_VERSION
+# error "you need to define GENL_MAGIC_VERSION before inclusion"
+#endif
+
+#ifndef GENL_MAGIC_INCLUDE_FILE
+# error "you need to define GENL_MAGIC_INCLUDE_FILE before inclusion"
+#endif
+
+#include <linux/genetlink.h>
+#include <linux/types.h>
+
+#define CONCAT__(a,b)	a ## b
+#define CONCAT_(a,b)	CONCAT__(a,b)
+
+extern int CONCAT_(GENL_MAGIC_FAMILY, _genl_register)(void);
+extern void CONCAT_(GENL_MAGIC_FAMILY, _genl_unregister)(void);
+
+/*
+ * Extension of genl attribute validation policies			{{{2
+ */
+
+/**
+ * GENLA_F_FLAGS - policy type flags to ease compatible ABI evolvement
+ *
+ * @GENLA_F_REQUIRED: attribute has to be present, or message is considered invalid.
+ * Adding new REQUIRED attributes breaks ABI compatibility, so don't do that.
+ *
+ * @GENLA_F_MANDATORY: if present, receiver _must_ understand it.
+ * Without this, unknown attributes (> maxtype) are _silently_ ignored
+ * by validate_nla().
+ *
+ * To be used for API extensions, so older kernel can reject requests for not
+ * yet implemented features, if newer userland tries to use them even though
+ * the genl_family version clearly indicates they are not available.
+ *
+ * @GENLA_F_MAY_IGNORE: To clearly document the fact, for good measure.
+ * To be used for API extensions for things that have sane defaults,
+ * so newer userland can still talk to older kernel, knowing it will
+ * silently ignore these attributes if not yet known.
+ *
+ * NOTE: These flags overload
+ *   NLA_F_NESTED		(1 << 15)
+ *   NLA_F_NET_BYTEORDER	(1 << 14)
+ * from linux/netlink.h, which are not useful for validate_nla():
+ * NET_BYTEORDER is not used anywhere, and NESTED would be specified by setting
+ * .type = NLA_NESTED in the appropriate policy.
+ *
+ * See also: nla_type()
+ */
+enum {
+	GENLA_F_MAY_IGNORE	= 0,
+	GENLA_F_MANDATORY	= 1 << 14,
+	GENLA_F_REQUIRED	= 1 << 15,
+
+	/* This will not be present in the __u16 .nla_type, but can be
+	 * triggered on in <struct>_to_skb, to exclude "sensitive"
+	 * information from broadcasts, or on unpriviledged get requests.
+	 * This is useful because genetlink multicast groups can be listened in
+	 * on by anyone.  */
+	GENLA_F_SENSITIVE	= 1 << 16,
+};
+
+#define __nla_type(x)	((__u16)((__u16)(x) & (__u16)NLA_TYPE_MASK))
+
+/*									}}}1
+ * MAGIC
+ * multi-include macro expansion magic starts here
+ */
+
+/* MAGIC helpers							{{{2 */
+
+/* possible field types */
+#define __flg_field(attr_nr, attr_flag, name) \
+	__field(attr_nr, attr_flag, name, NLA_FLAG, char, \
+			nla_get_flag, __nla_put_flag)
+#define __u8_field(attr_nr, attr_flag, name)	\
+	__field(attr_nr, attr_flag, name, NLA_U8, unsigned char, \
+			nla_get_u8, NLA_PUT_U8)
+#define __u16_field(attr_nr, attr_flag, name)	\
+	__field(attr_nr, attr_flag, name, NLA_U16, __u16, \
+			nla_get_u16, NLA_PUT_U16)
+#define __u32_field(attr_nr, attr_flag, name)	\
+	__field(attr_nr, attr_flag, name, NLA_U32, __u32, \
+			nla_get_u32, NLA_PUT_U32)
+#define __u64_field(attr_nr, attr_flag, name)	\
+	__field(attr_nr, attr_flag, name, NLA_U64, __u64, \
+			nla_get_u64, NLA_PUT_U64)
+#define __str_field(attr_nr, attr_flag, name, maxlen) \
+	__array(attr_nr, attr_flag, name, NLA_NUL_STRING, char, maxlen, \
+			nla_strlcpy, NLA_PUT)
+#define __bin_field(attr_nr, attr_flag, name, maxlen) \
+	__array(attr_nr, attr_flag, name, NLA_BINARY, char, maxlen, \
+			nla_memcpy, NLA_PUT)
+
+#define __nla_put_flag(skb, attrtype, value)		\
+	do {						\
+		if (value)				\
+			NLA_PUT_FLAG(skb, attrtype);	\
+	} while (0)
+
+#define GENL_op_init(args...)	args
+#define GENL_doit(handler)		\
+	.doit = handler,		\
+	.flags = GENL_ADMIN_PERM,
+#define GENL_dumpit(handler)		\
+	.dumpit = handler,		\
+	.flags = GENL_ADMIN_PERM,
+
+/*									}}}1
+ * Magic: define the enum symbols for genl_ops
+ * Magic: define the enum symbols for top level attributes
+ * Magic: define the enum symbols for nested attributes
+ *									{{{2
+ */
+
+#undef GENL_struct
+#define GENL_struct(tag_name, tag_number, s_name, s_fields)
+
+#undef GENL_mc_group
+#define GENL_mc_group(group)
+
+#undef GENL_notification
+#define GENL_notification(op_name, op_num, mcast_group, tla_list)	\
+	op_name = op_num,
+
+#undef GENL_op
+#define GENL_op(op_name, op_num, handler, tla_list)			\
+	op_name = op_num,
+
+enum {
+#include GENL_MAGIC_INCLUDE_FILE
+};
+
+#undef GENL_notification
+#define GENL_notification(op_name, op_num, mcast_group, tla_list)
+
+#undef GENL_op
+#define GENL_op(op_name, op_num, handler, attr_list)
+
+#undef GENL_struct
+#define GENL_struct(tag_name, tag_number, s_name, s_fields) \
+		tag_name = tag_number,
+
+enum {
+#include GENL_MAGIC_INCLUDE_FILE
+};
+
+#undef GENL_struct
+#define GENL_struct(tag_name, tag_number, s_name, s_fields)	\
+enum {								\
+	s_fields						\
+};
+
+#undef __field
+#define __field(attr_nr, attr_flag, name, nla_type, type, __get, __put)	\
+	T_ ## name = (__u16)(attr_nr | attr_flag),
+
+#undef __array
+#define __array(attr_nr, attr_flag, name, nla_type, type, maxlen, __get, __put) \
+	T_ ## name = (__u16)(attr_nr | attr_flag),
+
+#include GENL_MAGIC_INCLUDE_FILE
+
+/*									}}}1
+ * Magic: compile time assert unique numbers for operations
+ * Magic: -"- unique numbers for top level attributes
+ * Magic: -"- unique numbers for nested attributes
+ *									{{{2
+ */
+
+#undef GENL_struct
+#define GENL_struct(tag_name, tag_number, s_name, s_fields)
+
+#undef GENL_op
+#define GENL_op(op_name, op_num, handler, attr_list)	\
+	case op_name:
+
+#undef GENL_notification
+#define GENL_notification(op_name, op_num, mcast_group, tla_list)	\
+	case op_name:
+
+static inline void ct_assert_unique_operations(void)
+{
+	switch (0) {
+#include GENL_MAGIC_INCLUDE_FILE
+		;
+	}
+}
+
+#undef GENL_op
+#define GENL_op(op_name, op_num, handler, attr_list)
+
+#undef GENL_notification
+#define GENL_notification(op_name, op_num, mcast_group, tla_list)
+
+#undef GENL_struct
+#define GENL_struct(tag_name, tag_number, s_name, s_fields)		\
+		case tag_number:
+
+static inline void ct_assert_unique_top_level_attributes(void)
+{
+	switch (0) {
+#include GENL_MAGIC_INCLUDE_FILE
+		;
+	}
+}
+
+#undef GENL_struct
+#define GENL_struct(tag_name, tag_number, s_name, s_fields)		\
+static inline void ct_assert_unique_ ## s_name ## _attributes(void)	\
+{									\
+	switch (0) {							\
+		s_fields						\
+			;						\
+	}								\
+}
+
+#undef __field
+#define __field(attr_nr, attr_flag, name, nla_type, type, __get, __put)	\
+	case attr_nr:
+
+#undef __array
+#define __array(attr_nr, attr_flag, name, nla_type, type, maxlen, __get, __put) \
+	case attr_nr:
+
+#include GENL_MAGIC_INCLUDE_FILE
+
+/*									}}}1
+ * Magic: declare structs
+ * struct <name> {
+ *	fields
+ * };
+ *									{{{2
+ */
+
+#undef GENL_struct
+#define GENL_struct(tag_name, tag_number, s_name, s_fields)		\
+struct s_name { s_fields };
+
+#undef __field
+#define __field(attr_nr, attr_flag, name, nla_type, type, __get, __put) \
+	type name;
+
+#undef __array
+#define __array(attr_nr, attr_flag, name, nla_type, type, maxlen, __get, __put) \
+	type name[maxlen];	\
+	__u32 name ## _len;
+
+#include GENL_MAGIC_INCLUDE_FILE
+
+/* }}}1 */
+#endif /* GENL_MAGIC_STRUCT_H */
+/* vim: set foldmethod=marker nofoldenable : */
-- 
1.7.4.1

