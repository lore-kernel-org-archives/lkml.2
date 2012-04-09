Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756570Ab2DICaX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2012 22:30:23 -0400
Received: from masquerade.micron.com ([137.201.242.130]:31997 "EHLO
	masquerade.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755517Ab2DICaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2012 22:30:20 -0400
Message-ID: <4F8249B3.2020002@micron.com>
Date: Sun, 8 Apr 2012 19:30:11 -0700
From: Asai Thambi S P <asamymuthupa@micron.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg KH <greg@kroah.com>, Sam Bradshaw <sbradshaw@micron.com>
Subject: [PATCH v2 7/7] mtip32xx: dump tagmap on failure
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-TM-AS-Product-Ver: SMEX-10.0.0.4152-6.000.1038-18810.005
X-TM-AS-Result: No-2.867400-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-MT-CheckInternalSenderRule: True
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dump tagmap on failure, instead of individual tags

Signed-off-by: Asai Thambi S P <asamymuthupa@micron.com>
---
 drivers/block/mtip32xx/mtip32xx.c |   62 +++++++++++++++++++-----------------
 1 files changed, 33 insertions(+), 29 deletions(-)

diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
index 47404ef..00f9fc9 100644
--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -526,6 +526,25 @@ static void mtip_restart_port(struct mtip_port *port)
 }
 
 /*
+ * Helper function for tag logging
+ */
+static void print_tags(struct driver_data *dd,
+			char *msg,
+			unsigned long *tagbits,
+			int cnt)
+{
+	unsigned char tagmap[128];
+	int group, tagmap_len = 0;
+
+	memset(tagmap, 0, sizeof(tagmap));
+	for (group = SLOTBITS_IN_LONGS; group > 0; group--)
+		tagmap_len = sprintf(tagmap + tagmap_len, "%016lX ",
+						tagbits[group-1]);
+	dev_warn(&dd->pdev->dev,
+			"%d command(s) %s: tagmap [%s]", cnt, msg, tagmap);
+}
+
+/*
  * Called periodically to see if any read/write commands are
  * taking too long to complete.
  *
@@ -542,7 +561,7 @@ static void mtip_timeout_function(unsigned long int data)
 	int tag, cmdto_cnt = 0;
 	unsigned int bit, group;
 	unsigned int num_command_slots = port->dd->slot_groups * 32;
-	unsigned long to;
+	unsigned long to, tagaccum[SLOTBITS_IN_LONGS];
 
 	if (unlikely(!port))
 		return;
@@ -552,6 +571,8 @@ static void mtip_timeout_function(unsigned long int data)
 			jiffies + msecs_to_jiffies(30000));
 		return;
 	}
+	/* clear the tag accumulator */
+	memset(tagaccum, 0, SLOTBITS_IN_LONGS * sizeof(long));
 
 	for (tag = 0; tag < num_command_slots; tag++) {
 		/*
@@ -569,9 +590,7 @@ static void mtip_timeout_function(unsigned long int data)
 			command = &port->commands[tag];
 			fis = (struct host_to_dev_fis *) command->command;
 
-			dev_warn(&port->dd->pdev->dev,
-				"Timeout for command tag %d\n", tag);
-
+			set_bit(tag, tagaccum);
 			cmdto_cnt++;
 			if (cmdto_cnt == 1)
 				set_bit(MTIP_PF_EH_ACTIVE_BIT, &port->flags);
@@ -608,9 +627,8 @@ static void mtip_timeout_function(unsigned long int data)
 	}
 
 	if (cmdto_cnt && !test_bit(MTIP_PF_IC_ACTIVE_BIT, &port->flags)) {
-		dev_warn(&port->dd->pdev->dev,
-			"%d commands timed out: restarting port",
-			cmdto_cnt);
+		print_tags(port->dd, "timed out", tagaccum, cmdto_cnt);
+
 		mtip_restart_port(port);
 		clear_bit(MTIP_PF_EH_ACTIVE_BIT, &port->flags);
 		wake_up_interruptible(&port->svc_wait);
@@ -733,23 +751,6 @@ static void mtip_null_completion(struct mtip_port *port,
 	return;
 }
 
-/*
- * Helper function for tag logging
- */
-static void print_tags(struct driver_data *dd,
-			char *msg,
-			unsigned long *tagbits)
-{
-	unsigned int tag, count = 0;
-
-	for (tag = 0; tag < (dd->slot_groups) * 32; tag++) {
-		if (test_bit(tag, tagbits))
-			count++;
-	}
-	if (count)
-		dev_info(&dd->pdev->dev, "%s [%i tags]\n", msg, count);
-}
-
 static int mtip_read_log_page(struct mtip_port *port, u8 page, u16 *buffer,
 				dma_addr_t buffer_dma, unsigned int sectors);
 static int mtip_get_smart_attr(struct mtip_port *port, unsigned int id,
@@ -770,6 +771,7 @@ static void mtip_handle_tfe(struct driver_data *dd)
 	u32 completed;
 	struct host_to_dev_fis *fis;
 	unsigned long tagaccum[SLOTBITS_IN_LONGS];
+	unsigned int cmd_cnt = 0;
 	unsigned char *buf;
 	char *fail_reason = NULL;
 	int fail_all_ncq_write = 0, fail_all_ncq_cmds = 0;
@@ -781,6 +783,9 @@ static void mtip_handle_tfe(struct driver_data *dd)
 	/* Stop the timer to prevent command timeouts. */
 	del_timer(&port->cmd_timer);
 
+	/* clear the tag accumulator */
+	memset(tagaccum, 0, SLOTBITS_IN_LONGS * sizeof(long));
+
 	/* Set eh_active */
 	set_bit(MTIP_PF_EH_ACTIVE_BIT, &port->flags);
 
@@ -791,9 +796,6 @@ static void mtip_handle_tfe(struct driver_data *dd)
 		/* clear completed status register in the hardware.*/
 		writel(completed, port->completed[group]);
 
-		/* clear the tag accumulator */
-		memset(tagaccum, 0, SLOTBITS_IN_LONGS * sizeof(long));
-
 		/* Process successfully completed commands */
 		for (bit = 0; bit < 32 && completed; bit++) {
 			if (!(completed & (1<<bit)))
@@ -807,6 +809,7 @@ static void mtip_handle_tfe(struct driver_data *dd)
 			cmd = &port->commands[tag];
 			if (likely(cmd->comp_func)) {
 				set_bit(tag, tagaccum);
+				cmd_cnt++;
 				atomic_set(&cmd->active, 0);
 				cmd->comp_func(port,
 					 tag,
@@ -824,7 +827,8 @@ static void mtip_handle_tfe(struct driver_data *dd)
 			}
 		}
 	}
-	print_tags(dd, "TFE tags completed:", tagaccum);
+
+	print_tags(dd, "completed (TFE)", tagaccum, cmd_cnt);
 
 	/* Restart the port */
 	mdelay(20);
@@ -934,7 +938,7 @@ static void mtip_handle_tfe(struct driver_data *dd)
 					tag);
 		}
 	}
-	print_tags(dd, "TFE tags reissued:", tagaccum);
+	print_tags(dd, "reissued (TFE)", tagaccum, cmd_cnt);
 
 	/* clear eh_active */
 	clear_bit(MTIP_PF_EH_ACTIVE_BIT, &port->flags);
-- 
1.7.1

