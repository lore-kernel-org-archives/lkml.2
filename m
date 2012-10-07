Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755084Ab2JGXrd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 19:47:33 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38156 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752742Ab2JGXV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 19:21:57 -0400
Message-Id: <20121007225834.878055665@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 07 Oct 2012 23:58:35 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Roland Dreier <roland@purestorage.com>, Christoph Hellwig <hch@lst.de>,
        Boaz Harrosh <bharrosh@panasas.com>
Subject: [ 001/108] target: Fix ->data_length re-assignment bug with SCSI overflow
In-Reply-To: <20121007225834.673681075@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicholas Bellinger <nab@linux-iscsi.org>

commit 4c054ba63ad47ef244cfcfa1cea38134620a5bae upstream.

This patch fixes a long-standing bug with SCSI overflow handling
where se_cmd->data_length was incorrectly being re-assigned to
the larger CDB extracted allocation length, resulting in a number
of fabric level errors that would end up causing a session reset
in most cases.  So instead now:

 - Only re-assign se_cmd->data_length durining UNDERFLOW (to use the
   smaller value)
 - Use existing se_cmd->data_length for OVERFLOW (to use the smaller
   value)

This fix has been tested with the following CDB to generate an
SCSI overflow:

  sg_raw -r512 /dev/sdc 28 0 0 0 0 0 0 0 9 0

Tested using iscsi-target, tcm_qla2xxx, loopback and tcm_vhost fabric
ports.  Here is a bit more detail on each case:

 - iscsi-target: Bug with open-iscsi with overflow, sg_raw returns
                 -3584 bytes of data.
 - tcm_qla2xxx: Working as expected, returnins 512 bytes of data
 - loopback: sg_raw returns CHECK_CONDITION, from overflow rejection
             in transport_generic_map_mem_to_cmd()
 - tcm_vhost: Same as loopback

Reported-by: Roland Dreier <roland@purestorage.com>
Cc: Roland Dreier <roland@purestorage.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Boaz Harrosh <bharrosh@panasas.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/target/target_core_transport.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -3039,15 +3039,20 @@ static int transport_generic_cmd_sequenc
 			/* Returns CHECK_CONDITION + INVALID_CDB_FIELD */
 			goto out_invalid_cdb_field;
 		}
-
+		/*
+		 * For the overflow case keep the existing fabric provided
+		 * ->data_length.  Otherwise for the underflow case, reset
+		 * ->data_length to the smaller SCSI expected data transfer
+		 * length.
+		 */
 		if (size > cmd->data_length) {
 			cmd->se_cmd_flags |= SCF_OVERFLOW_BIT;
 			cmd->residual_count = (size - cmd->data_length);
 		} else {
 			cmd->se_cmd_flags |= SCF_UNDERFLOW_BIT;
 			cmd->residual_count = (cmd->data_length - size);
+			cmd->data_length = size;
 		}
-		cmd->data_length = size;
 	}
 
 	/* reject any command that we don't have a handler for */


