Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951Ab1JJLz4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 07:55:56 -0400
Received: from mail09.linbit.com ([212.69.161.110]:45071 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753860Ab1JJLzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 07:55:15 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 10/13] drbd: Make drbd's use of netlink attribute flags less confusing
Date: Mon, 10 Oct 2011 13:55:03 +0200
Message-Id: <1318247706-7732-11-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1318247706-7732-1-git-send-email-philipp.reisner@linbit.com>
References: <1318247706-7732-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

Make it more clear in the flag names which flags are internal to drbd, and
which are not.

The check for mandatory attributes is the only extension visible at the netlink
layer.  Attributes with this flag set would look like unknown attributes to
some kernel versions.  The netlink layer would ignore them and also skip
consistency checks on the attribute type and legth.  To avoid this, we check
for mandatory attributes first, remove the mandatory flag, and then process the
attributes normally.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 include/linux/drbd_genl.h         |  244 ++++++++++++++++++------------------
 include/linux/genl_magic_func.h   |  107 +++++++---------
 include/linux/genl_magic_struct.h |   64 ++++------
 3 files changed, 193 insertions(+), 222 deletions(-)

diff --git a/include/linux/drbd_genl.h b/include/linux/drbd_genl.h
index 4b446af..f3c9a5b 100644
--- a/include/linux/drbd_genl.h
+++ b/include/linux/drbd_genl.h
@@ -86,7 +86,7 @@
  */
 GENL_struct(DRBD_NLA_CFG_REPLY, 1, drbd_cfg_reply,
 		/* "arbitrary" size strings, nla_policy.len = 0 */
-	__str_field(1, GENLA_F_MANDATORY,	info_text, 0)
+	__str_field(1, DRBD_GENLA_F_MANDATORY,	info_text, 0)
 )
 
 /* Configuration requests typically need a context to operate on.
@@ -97,133 +97,133 @@ GENL_struct(DRBD_NLA_CFG_REPLY, 1, drbd_cfg_reply,
 GENL_struct(DRBD_NLA_CFG_CONTEXT, 2, drbd_cfg_context,
 		/* currently only 256 volumes per group,
 		 * but maybe we still change that */
