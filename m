Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760415Ab2DKOV2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 10:21:28 -0400
Received: from kamaji.grokhost.net ([87.117.218.43]:54920 "EHLO
	kamaji.grokhost.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760377Ab2DKOVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 10:21:23 -0400
From: Chris Boot <bootc@bootc.net>
To: linux1394-devel@lists.sourceforge.net, target-devel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, agrover@redhat.com, clemens@ladisch.de,
        nab@linux-iscsi.org, stefanr@s5r6.in-berlin.de,
        Chris Boot <bootc@bootc.net>
Subject: [PATCH 04/11] firewire-sbp-target: Add sbp_base.h header
Date: Wed, 11 Apr 2012 15:20:36 +0100
Message-Id: <1334154043-69076-5-git-send-email-bootc@bootc.net>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1334154043-69076-1-git-send-email-bootc@bootc.net>
References: <1329317248-94128-1-git-send-email-bootc@bootc.net>
 <1334154043-69076-1-git-send-email-bootc@bootc.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This header contains defines and structures that are common to many of
the modules of the target code. This includes SBP-2 protocol structures
and constants as well as a few structs for setting up the target, LUN
login information and session setup.

Signed-off-by: Chris Boot <bootc@bootc.net>
Cc: Andy Grover <agrover@redhat.com>
Cc: Clemens Ladisch <clemens@ladisch.de>
Cc: Nicholas A. Bellinger <nab@linux-iscsi.org>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/target/sbp/sbp_base.h |  211 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 211 insertions(+)
 create mode 100644 drivers/target/sbp/sbp_base.h

diff --git a/drivers/target/sbp/sbp_base.h b/drivers/target/sbp/sbp_base.h
new file mode 100644
index 0000000..fa6a39b
--- /dev/null
+++ b/drivers/target/sbp/sbp_base.h
@@ -0,0 +1,211 @@
+#ifndef _SBP_BASE_H
+#define _SBP_BASE_H
+
+#include <linux/firewire.h>
+#include <linux/spinlock.h>
+#include <linux/types.h>
+#include <linux/workqueue.h>
+#include <target/target_core_base.h>
+
+#define SBP_VERSION  "v0.1"
+#define SBP_NAMELEN 32
+
+#define SBP_ORB_FETCH_SIZE	8
+
+#define MANAGEMENT_AGENT_STATE_IDLE	0
+#define MANAGEMENT_AGENT_STATE_BUSY	1
+
+#define ORB_NOTIFY(v)			(((v) >> 31) & 0x01)
+#define ORB_REQUEST_FORMAT(v)		(((v) >> 29) & 0x03)
+
+#define MANAGEMENT_ORB_FUNCTION(v)	(((v) >> 16) & 0x0f)
+
+#define MANAGEMENT_ORB_FUNCTION_LOGIN			0x0
+#define MANAGEMENT_ORB_FUNCTION_QUERY_LOGINS		0x1
+#define MANAGEMENT_ORB_FUNCTION_RECONNECT		0x3
+#define MANAGEMENT_ORB_FUNCTION_SET_PASSWORD		0x4
+#define MANAGEMENT_ORB_FUNCTION_LOGOUT			0x7
+#define MANAGEMENT_ORB_FUNCTION_ABORT_TASK		0xb
+#define MANAGEMENT_ORB_FUNCTION_ABORT_TASK_SET		0xc
+#define MANAGEMENT_ORB_FUNCTION_LOGICAL_UNIT_RESET	0xe
+#define MANAGEMENT_ORB_FUNCTION_TARGET_RESET		0xf
+
+#define LOGIN_ORB_EXCLUSIVE(v)		(((v) >> 28) &   0x01)
+#define LOGIN_ORB_RESERVED(v)		(((v) >> 24) &   0x0f)
+#define LOGIN_ORB_RECONNECT(v)		(((v) >> 20) &   0x0f)
+#define LOGIN_ORB_LUN(v)		(((v) >>  0) & 0xffff)
+#define LOGIN_ORB_PASSWORD_LENGTH(v)	(((v) >> 16) & 0xffff)
+#define LOGIN_ORB_RESPONSE_LENGTH(v)	(((v) >>  0) & 0xffff)
+
+#define RECONNECT_ORB_LOGIN_ID(v)	(((v) >>  0) & 0xffff)
+#define LOGOUT_ORB_LOGIN_ID(v)		(((v) >>  0) & 0xffff)
+
+#define CMDBLK_ORB_DIRECTION(v)		(((v) >> 27) &   0x01)
+#define CMDBLK_ORB_SPEED(v)		(((v) >> 24) &   0x07)
+#define CMDBLK_ORB_MAX_PAYLOAD(v)	(((v) >> 20) &   0x0f)
+#define CMDBLK_ORB_PG_TBL_PRESENT(v)	(((v) >> 19) &   0x01)
+#define CMDBLK_ORB_PG_SIZE(v)		(((v) >> 16) &   0x07)
+#define CMDBLK_ORB_DATA_SIZE(v)		(((v) >>  0) & 0xffff)
+
+#define STATUS_BLOCK_SRC(v)		(((v) &   0x03) << 30)
+#define STATUS_BLOCK_RESP(v)		(((v) &   0x03) << 28)
+#define STATUS_BLOCK_DEAD(v)		(((v) ? 1 : 0)  << 27)
+#define STATUS_BLOCK_LEN(v)		(((v) &   0x07) << 24)
+#define STATUS_BLOCK_SBP_STATUS(v)	(((v) &   0xff) << 16)
+#define STATUS_BLOCK_ORB_OFFSET_HIGH(v)	(((v) & 0xffff) <<  0)
+
+#define STATUS_SRC_ORB_CONTINUING	0
+#define STATUS_SRC_ORB_FINISHED		1
+#define STATUS_SRC_UNSOLICITED		2
+
+#define STATUS_RESP_REQUEST_COMPLETE	0
+#define STATUS_RESP_TRANSPORT_FAILURE	1
+#define STATUS_RESP_ILLEGAL_REQUEST	2
+#define STATUS_RESP_VENDOR_DEPENDENT	3
+
+#define SBP_STATUS_OK			0
+#define SBP_STATUS_REQ_TYPE_NOTSUPP	1
+#define SBP_STATUS_SPEED_NOTSUPP	2
+#define SBP_STATUS_PAGE_SIZE_NOTSUPP	3
+#define SBP_STATUS_ACCESS_DENIED	4
+#define SBP_STATUS_LUN_NOTSUPP		5
+#define SBP_STATUS_PAYLOAD_TOO_SMALL	6
+/* 7 is reserved */
+#define SBP_STATUS_RESOURCES_UNAVAIL	8
+#define SBP_STATUS_FUNCTION_REJECTED	9
+#define SBP_STATUS_LOGIN_ID_UNKNOWN	10
+#define SBP_STATUS_DUMMY_ORB_COMPLETE	11
+#define SBP_STATUS_REQUEST_ABORTED	12
+#define SBP_STATUS_UNSPECIFIED_ERROR	0xff
+
+#define AGENT_STATE_RESET	0
+#define AGENT_STATE_ACTIVE	1
+#define AGENT_STATE_SUSPENDED	2
+#define AGENT_STATE_DEAD	3
+
+struct sbp2_pointer {
+	__be32 high;
+	__be32 low;
+};
+
+struct sbp_command_block_orb {
+	struct sbp2_pointer next_orb;
+	struct sbp2_pointer data_descriptor;
+	__be32 misc;
+	u8 command_block[12];
+};
+
+struct sbp_page_table_entry {
+	__be16 segment_length;
+	__be16 segment_base_hi;
+	__be32 segment_base_lo;
+};
+
+struct sbp_management_orb {
+	struct sbp2_pointer ptr1;
+	struct sbp2_pointer ptr2;
+	__be32 misc;
+	__be32 length;
+	struct sbp2_pointer status_fifo;
+};
+
+struct sbp_status_block {
+	__be32 status;
+	__be32 orb_low;
+	u8 data[24];
+};
+
+struct sbp_login_response_block {
+	__be32 misc;
+	struct sbp2_pointer command_block_agent;
+	__be32 reconnect_hold;
+};
+
+struct sbp_login_descriptor {
+	struct sbp_session *sess;
+	struct list_head link;
+
+	struct se_lun *lun;
+
+	u64 status_fifo_addr;
+	int exclusive;
+	u16 login_id;
+
+	struct sbp_target_agent *tgt_agt;
+};
+
+struct sbp_session {
+	spinlock_t lock;
+	struct se_session *se_sess;
+	struct list_head login_list;
+	struct delayed_work maint_work;
+
+	u64 guid; /* login_owner_EUI_64 */
+	int node_id; /* login_owner_ID */
+
+	struct fw_card *card;
+	int generation;
+	int speed;
+
+	int reconnect_hold;
+	u64 reconnect_expires;
+};
+
+struct sbp_nacl {
+	/* Initiator EUI-64 */
+	u64 guid;
+	/* ASCII formatted GUID for SBP Initiator port */
+	char iport_name[SBP_NAMELEN];
+	/* Returned by sbp_make_nodeacl() */
+	struct se_node_acl se_node_acl;
+};
+
+struct sbp_tpg {
+	/* Target portal group tag for TCM */
+	u16 tport_tpgt;
+	/* Pointer back to sbp_tport */
+	struct sbp_tport *tport;
+	/* Returned by sbp_make_tpg() */
+	struct se_portal_group se_tpg;
+};
+
+struct sbp_tport {
+	/* Target Unit Identifier (EUI-64) */
+	u64 guid;
+	/* Target port name */
+	char tport_name[SBP_NAMELEN];
+	/* Returned by sbp_make_tport() */
+	struct se_wwn tport_wwn;
+
+	struct sbp_tpg *tpg;
+
+	/* FireWire unit directory */
+	struct fw_descriptor unit_directory;
+
+	/* SBP Management Agent */
+	struct sbp_management_agent *mgt_agt;
+
+	/* Parameters */
+	int enable;
+	s32 directory_id;
+	int mgt_orb_timeout;
+	int max_reconnect_timeout;
+	int max_logins_per_lun;
+};
+
+extern struct target_fabric_configfs *sbp_fabric_configfs;
+extern const struct fw_address_region sbp_register_region;
+
+static inline u64 sbp2_pointer_to_addr(const struct sbp2_pointer *ptr)
+{
+	return (u64)(be32_to_cpu(ptr->high) & 0x0000ffff) << 32 |
+		(be32_to_cpu(ptr->low) & 0xfffffffc);
+}
+
+static inline void addr_to_sbp2_pointer(u64 addr, struct sbp2_pointer *ptr)
+{
+	ptr->high = cpu_to_be32(addr >> 32);
+	ptr->low = cpu_to_be32(addr);
+}
+
+#endif
-- 
1.7.9.5

