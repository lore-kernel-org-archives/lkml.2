Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758326Ab2FGI0V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 04:26:21 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:33020 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759235Ab2FGIZe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 04:25:34 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av4EAPdk0E9bdWOb/2dsb2JhbABFhU6uToEHghkBBSMECwFGECUCJgICVwcSiA+mFJJlgSOOcIESA5UdiSOGV4Ji
X-IronPort-AV: E=Sophos;i="4.75,730,1330902000"; 
   d="scan'208";a="923788932"
From: =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>
To: gregkh@linuxfoundation.org, siglesias@igalia.com, dan.carpenter@oracle.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>
Subject: [PATCH 6/9] Staging: ipack/devices/ipoctal: remove ipoctal_config structure.
Date: Thu,  7 Jun 2012 10:24:55 +0200
Message-Id: <1339057498-5256-6-git-send-email-magomez@igalia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1339057498-5256-1-git-send-email-magomez@igalia.com>
References: <1339057498-5256-1-git-send-email-magomez@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The configuration of the communication channel is handled by the tty
abstraction, so the ipoctal_config structure has become useless and it's
only used to store values that are never accesed. Remove it.

Signed-off-by: Miguel Gómez <magomez@igalia.com>
---
 drivers/staging/ipack/devices/ipoctal.c |   11 -----------
 drivers/staging/ipack/devices/ipoctal.h |   17 -----------------
 2 files changed, 28 deletions(-)

diff --git a/drivers/staging/ipack/devices/ipoctal.c b/drivers/staging/ipack/devices/ipoctal.c
index 17aa35a..ff88800 100644
--- a/drivers/staging/ipack/devices/ipoctal.c
+++ b/drivers/staging/ipack/devices/ipoctal.c
@@ -49,7 +49,6 @@ struct ipoctal {
 	char				*buffer[NR_CHANNELS];
 	unsigned int			nb_bytes[NR_CHANNELS];
 	unsigned int			count_wr[NR_CHANNELS];
-	struct ipoctal_config		chan_config[NR_CHANNELS];
 	wait_queue_head_t		queue[NR_CHANNELS];
 	unsigned short			error_flag[NR_CHANNELS];
 	spinlock_t			lock[NR_CHANNELS];
@@ -671,22 +670,18 @@ static void ipoctal_set_termios(struct tty_struct *tty,
 		if (cflag & CRTSCTS) {
 			mr1 |= MR1_RxRTS_CONTROL_ON;
 			mr2 |= MR2_TxRTS_CONTROL_OFF | MR2_CTS_ENABLE_TX_ON;
-			ipoctal->chan_config[channel].flow_control = 1;
 		} else {
 			mr1 |= MR1_RxRTS_CONTROL_OFF;
 			mr2 |= MR2_TxRTS_CONTROL_OFF | MR2_CTS_ENABLE_TX_OFF;
-			ipoctal->chan_config[channel].flow_control = 0;
 		}
 		break;
 	case IP_OCTAL_422_ID:
 		mr1 |= MR1_RxRTS_CONTROL_OFF;
 		mr2 |= MR2_TxRTS_CONTROL_OFF | MR2_CTS_ENABLE_TX_OFF;
-		ipoctal->chan_config[channel].flow_control = 0;
 		break;
 	case IP_OCTAL_485_ID:
 		mr1 |= MR1_RxRTS_CONTROL_OFF;
 		mr2 |= MR2_TxRTS_CONTROL_ON | MR2_CTS_ENABLE_TX_OFF;
-		ipoctal->chan_config[channel].flow_control = 0;
 		break;
 	default:
 		return;
@@ -750,12 +745,6 @@ static void ipoctal_set_termios(struct tty_struct *tty,
 	ipoctal_write_io_reg(ipoctal, &ipoctal->chan_regs[channel].u.w.mr, mr2);
 	ipoctal_write_io_reg(ipoctal, &ipoctal->chan_regs[channel].u.w.csr, csr);
 
-	/* save the setup in the structure */
-	ipoctal->chan_config[channel].baud = tty_get_baud_rate(tty);
-	ipoctal->chan_config[channel].bits_per_char = cflag & CSIZE;
-	ipoctal->chan_config[channel].parity = cflag & PARENB;
-	ipoctal->chan_config[channel].stop_bits = cflag & CSTOPB;
-
 	/* Enable again the RX */
 	ipoctal_write_io_reg(ipoctal, &ipoctal->chan_regs[channel].u.w.cr,
 			     CR_ENABLE_RX);
diff --git a/drivers/staging/ipack/devices/ipoctal.h b/drivers/staging/ipack/devices/ipoctal.h
index 266f361..b3c901c 100644
--- a/drivers/staging/ipack/devices/ipoctal.h
+++ b/drivers/staging/ipack/devices/ipoctal.h
@@ -42,23 +42,6 @@ enum uart_error	{
 };
 
 /**
- * struct ipoctal_config - Serial configuration
- *
- * @baud: Baud rate
- * @stop_bits: Stop bits (1 or 2)
- * @bits_per_char: data size in bits
- * @parity
- * @flow_control: Flow control management (RTS/CTS) (0 disabled, 1 enabled)
- */
-struct ipoctal_config {
-	unsigned int baud;
-	unsigned int stop_bits;
-	unsigned int bits_per_char;
-	unsigned short parity;
-	unsigned int flow_control;
-};
-
-/**
  * struct ipoctal_stats -- Stats since last reset
  *
  * @tx: Number of transmitted bytes
-- 
1.7.9.5

