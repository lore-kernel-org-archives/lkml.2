Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759585Ab2BOOyJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 09:54:09 -0500
Received: from kamaji.grokhost.net ([87.117.218.43]:42126 "EHLO
	kamaji.grokhost.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753914Ab2BOOuu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 09:50:50 -0500
From: Chris Boot <bootc@bootc.net>
To: linux1394-devel@lists.sourceforge.net, target-devel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, agrover@redhat.com, clemens@ladisch.de,
        nab@linux-iscsi.org, stefanr@s5r6.in-berlin.de,
        Chris Boot <bootc@bootc.net>
Subject: [PATCH v2 06/11] firewire-sbp-target: Add sbp_fabric.{c,h}
Date: Wed, 15 Feb 2012 14:47:23 +0000
Message-Id: <1329317248-94128-7-git-send-email-bootc@bootc.net>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1329317248-94128-1-git-send-email-bootc@bootc.net>
References: <1328989452-20921-1-git-send-email-bootc@bootc.net>
 <1329317248-94128-1-git-send-email-bootc@bootc.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This serves as further glue between the target framework and SBP-2, in
this case dealing with SCSI command submission and data in/out.

Signed-off-by: Chris Boot <bootc@bootc.net>
Cc: Andy Grover <agrover@redhat.com>
Cc: Clemens Ladisch <clemens@ladisch.de>
Cc: Nicholas A. Bellinger <nab@linux-iscsi.org>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/target/sbp/sbp_fabric.c |  353 +++++++++++++++++++++++++++++++++++++++
 drivers/target/sbp/sbp_fabric.h |   42 +++++
 2 files changed, 395 insertions(+), 0 deletions(-)
 create mode 100644 drivers/target/sbp/sbp_fabric.c
 create mode 100644 drivers/target/sbp/sbp_fabric.h

diff --git a/drivers/target/sbp/sbp_fabric.c b/drivers/target/sbp/sbp_fabric.c
new file mode 100644
index 0000000..354ef93
--- /dev/null
+++ b/drivers/target/sbp/sbp_fabric.c
@@ -0,0 +1,353 @@
+/*
+ * SBP2 target driver (SCSI over IEEE1394 in target mode)
+ *
+ * Copyright (C) 2011  Chris Boot <bootc@bootc.net>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software Foundation,
+ * Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ */
+
+#define KMSG_COMPONENT "sbp_target"
+#define pr_fmt(fmt) KMSG_COMPONENT ": " fmt
+
+#include <linux/slab.h>
+#include <linux/kthread.h>
+#include <linux/types.h>
+#include <linux/list.h>
+#include <linux/types.h>
+#include <linux/string.h>
+#include <linux/ctype.h>
+#include <linux/firewire.h>
+
+#include <asm/unaligned.h>
+
+#include <scsi/scsi.h>
+#include <scsi/scsi_host.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/libfc.h>
+
+#include <target/target_core_base.h>
+#include <target/target_core_fabric.h>
+
+#include "sbp_base.h"
+#include "sbp_fabric.h"
+#include "sbp_target_agent.h"
+#include "sbp_scsi_cmnd.h"
+
+int sbp_check_true(struct se_portal_group *se_tpg)
+{
+	return 1;
+}
+
+int sbp_check_false(struct se_portal_group *se_tpg)
+{
+	return 0;
+}
+
+char *sbp_get_fabric_name(void)
+{
+	return "sbp";
+}
+
+char *sbp_get_fabric_wwn(struct se_portal_group *se_tpg)
+{
+	struct sbp_tpg *tpg = container_of(se_tpg, struct sbp_tpg, se_tpg);
+	struct sbp_tport *tport = tpg->tport;
+
+	return &tport->tport_name[0];
+}
+
+u16 sbp_get_tag(struct se_portal_group *se_tpg)
+{
+	struct sbp_tpg *tpg = container_of(se_tpg, struct sbp_tpg, se_tpg);
+	return tpg->tport_tpgt;
+}
+
+u32 sbp_get_default_depth(struct se_portal_group *se_tpg)
+{
+	return 1;
+}
+
+struct se_node_acl *sbp_alloc_fabric_acl(struct se_portal_group *se_tpg)
+{
+	struct sbp_nacl *nacl;
+
+	nacl = kzalloc(sizeof(struct sbp_nacl), GFP_KERNEL);
+	if (!nacl) {
+		pr_err("Unable to alocate struct sbp_nacl\n");
+		return NULL;
+	}
+
+	return &nacl->se_node_acl;
+}
+
+void sbp_release_fabric_acl(
+	struct se_portal_group *se_tpg,
+	struct se_node_acl *se_nacl)
+{
+	struct sbp_nacl *nacl =
+		container_of(se_nacl, struct sbp_nacl, se_node_acl);
+	kfree(nacl);
+}
+
+u32 sbp_tpg_get_inst_index(struct se_portal_group *se_tpg)
+{
+	return 1;
+}
+
+void sbp_release_cmd(struct se_cmd *se_cmd)
+{
+	struct sbp_target_request *req = container_of(se_cmd,
+			struct sbp_target_request, se_cmd);
+
+	sbp_free_request(req);
+}
+
+int sbp_shutdown_session(struct se_session *se_sess)
+{
+	return 0;
+}
+
+void sbp_close_session(struct se_session *se_sess)
+{
+	return;
+}
+
+void sbp_stop_session(struct se_session *se_sess, int sess_sleep,
+		int conn_sleep)
+{
+	return;
+}
+
+void sbp_reset_nexus(struct se_session *se_sess)
+{
+	return;
+}
+
+int sbp_sess_logged_in(struct se_session *se_sess)
+{
+	return 0;
+}
+
+u32 sbp_sess_get_index(struct se_session *se_sess)
+{
+	return 0;
+}
+
+int sbp_write_pending(struct se_cmd *se_cmd)
+{
+	struct sbp_target_request *req = container_of(se_cmd,
+			struct sbp_target_request, se_cmd);
+	int ret;
+
+	req->data_buf = kmalloc(se_cmd->data_length, GFP_KERNEL);
+	if (!req->data_buf)
+		return -ENOMEM;
+
+	ret = sbp_rw_data(req);
+	if (ret) {
+		req->status.status |= cpu_to_be32(
+			STATUS_BLOCK_RESP(STATUS_RESP_TRANSPORT_FAILURE) |
+			STATUS_BLOCK_DEAD(0) |
+			STATUS_BLOCK_LEN(1) |
+			STATUS_BLOCK_SBP_STATUS(SBP_STATUS_UNSPECIFIED_ERROR));
+		sbp_send_status(req);
+		pr_warn("sbp_write_pending: data write error\n");
+		return ret;
+	}
+
+	sg_copy_from_buffer(se_cmd->t_data_sg,
+			se_cmd->t_data_nents,
+			req->data_buf,
+			se_cmd->data_length);
+
+	transport_generic_process_write(se_cmd);
+
+	return 0;
+}
+
+int sbp_write_pending_status(struct se_cmd *se_cmd)
+{
+	return 0;
+}
+
+void sbp_set_default_node_attrs(struct se_node_acl *nacl)
+{
+	return;
+}
+
+u32 sbp_get_task_tag(struct se_cmd *se_cmd)
+{
+	struct sbp_target_request *req = container_of(se_cmd,
+			struct sbp_target_request, se_cmd);
+
+	/* only used for printk until we do TMRs */
+	return (u32)req->orb_pointer;
+}
+
+int sbp_get_cmd_state(struct se_cmd *se_cmd)
+{
+	return 0;
+}
+
+int sbp_queue_data_in(struct se_cmd *se_cmd)
+{
+	struct sbp_target_request *req = container_of(se_cmd,
+			struct sbp_target_request, se_cmd);
+	int ret;
+
+	req->data_buf = kmalloc(se_cmd->data_length, GFP_KERNEL);
+	if (!req->data_buf)
+		return -ENOMEM;
+
+	sg_copy_to_buffer(se_cmd->t_data_sg,
+		se_cmd->t_data_nents,
+		req->data_buf,
+		se_cmd->data_length);
+
+	ret = sbp_rw_data(req);
+	if (ret) {
+		req->status.status |= cpu_to_be32(
+			STATUS_BLOCK_RESP(STATUS_RESP_TRANSPORT_FAILURE) |
+			STATUS_BLOCK_DEAD(0) |
+			STATUS_BLOCK_LEN(1) |
+			STATUS_BLOCK_SBP_STATUS(SBP_STATUS_UNSPECIFIED_ERROR));
+		sbp_send_status(req);
+		return ret;
+	}
+
+	return sbp_send_sense(req);
+}
+
+/*
+ * Called after command (no data transfer) or after the write (to device)
+ * operation is completed
+ */
+int sbp_queue_status(struct se_cmd *se_cmd)
+{
+	struct sbp_target_request *req = container_of(se_cmd,
+			struct sbp_target_request, se_cmd);
+
+	return sbp_send_sense(req);
+}
+
+int sbp_queue_tm_rsp(struct se_cmd *se_cmd)
+{
+	return 0;
+}
+
+u16 sbp_set_fabric_sense_len(struct se_cmd *se_cmd, u32 sense_length)
+{
+	return 0;
+}
+
+u16 sbp_get_fabric_sense_len(void)
+{
+	return 0;
+}
+
+int sbp_is_state_remove(struct se_cmd *se_cmd)
+{
+	return 0;
+}
+
+int sbp_check_stop_free(struct se_cmd *se_cmd)
+{
+	struct sbp_target_request *req = container_of(se_cmd,
+			struct sbp_target_request, se_cmd);
+
+	transport_generic_free_cmd(&req->se_cmd, 0);
+	return 1;
+}
+
+/*
+ * Handlers for Serial Bus Protocol 2/3 (SBP-2 / SBP-3)
+ */
+u8 sbp_get_fabric_proto_ident(struct se_portal_group *se_tpg)
+{
+	/*
+	 * Return a IEEE 1394 SCSI Protocol identifier for loopback operations
+	 * This is defined in section 7.5.1 Table 362 in spc4r17
+	 */
+	return SCSI_PROTOCOL_SBP;
+}
+
+u32 sbp_get_pr_transport_id(
+	struct se_portal_group *se_tpg,
+	struct se_node_acl *se_nacl,
+	struct t10_pr_registration *pr_reg,
+	int *format_code,
+	unsigned char *buf)
+{
+	int ret;
+
+	/*
+	 * Set PROTOCOL IDENTIFIER to 3h for SBP
+	 */
+	buf[0] = SCSI_PROTOCOL_SBP;
+	/*
+	 * From spc4r17, 7.5.4.4 TransportID for initiator ports using SCSI
+	 * over IEEE 1394
+	 */
+	ret = hex2bin(&buf[8], se_nacl->initiatorname, 8);
+	if (ret < 0)
+		pr_debug("sbp transport_id: invalid hex string\n");
+
+	/*
+	 * The IEEE 1394 Transport ID is a hardcoded 24-byte length
+	 */
+	return 24;
+}
+
+u32 sbp_get_pr_transport_id_len(
+	struct se_portal_group *se_tpg,
+	struct se_node_acl *se_nacl,
+	struct t10_pr_registration *pr_reg,
+	int *format_code)
+{
+	*format_code = 0;
+	/*
+	 * From spc4r17, 7.5.4.4 TransportID for initiator ports using SCSI
+	 * over IEEE 1394
+	 *
+	 * The SBP Transport ID is a hardcoded 24-byte length
+	 */
+	return 24;
+}
+
+/*
+ * Used for handling SCSI fabric dependent TransportIDs in SPC-3 and above
+ * Persistent Reservation SPEC_I_PT=1 and PROUT REGISTER_AND_MOVE operations.
+ */
+char *sbp_parse_pr_out_transport_id(
+	struct se_portal_group *se_tpg,
+	const char *buf,
+	u32 *out_tid_len,
+	char **port_nexus_ptr)
+{
+	/*
+	 * Assume the FORMAT CODE 00b from spc4r17, 7.5.4.4 TransportID
+	 * for initiator ports using SCSI over SBP Serial SCSI Protocol
+	 *
+	 * The TransportID for a IEEE 1394 Initiator Port is of fixed size of
+	 * 24 bytes, and IEEE 1394 does not contain a I_T nexus identifier,
+	 * so we return the **port_nexus_ptr set to NULL.
+	 */
+	*port_nexus_ptr = NULL;
+	*out_tid_len = 24;
+
+	return (char *)&buf[8];
+}
+
diff --git a/drivers/target/sbp/sbp_fabric.h b/drivers/target/sbp/sbp_fabric.h
new file mode 100644
index 0000000..eb757a0
--- /dev/null
+++ b/drivers/target/sbp/sbp_fabric.h
@@ -0,0 +1,42 @@
+
+int sbp_check_true(struct se_portal_group *);
+int sbp_check_false(struct se_portal_group *);
+char *sbp_get_fabric_name(void);
+char *sbp_get_fabric_wwn(struct se_portal_group *);
+u16 sbp_get_tag(struct se_portal_group *);
+u32 sbp_get_default_depth(struct se_portal_group *);
+struct se_node_acl *sbp_alloc_fabric_acl(struct se_portal_group *);
+void sbp_release_fabric_acl(struct se_portal_group *,
+		struct se_node_acl *);
+u32 sbp_tpg_get_inst_index(struct se_portal_group *);
+void sbp_release_cmd(struct se_cmd *se_cmd);
+int sbp_shutdown_session(struct se_session *);
+void sbp_close_session(struct se_session *);
+void sbp_stop_session(struct se_session *, int, int);
+void sbp_reset_nexus(struct se_session *);
+int sbp_sess_logged_in(struct se_session *);
+u32 sbp_sess_get_index(struct se_session *);
+int sbp_write_pending(struct se_cmd *);
+int sbp_write_pending_status(struct se_cmd *);
+void sbp_set_default_node_attrs(struct se_node_acl *);
+u32 sbp_get_task_tag(struct se_cmd *);
+int sbp_get_cmd_state(struct se_cmd *);
+int sbp_queue_data_in(struct se_cmd *);
+int sbp_queue_status(struct se_cmd *);
+int sbp_queue_tm_rsp(struct se_cmd *);
+u16 sbp_set_fabric_sense_len(struct se_cmd *, u32);
+u16 sbp_get_fabric_sense_len(void);
+int sbp_is_state_remove(struct se_cmd *);
+int sbp_check_stop_free(struct se_cmd *se_cmd);
+
+u8 sbp_get_fabric_proto_ident(struct se_portal_group *se_tpg);
+u32 sbp_get_pr_transport_id(struct se_portal_group *se_tpg,
+		struct se_node_acl *se_nacl, struct t10_pr_registration *pr_reg,
+		int *format_code, unsigned char *buf);
+u32 sbp_get_pr_transport_id_len(
+		struct se_portal_group *se_tpg, struct se_node_acl *se_nacl,
+		struct t10_pr_registration *pr_reg, int *format_code);
+char *sbp_parse_pr_out_transport_id(
+		struct se_portal_group *se_tpg, const char *buf,
+		u32 *out_tid_len, char **port_nexus_ptr);
+
-- 
1.7.9

