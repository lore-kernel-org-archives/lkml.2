Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755901Ab2DIC2k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2012 22:28:40 -0400
Received: from masquerade.micron.com ([137.201.242.130]:13256 "EHLO
	masquerade.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754522Ab2DIC2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2012 22:28:39 -0400
Message-ID: <4F824952.4000500@micron.com>
Date: Sun, 8 Apr 2012 19:28:34 -0700
From: Asai Thambi S P <asamymuthupa@micron.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg KH <greg@kroah.com>, Sam Bradshaw <sbradshaw@micron.com>
Subject: [PATCH v2 2/7] mtip32xx: make setting comp_time as common
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-TM-AS-Product-Ver: SMEX-10.0.0.4152-6.000.1038-18810.005
X-TM-AS-Result: No--5.083300-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-MT-CheckInternalSenderRule: True
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Moved setting completion time into mtip_issue_ncq_command()

Signed-off-by: Asai Thambi S P <asamymuthupa@micron.com>
---
 drivers/block/mtip32xx/mtip32xx.c |   16 +++++-----------
 1 files changed, 5 insertions(+), 11 deletions(-)

diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
index 34b395d..aaa8245 100644
--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -306,6 +306,10 @@ static inline void mtip_issue_ncq_command(struct mtip_port *port, int tag)
 			port->cmd_issue[MTIP_TAG_INDEX(tag)]);
 
 	spin_unlock_irqrestore(&port->cmd_issue_lock, flags);
+
+	/* Set the command's timeout value.*/
+	port->commands[tag].comp_time = jiffies + msecs_to_jiffies(
+					MTIP_NCQ_COMMAND_TIMEOUT_MS);
 }
 
 /*
@@ -824,10 +828,6 @@ static void mtip_handle_tfe(struct driver_data *dd)
 
 				set_bit(tag, tagaccum);
 
-				/* Update the timeout value. */
-				port->commands[tag].comp_time =
-					jiffies + msecs_to_jiffies(
-					MTIP_NCQ_COMMAND_TIMEOUT_MS);
 				/* Re-issue the command. */
 				mtip_issue_ncq_command(port, tag);
 
@@ -2204,9 +2204,7 @@ static void mtip_hw_submit_io(struct driver_data *dd, sector_t start,
 	/* Issue the command to the hardware */
 	mtip_issue_ncq_command(port, tag);
 
-	/* Set the command's timeout value.*/
-	port->commands[tag].comp_time = jiffies + msecs_to_jiffies(
-					MTIP_NCQ_COMMAND_TIMEOUT_MS);
+	return;
 }
 
 /*
@@ -2538,10 +2536,6 @@ static int mtip_service_thread(void *data)
 				/* Issue the command to the hardware */
 				mtip_issue_ncq_command(port, slot);
 
-				/* Set the command's timeout value.*/
-				port->commands[slot].comp_time = jiffies +
-				msecs_to_jiffies(MTIP_NCQ_COMMAND_TIMEOUT_MS);
-
 				clear_bit(slot, port->cmds_to_issue);
 			}
 
-- 
1.7.1

