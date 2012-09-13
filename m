Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753364Ab2IMVaT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 17:30:19 -0400
Received: from mail.ispras.ru ([83.149.199.43]:43217 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752264Ab2IMVaR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 17:30:17 -0400
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>, linux-kernel@vger.kernel.org,
        ldv-project@ispras.ru
Subject: [PATCH] pcmcia: synclink_cs: fix potential tty NULL dereference
Date: Fri, 14 Sep 2012 01:30:06 +0400
Message-Id: <1347571806-5567-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tty_port_tty_get() can return NULL after port hangup that may happen anytime.
The patch adds checks that tty_port_tty_get() returns nonNULL around places
where tty is actually used.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/char/pcmcia/synclink_cs.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/char/pcmcia/synclink_cs.c b/drivers/char/pcmcia/synclink_cs.c
index 0a484b4..13c9747 100644
--- a/drivers/char/pcmcia/synclink_cs.c
+++ b/drivers/char/pcmcia/synclink_cs.c
@@ -891,6 +891,9 @@ static void rx_ready_async(MGSLPC_INFO *info, int tcd, struct tty_struct *tty)
 	int work = 0;
  	struct mgsl_icount *icount = &info->icount;
 
+	if (!tty)
+		return;
+
 	if (tcd) {
 		/* early termination, get FIFO count from RBCL register */
 		fifo_count = (unsigned char)(read_reg(info, CHA+RBCL) & 0x1f);
@@ -980,7 +983,7 @@ static void tx_done(MGSLPC_INFO *info, struct tty_struct *tty)
 	else
 #endif
 	{
-		if (tty->stopped || tty->hw_stopped) {
+		if (tty && (tty->stopped || tty->hw_stopped)) {
 			tx_stop(info);
 			return;
 		}
@@ -1000,7 +1003,7 @@ static void tx_ready(MGSLPC_INFO *info, struct tty_struct *tty)
 		if (!info->tx_active)
 			return;
 	} else {
-		if (tty->stopped || tty->hw_stopped) {
+		if (tty && (tty->stopped || tty->hw_stopped)) {
 			tx_stop(info);
 			return;
 		}
@@ -1050,13 +1053,12 @@ static void cts_change(MGSLPC_INFO *info, struct tty_struct *tty)
 	wake_up_interruptible(&info->status_event_wait_q);
 	wake_up_interruptible(&info->event_wait_q);
 
-	if (info->port.flags & ASYNC_CTS_FLOW) {
+	if (tty && (info->port.flags & ASYNC_CTS_FLOW)) {
 		if (tty->hw_stopped) {
 			if (info->serial_signals & SerialSignal_CTS) {
 				if (debug_level >= DEBUG_LEVEL_ISR)
 					printk("CTS tx start...");
-				if (tty)
-					tty->hw_stopped = 0;
+				tty->hw_stopped = 0;
 				tx_start(info, tty);
 				info->pending_bh |= BH_TRANSMIT;
 				return;
@@ -1065,8 +1067,7 @@ static void cts_change(MGSLPC_INFO *info, struct tty_struct *tty)
 			if (!(info->serial_signals & SerialSignal_CTS)) {
 				if (debug_level >= DEBUG_LEVEL_ISR)
 					printk("CTS tx stop...");
-				if (tty)
-					tty->hw_stopped = 1;
+				tty->hw_stopped = 1;
 				tx_stop(info);
 			}
 		}
-- 
1.7.9.5

