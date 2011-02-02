Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753602Ab1BBLBX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 06:01:23 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:50644 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753438Ab1BBLA4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 06:00:56 -0500
From: pavan_savoy@ti.com
To: linux-kernel@vger.kernel.org, gregkh@suse.de
Cc: Pavan Savoy <pavan_savoy@ti.com>
Subject: [PATCH 5/7] drivers:misc: ti-st: firmware download optimization
Date: Wed,  2 Feb 2011 05:00:46 -0600
Message-Id: <1296644448-29667-6-git-send-email-pavan_savoy@ti.com>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1296644448-29667-5-git-send-email-pavan_savoy@ti.com>
References: <1296644448-29667-1-git-send-email-pavan_savoy@ti.com>
 <1296644448-29667-2-git-send-email-pavan_savoy@ti.com>
 <1296644448-29667-3-git-send-email-pavan_savoy@ti.com>
 <1296644448-29667-4-git-send-email-pavan_savoy@ti.com>
 <1296644448-29667-5-git-send-email-pavan_savoy@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pavan Savoy <pavan_savoy@ti.com>

To fasten the process of firmware download, the chip allows
disabling of the command complete event generation from host.
In these cases, only few very essential commands would have
the command complete events and hence the wait associated with
them.

So now the driver would wait for a command complete event, only
when it comes across a wait event during firmware parsing.
This would also mean we need to skip not just the change baud
rate command but also the wait for it.

Signed-off-by: Pavan Savoy <pavan_savoy@ti.com>
---
 drivers/misc/ti-st/st_core.c |   18 +++++++++
 drivers/misc/ti-st/st_kim.c  |   80 ++++++++++++++++++++++++++++++++++++++----
 include/linux/ti_wilink_st.h |    6 +++
 3 files changed, 97 insertions(+), 7 deletions(-)

diff --git a/drivers/misc/ti-st/st_core.c b/drivers/misc/ti-st/st_core.c
index f7bb96f..dd2c879 100644
--- a/drivers/misc/ti-st/st_core.c
+++ b/drivers/misc/ti-st/st_core.c
@@ -52,6 +52,24 @@ static void remove_channel_from_table(struct st_data_s *st_gdata,
 	st_gdata->list[proto->chnl_id] = NULL;
 }
 
+/*
+ * called from KIM during firmware download.
+ *
+ * This is a wrapper function to tty->ops->write_room.
+ * It returns number of free space available in
+ * uart tx buffer.
+ */
+int st_get_uart_wr_room(struct st_data_s *st_gdata)
+{
+	struct tty_struct *tty;
+	if (unlikely(st_gdata == NULL || st_gdata->tty == NULL)) {
+		pr_err("tty unavailable to perform write");
+		return -1;
+	}
+	tty = st_gdata->tty;
+	return tty->ops->write_room(tty);
+}
+
 /* can be called in from
  * -- KIM (during fw download)
  * -- ST Core (during st_write)
diff --git a/drivers/misc/ti-st/st_kim.c b/drivers/misc/ti-st/st_kim.c
index ccc46a7..2c096cc 100644
--- a/drivers/misc/ti-st/st_kim.c
+++ b/drivers/misc/ti-st/st_kim.c
@@ -232,6 +232,26 @@ static long read_local_version(struct kim_data_s *kim_gdata, char *bts_scr_name)
 	return 0;
 }
 
+void skip_change_remote_baud(unsigned char **ptr, long *len)
+{
+	unsigned char *nxt_action, *cur_action;
+	cur_action = *ptr;
+
+	nxt_action = cur_action + sizeof(struct bts_action) +
+		((struct bts_action *) cur_action)->size;
+
+	if (((struct bts_action *) nxt_action)->type != ACTION_WAIT_EVENT) {
+		pr_err("invalid action after change remote baud command");
+	} else {
+		*ptr = *ptr + sizeof(struct bts_action) +
+			((struct bts_action *)nxt_action)->size;
+		*len = *len - (sizeof(struct bts_action) +
+				((struct bts_action *)nxt_action)->size);
+		/* warn user on not commenting these in firmware */
+		pr_warn("skipping the wait event of change remote baud");
+	}
+}
+
 /**
  * download_firmware -
  *	internal function which parses through the .bts firmware
@@ -244,6 +264,9 @@ static long download_firmware(struct kim_data_s *kim_gdata)
 	unsigned char *ptr = NULL;
 	unsigned char *action_ptr = NULL;
 	unsigned char bts_scr_name[30] = { 0 };	/* 30 char long bts scr name? */
