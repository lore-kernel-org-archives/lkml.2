Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754277Ab2BKTpR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Feb 2012 14:45:17 -0500
Received: from kamaji.grokhost.net ([87.117.218.43]:52765 "EHLO
	kamaji.grokhost.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002Ab2BKToW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Feb 2012 14:44:22 -0500
From: Chris Boot <bootc@bootc.net>
To: linux1394-devel@lists.sourceforge.net, target-devel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, agrover@redhat.com, clemens@ladisch.de,
        nab@linux-iscsi.org, stefanr@s5r6.in-berlin.de,
        Chris Boot <bootc@bootc.net>
Subject: [PATCH 07/13] firewire-sbp-target: Add sbp_proto.{c,h}
Date: Sat, 11 Feb 2012 19:44:06 +0000
Message-Id: <1328989452-20921-8-git-send-email-bootc@bootc.net>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1328989452-20921-1-git-send-email-bootc@bootc.net>
References: <4E4BD560.4010806@bootc.net>
 <1328989452-20921-1-git-send-email-bootc@bootc.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are functions to generate TransportID identifiers as per SPC-4
revision 17.

Signed-off-by: Chris Boot <bootc@bootc.net>
Cc: Andy Grover <agrover@redhat.com>
Cc: Clemens Ladisch <clemens@ladisch.de>
Cc: Nicholas A. Bellinger <nab@linux-iscsi.org>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/target/sbp/sbp_proto.c |  113 ++++++++++++++++++++++++++++++++++++++++
 drivers/target/sbp/sbp_proto.h |   12 ++++
 2 files changed, 125 insertions(+), 0 deletions(-)
 create mode 100644 drivers/target/sbp/sbp_proto.c
 create mode 100644 drivers/target/sbp/sbp_proto.h

diff --git a/drivers/target/sbp/sbp_proto.c b/drivers/target/sbp/sbp_proto.c
new file mode 100644
index 0000000..5744b5c
--- /dev/null
+++ b/drivers/target/sbp/sbp_proto.c
@@ -0,0 +1,113 @@
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
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <scsi/scsi.h>
+#include <target/target_core_base.h>
+
+#include "sbp_proto.h"
+
+/*
+ * Handlers for Serial Attached SCSI (SBP)
+ */
+u8 sbp_get_fabric_proto_ident(struct se_portal_group *se_tpg)
+{
+	/*
+	 * Return a IEEE 1394 SCSI Protocol identifier for loopback operations
+	 * This is defined in section 7.5.1 Table 362 in spc4r17
+	 */
+	return SCSI_PROTOCOL_SBP;
+}
+EXPORT_SYMBOL(sbp_get_fabric_proto_ident);
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
+EXPORT_SYMBOL(sbp_get_pr_transport_id);
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
+EXPORT_SYMBOL(sbp_get_pr_transport_id_len);
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
+EXPORT_SYMBOL(sbp_parse_pr_out_transport_id);
+
diff --git a/drivers/target/sbp/sbp_proto.h b/drivers/target/sbp/sbp_proto.h
new file mode 100644
index 0000000..1bd3e16
--- /dev/null
+++ b/drivers/target/sbp/sbp_proto.h
@@ -0,0 +1,12 @@
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

