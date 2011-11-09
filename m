Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934176Ab1KJDXL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:23:11 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41890 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934148Ab1KJDXD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:23:03 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:27:03 2011
Message-Id: <20111109212703.799279408@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:25:57 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Nicholas Bellinger <nab@risingtidesystems.com>
Subject: [035/262] target: Fix REPORT TARGET PORT GROUPS handling with small allocation length
In-Reply-To: <20111109212847.GA20838@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicholas Bellinger <nab@linux-iscsi.org>

commit 6b20fa9aaf0c2f69ee6f9648e20ab2be0206705e upstream.

This patch fixes a bug with the handling of REPORT TARGET PORT GROUPS
containing a smaller allocation length than the payload requires causing
memory writes beyond the end of the buffer.  This patch checks for the
minimum 4 byte length for the response payload length, and also checks
upon each loop of T10_ALUA(su_dev)->tg_pt_gps_list to ensure the Target
port group and Target port descriptor list is able to fit into the
remaining allocation length.

If the response payload exceeds the allocation length length, then rd_len
is still increments to indicate to the initiator that the payload has
been truncated.

Reported-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Nicholas Bellinger <nab@risingtidesystems.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/target/target_core_alua.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

--- a/drivers/target/target_core_alua.c
+++ b/drivers/target/target_core_alua.c
@@ -60,11 +60,31 @@ int core_emulate_report_target_port_grou
 	unsigned char *buf = (unsigned char *)T_TASK(cmd)->t_task_buf;
 	u32 rd_len = 0, off = 4; /* Skip over RESERVED area to first
 				    Target port group descriptor */
+	/*
+	 * Need at least 4 bytes of response data or else we can't
+	 * even fit the return data length.
+	 */
+	if (cmd->data_length < 4) {
+		pr_warn("REPORT TARGET PORT GROUPS allocation length %u"
+			" too small\n", cmd->data_length);
+		return -EINVAL;
+	}
 
 	spin_lock(&T10_ALUA(su_dev)->tg_pt_gps_lock);
 	list_for_each_entry(tg_pt_gp, &T10_ALUA(su_dev)->tg_pt_gps_list,
 			tg_pt_gp_list) {
 		/*
+		 * Check if the Target port group and Target port descriptor list
+		 * based on tg_pt_gp_members count will fit into the response payload.
+		 * Otherwise, bump rd_len to let the initiator know we have exceeded
+		 * the allocation length and the response is truncated.
+		 */
+		if ((off + 8 + (tg_pt_gp->tg_pt_gp_members * 4)) >
+		     cmd->data_length) {
+			rd_len += 8 + (tg_pt_gp->tg_pt_gp_members * 4);
+			continue;
+		}
+		/*
 		 * PREF: Preferred target port bit, determine if this
 		 * bit should be set for port group.
 		 */


