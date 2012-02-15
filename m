Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759545Ab2BOOyG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 09:54:06 -0500
Received: from kamaji.grokhost.net ([87.117.218.43]:42133 "EHLO
	kamaji.grokhost.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758132Ab2BOOuu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 09:50:50 -0500
From: Chris Boot <bootc@bootc.net>
To: linux1394-devel@lists.sourceforge.net, target-devel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, agrover@redhat.com, clemens@ladisch.de,
        nab@linux-iscsi.org, stefanr@s5r6.in-berlin.de,
        Chris Boot <bootc@bootc.net>
Subject: [PATCH v2 09/11] firewire-sbp-target: Add sbp_target_agent.{c,h}
Date: Wed, 15 Feb 2012 14:47:26 +0000
Message-Id: <1329317248-94128-10-git-send-email-bootc@bootc.net>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1329317248-94128-1-git-send-email-bootc@bootc.net>
References: <1328989452-20921-1-git-send-email-bootc@bootc.net>
 <1329317248-94128-1-git-send-email-bootc@bootc.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This implements the SBP-2 Command Block Agent, or Target Agent. This is
what receives SCSI commands and forwards them to the target framework.

Signed-off-by: Chris Boot <bootc@bootc.net>
Cc: Andy Grover <agrover@redhat.com>
Cc: Clemens Ladisch <clemens@ladisch.de>
Cc: Nicholas A. Bellinger <nab@linux-iscsi.org>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/target/sbp/sbp_target_agent.c |  356 +++++++++++++++++++++++++++++++++
 drivers/target/sbp/sbp_target_agent.h |   27 +++
 2 files changed, 383 insertions(+), 0 deletions(-)
 create mode 100644 drivers/target/sbp/sbp_target_agent.c
 create mode 100644 drivers/target/sbp/sbp_target_agent.h

diff --git a/drivers/target/sbp/sbp_target_agent.c b/drivers/target/sbp/sbp_target_agent.c
new file mode 100644
index 0000000..66b0b78
--- /dev/null
+++ b/drivers/target/sbp/sbp_target_agent.c
@@ -0,0 +1,356 @@
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
+#include <linux/firewire.h>
+#include <linux/firewire-constants.h>
+#include <linux/slab.h>
+
+#include <target/target_core_base.h>
+
+#include "sbp_base.h"
+#include "sbp_management_agent.h"
+#include "sbp_login.h"
+#include "sbp_target_agent.h"
+#include "sbp_scsi_cmnd.h"
+
+static int tgt_agent_rw_agent_state(struct fw_card *card,
+	int tcode, int generation, void *data,
+	struct sbp_target_agent *agent)
+{
+	__be32 state;
+
+	switch (tcode) {
+	case TCODE_READ_QUADLET_REQUEST:
+		pr_debug("tgt_agent AGENT_STATE READ\n");
+
+		state = cpu_to_be32(atomic_read(&agent->state));
+		memcpy(data, &state, sizeof(state));
+
+		return RCODE_COMPLETE;
+	
+	case TCODE_WRITE_QUADLET_REQUEST:
+		/* ignored */
+		return RCODE_COMPLETE;
+
+	default:
+		return RCODE_TYPE_ERROR;
+	}
+}
+
+static int tgt_agent_rw_agent_reset(struct fw_card *card,
+	int tcode, int generation, void *data,
+	struct sbp_target_agent *agent)
+{
+	switch (tcode) {
+	case TCODE_WRITE_QUADLET_REQUEST:
+		pr_debug("tgt_agent AGENT_RESET\n");
+		atomic_set(&agent->state, AGENT_STATE_RESET);
+		return RCODE_COMPLETE;
+
+	default:
+		return RCODE_TYPE_ERROR;
+	}
+}
+
+static int tgt_agent_rw_orb_pointer(struct fw_card *card,
+	int tcode, int generation, void *data,
+	struct sbp_target_agent *agent)
+{
+	struct sbp2_pointer *ptr = data;
+	int ret;
+
+	switch (tcode) {
+	case TCODE_WRITE_BLOCK_REQUEST:
+		smp_wmb();
+		atomic_cmpxchg(&agent->state,
+				AGENT_STATE_RESET, AGENT_STATE_SUSPENDED);
+		smp_wmb();
+		if (atomic_cmpxchg(&agent->state,
+					AGENT_STATE_SUSPENDED,
+					AGENT_STATE_ACTIVE)
+				!= AGENT_STATE_SUSPENDED)
+			return RCODE_CONFLICT_ERROR;
+		smp_wmb();
+
+		agent->orb_pointer = sbp2_pointer_to_addr(ptr);
+
+		pr_debug("tgt_agent ORB_POINTER write: 0x%llx\n",
+			agent->orb_pointer);
+
+		ret = queue_work(sbp_workqueue, &agent->work);
+		if (!ret)
+			return RCODE_CONFLICT_ERROR;
+
+		return RCODE_COMPLETE;
+
+	case TCODE_READ_BLOCK_REQUEST:
+		pr_debug("tgt_agent ORB_POINTER READ\n");
+		addr_to_sbp2_pointer(agent->orb_pointer, ptr);
+		return RCODE_COMPLETE;
+
+	default:
+		return RCODE_TYPE_ERROR;
+	}
+}
+
+static int tgt_agent_rw_doorbell(struct fw_card *card,
+	int tcode, int generation, void *data,
+	struct sbp_target_agent *agent)
+{
+	int ret;
+
+	switch (tcode) {
+	case TCODE_WRITE_QUADLET_REQUEST:
+		smp_wmb();
+		if (atomic_cmpxchg(&agent->state,
+					AGENT_STATE_SUSPENDED,
+					AGENT_STATE_ACTIVE)
+				!= AGENT_STATE_SUSPENDED)
+			return RCODE_CONFLICT_ERROR;
+		smp_wmb();
+
+		pr_debug("tgt_agent DOORBELL\n");
+
+		ret = queue_work(sbp_workqueue, &agent->work);
+		if (!ret)
+			return RCODE_CONFLICT_ERROR;
+
+		return RCODE_COMPLETE;
+
+	case TCODE_READ_QUADLET_REQUEST:
+		return RCODE_COMPLETE;
+	
+	default:
+		return RCODE_TYPE_ERROR;
+	}
+}
+
+static int tgt_agent_rw_unsolicited_status_enable(struct fw_card *card,
+	int tcode, int generation, void *data,
+	struct sbp_target_agent *agent)
+{
+	switch (tcode) {
+	case TCODE_WRITE_QUADLET_REQUEST:
+		pr_debug("tgt_agent UNSOLICITED_STATUS_ENABLE\n");
+		atomic_set(&agent->login->unsolicited_status_enable, 1);
+		return RCODE_COMPLETE;
+
+	case TCODE_READ_QUADLET_REQUEST:
+		return RCODE_COMPLETE;
+
+	default:
+		return RCODE_TYPE_ERROR;
+	}
+}
+
+static void tgt_agent_rw(struct fw_card *card,
+	struct fw_request *request, int tcode, int destination, int source,
+	int generation, unsigned long long offset, void *data, size_t length,
+	void *callback_data)
+{
+	struct sbp_target_agent *agent = callback_data;
+	int rcode = RCODE_ADDRESS_ERROR;
+
+	/* turn offset into the offset from the start of the block */
+	offset -= agent->handler.offset;
+
+	if (source != agent->login->sess->node_id) {
+		pr_notice("ignoring request from foreign node (%x != %x)\n",
+				source, agent->login->sess->node_id);
+		fw_send_response(card, request, RCODE_TYPE_ERROR);
+		return;
+	}
+
+	if (offset == 0x00 && length == 4) {
+		/* AGENT_STATE */
+		rcode = tgt_agent_rw_agent_state(card, tcode,
+			generation, data, agent);
+	} else if (offset == 0x04 && length == 4) {
+		/* AGENT_RESET */
+		rcode = tgt_agent_rw_agent_reset(card, tcode,
+			generation, data, agent);
+	} else if (offset == 0x08 && length == 8) {
+		/* ORB_POINTER */
+		rcode = tgt_agent_rw_orb_pointer(card, tcode,
+			generation, data, agent);
+	} else if (offset == 0x10 && length == 4) {
+		/* DOORBELL */
+		rcode = tgt_agent_rw_doorbell(card, tcode,
+			generation, data, agent);
+	} else if (offset == 0x14 && length == 4) {
+		/* UNSOLICITED_STATUS_ENABLE */
+		rcode = tgt_agent_rw_unsolicited_status_enable(card, tcode,
+			generation, data, agent);
+	}
+
+	fw_send_response(card, request, rcode);
+}
+
+static void tgt_agent_process_work(struct work_struct *work)
+{
+	struct sbp_target_request *req =
+		container_of(work, struct sbp_target_request, work);
+
+	switch (ORB_REQUEST_FORMAT(be32_to_cpu(req->orb.misc))) {
+	case 0:/* Format specified by this standard */
+		sbp_handle_command(req);
+		return;
+	case 1: /* Reserved for future standardization */
+	case 2: /* Vendor-dependent */
+		req->status.status |= cpu_to_be32(
+			STATUS_BLOCK_RESP(STATUS_RESP_REQUEST_COMPLETE) |
+			STATUS_BLOCK_DEAD(0) |
+			STATUS_BLOCK_LEN(1) |
+			STATUS_BLOCK_SBP_STATUS(SBP_STATUS_REQ_TYPE_NOTSUPP));
+		sbp_send_status(req);
+		sbp_free_request(req);
+		return;
+	case 3: /* Dummy ORB */
+		req->status.status |= cpu_to_be32(
+			STATUS_BLOCK_RESP(STATUS_RESP_REQUEST_COMPLETE) |
+			STATUS_BLOCK_DEAD(0) |
+			STATUS_BLOCK_LEN(1) |
+			STATUS_BLOCK_SBP_STATUS(SBP_STATUS_DUMMY_ORB_COMPLETE));
+		sbp_send_status(req);
+		sbp_free_request(req);
+		return;
+	default:
+		BUG();
+	}
+}
+
+static void tgt_agent_fetch_work(struct work_struct *work)
+{
+	struct sbp_target_agent *agent =
+		container_of(work, struct sbp_target_agent, work);
+	struct sbp_session *sess = agent->login->sess;
+	struct sbp_target_request *req;
+	int ret;
+
+	smp_rmb();
+	if (atomic_read(&agent->state) != AGENT_STATE_ACTIVE)
+		return;
+
+	req = kzalloc(sizeof(*req), GFP_KERNEL);
+	if (!req) {
+		atomic_cmpxchg(&agent->state, AGENT_STATE_ACTIVE,
+				AGENT_STATE_DEAD);
+		return;
+	}
+
+	req->agent = agent;
+	req->orb_pointer = agent->orb_pointer;
+	req->status.status = cpu_to_be32(
+			STATUS_BLOCK_ORB_OFFSET_HIGH(req->orb_pointer >> 32));
+	req->status.orb_low = cpu_to_be32(agent->orb_pointer & 0xfffffffc);
+	INIT_WORK(&req->work, tgt_agent_process_work);
+
+	/* read in the ORB */
+	ret = fw_run_transaction(sess->card, TCODE_READ_BLOCK_REQUEST,
+		sess->node_id, sess->generation, sess->speed,
+		req->orb_pointer, &req->orb, sizeof(req->orb));
+	if (ret != RCODE_COMPLETE) {
+		pr_debug("tgt_orb fetch failed: %x\n", ret);
+		req->status.status |= cpu_to_be32(
+			STATUS_BLOCK_RESP(STATUS_RESP_TRANSPORT_FAILURE) |
+			STATUS_BLOCK_DEAD(1) |
+			STATUS_BLOCK_LEN(1) |
+			STATUS_BLOCK_SBP_STATUS(SBP_STATUS_UNSPECIFIED_ERROR));
+		sbp_send_status(req);
+		sbp_free_request(req);
+		atomic_cmpxchg(&agent->state, AGENT_STATE_ACTIVE,
+				AGENT_STATE_DEAD);
+		return;
+	}
+
+	pr_debug("tgt_orb ptr:0x%llx next_orb:0x%llx data_descriptor:0x%llx misc:0x%x\n",
+			req->orb_pointer,
+			sbp2_pointer_to_addr(&req->orb.next_orb),
+			sbp2_pointer_to_addr(&req->orb.data_descriptor),
+			be32_to_cpu(req->orb.misc));
+
+	if (req->orb_pointer >> 32)
+		pr_debug("ORB with high bits set\n");
+
+	if (be32_to_cpu(req->orb.next_orb.high) & 0x80000000) {
+		/* NULL next-ORB */
+		req->status.status |= cpu_to_be32(
+				STATUS_BLOCK_SRC(STATUS_SRC_ORB_FINISHED));
+	} else {
+		/* non-NULL next-ORB */
+		req->status.status |= cpu_to_be32(
+				STATUS_BLOCK_SRC(STATUS_SRC_ORB_CONTINUING));
+	}
+
+	queue_work(sbp_workqueue, &req->work);
+
+	/* check if we should carry on processing */
+	if (be32_to_cpu(req->orb.next_orb.high) & 0x80000000) {
+		/* null next_orb */
+		atomic_cmpxchg(&agent->state, AGENT_STATE_ACTIVE,
+				AGENT_STATE_SUSPENDED);
+	} else {
+		pr_debug("non-NULL next-ORB\n");
+		agent->orb_pointer = sbp2_pointer_to_addr(&req->orb.next_orb);
+		queue_work(sbp_workqueue, &agent->work);
+	}
+}
+
+struct sbp_target_agent *sbp_target_agent_register(
+		struct sbp_login_descriptor *login)
+{
+	struct sbp_target_agent *agent;
+	int ret;
+
+	agent = kmalloc(sizeof(*agent), GFP_KERNEL);
+	if (!agent)
+		return ERR_PTR(-ENOMEM);
+
+	agent->handler.length = 0x20;
+	agent->handler.address_callback = tgt_agent_rw;
+	agent->handler.callback_data = agent;
+
+	agent->login = login;
+	atomic_set(&agent->state, AGENT_STATE_RESET);
+	INIT_WORK(&agent->work, tgt_agent_fetch_work);
+	agent->orb_pointer = (u64)-1;
+
+	ret = fw_core_add_address_handler(&agent->handler,
+		&sbp_register_region);
+	if (ret < 0) {
+		kfree(agent);
+		return ERR_PTR(ret);
+	}
+
+	return agent;
+}
+
+void sbp_target_agent_unregister(struct sbp_target_agent *agent)
+{
+	if (atomic_read(&agent->state) == AGENT_STATE_ACTIVE)
+		flush_work_sync(&agent->work);
+
+	fw_core_remove_address_handler(&agent->handler);
+	kfree(agent);
+}
+
diff --git a/drivers/target/sbp/sbp_target_agent.h b/drivers/target/sbp/sbp_target_agent.h
new file mode 100644
index 0000000..cddcc2f
--- /dev/null
+++ b/drivers/target/sbp/sbp_target_agent.h
@@ -0,0 +1,27 @@
+
+struct sbp_target_agent {
+	struct fw_address_handler handler;
+	struct sbp_login_descriptor *login;
+	atomic_t state;
+	struct work_struct work;
+	u64 orb_pointer;
+};
+
+struct sbp_target_request {
+	struct sbp_target_agent *agent;
+	u64 orb_pointer;
+	struct sbp_command_block_orb orb;
+	struct sbp_status_block status;
+	struct work_struct work;
+
+	struct se_cmd se_cmd;
+	struct sbp_page_table_entry *pg_tbl;
+	void *cmd_buf;
+	void *data_buf;
+
+	unsigned char sense_buf[TRANSPORT_SENSE_BUFFER];
+};
+
+struct sbp_target_agent *sbp_target_agent_register(
+		struct sbp_login_descriptor *login);
+void sbp_target_agent_unregister(struct sbp_target_agent *agent);
-- 
1.7.9

