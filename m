Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760370Ab2BOOvq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 09:51:46 -0500
Received: from kamaji.grokhost.net ([87.117.218.43]:42144 "EHLO
	kamaji.grokhost.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758369Ab2BOOuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 09:50:51 -0500
From: Chris Boot <bootc@bootc.net>
To: linux1394-devel@lists.sourceforge.net, target-devel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, agrover@redhat.com, clemens@ladisch.de,
        nab@linux-iscsi.org, stefanr@s5r6.in-berlin.de,
        Chris Boot <bootc@bootc.net>
Subject: [PATCH v2 07/11] firewire-sbp-target: add sbp_management_agent.{c,h}
Date: Wed, 15 Feb 2012 14:47:24 +0000
Message-Id: <1329317248-94128-8-git-send-email-bootc@bootc.net>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1329317248-94128-1-git-send-email-bootc@bootc.net>
References: <1328989452-20921-1-git-send-email-bootc@bootc.net>
 <1329317248-94128-1-git-send-email-bootc@bootc.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This code implements the SBP-2 Management Agent. This is the first of
two firewire address handlers that are used to communicate with the
target. The Management Agent is used to handle login, reconnect and
logout to a SCSI LUN as well as task management functions.

Signed-off-by: Chris Boot <bootc@bootc.net>
Cc: Andy Grover <agrover@redhat.com>
Cc: Clemens Ladisch <clemens@ladisch.de>
Cc: Nicholas A. Bellinger <nab@linux-iscsi.org>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/target/sbp/sbp_management_agent.c |  260 +++++++++++++++++++++++++++++
 drivers/target/sbp/sbp_management_agent.h |   23 +++
 2 files changed, 283 insertions(+), 0 deletions(-)
 create mode 100644 drivers/target/sbp/sbp_management_agent.c
 create mode 100644 drivers/target/sbp/sbp_management_agent.h

diff --git a/drivers/target/sbp/sbp_management_agent.c b/drivers/target/sbp/sbp_management_agent.c
new file mode 100644
index 0000000..04e4df8
--- /dev/null
+++ b/drivers/target/sbp/sbp_management_agent.c
@@ -0,0 +1,260 @@
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
+#include <linux/kref.h>
+
+#include <target/target_core_base.h>
+
+#include "sbp_base.h"
+#include "sbp_management_agent.h"
+#include "sbp_login.h"
+
+static void sbp_mgt_agent_process(struct work_struct *work)
+{
+	struct sbp_management_agent *agent =
+		container_of(work, struct sbp_management_agent, work);
+	struct sbp_management_request *req = agent->request;
+	int ret;
+	int status_data_len = 0;
+
+	/* fetch the ORB from the initiator */
+	ret = fw_run_transaction(req->card, TCODE_READ_BLOCK_REQUEST,
+		req->node_addr, req->generation, req->speed,
+		agent->orb_offset, &req->orb, sizeof(req->orb));
+	if (ret != RCODE_COMPLETE) {
+		pr_debug("mgt_orb fetch failed: %x\n", ret);
+		goto out;
+	}
+
+	pr_debug("mgt_orb ptr1:0x%llx ptr2:0x%llx misc:0x%x len:0x%x status_fifo:0x%llx\n",
+		sbp2_pointer_to_addr(&req->orb.ptr1),
+		sbp2_pointer_to_addr(&req->orb.ptr2),
+		be32_to_cpu(req->orb.misc), be32_to_cpu(req->orb.length),
+		sbp2_pointer_to_addr(&req->orb.status_fifo));
+
+	if (!ORB_NOTIFY(be32_to_cpu(req->orb.misc)) ||
+		ORB_REQUEST_FORMAT(be32_to_cpu(req->orb.misc)) != 0) {
+		pr_err("mgt_orb bad request\n");
+		goto out;
+	}
+
+	switch (MANAGEMENT_ORB_FUNCTION(be32_to_cpu(req->orb.misc))) {
+	case MANAGEMENT_ORB_FUNCTION_LOGIN:
+		sbp_management_request_login(agent, req, &status_data_len);
+		break;
+
+	case MANAGEMENT_ORB_FUNCTION_QUERY_LOGINS:
+		sbp_management_request_query_logins(agent, req,
+				&status_data_len);
+		break;
+
+	case MANAGEMENT_ORB_FUNCTION_RECONNECT:
+		sbp_management_request_reconnect(agent, req, &status_data_len);
+		break;
+
+	case MANAGEMENT_ORB_FUNCTION_SET_PASSWORD:
+		pr_notice("SET PASSWORD not implemented\n");
+
+		req->status.status = cpu_to_be32(
+			STATUS_BLOCK_RESP(STATUS_RESP_REQUEST_COMPLETE) |
+			STATUS_BLOCK_SBP_STATUS(SBP_STATUS_REQ_TYPE_NOTSUPP));
+
+		break;
+
+	case MANAGEMENT_ORB_FUNCTION_LOGOUT:
+		sbp_management_request_logout(agent, req, &status_data_len);
+		break;
+
+	case MANAGEMENT_ORB_FUNCTION_ABORT_TASK:
+		pr_notice("ABORT TASK not implemented\n");
+
+		req->status.status = cpu_to_be32(
+			STATUS_BLOCK_RESP(STATUS_RESP_REQUEST_COMPLETE) |
+			STATUS_BLOCK_SBP_STATUS(SBP_STATUS_REQ_TYPE_NOTSUPP));
+
+		break;
+
+	case MANAGEMENT_ORB_FUNCTION_ABORT_TASK_SET:
+		pr_notice("ABORT TASK SET not implemented\n");
+
+		req->status.status = cpu_to_be32(
+			STATUS_BLOCK_RESP(STATUS_RESP_REQUEST_COMPLETE) |
+			STATUS_BLOCK_SBP_STATUS(SBP_STATUS_REQ_TYPE_NOTSUPP));
+
+		break;
+
+	case MANAGEMENT_ORB_FUNCTION_LOGICAL_UNIT_RESET:
+		pr_notice("LOGICAL UNIT RESET not implemented\n");
+
+		req->status.status = cpu_to_be32(
+			STATUS_BLOCK_RESP(STATUS_RESP_REQUEST_COMPLETE) |
+			STATUS_BLOCK_SBP_STATUS(SBP_STATUS_REQ_TYPE_NOTSUPP));
+
+		break;
+
+	case MANAGEMENT_ORB_FUNCTION_TARGET_RESET:
+		pr_notice("TARGET RESET not implemented\n");
+
+		req->status.status = cpu_to_be32(
+			STATUS_BLOCK_RESP(STATUS_RESP_REQUEST_COMPLETE) |
+			STATUS_BLOCK_SBP_STATUS(SBP_STATUS_REQ_TYPE_NOTSUPP));
+
+		break;
+
+	default:
+		pr_notice("unknown management function 0x%x\n",
+			MANAGEMENT_ORB_FUNCTION(be32_to_cpu(req->orb.misc)));
+
+		req->status.status = cpu_to_be32(
+			STATUS_BLOCK_RESP(STATUS_RESP_REQUEST_COMPLETE) |
+			STATUS_BLOCK_SBP_STATUS(SBP_STATUS_REQ_TYPE_NOTSUPP));
+
+		break;
+	}
+
+	req->status.status |= cpu_to_be32(
+		STATUS_BLOCK_SRC(1) | /* Response to ORB, next_ORB absent */
+		STATUS_BLOCK_LEN(DIV_ROUND_UP(status_data_len, 4) + 1) |
+		STATUS_BLOCK_ORB_OFFSET_HIGH(agent->orb_offset >> 32));
+	req->status.orb_low = cpu_to_be32(agent->orb_offset);
+
+	/* write the status block back to the initiator */
+	ret = fw_run_transaction(req->card, TCODE_WRITE_BLOCK_REQUEST,
+		req->node_addr, req->generation, req->speed,
+		sbp2_pointer_to_addr(&req->orb.status_fifo),
+		&req->status, 8 + status_data_len);
+	if (ret != RCODE_COMPLETE) {
+		pr_debug("mgt_orb status write failed: %x\n", ret);
+		goto out;
+	}
+
+out:
+	fw_card_put(req->card);
+	kfree(req);
+	atomic_set(&agent->state, MANAGEMENT_AGENT_STATE_IDLE);
+}
+
+static void sbp_mgt_agent_rw(struct fw_card *card,
+	struct fw_request *request, int tcode, int destination, int source,
+	int generation, unsigned long long offset, void *data, size_t length,
+	void *callback_data)
+{
+	struct sbp_management_agent *agent = callback_data;
+	struct sbp2_pointer *ptr = data;
+
+	if (!agent->tport->enable) {
+		fw_send_response(card, request, RCODE_ADDRESS_ERROR);
+		return;
+	}
+
+	if ((offset != agent->handler.offset) || (length != 8)) {
+		fw_send_response(card, request, RCODE_ADDRESS_ERROR);
+		return;
+	}
+
+	if (tcode == TCODE_WRITE_BLOCK_REQUEST) {
+		struct sbp_management_request *req;
+		int ret;
+
+		smp_wmb();
+		if (atomic_cmpxchg(&agent->state,
+					MANAGEMENT_AGENT_STATE_IDLE,
+					MANAGEMENT_AGENT_STATE_BUSY) !=
+				MANAGEMENT_AGENT_STATE_IDLE) {
+			pr_notice("ignoring management request while busy\n");
+
+			fw_send_response(card, request, RCODE_CONFLICT_ERROR);
+			return;
+		}
+
+		req = kzalloc(sizeof(*req), GFP_ATOMIC);
+		if (!req) {
+			fw_send_response(card, request, RCODE_CONFLICT_ERROR);
+			return;
+		}
+
+		req->card = fw_card_get(card);
+		req->generation = generation;
+		req->node_addr = source;
+		req->speed = fw_get_request_speed(request);
+
+		agent->orb_offset = sbp2_pointer_to_addr(ptr);
+		agent->request = req;
+
+		ret = queue_work(sbp_workqueue, &agent->work);
+		if (!ret) {
+			/* pretend we're busy */
+			kfree(req);
+			fw_send_response(card, request, RCODE_CONFLICT_ERROR);
+			return;
+		}
+
+		fw_send_response(card, request, RCODE_COMPLETE);
+	} else if (tcode == TCODE_READ_BLOCK_REQUEST) {
+		addr_to_sbp2_pointer(agent->orb_offset, ptr);
+		fw_send_response(card, request, RCODE_COMPLETE);
+	} else {
+		fw_send_response(card, request, RCODE_TYPE_ERROR);
+	}
+}
+
+struct sbp_management_agent *sbp_management_agent_register(
+		struct sbp_tport *tport)
+{
+	int ret;
+	struct sbp_management_agent *agent;
+
+	agent = kmalloc(sizeof(*agent), GFP_KERNEL);
+	if (!agent)
+		return ERR_PTR(-ENOMEM);
+
+	agent->tport = tport;
+	agent->handler.length = 0x08;
+	agent->handler.address_callback = sbp_mgt_agent_rw;
+	agent->handler.callback_data = agent;
+	atomic_set(&agent->state, MANAGEMENT_AGENT_STATE_IDLE);
+	INIT_WORK(&agent->work, sbp_mgt_agent_process);
+	agent->orb_offset = 0;
+	agent->request = NULL;
+
+	ret = fw_core_add_address_handler(&agent->handler,
+			&sbp_register_region);
+	if (ret < 0) {
+		kfree(agent);
+		return ERR_PTR(ret);
+	}
+
+	return agent;
+}
+
+void sbp_management_agent_unregister(struct sbp_management_agent *agent)
+{
+	if (atomic_read(&agent->state) != MANAGEMENT_AGENT_STATE_IDLE)
+		flush_work_sync(&agent->work);
+
+	fw_core_remove_address_handler(&agent->handler);
+	kfree(agent);
+}
+
diff --git a/drivers/target/sbp/sbp_management_agent.h b/drivers/target/sbp/sbp_management_agent.h
new file mode 100644
index 0000000..615b90e
--- /dev/null
+++ b/drivers/target/sbp/sbp_management_agent.h
@@ -0,0 +1,23 @@
+
+struct sbp_management_agent {
+	struct sbp_tport *tport;
+	struct fw_address_handler handler;
+	atomic_t state;
+	struct work_struct work;
+	u64 orb_offset;
+	struct sbp_management_request *request;
+};
+
+struct sbp_management_request {
+	struct sbp_management_orb orb;
+	struct sbp_status_block status;
+	struct fw_card *card;
+	int generation;
+	int node_addr;
+	int speed;
+};
+
+struct sbp_management_agent *sbp_management_agent_register(
+		struct sbp_tport *tport);
+void sbp_management_agent_unregister(struct sbp_management_agent *agent);
+
-- 
1.7.9

