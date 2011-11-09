Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965803Ab1KJDq3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:46:29 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44887 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965544Ab1KJDqZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:46:25 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:32:03 2011
Message-Id: <20111109213203.771270563@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:34:19 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Andy Grover <agrover@redhat.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [212/264] iscsi-target: Fix non-immediate TMR handling
In-Reply-To: <20111109213508.GA3476@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicholas Bellinger <nab@linux-iscsi.org>

commit 5a4c8666c6d576f076a7c6824589cdbb984c0f84 upstream.

This patch addresses two issues with non immediate TMR handling in
iscsit_handle_task_mgt_cmd().  The first involves breakage due to
v3.1-rc conversion of iscsit_sequence_cmd(), which upon good status
would hit the iscsit_add_reject_from_cmd() block of code.  This patch
adds an explict check for CMDSN_ERROR_CANNOT_RECOVER.

The second adds a check to return when non immediate TMR operation is
detected after iscsit_ack_from_expstatsn(), as iscsit_sequence_cmd()
-> iscsit_execute_cmd() will have called transport_generic_handle_tmr()
for the non immediate TMR case already.

Cc: Andy Grover <agrover@redhat.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/target/iscsi/iscsi_target.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -1821,17 +1821,16 @@ attach:
 		int cmdsn_ret = iscsit_sequence_cmd(conn, cmd, hdr->cmdsn);
 		if (cmdsn_ret == CMDSN_HIGHER_THAN_EXP)
 			out_of_order_cmdsn = 1;
-		else if (cmdsn_ret == CMDSN_LOWER_THAN_EXP) {
+		else if (cmdsn_ret == CMDSN_LOWER_THAN_EXP)
 			return 0;
-		} else { /* (cmdsn_ret == CMDSN_ERROR_CANNOT_RECOVER) */
+		else if (cmdsn_ret == CMDSN_ERROR_CANNOT_RECOVER)
 			return iscsit_add_reject_from_cmd(
 					ISCSI_REASON_PROTOCOL_ERROR,
 					1, 0, buf, cmd);
-		}
 	}
 	iscsit_ack_from_expstatsn(conn, hdr->exp_statsn);
 
-	if (out_of_order_cmdsn)
+	if (out_of_order_cmdsn || !(hdr->opcode & ISCSI_OP_IMMEDIATE))
 		return 0;
 	/*
 	 * Found the referenced task, send to transport for processing.


