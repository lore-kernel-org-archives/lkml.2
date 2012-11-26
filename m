Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756585Ab2KZSQ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 13:16:26 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47155 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756280Ab2KZRBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:01:51 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Nicholas Bellinger <nab@linux-iscsi.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 034/270] iscsi-target: Correctly set 0xffffffff field within ISCSI_OP_REJECT PDU
Date: Mon, 26 Nov 2012 14:55:24 -0200
Message-Id: <1353949160-26803-35-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicholas Bellinger <nab@linux-iscsi.org>

commit f25590f39d543272f7ae7b00d533359c8d7ff331 upstream.

This patch adds a missing iscsi_reject->ffffffff assignment within
iscsit_send_reject() code to properly follow RFC-3720 Section 10.17
Bytes 16 -> 19 for the PDU format definition of ISCSI_OP_REJECT.

We've not seen any initiators care about this bytes in practice, but
as Ronnie reported this was causing trouble with wireshark packet
decoding lets go ahead and fix this up now.

Reported-by: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/target/iscsi/iscsi_target.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index d7dcd67..d3114d1 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -3422,6 +3422,7 @@ static int iscsit_send_reject(
 	hdr->opcode		= ISCSI_OP_REJECT;
 	hdr->flags		|= ISCSI_FLAG_CMD_FINAL;
 	hton24(hdr->dlength, ISCSI_HDR_LEN);
+	hdr->ffffffff		= 0xffffffff;
 	cmd->stat_sn		= conn->stat_sn++;
 	hdr->statsn		= cpu_to_be32(cmd->stat_sn);
 	hdr->exp_cmdsn	= cpu_to_be32(conn->sess->exp_cmd_sn);
-- 
1.7.9.5