+	int wr_room_space;
+	int cmd_size;
+	unsigned long timeout;
 
 	err = read_local_version(kim_gdata, bts_scr_name);
 	if (err != 0) {
@@ -280,13 +303,43 @@ static long download_firmware(struct kim_data_s *kim_gdata)
 			     0xFF36)) {
 				/* ignore remote change
 				 * baud rate HCI VS command */
-				pr_err
-				    (" change remote baud"
+				pr_warn("change remote baud"
 				    " rate command in firmware");
+				skip_change_remote_baud(&ptr, &len);
 				break;
 			}
+			/*
+			 * Make sure we have enough free space in uart
+			 * tx buffer to write current firmware command
+			 */
+			cmd_size = ((struct bts_action *)ptr)->size;
+			timeout = jiffies + msecs_to_jiffies(CMD_WR_TIME);
+			do {
+				wr_room_space =
+					st_get_uart_wr_room(kim_gdata->core_data);
+				if (wr_room_space < 0) {
+					pr_err("Unable to get free "
+							"space info from uart tx buffer");
+					release_firmware(kim_gdata->fw_entry);
+					return wr_room_space;
+				}
+				mdelay(1); /* wait 1ms before checking room */
+			} while ((wr_room_space < cmd_size) &&
+					time_before(jiffies, timeout));
+
+			/* Timeout happened ? */
+			if (time_after_eq(jiffies, timeout)) {
+				pr_err("Timeout while waiting for free "
+						"free space in uart tx buffer");
+				release_firmware(kim_gdata->fw_entry);
+				return -ETIMEDOUT;
+			}
 
-			INIT_COMPLETION(kim_gdata->kim_rcvd);
+			/*
+			 * Free space found in uart buffer, call st_int_write
+			 * to send current firmware command to the uart tx
+			 * buffer.
+			 */
 			err = st_int_write(kim_gdata->core_data,
 			((struct bts_action_send *)action_ptr)->data,
 					   ((struct bts_action *)ptr)->size);
@@ -294,15 +347,28 @@ static long download_firmware(struct kim_data_s *kim_gdata)
 				release_firmware(kim_gdata->fw_entry);
 				return err;
 			}
+			/*
+			 * Check number of bytes written to the uart tx buffer
+			 * and requested command write size
+			 */
+			if (err != cmd_size) {
+				pr_err("Number of bytes written to uart "
+						"tx buffer are not matching with "
+						"requested cmd write size");
+				release_firmware(kim_gdata->fw_entry);
+				return -EIO;
+			}
+			break;
+		case ACTION_WAIT_EVENT:  /* wait */
 			if (!wait_for_completion_timeout
-			    (&kim_gdata->kim_rcvd,
-			     msecs_to_jiffies(CMD_RESP_TIME))) {
-				pr_err
-				    (" response timeout during fw download ");
+					(&kim_gdata->kim_rcvd,
+					 msecs_to_jiffies(CMD_RESP_TIME))) {
+				pr_err("response timeout during fw download ");
 				/* timed out */
 				release_firmware(kim_gdata->fw_entry);
 				return -ETIMEDOUT;
 			}
+			INIT_COMPLETION(kim_gdata->kim_rcvd);
 			break;
 		case ACTION_DELAY:	/* sleep */
 			pr_info("sleep command in scr");
diff --git a/include/linux/ti_wilink_st.h b/include/linux/ti_wilink_st.h
index 010cda7..7885a77 100644
--- a/include/linux/ti_wilink_st.h
+++ b/include/linux/ti_wilink_st.h
@@ -166,6 +166,11 @@ struct st_data_s {
 	void *kim_data;
 };
 
+/*
+ * wrapper around tty->ops->write_room to check
+ * availability during firmware download
+ */
+int st_get_uart_wr_room(struct st_data_s *st_gdata);
 /**
  * st_int_write -
  * point this to tty->driver->write or tty->ops->write
@@ -208,6 +213,7 @@ void gps_chrdrv_stub_init(void);
  */
 #define LDISC_TIME	1000
 #define CMD_RESP_TIME	800
+#define CMD_WR_TIME	5000
 #define MAKEWORD(a, b)  ((unsigned short)(((unsigned char)(a)) \
 	| ((unsigned short)((unsigned char)(b))) << 8))
 
-- 
1.6.3.3

