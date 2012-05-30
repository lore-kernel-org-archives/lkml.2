Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756182Ab2E3Bmb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 21:42:31 -0400
Received: from masquerade.micron.com ([137.201.242.130]:26971 "EHLO
	masquerade.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756122Ab2E3Bma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 21:42:30 -0400
Message-ID: <4FC57B03.8000302@micron.com>
Date: Tue, 29 May 2012 18:42:27 -0700
From: Asai Thambi S P <asamymuthupa@micron.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sam Bradshaw <sbradshaw@micron.com>
Subject: [PATCH 04/11] mtip32xx: Fix to handle TFE for PIO(IOCTL/internal)
 commands
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-TM-AS-Product-Ver: SMEX-10.0.0.4152-6.800.1017-18936.003
X-TM-AS-Result: No--7.653200-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-MT-CheckInternalSenderRule: True
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


If a PIO (IOCTL/internal) command resulted in TFE, signal the wait event or break out of polling.

Signed-off-by: Asai Thambi S P <asamymuthupa@micron.com>
---
 drivers/block/mtip32xx/mtip32xx.c |   60 ++++++++++++++++++------------------
 1 files changed, 30 insertions(+), 30 deletions(-)

diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
index 8b7f82b..9fe897d 100644
--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -781,13 +781,24 @@ static void mtip_handle_tfe(struct driver_data *dd)
 
 	/* Stop the timer to prevent command timeouts. */
 	del_timer(&port->cmd_timer);
+	set_bit(MTIP_PF_EH_ACTIVE_BIT, &port->flags);
+
+	if (test_bit(MTIP_PF_IC_ACTIVE_BIT, &port->flags) &&
+			test_bit(MTIP_TAG_INTERNAL, port->allocated)) {
+		cmd = &port->commands[MTIP_TAG_INTERNAL];
+		dbg_printk(MTIP_DRV_NAME " TFE for the internal command\n");
+
+		atomic_inc(&cmd->active); /* active > 1 indicates error */
+		if (cmd->comp_data && cmd->comp_func) {
+			cmd->comp_func(port, MTIP_TAG_INTERNAL,
+					cmd->comp_data, PORT_IRQ_TF_ERR);
+		}
+		goto handle_tfe_exit;
+	}
 
 	/* clear the tag accumulator */
 	memset(tagaccum, 0, SLOTBITS_IN_LONGS * sizeof(long));
 
-	/* Set eh_active */
-	set_bit(MTIP_PF_EH_ACTIVE_BIT, &port->flags);
-
 	/* Loop through all the groups */
 	for (group = 0; group < dd->slot_groups; group++) {
 		completed = readl(port->completed[group]);
@@ -939,6 +950,7 @@ static void mtip_handle_tfe(struct driver_data *dd)
 	}
 	print_tags(dd, "reissued (TFE)", tagaccum, cmd_cnt);
 
+handle_tfe_exit:
 	/* clear eh_active */
 	clear_bit(MTIP_PF_EH_ACTIVE_BIT, &port->flags);
 	wake_up_interruptible(&port->svc_wait);
@@ -1328,22 +1340,6 @@ static int mtip_exec_internal_command(struct mtip_port *port,
 			}
 			rv = -EAGAIN;
 		}
-
-		if (readl(port->cmd_issue[MTIP_TAG_INTERNAL])
-			& (1 << MTIP_TAG_INTERNAL)) {
-			dev_warn(&port->dd->pdev->dev,
-				"Retiring internal command but CI is 1.\n");
-			if (test_bit(MTIP_DDF_REMOVE_PENDING_BIT,
-						&port->dd->dd_flag)) {
-				hba_reset_nosleep(port->dd);
-				rv = -ENXIO;
-			} else {
-				mtip_restart_port(port);
-				rv = -EAGAIN;
-			}
-			goto exec_ic_exit;
-		}
-
 	} else {
 		/* Spin for <timeout> checking if command still outstanding */
 		timeout = jiffies + msecs_to_jiffies(timeout);
@@ -1360,21 +1356,25 @@ static int mtip_exec_internal_command(struct mtip_port *port,
 				rv = -ENXIO;
 				goto exec_ic_exit;
 			}
+			if (readl(port->mmio + PORT_IRQ_STAT) & PORT_IRQ_ERR) {
+				atomic_inc(&int_cmd->active); /* error */
+				break;
+			}
 		}
+	}
 
-		if (readl(port->cmd_issue[MTIP_TAG_INTERNAL])
+	if (atomic_read(&int_cmd->active) > 1) {
+		dev_err(&port->dd->pdev->dev,
+			"Internal command [%02X] failed\n", fis->command);
+		rv = -EIO;
+	}
+	if (readl(port->cmd_issue[MTIP_TAG_INTERNAL])
 			& (1 << MTIP_TAG_INTERNAL)) {
-			dev_err(&port->dd->pdev->dev,
-				"Internal command did not complete [atomic]\n");
+		rv = -ENXIO;
+		if (!test_bit(MTIP_DDF_REMOVE_PENDING_BIT,
+					&port->dd->dd_flag)) {
+			mtip_restart_port(port);
 			rv = -EAGAIN;
-			if (test_bit(MTIP_DDF_REMOVE_PENDING_BIT,
-						&port->dd->dd_flag)) {
-				hba_reset_nosleep(port->dd);
-				rv = -ENXIO;
-			} else {
-				mtip_restart_port(port);
-				rv = -EAGAIN;
-			}
 		}
 	}
 exec_ic_exit:
-- 
1.7.1

