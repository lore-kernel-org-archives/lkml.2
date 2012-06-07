Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759833Ab2FGI1i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 04:27:38 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:34390 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756927Ab2FGIZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 04:25:31 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av4EAPdk0E9bdWOb/2dsb2JhbABFhU6uToEHghkBBSMECwFGECUCJgICVwcSiA+mFJJlgSOOcIESA5UdiSOGV4Ji
X-IronPort-AV: E=Sophos;i="4.75,730,1330902000"; 
   d="scan'208";a="923788922"
From: =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>
To: gregkh@linuxfoundation.org, siglesias@igalia.com, dan.carpenter@oracle.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>
Subject: [PATCH 7/9] Staging: ipack/devices/ipoctal: remove error_flag field from ipoctal struct.
Date: Thu,  7 Jun 2012 10:24:56 +0200
Message-Id: <1339057498-5256-7-git-send-email-magomez@igalia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1339057498-5256-1-git-send-email-magomez@igalia.com>
References: <1339057498-5256-1-git-send-email-magomez@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the error_flag field from the ipoctal structure, as the error code
is handled through the tty abstraction. Remove the values definition as well.

Signed-off-by: Miguel Gómez <magomez@igalia.com>
---
 drivers/staging/ipack/devices/ipoctal.c |    8 --------
 drivers/staging/ipack/devices/ipoctal.h |   13 -------------
 2 files changed, 21 deletions(-)

diff --git a/drivers/staging/ipack/devices/ipoctal.c b/drivers/staging/ipack/devices/ipoctal.c
index ff88800..2921467 100644
--- a/drivers/staging/ipack/devices/ipoctal.c
+++ b/drivers/staging/ipack/devices/ipoctal.c
@@ -50,7 +50,6 @@ struct ipoctal {
 	unsigned int			nb_bytes[NR_CHANNELS];
 	unsigned int			count_wr[NR_CHANNELS];
 	wait_queue_head_t		queue[NR_CHANNELS];
-	unsigned short			error_flag[NR_CHANNELS];
 	spinlock_t			lock[NR_CHANNELS];
 	unsigned int			pointer_read[NR_CHANNELS];
 	unsigned int			pointer_write[NR_CHANNELS];
@@ -275,23 +274,19 @@ static int ipoctal_irq_handler(void *arg)
 						     CR_CMD_RESET_ERR_STATUS);
 
 				if (sr & SR_OVERRUN_ERROR) {
-					ipoctal->error_flag[channel] |= UART_OVERRUN;
 					ipoctal->chan_stats[channel].overrun_err++;
 					/* Overrun doesn't affect the current character*/
 					tty_insert_flip_char(tty, 0, TTY_OVERRUN);
 				}
 				if (sr & SR_PARITY_ERROR) {
-					ipoctal->error_flag[channel] |= UART_PARITY;
 					ipoctal->chan_stats[channel].parity_err++;
 					flag = TTY_PARITY;
 				}
 				if (sr & SR_FRAMING_ERROR) {
-					ipoctal->error_flag[channel] |= UART_FRAMING;
 					ipoctal->chan_stats[channel].framing_err++;
 					flag = TTY_FRAME;
 				}
 				if (sr & SR_RECEIVED_BREAK) {
-					ipoctal->error_flag[channel] |= UART_BREAK;
 					ipoctal->chan_stats[channel].rcv_break++;
 					flag = TTY_BREAK;
 				}
@@ -493,7 +488,6 @@ static int ipoctal_inst_slot(struct ipoctal *ipoctal, unsigned int bus_nr,
 		ipoctal_reset_stats(&ipoctal->chan_stats[i]);
 		ipoctal->nb_bytes[i] = 0;
 		init_waitqueue_head(&ipoctal->queue[i]);
-		ipoctal->error_flag[i] = UART_NOERROR;
 
 		spin_lock_init(&ipoctal->lock[i]);
 		ipoctal->pointer_read[i] = 0;
@@ -552,8 +546,6 @@ static int ipoctal_write(struct ipoctal *ipoctal, unsigned int channel,
 
 	ipoctal_copy_write_buffer(ipoctal, channel, buf, count);
 
-	ipoctal->error_flag[channel] = UART_NOERROR;
-
 	/* As the IP-OCTAL 485 only supports half duplex, do it manually */
 	if (ipoctal->board_id == IP_OCTAL_485_ID) {
 		ipoctal_write_io_reg(ipoctal,
diff --git a/drivers/staging/ipack/devices/ipoctal.h b/drivers/staging/ipack/devices/ipoctal.h
index b3c901c..2aae170 100644
--- a/drivers/staging/ipack/devices/ipoctal.h
+++ b/drivers/staging/ipack/devices/ipoctal.h
@@ -29,19 +29,6 @@ enum uart_parity_e {
 };
 
 /**
- * enum uart_error - UART error type
- *
- */
-enum uart_error	{
-	UART_NOERROR = 0,      /* No error during transmission */
-	UART_TIMEOUT = 1 << 0, /* Timeout error */
-	UART_OVERRUN = 1 << 1, /* Overrun error */
-	UART_PARITY  = 1 << 2, /* Parity error */
-	UART_FRAMING = 1 << 3, /* Framing error */
-	UART_BREAK   = 1 << 4, /* Received break */
-};
-
-/**
  * struct ipoctal_stats -- Stats since last reset
  *
  * @tx: Number of transmitted bytes
-- 
1.7.9.5

