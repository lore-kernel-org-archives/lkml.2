Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752345Ab1FCOy0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 10:54:26 -0400
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:3234 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753930Ab1FCOyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 10:54:23 -0400
Subject: [PATCH 2/2] cciss: fix potential overrun while memcpy'ing sense data
To: axboe@kernel.dk
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: mikem@beardog.cce.hp.com, akpm@linux-foundation.org, thenzl@redhat.com,
        linux-kernel@vger.kernel.org, smcameron@yahoo.com
Date: Fri, 03 Jun 2011 09:54:22 -0500
Message-ID: <20110603145422.17174.79317.stgit@beardog.cce.hp.com>
In-Reply-To: <20110603145313.17174.78662.stgit@beardog.cce.hp.com>
References: <20110603145313.17174.78662.stgit@beardog.cce.hp.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

This memcpy:

       memcpy(cmd->sense_buffer, ei->SenseInfo,
               ei->SenseLen > SCSI_SENSE_BUFFERSIZE ?
                       SCSI_SENSE_BUFFERSIZE :
                       ei->SenseLen);

The ei->SenseLen field is filled in by the Smart Array.  For requests to
logical drives, it will not exceed 32 bytes, so should be ok, but for physical
requests it depends on the target device, not the Smart Array.  It's conceivable
that this could exceed the 32 byte size of ei->SenseInfo.  In that case, the memcpy
would read past the end of ei->SenseInfo, copying data from the next command,
as if it were sense data, or, if it happened to be the very last command in the
block of allocated commands, could fall off the end of the allocated area and
crash.  I'm not aware of anyone ever encountering this behavior, but it could
conceivably happen.  This bug was found by Coverity.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/block/cciss_scsi.c |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/block/cciss_scsi.c b/drivers/block/cciss_scsi.c
index 6961002..2405412 100644
--- a/drivers/block/cciss_scsi.c
+++ b/drivers/block/cciss_scsi.c
@@ -726,6 +726,7 @@ static void complete_scsi_command(CommandList_struct *c, int timeout,
 	struct scsi_cmnd *cmd;
 	ctlr_info_t *h;
 	ErrorInfo_struct *ei;
+	unsigned long sense_data_size;
 
 	ei = c->err_info;
 
@@ -750,11 +751,14 @@ static void complete_scsi_command(CommandList_struct *c, int timeout,
 	/* printk("Scsistatus is 0x%02x\n", ei->ScsiStatus);  */
 
 	/* copy the sense data whether we need to or not. */
+	if (SCSI_SENSE_BUFFERSIZE < sizeof(ei->SenseInfo))
+		sense_data_size = SCSI_SENSE_BUFFERSIZE;
+	else
+		sense_data_size = sizeof(ei->SenseInfo);
+	if (ei->SenseLen < sense_data_size)
+		sense_data_size = ei->SenseLen;
 
-	memcpy(cmd->sense_buffer, ei->SenseInfo, 
-		ei->SenseLen > SCSI_SENSE_BUFFERSIZE ?
-			SCSI_SENSE_BUFFERSIZE : 
-			ei->SenseLen);
+	memcpy(cmd->sense_buffer, ei->SenseInfo, sense_data_size);
 	scsi_set_resid(cmd, ei->ResidualCnt);
 
 	if(ei->CommandStatus != 0) 