-	__u32_field(1, GENLA_F_MANDATORY,	ctx_volume)
-	__str_field(2, GENLA_F_MANDATORY,	ctx_conn_name, 128)
+	__u32_field(1, DRBD_GENLA_F_MANDATORY,	ctx_volume)
+	__str_field(2, DRBD_GENLA_F_MANDATORY,	ctx_conn_name, 128)
 )
 
 GENL_struct(DRBD_NLA_DISK_CONF, 3, disk_conf,
-	__str_field(1, GENLA_F_REQUIRED | GENLA_F_INVARIANT,	backing_dev,	128)
-	__str_field(2, GENLA_F_REQUIRED | GENLA_F_INVARIANT,	meta_dev,	128)
-	__s32_field(3, GENLA_F_REQUIRED | GENLA_F_INVARIANT,	meta_dev_idx)
+	__str_field(1, DRBD_F_REQUIRED | DRBD_F_INVARIANT,	backing_dev,	128)
+	__str_field(2, DRBD_F_REQUIRED | DRBD_F_INVARIANT,	meta_dev,	128)
+	__s32_field(3, DRBD_F_REQUIRED | DRBD_F_INVARIANT,	meta_dev_idx)
 
 	/* use the resize command to try and change the disk_size */
-	__u64_field(4, GENLA_F_MANDATORY | GENLA_F_INVARIANT,	disk_size)
+	__u64_field(4, DRBD_GENLA_F_MANDATORY | DRBD_F_INVARIANT,	disk_size)
 	/* we could change the max_bio_bvecs,
 	 * but it won't propagate through the stack */
-	__u32_field(5, GENLA_F_MANDATORY | GENLA_F_INVARIANT,	max_bio_bvecs)
-
-	__u32_field_def(6, GENLA_F_MANDATORY,	on_io_error, DRBD_ON_IO_ERROR_DEF)
-	__u32_field_def(7, GENLA_F_MANDATORY,	fencing, DRBD_FENCING_DEF)
-
-	__u32_field_def(8,	GENLA_F_MANDATORY,	resync_rate, DRBD_RESYNC_RATE_DEF)
-	__s32_field_def(9,	GENLA_F_MANDATORY,	resync_after, DRBD_RESYNC_AFTER_DEF)
-	__u32_field_def(10,	GENLA_F_MANDATORY,	al_extents, DRBD_AL_EXTENTS_DEF)
-	__u32_field_def(11,	GENLA_F_MANDATORY,	c_plan_ahead, DRBD_C_PLAN_AHEAD_DEF)
-	__u32_field_def(12,	GENLA_F_MANDATORY,	c_delay_target, DRBD_C_DELAY_TARGET_DEF)
-	__u32_field_def(13,	GENLA_F_MANDATORY,	c_fill_target, DRBD_C_FILL_TARGET_DEF)
-	__u32_field_def(14,	GENLA_F_MANDATORY,	c_max_rate, DRBD_C_MAX_RATE_DEF)
-	__u32_field_def(15,	GENLA_F_MANDATORY,	c_min_rate, DRBD_C_MIN_RATE_DEF)
-
-	__flg_field_def(16, GENLA_F_MANDATORY,	disk_barrier, DRBD_DISK_BARRIER_DEF)
-	__flg_field_def(17, GENLA_F_MANDATORY,	disk_flushes, DRBD_DISK_FLUSHES_DEF)
-	__flg_field_def(18, GENLA_F_MANDATORY,	disk_drain, DRBD_DISK_DRAIN_DEF)
-	__flg_field_def(19, GENLA_F_MANDATORY,	md_flushes, DRBD_MD_FLUSHES_DEF)
+	__u32_field(5, DRBD_GENLA_F_MANDATORY | DRBD_F_INVARIANT,	max_bio_bvecs)
+
+	__u32_field_def(6, DRBD_GENLA_F_MANDATORY,	on_io_error, DRBD_ON_IO_ERROR_DEF)
+	__u32_field_def(7, DRBD_GENLA_F_MANDATORY,	fencing, DRBD_FENCING_DEF)
+
+	__u32_field_def(8,	DRBD_GENLA_F_MANDATORY,	resync_rate, DRBD_RESYNC_RATE_DEF)
+	__s32_field_def(9,	DRBD_GENLA_F_MANDATORY,	resync_after, DRBD_MINOR_NUMBER_DEF)
+	__u32_field_def(10,	DRBD_GENLA_F_MANDATORY,	al_extents, DRBD_AL_EXTENTS_DEF)
+	__u32_field_def(11,	DRBD_GENLA_F_MANDATORY,	c_plan_ahead, DRBD_C_PLAN_AHEAD_DEF)
+	__u32_field_def(12,	DRBD_GENLA_F_MANDATORY,	c_delay_target, DRBD_C_DELAY_TARGET_DEF)
+	__u32_field_def(13,	DRBD_GENLA_F_MANDATORY,	c_fill_target, DRBD_C_FILL_TARGET_DEF)
+	__u32_field_def(14,	DRBD_GENLA_F_MANDATORY,	c_max_rate, DRBD_C_MAX_RATE_DEF)
+	__u32_field_def(15,	DRBD_GENLA_F_MANDATORY,	c_min_rate, DRBD_C_MIN_RATE_DEF)
+
+	__flg_field_def(16, DRBD_GENLA_F_MANDATORY,	disk_barrier, DRBD_DISK_BARRIER_DEF)
+	__flg_field_def(17, DRBD_GENLA_F_MANDATORY,	disk_flushes, DRBD_DISK_FLUSHES_DEF)
+	__flg_field_def(18, DRBD_GENLA_F_MANDATORY,	disk_drain, DRBD_DISK_DRAIN_DEF)
+	__flg_field_def(19, DRBD_GENLA_F_MANDATORY,	md_flushes, DRBD_MD_FLUSHES_DEF)
 )
 
 GENL_struct(DRBD_NLA_RESOURCE_OPTS, 4, res_opts,
-	__str_field_def(1,	GENLA_F_MANDATORY,	cpu_mask,       32)
-	__u32_field_def(2,	GENLA_F_MANDATORY,	on_no_data, DRBD_ON_NO_DATA_DEF)
+	__str_field_def(1,	DRBD_GENLA_F_MANDATORY,	cpu_mask,       32)
+	__u32_field_def(2,	DRBD_GENLA_F_MANDATORY,	on_no_data, DRBD_ON_NO_DATA_DEF)
 )
 
 GENL_struct(DRBD_NLA_NET_CONF, 5, net_conf,
-	__bin_field(1,	GENLA_F_REQUIRED | GENLA_F_INVARIANT,	my_addr,	128)
-	__bin_field(2,	GENLA_F_REQUIRED | GENLA_F_INVARIANT,	peer_addr,	128)
-	__str_field_def(3,	GENLA_F_MANDATORY | GENLA_F_SENSITIVE,
+	__bin_field(1,	DRBD_F_REQUIRED | DRBD_F_INVARIANT,	my_addr,	128)
+	__bin_field(2,	DRBD_F_REQUIRED | DRBD_F_INVARIANT,	peer_addr,	128)
+	__str_field_def(3,	DRBD_GENLA_F_MANDATORY | DRBD_F_SENSITIVE,
 						shared_secret,	SHARED_SECRET_MAX)
-	__str_field_def(4,	GENLA_F_MANDATORY,	cram_hmac_alg,	SHARED_SECRET_MAX)
-	__str_field_def(5,	GENLA_F_MANDATORY,	integrity_alg,	SHARED_SECRET_MAX)
-	__str_field_def(6,	GENLA_F_MANDATORY,	verify_alg,     SHARED_SECRET_MAX)
-	__str_field_def(7,	GENLA_F_MANDATORY,	csums_alg,	SHARED_SECRET_MAX)
-	__u32_field_def(8,	GENLA_F_MANDATORY,	wire_protocol, DRBD_PROTOCOL_DEF)
-	__u32_field_def(9,	GENLA_F_MANDATORY,	connect_int, DRBD_CONNECT_INT_DEF)
-	__u32_field_def(10,	GENLA_F_MANDATORY,	timeout, DRBD_TIMEOUT_DEF)
-	__u32_field_def(11,	GENLA_F_MANDATORY,	ping_int, DRBD_PING_INT_DEF)
-	__u32_field_def(12,	GENLA_F_MANDATORY,	ping_timeo, DRBD_PING_TIMEO_DEF)
-	__u32_field_def(13,	GENLA_F_MANDATORY,	sndbuf_size, DRBD_SNDBUF_SIZE_DEF)
-	__u32_field_def(14,	GENLA_F_MANDATORY,	rcvbuf_size, DRBD_RCVBUF_SIZE_DEF)
-	__u32_field_def(15,	GENLA_F_MANDATORY,	ko_count, DRBD_KO_COUNT_DEF)
-	__u32_field_def(16,	GENLA_F_MANDATORY,	max_buffers, DRBD_MAX_BUFFERS_DEF)
-	__u32_field_def(17,	GENLA_F_MANDATORY,	max_epoch_size, DRBD_MAX_EPOCH_SIZE_DEF)
-	__u32_field_def(18,	GENLA_F_MANDATORY,	unplug_watermark, DRBD_UNPLUG_WATERMARK_DEF)
-	__u32_field_def(19,	GENLA_F_MANDATORY,	after_sb_0p, DRBD_AFTER_SB_0P_DEF)
-	__u32_field_def(20,	GENLA_F_MANDATORY,	after_sb_1p, DRBD_AFTER_SB_1P_DEF)
-	__u32_field_def(21,	GENLA_F_MANDATORY,	after_sb_2p, DRBD_AFTER_SB_2P_DEF)
-	__u32_field_def(22,	GENLA_F_MANDATORY,	rr_conflict, DRBD_RR_CONFLICT_DEF)
-	__u32_field_def(23,	GENLA_F_MANDATORY,	on_congestion, DRBD_ON_CONGESTION_DEF)
-	__u32_field_def(24,	GENLA_F_MANDATORY,	cong_fill, DRBD_CONG_FILL_DEF)
-	__u32_field_def(25,	GENLA_F_MANDATORY,	cong_extents, DRBD_CONG_EXTENTS_DEF)
-	__flg_field_def(26, GENLA_F_MANDATORY,	two_primaries, DRBD_ALLOW_TWO_PRIMARIES_DEF)
-	__flg_field(27, GENLA_F_MANDATORY | GENLA_F_INVARIANT,	discard_my_data)
-	__flg_field_def(28, GENLA_F_MANDATORY,	tcp_cork, DRBD_TCP_CORK_DEF)
-	__flg_field_def(29, GENLA_F_MANDATORY,	always_asbp, DRBD_ALWAYS_ASBP_DEF)
-	__flg_field(30, GENLA_F_MANDATORY | GENLA_F_INVARIANT,	dry_run)
-	__flg_field_def(31,	GENLA_F_MANDATORY,	use_rle, DRBD_USE_RLE_DEF)
+	__str_field_def(4,	DRBD_GENLA_F_MANDATORY,	cram_hmac_alg,	SHARED_SECRET_MAX)
+	__str_field_def(5,	DRBD_GENLA_F_MANDATORY,	integrity_alg,	SHARED_SECRET_MAX)
+	__str_field_def(6,	DRBD_GENLA_F_MANDATORY,	verify_alg,     SHARED_SECRET_MAX)
+	__str_field_def(7,	DRBD_GENLA_F_MANDATORY,	csums_alg,	SHARED_SECRET_MAX)
+	__u32_field_def(8,	DRBD_GENLA_F_MANDATORY,	wire_protocol, DRBD_PROTOCOL_DEF)
+	__u32_field_def(9,	DRBD_GENLA_F_MANDATORY,	connect_int, DRBD_CONNECT_INT_DEF)
+	__u32_field_def(10,	DRBD_GENLA_F_MANDATORY,	timeout, DRBD_TIMEOUT_DEF)
+	__u32_field_def(11,	DRBD_GENLA_F_MANDATORY,	ping_int, DRBD_PING_INT_DEF)
+	__u32_field_def(12,	DRBD_GENLA_F_MANDATORY,	ping_timeo, DRBD_PING_TIMEO_DEF)
+	__u32_field_def(13,	DRBD_GENLA_F_MANDATORY,	sndbuf_size, DRBD_SNDBUF_SIZE_DEF)
+	__u32_field_def(14,	DRBD_GENLA_F_MANDATORY,	rcvbuf_size, DRBD_RCVBUF_SIZE_DEF)
+	__u32_field_def(15,	DRBD_GENLA_F_MANDATORY,	ko_count, DRBD_KO_COUNT_DEF)
+	__u32_field_def(16,	DRBD_GENLA_F_MANDATORY,	max_buffers, DRBD_MAX_BUFFERS_DEF)
+	__u32_field_def(17,	DRBD_GENLA_F_MANDATORY,	max_epoch_size, DRBD_MAX_EPOCH_SIZE_DEF)
+	__u32_field_def(18,	DRBD_GENLA_F_MANDATORY,	unplug_watermark, DRBD_UNPLUG_WATERMARK_DEF)
+	__u32_field_def(19,	DRBD_GENLA_F_MANDATORY,	after_sb_0p, DRBD_AFTER_SB_0P_DEF)
+	__u32_field_def(20,	DRBD_GENLA_F_MANDATORY,	after_sb_1p, DRBD_AFTER_SB_1P_DEF)
+	__u32_field_def(21,	DRBD_GENLA_F_MANDATORY,	after_sb_2p, DRBD_AFTER_SB_2P_DEF)
+	__u32_field_def(22,	DRBD_GENLA_F_MANDATORY,	rr_conflict, DRBD_RR_CONFLICT_DEF)
+	__u32_field_def(23,	DRBD_GENLA_F_MANDATORY,	on_congestion, DRBD_ON_CONGESTION_DEF)
+	__u32_field_def(24,	DRBD_GENLA_F_MANDATORY,	cong_fill, DRBD_CONG_FILL_DEF)
+	__u32_field_def(25,	DRBD_GENLA_F_MANDATORY,	cong_extents, DRBD_CONG_EXTENTS_DEF)
+	__flg_field_def(26, DRBD_GENLA_F_MANDATORY,	two_primaries, DRBD_ALLOW_TWO_PRIMARIES_DEF)
+	__flg_field(27, DRBD_GENLA_F_MANDATORY | DRBD_F_INVARIANT,	discard_my_data)
+	__flg_field_def(28, DRBD_GENLA_F_MANDATORY,	tcp_cork, DRBD_TCP_CORK_DEF)
+	__flg_field_def(29, DRBD_GENLA_F_MANDATORY,	always_asbp, DRBD_ALWAYS_ASBP_DEF)
+	__flg_field(30, DRBD_GENLA_F_MANDATORY | DRBD_F_INVARIANT,	dry_run)
+	__flg_field_def(31,	DRBD_GENLA_F_MANDATORY,	use_rle, DRBD_USE_RLE_DEF)
 )
 
 GENL_struct(DRBD_NLA_SET_ROLE_PARMS, 6, set_role_parms,
-	__flg_field(1, GENLA_F_MANDATORY,	assume_uptodate)
+	__flg_field(1, DRBD_GENLA_F_MANDATORY,	assume_uptodate)
 )
 
 GENL_struct(DRBD_NLA_RESIZE_PARMS, 7, resize_parms,
-	__u64_field(1, GENLA_F_MANDATORY,	resize_size)
-	__flg_field(2, GENLA_F_MANDATORY,	resize_force)
-	__flg_field(3, GENLA_F_MANDATORY,	no_resync)
+	__u64_field(1, DRBD_GENLA_F_MANDATORY,	resize_size)
+	__flg_field(2, DRBD_GENLA_F_MANDATORY,	resize_force)
+	__flg_field(3, DRBD_GENLA_F_MANDATORY,	no_resync)
 )
 
 GENL_struct(DRBD_NLA_STATE_INFO, 8, state_info,
 	/* the reason of the broadcast,
 	 * if this is an event triggered broadcast. */
-	__u32_field(1, GENLA_F_MANDATORY,	sib_reason)
-	__u32_field(2, GENLA_F_REQUIRED,	current_state)
-	__u64_field(3, GENLA_F_MANDATORY,	capacity)
-	__u64_field(4, GENLA_F_MANDATORY,	ed_uuid)
+	__u32_field(1, DRBD_GENLA_F_MANDATORY,	sib_reason)
+	__u32_field(2, DRBD_F_REQUIRED,	current_state)
+	__u64_field(3, DRBD_GENLA_F_MANDATORY,	capacity)
+	__u64_field(4, DRBD_GENLA_F_MANDATORY,	ed_uuid)
 
 	/* These are for broadcast from after state change work.
 	 * prev_state and new_state are from the moment the state change took
 	 * place, new_state is not neccessarily the same as current_state,
 	 * there may have been more state changes since.  Which will be
 	 * broadcasted soon, in their respective after state change work.  */
-	__u32_field(5, GENLA_F_MANDATORY,	prev_state)
-	__u32_field(6, GENLA_F_MANDATORY,	new_state)
+	__u32_field(5, DRBD_GENLA_F_MANDATORY,	prev_state)
+	__u32_field(6, DRBD_GENLA_F_MANDATORY,	new_state)
 
 	/* if we have a local disk: */
-	__bin_field(7, GENLA_F_MANDATORY,	uuids, (UI_SIZE*sizeof(__u64)))
-	__u32_field(8, GENLA_F_MANDATORY,	disk_flags)
-	__u64_field(9, GENLA_F_MANDATORY,	bits_total)
-	__u64_field(10, GENLA_F_MANDATORY,	bits_oos)
+	__bin_field(7, DRBD_GENLA_F_MANDATORY,	uuids, (UI_SIZE*sizeof(__u64)))
+	__u32_field(8, DRBD_GENLA_F_MANDATORY,	disk_flags)
+	__u64_field(9, DRBD_GENLA_F_MANDATORY,	bits_total)
+	__u64_field(10, DRBD_GENLA_F_MANDATORY,	bits_oos)
 	/* and in case resync or online verify is active */
-	__u64_field(11, GENLA_F_MANDATORY,	bits_rs_total)
-	__u64_field(12, GENLA_F_MANDATORY,	bits_rs_failed)
+	__u64_field(11, DRBD_GENLA_F_MANDATORY,	bits_rs_total)
+	__u64_field(12, DRBD_GENLA_F_MANDATORY,	bits_rs_failed)
 
 	/* for pre and post notifications of helper execution */
-	__str_field(13, GENLA_F_MANDATORY,	helper, 32)
-	__u32_field(14, GENLA_F_MANDATORY,	helper_exit_code)
+	__str_field(13, DRBD_GENLA_F_MANDATORY,	helper, 32)
+	__u32_field(14, DRBD_GENLA_F_MANDATORY,	helper_exit_code)
 )
 
 GENL_struct(DRBD_NLA_START_OV_PARMS, 9, start_ov_parms,
-	__u64_field(1, GENLA_F_MANDATORY,	ov_start_sector)
+	__u64_field(1, DRBD_GENLA_F_MANDATORY,	ov_start_sector)
 )
 
 GENL_struct(DRBD_NLA_NEW_C_UUID_PARMS, 10, new_c_uuid_parms,
-	__flg_field(1, GENLA_F_MANDATORY, clear_bm)
+	__flg_field(1, DRBD_GENLA_F_MANDATORY, clear_bm)
 )
 
 GENL_struct(DRBD_NLA_TIMEOUT_PARMS, 11, timeout_parms,
-	__u32_field(1,	GENLA_F_REQUIRED,	timeout_type)
+	__u32_field(1,	DRBD_F_REQUIRED,	timeout_type)
 )
 
 GENL_struct(DRBD_NLA_DISCONNECT_PARMS, 12, disconnect_parms,
-	__flg_field(1, GENLA_F_MANDATORY,	force_disconnect)
+	__flg_field(1, DRBD_GENLA_F_MANDATORY,	force_disconnect)
 )
 
 /*
@@ -234,11 +234,11 @@ GENL_mc_group(events)
 	/* kernel -> userspace announcement of changes */
 GENL_notification(
 	DRBD_EVENT, 1, events,
-	GENL_tla_expected(DRBD_NLA_CFG_CONTEXT, GENLA_F_REQUIRED)
-	GENL_tla_expected(DRBD_NLA_STATE_INFO, GENLA_F_REQUIRED)
-	GENL_tla_expected(DRBD_NLA_NET_CONF, GENLA_F_MANDATORY)
-	GENL_tla_expected(DRBD_NLA_DISK_CONF, GENLA_F_MANDATORY)
-	GENL_tla_expected(DRBD_NLA_SYNCER_CONF, GENLA_F_MANDATORY)
+	GENL_tla_expected(DRBD_NLA_CFG_CONTEXT, DRBD_F_REQUIRED)
+	GENL_tla_expected(DRBD_NLA_STATE_INFO, DRBD_F_REQUIRED)
+	GENL_tla_expected(DRBD_NLA_NET_CONF, DRBD_GENLA_F_MANDATORY)
+	GENL_tla_expected(DRBD_NLA_DISK_CONF, DRBD_GENLA_F_MANDATORY)
+	GENL_tla_expected(DRBD_NLA_SYNCER_CONF, DRBD_GENLA_F_MANDATORY)
 )
 
 	/* query kernel for specific or all info */
@@ -252,116 +252,116 @@ GENL_op(
 	),
 	/* To select the object .doit.
 	 * Or a subset of objects in .dumpit. */
-	GENL_tla_expected(DRBD_NLA_CFG_CONTEXT, GENLA_F_MANDATORY)
+	GENL_tla_expected(DRBD_NLA_CFG_CONTEXT, DRBD_GENLA_F_MANDATORY)
 )
 
 #if 0
 	/* TO BE DONE */
 	/* create or destroy resources, aka replication groups */
 GENL_op(DRBD_ADM_CREATE_RESOURCE, 3, GENL_doit(drbd_adm_create_resource),
-	GENL_tla_expected(DRBD_NLA_CFG_CONTEXT, GENLA_F_REQUIRED))
+	GENL_tla_expected(DRBD_NLA_CFG_CONTEXT, DRBD_F_REQUIRED))
 GENL_op(DRBD_ADM_DELETE_RESOURCE, 4, GENL_doit(drbd_adm_delete_resource),
-	GENL_tla_expected(DRBD_NLA_CFG_CONTEXT, GENLA_F_REQUIRED))
+	GENL_tla_expected(DRBD_NLA_CFG_CONTEXT, DRBD_F_REQUIRED))
 #endif
 
 	/* add DRBD minor devices as volumes to resources */
 GENL_op(DRBD_ADM_ADD_MINOR, 5, GENL_doit(drbd_adm_add_minor),
-	GENL_tla_expected(DRBD_NLA_CFG_CONTEXT, GENLA_F_REQUIRED))
+	GENL_tla_expected(DRBD_NLA_CFG_CONTEXT, DRBD_F_REQUIRED))
 GENL_op(DRBD_ADM_DEL_MINOR, 6, GENL_doit(drbd_adm_delete_minor),
-	GENL_tla_expected(DRBD_NLA_CFG_CONTEXT, GENLA_F_REQUIRED))
+	GENL_tla_expected(DRBD_NLA_CFG_CONTEXT, DRBD_F_REQUIRED))
 
 	/* add or delete replication links to resources */
 GENL_op(DRBD_ADM_ADD_LINK, 7, GENL_doit(drbd_adm_create_connection),
-	GENL_tla_expected(DRBD_NLA_CFG_CONTEXT, GENLA_F_REQUIRED))
+	GENL_tla_expected(DRBD_NLA_CFG_CONTEXT, DRBD_F_REQUIRED))
 GENL_op(DRBD_ADM_DEL_LINK, 8, GENL_doit(drbd_adm_delete_connection),
-	GENL_tla_expected(DRBD_NLA_CFG_CONTEXT, GENLA_F_REQUIRED))
+	GENL_tla_expected(DRBD_NLA_CFG_CONTEXT, DRBD_F_REQUIRED))
 
 GENL_op(DRBD_ADM_RESOURCE_OPTS, 9,
 	GENL_doit(drbd_adm_resource_opts),
-	GENL_tla_expected(DRBD_NLA_CFG_CONTEXT, GENLA_F_REQUIRED)
-	GENL_tla_expected(DRBD_NLA_RESOURCE_OPTS, GENLA_F_MANDATORY)
+	GENL_tla_expected(DRBD_NLA_CFG_CONTEXT, DRBD_F_REQUIRED)
+	GENL_tla_expected(DRBD_NLA_RESOURCE_OPTS, DRBD_GENLA_F_MANDATORY)
 )
 
 GENL_op(
 	DRBD_ADM_CONNECT, 10,
 	GENL_doit(drbd_adm_connect),
-	GENL_tla_expected(DRBD_NLA_CFG_CONTEXT, GENLA_F_REQUIRED)
-	GENL_tla_expected(DRBD_NLA_NET_CONF, GENLA_F_REQUIRED)
+	GENL_tla_expected(DRBD_NLA_CFG_CONTEXT, DRBD_F_REQUIRED)
+	GENL_tla_expected(DRBD_NLA_NET_CONF, DRBD_F_REQUIRED)
 )
 
 GENL_op(
 	DRBD_ADM_CHG_NET_OPTS, 29,
 	GENL_doit(drbd_adm_net_opts),
-	GENL_tla_expected(DRBD_NLA_CFG_CONTEXT, GENLA_F_REQUIRED)
-	GENL_tla_expected(DRBD_NLA_NET_CONF, GENLA_F_REQUIRED)
+	GENL_tla_expected(DRBD_NLA_CFG_CONTEXT, DRBD_F_REQUIRED)
+	GENL_tla_expected(DRBD_NLA_NET_CONF, DRBD_F_REQUIRED)
 )
 
 GENL_op(DRBD_ADM_DISCONNECT, 11, GENL_doit(drbd_adm_disconnect),
-	GENL_tla_expected(DRBD_NLA_CFG_CONTEXT, GENLA_F_REQUIRED))
+	GENL_tla_expected(DRBD_NLA_CFG_CONTEXT, DRBD_F_REQUIRED))
 
 GENL_op(DRBD_ADM_ATTACH, 12,
 	GENL_doit(drbd_adm_attach),
-	GENL_tla_expected(DRBD_NLA_CFG_CONTEXT, GENLA_F_REQUIRED)
-	GENL_tla_expected(DRBD_NLA_DISK_CONF, GENLA_F_REQUIRED)
+	GENL_tla_expected(DRBD_NLA_CFG_CONTEXT, DRBD_F_REQUIRED)
+	GENL_tla_expected(DRBD_NLA_DISK_CONF, DRBD_F_REQUIRED)
 )
 
 GENL_op(DRBD_ADM_CHG_DISK_OPTS, 28,
 	GENL_doit(drbd_adm_disk_opts),
-	GENL_tla_expected(DRBD_NLA_CFG_CONTEXT, GENLA_F_REQUIRED)
-	GENL_tla_expected(DRBD_NLA_DISK_OPTS, GENLA_F_REQUIRED)
+	GENL_tla_expected(DRBD_NLA_CFG_CONTEXT, DRBD_F_REQUIRED)
+	GENL_tla_expected(DRBD_NLA_DISK_OPTS, DRBD_F_REQUIRED)
 )
 
 GENL_op(
 	DRBD_ADM_RESIZE, 13,
 	GENL_doit(drbd_adm_resize),
-	GENL_tla_expected(DRBD_NLA_CFG_CONTEXT, GENLA_F_REQUIRED)
-	GENL_tla_expected(DRBD_NLA_RESIZE_PARMS, GENLA_F_MANDATORY)
+	GENL_tla_expected(DRBD_NLA_CFG_CONTEXT, DRBD_F_REQUIRED)
+	GENL_tla_expected(DRBD_NLA_RESIZE_PARMS, DRBD_GENLA_F_MANDATORY)
 )
 
 GENL_op(
 	DRBD_ADM_PRIMARY, 14,
 	GENL_doit(drbd_adm_set_role),
-	GENL_tla_expected(DRBD_NLA_CFG_CONTEXT, GENLA_F_REQUIRED)
-	GENL_tla_expected(DRBD_NLA_SET_ROLE_PARMS, GENLA_F_REQUIRED)
+	GENL_tla_expected(DRBD_NLA_CFG_CONTEXT, DRBD_F_REQUIRED)
+	GENL_tla_expected(DRBD_NLA_SET_ROLE_PARMS, DRBD_F_REQUIRED)
 )
 
 GENL_op(
 	DRBD_ADM_SECONDARY, 15,
 	GENL_doit(drbd_adm_set_role),
-	GENL_tla_expected(DRBD_NLA_CFG_CONTEXT, GENLA_F_REQUIRED)
-	GENL_tla_expected(DRBD_NLA_SET_ROLE_PARMS, GENLA_F_REQUIRED)
+	GENL_tla_expected(DRBD_NLA_CFG_CONTEXT, DRBD_F_REQUIRED)
+	GENL_tla_expected(DRBD_NLA_SET_ROLE_PARMS, DRBD_F_REQUIRED)
 )
 
 GENL_op(
 	DRBD_ADM_NEW_C_UUID, 16,
 	GENL_doit(drbd_adm_new_c_uuid),
-	GENL_tla_expected(DRBD_NLA_CFG_CONTEXT, GENLA_F_REQUIRED)
-	GENL_tla_expected(DRBD_NLA_NEW_C_UUID_PARMS, GENLA_F_MANDATORY)
+	GENL_tla_expected(DRBD_NLA_CFG_CONTEXT, DRBD_F_REQUIRED)
+	GENL_tla_expected(DRBD_NLA_NEW_C_UUID_PARMS, DRBD_GENLA_F_MANDATORY)
 )
 
 GENL_op(
 	DRBD_ADM_START_OV, 17,
 	GENL_doit(drbd_adm_start_ov),
-	GENL_tla_expected(DRBD_NLA_START_OV_PARMS, GENLA_F_MANDATORY)
+	GENL_tla_expected(DRBD_NLA_START_OV_PARMS, DRBD_GENLA_F_MANDATORY)
 )
 
 GENL_op(DRBD_ADM_DETACH,	18, GENL_doit(drbd_adm_detach),
-	GENL_tla_expected(DRBD_NLA_CFG_CONTEXT, GENLA_F_REQUIRED))
+	GENL_tla_expected(DRBD_NLA_CFG_CONTEXT, DRBD_F_REQUIRED))
 GENL_op(DRBD_ADM_INVALIDATE,	19, GENL_doit(drbd_adm_invalidate),
-	GENL_tla_expected(DRBD_NLA_CFG_CONTEXT, GENLA_F_REQUIRED))
+	GENL_tla_expected(DRBD_NLA_CFG_CONTEXT, DRBD_F_REQUIRED))
 GENL_op(DRBD_ADM_INVAL_PEER,	20, GENL_doit(drbd_adm_invalidate_peer),
-	GENL_tla_expected(DRBD_NLA_CFG_CONTEXT, GENLA_F_REQUIRED))
+	GENL_tla_expected(DRBD_NLA_CFG_CONTEXT, DRBD_F_REQUIRED))
 GENL_op(DRBD_ADM_PAUSE_SYNC,	21, GENL_doit(drbd_adm_pause_sync),
-	GENL_tla_expected(DRBD_NLA_CFG_CONTEXT, GENLA_F_REQUIRED))
+	GENL_tla_expected(DRBD_NLA_CFG_CONTEXT, DRBD_F_REQUIRED))
 GENL_op(DRBD_ADM_RESUME_SYNC,	22, GENL_doit(drbd_adm_resume_sync),
-	GENL_tla_expected(DRBD_NLA_CFG_CONTEXT, GENLA_F_REQUIRED))
+	GENL_tla_expected(DRBD_NLA_CFG_CONTEXT, DRBD_F_REQUIRED))
 GENL_op(DRBD_ADM_SUSPEND_IO,	23, GENL_doit(drbd_adm_suspend_io),
-	GENL_tla_expected(DRBD_NLA_CFG_CONTEXT, GENLA_F_REQUIRED))
+	GENL_tla_expected(DRBD_NLA_CFG_CONTEXT, DRBD_F_REQUIRED))
 GENL_op(DRBD_ADM_RESUME_IO,	24, GENL_doit(drbd_adm_resume_io),
-	GENL_tla_expected(DRBD_NLA_CFG_CONTEXT, GENLA_F_REQUIRED))
+	GENL_tla_expected(DRBD_NLA_CFG_CONTEXT, DRBD_F_REQUIRED))
 GENL_op(DRBD_ADM_OUTDATE,	25, GENL_doit(drbd_adm_outdate),
-	GENL_tla_expected(DRBD_NLA_CFG_CONTEXT, GENLA_F_REQUIRED))
+	GENL_tla_expected(DRBD_NLA_CFG_CONTEXT, DRBD_F_REQUIRED))
 GENL_op(DRBD_ADM_GET_TIMEOUT_TYPE, 26, GENL_doit(drbd_adm_get_timeout_type),
-	GENL_tla_expected(DRBD_NLA_CFG_CONTEXT, GENLA_F_REQUIRED))
+	GENL_tla_expected(DRBD_NLA_CFG_CONTEXT, DRBD_F_REQUIRED))
 GENL_op(DRBD_ADM_DOWN,		27, GENL_doit(drbd_adm_down),
-	GENL_tla_expected(DRBD_NLA_CFG_CONTEXT, GENLA_F_REQUIRED))
+	GENL_tla_expected(DRBD_NLA_CFG_CONTEXT, DRBD_F_REQUIRED))
diff --git a/include/linux/genl_magic_func.h b/include/linux/genl_magic_func.h
index a1305b7..99f4e95 100644
--- a/include/linux/genl_magic_func.h
+++ b/include/linux/genl_magic_func.h
@@ -4,53 +4,6 @@
 #include <linux/genl_magic_struct.h>
 
 /*
- * Extension of genl attribute validation policies			{{{1
- *									{{{2
- */
-
-/**
- * nla_is_required - return true if this attribute is required
- * @nla: netlink attribute
- */
-static inline int nla_is_required(const struct nlattr *nla)
-{
-        return nla->nla_type & GENLA_F_REQUIRED;
-}
-
-/**
- * nla_is_mandatory - return true if understanding this attribute is mandatory
- * @nla: netlink attribute
- * Note: REQUIRED attributes are implicitly MANDATORY as well
- */
-static inline int nla_is_mandatory(const struct nlattr *nla)
-{
-        return nla->nla_type & (GENLA_F_MANDATORY | GENLA_F_REQUIRED);
-}
-
-/* Functionality to be integrated into nla_parse(), and validate_nla(),
- * respectively.
- *
- * Enforcing the "mandatory" bit is done here,
- * by rejecting unknown mandatory attributes.
- *
- * Part of enforcing the "required" flag would mean to embed it into
- * nla_policy.type, and extending validate_nla(), which currently does
- * BUG_ON(pt->type > NLA_TYPE_MAX); we have to work on existing kernels,
- * so we cannot do that.  Thats why enforcing "required" is done in the
- * generated assignment functions below. */
-static int nla_check_unknown(int maxtype, struct nlattr *head, int len)
-{
-	struct nlattr *nla;
-	int rem;
-        nla_for_each_attr(nla, head, len, rem) {
-		__u16 type = nla_type(nla);
-		if (type > maxtype && nla_is_mandatory(nla))
-			return -EOPNOTSUPP;
-	}
-	return 0;
-}
-
-/*
  * Magic: declare tla policy						{{{1
  * Magic: declare nested policies
  *									{{{2
@@ -80,13 +33,13 @@ static struct nla_policy s_name ## _nl_policy[] __read_mostly =		\
 #undef __field
 #define __field(attr_nr, attr_flag, name, nla_type, _type, __get,	\
 		 __put, __is_signed)					\
-	[__nla_type(attr_nr)] = { .type = nla_type },
+	[attr_nr] = { .type = nla_type },
 
 #undef __array
 #define __array(attr_nr, attr_flag, name, nla_type, _type, maxlen,	\
 		__get, __put, __is_signed)				\
-	[__nla_type(attr_nr)] = { .type = nla_type,			\
-		.len = maxlen - (nla_type == NLA_NUL_STRING) },
+	[attr_nr] = { .type = nla_type,					\
+		      .len = maxlen - (nla_type == NLA_NUL_STRING) },
 
 #include GENL_MAGIC_INCLUDE_FILE
 
@@ -189,6 +142,43 @@ static struct nlattr *nested_attr_tb[128];
 #define BUILD_BUG_ON_NULL(e) ((void *)sizeof(struct { int:-!!(e); }))
 #endif
 
+static inline int drbd_nla_check_mandatory(int maxtype, struct nlattr *nla)
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
+			if (nla_type(nla) > maxtype)
+				return -EOPNOTSUPP;
+			nla->nla_type &= ~DRBD_GENLA_F_MANDATORY;
+		}
+	}
+	return 0;
+}
+
+static inline int drbd_nla_parse_nested(struct nlattr *tb[], int maxtype,
+					struct nlattr *nla,
+					const struct nla_policy *policy)
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
 #undef GENL_struct
 #define GENL_struct(tag_name, tag_number, s_name, s_fields)		\
 static int s_name ## _from_attrs(struct s_name *s, struct genl_info *info) __attribute__((unused)); \
@@ -207,12 +197,9 @@ static int s_name ## _from_attrs(struct s_name *s, struct genl_info *info)	\
 	if (!tla)							\
 		return -ENOMSG;						\
 	DPRINT_TLA(#s_name, "<=-", #tag_name);				\
-	err = nla_parse_nested(ntb, maxtype, tla, s_name ## _nl_policy); \
+	err = drbd_nla_parse_nested(ntb, maxtype, tla, s_name ## _nl_policy);	\
 	if (err)							\
 		return err;						\
-	err = nla_check_unknown(maxtype, nla_data(tla), nla_len(tla));	\
-	if (err)							\
-	      return err;						\
 									\
 	s_fields							\
 	return 0;							\
@@ -220,17 +207,17 @@ static int s_name ## _from_attrs(struct s_name *s, struct genl_info *info)	\
 
 
 #define __assign(attr_nr, attr_flag, name, nla_type, type, assignment...)	\
-		nla = ntb[__nla_type(attr_nr)];				\
+		nla = ntb[attr_nr];						\
 		if (nla) {						\
-			if (exclude_invariants && ((attr_flag) & GENLA_F_INVARIANT)) {		\
+			if (exclude_invariants && ((attr_flag) & DRBD_F_INVARIANT)) {		\
 				pr_info("<< must not change invariant attr: %s\n", #name);	\
 				return -EEXIST;				\
 			}						\
 			assignment;					\
-		} else if (exclude_invariants && ((attr_flag) & GENLA_F_INVARIANT)) {		\
+		} else if (exclude_invariants && ((attr_flag) & DRBD_F_INVARIANT)) {		\
 			/* attribute missing from payload, */		\
 			/* which was expected */			\
