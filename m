Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759579Ab2I1UlK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 16:41:10 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:55696 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031442Ab2I1Uk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:40:57 -0400
X-Sasl-enc: QNE/7LesDwRcqAWSZETmuGlrU9rF5Lm2aSjc1N27yVhf 1348864856
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Roland Dreier <roland@purestorage.com>, Christoph Hellwig <hch@lst.de>,
        Boaz Harrosh <bharrosh@panasas.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [ 030/127] target: Fix ->data_length re-assignment bug with SCSI overflow
Date: Fri, 28 Sep 2012 13:33:23 -0700
Message-Id: <20120928203049.364428798@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928203045.835238916@linuxfoundation.org>
References: <20120928203045.835238916@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/target/target_core_transport.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -3672,15 +3672,20 @@ static int transport_generic_cmd_sequenc
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
 
 	transport_set_supported_SAM_opcode(cmd);


