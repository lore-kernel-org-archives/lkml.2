Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754905Ab2LJLBQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 06:01:16 -0500
Received: from smtp3.mundo-r.com ([212.51.32.191]:36847 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753090Ab2LJLBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 06:01:12 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApgDAJtkv1BbdWObgWdsb2JhbABEg0e6ZBYOAQEWJieCHwEFJ1IQPxJXBgESiBTCKZB4A5YDiU2JbQ
From: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
To: Jens Taprogge <jens.taprogge@taprogge.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: industrypack-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org,
        Samuel Iglesias Gonsalvez <siglesias@igalia.com>
Subject: [PATCH 11/12] ipack/devices/ipoctal: add rx_enable flag
Date: Mon, 10 Dec 2012 11:50:07 +0100
Message-Id: <1355136608-22029-11-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1355136608-22029-1-git-send-email-siglesias@igalia.com>
References: <1355136608-22029-1-git-send-email-siglesias@igalia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thus, we don't enable RX when a termios setup has been called, as it could be
disabled previously.

As the control registers (Rx, Tx flags specifically) cannot be read from the
device, we keep this info in rx_enable.

Signed-off-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
---
 drivers/ipack/devices/ipoctal.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/ipack/devices/ipoctal.c b/drivers/ipack/devices/ipoctal.c
index f2284ec..3561fb52 100644
--- a/drivers/ipack/devices/ipoctal.c
+++ b/drivers/ipack/devices/ipoctal.c
@@ -43,6 +43,7 @@ struct ipoctal_channel {
 	unsigned int			board_id;
 	u8				isr_rx_rdy_mask;
 	u8				isr_tx_rdy_mask;
+	unsigned int			rx_enable;
 };
 
 struct ipoctal {
@@ -65,6 +66,7 @@ static int ipoctal_port_activate(struct tty_port *port, struct tty_struct *tty)
 	 * there is something to send
 	 */
 	iowrite8(CR_ENABLE_RX, &channel->regs->w.cr);
+	channel->rx_enable = 1;
 	return 0;
 }
 
@@ -309,6 +311,7 @@ static int ipoctal_inst_slot(struct ipoctal *ipoctal, unsigned int bus_nr,
 		}
 
 		iowrite8(CR_DISABLE_RX | CR_DISABLE_TX, &channel->regs->w.cr);
+		channel->rx_enable = 0;
 		iowrite8(CR_CMD_RESET_RX, &channel->regs->w.cr);
 		iowrite8(CR_CMD_RESET_TX, &channel->regs->w.cr);
 		iowrite8(MR1_CHRL_8_BITS | MR1_ERROR_CHAR | MR1_RxINT_RxRDY,
@@ -429,6 +432,7 @@ static int ipoctal_write_tty(struct tty_struct *tty,
 	/* As the IP-OCTAL 485 only supports half duplex, do it manually */
 	if (channel->board_id == IPACK1_DEVICE_ID_SBS_OCTAL_485) {
 		iowrite8(CR_DISABLE_RX, &channel->regs->w.cr);
+		channel->rx_enable = 0;
 		iowrite8(CR_CMD_ASSERT_RTSN, &channel->regs->w.cr);
 	}
 
@@ -588,8 +592,9 @@ static void ipoctal_set_termios(struct tty_struct *tty,
 	iowrite8(mr2, &channel->regs->w.mr);
 	iowrite8(csr, &channel->regs->w.csr);
 
-	/* Enable again the RX */
-	iowrite8(CR_ENABLE_RX, &channel->regs->w.cr);
+	/* Enable again the RX, if it was before */
+	if (channel->rx_enable)
+		iowrite8(CR_ENABLE_RX, &channel->regs->w.cr);
 }
 
 static void ipoctal_hangup(struct tty_struct *tty)
@@ -609,6 +614,7 @@ static void ipoctal_hangup(struct tty_struct *tty)
 	tty_port_hangup(&channel->tty_port);
 
 	iowrite8(CR_DISABLE_RX | CR_DISABLE_TX, &channel->regs->w.cr);
+	channel->rx_enable = 0;
 	iowrite8(CR_CMD_RESET_RX, &channel->regs->w.cr);
 	iowrite8(CR_CMD_RESET_TX, &channel->regs->w.cr);
 	iowrite8(CR_CMD_RESET_ERR_STATUS, &channel->regs->w.cr);
-- 
1.7.10.4