-		} else if ((attr_flag) & GENLA_F_REQUIRED) {		\
+		} else if ((attr_flag) & DRBD_F_REQUIRED) {		\
 			pr_info("<< missing attr: %s\n", #name);	\
 			return -ENOMSG;					\
 		}
@@ -409,7 +396,7 @@ static inline int s_name ## _to_unpriv_skb(struct sk_buff *skb,		\
 #undef __field
 #define __field(attr_nr, attr_flag, name, nla_type, type, __get, __put,	\
 		__is_signed)						\
-	if (!exclude_sensitive || !((attr_flag) & GENLA_F_SENSITIVE)) {	\
+	if (!exclude_sensitive || !((attr_flag) & DRBD_F_SENSITIVE)) {	\
 		DPRINT_FIELD(">>", nla_type, name, s, NULL);		\
 		__put(skb, attr_nr, s->name);				\
 	}
@@ -417,7 +404,7 @@ static inline int s_name ## _to_unpriv_skb(struct sk_buff *skb,		\
 #undef __array
 #define __array(attr_nr, attr_flag, name, nla_type, type, maxlen,	\
 		__get, __put, __is_signed)				\
-	if (!exclude_sensitive || !((attr_flag) & GENLA_F_SENSITIVE)) {	\
+	if (!exclude_sensitive || !((attr_flag) & DRBD_F_SENSITIVE)) {	\
 		DPRINT_ARRAY(">>",nla_type, name, s, NULL);		\
 		__put(skb, attr_nr, min_t(int, maxlen,			\
 			s->name ## _len + (nla_type == NLA_NUL_STRING)),\
diff --git a/include/linux/genl_magic_struct.h b/include/linux/genl_magic_struct.h
index f3c3425..1d0bd79 100644
--- a/include/linux/genl_magic_struct.h
+++ b/include/linux/genl_magic_struct.h
@@ -26,50 +26,34 @@ extern void CONCAT_(GENL_MAGIC_FAMILY, _genl_unregister)(void);
  * Extension of genl attribute validation policies			{{{2
  */
 
-/**
- * GENLA_F_FLAGS - policy type flags to ease compatible ABI evolvement
- *
- * @GENLA_F_REQUIRED: attribute has to be present, or message is considered invalid.
- * Adding new REQUIRED attributes breaks ABI compatibility, so don't do that.
+/*
+ * @DRBD_GENLA_F_MANDATORY: By default, netlink ignores attributes it does not
+ * know about.  This flag can be set in nlattr->nla_type to indicate that this
+ * attribute must not be ignored.
  *
- * @GENLA_F_MANDATORY: if present, receiver _must_ understand it.
- * Without this, unknown attributes (> maxtype) are _silently_ ignored
- * by validate_nla().
+ * We check and remove this flag in drbd_nla_check_mandatory() before
+ * validating the attribute types and lengths via nla_parse_nested().
+ */
+#define DRBD_GENLA_F_MANDATORY (1 << 14)
+
+/*
+ * Flags specific to drbd and not visible at the netlink layer, used in
+ * <struct>_from_attrs and <struct>_to_skb:
  *
- * To be used for API extensions, so older kernel can reject requests for not
- * yet implemented features, if newer userland tries to use them even though
- * the genl_family version clearly indicates they are not available.
+ * @DRBD_F_REQUIRED: Attribute is required; a request without this attribute is
+ * invalid.
  *
- * NOTE: These flags overload
- *   NLA_F_NESTED		(1 << 15)
- *   NLA_F_NET_BYTEORDER	(1 << 14)
- * from linux/netlink.h, which are not useful for validate_nla():
- * NET_BYTEORDER is not used anywhere, and NESTED would be specified by setting
- * .type = NLA_NESTED in the appropriate policy.
+ * @DRBD_F_SENSITIVE: Attribute includes sensitive information and must not be
+ * included in unpriviledged get requests or broadcasts.
  *
- * See also: nla_type()
+ * @DRBD_F_INVARIANT: Attribute is set when an object is initially created, but
+ * cannot subsequently be changed.
  */
-enum {
-	GENLA_F_MANDATORY	= 1 << 14,
-	GENLA_F_REQUIRED	= 1 << 15,
-
-	/* Below will not be present in the __u16 .nla_type, but can be
-	 * triggered on in <struct>_to_skb resp. <struct>_from_attrs */
-
-	/* To exclude "sensitive" information from broadcasts, or on
-	 * unpriviledged get requests.  This is useful because genetlink
-	 * multicast groups can be listened in on by anyone.  */
-	GENLA_F_SENSITIVE	= 1 << 16,
-
-	/* INVARIAN options cannot be changed at runtime.
-	 * Useful to share an attribute policy and struct definition,
-	 * between some "create" and "change" commands,
-	 * but disallow certain fields to be changed online.
-	 */
-	GENLA_F_INVARIANT	= 1 << 17,
-};
+#define DRBD_F_REQUIRED (1 << 0)
+#define DRBD_F_SENSITIVE (1 << 1)
+#define DRBD_F_INVARIANT (1 << 2)
 
-#define __nla_type(x)	((__u16)((__u16)(x) & (__u16)NLA_TYPE_MASK))
+#define __nla_type(x)	((__u16)((x) & NLA_TYPE_MASK & ~DRBD_GENLA_F_MANDATORY))
 
 /*									}}}1
  * MAGIC
@@ -170,12 +154,12 @@ enum {								\
 #undef __field
 #define __field(attr_nr, attr_flag, name, nla_type, type,	\
 		__get, __put, __is_signed)			\
-	T_ ## name = (__u16)(attr_nr | attr_flag),
+	T_ ## name = (__u16)(attr_nr | ((attr_flag) & DRBD_GENLA_F_MANDATORY)),
 
 #undef __array
 #define __array(attr_nr, attr_flag, name, nla_type, type,	\
 		maxlen, __get, __put, __is_signed)		\
-	T_ ## name = (__u16)(attr_nr | attr_flag),
+	T_ ## name = (__u16)(attr_nr | ((attr_flag) & DRBD_GENLA_F_MANDATORY)),
 
 #include GENL_MAGIC_INCLUDE_FILE
 
-- 
1.7.4.1

