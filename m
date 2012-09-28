Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423033Ab2I1Vnw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 17:43:52 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55300 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032363Ab2I1UZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:25:47 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        =?UTF-8?q?Beno=C3=AEt=20Locher?= <Benoit.Locher@skf.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: =?UTF-8?q?=5B=20080/218=5D=20can=3A=20mcp251x=3A=20avoid=20repeated=20frame=20bug?=
Date: Fri, 28 Sep 2012 13:14:57 -0700
Message-Id: <20120928201510.745148252@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928201501.208384923@linuxfoundation.org>
References: <20120928201501.208384923@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benoît Locher <Benoit.Locher@skf.com>

commit cab32f39dcc5b35db96497dc0a026b5dea76e4e7 upstream.

The MCP2515 has a silicon bug causing repeated frame transmission, see section
5 of MCP2515 Rev. B Silicon Errata Revision G (March 2007).

Basically, setting TXBnCTRL.TXREQ in either SPI mode (00 or 11) will eventually
cause the bug. The workaround proposed by Microchip is to use mode 00 and send
a RTS command on the SPI bus to initiate the transmission.

Signed-off-by: Benoît Locher <Benoit.Locher@skf.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/can/mcp251x.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/drivers/net/can/mcp251x.c
+++ b/drivers/net/can/mcp251x.c
@@ -83,6 +83,11 @@
 #define INSTRUCTION_LOAD_TXB(n)	(0x40 + 2 * (n))
 #define INSTRUCTION_READ_RXB(n)	(((n) == 0) ? 0x90 : 0x94)
 #define INSTRUCTION_RESET	0xC0
+#define RTS_TXB0		0x01
+#define RTS_TXB1		0x02
+#define RTS_TXB2		0x04
+#define INSTRUCTION_RTS(n)	(0x80 | ((n) & 0x07))
+
 
 /* MPC251x registers */
 #define CANSTAT	      0x0e
@@ -397,6 +402,7 @@ static void mcp251x_hw_tx_frame(struct s
 static void mcp251x_hw_tx(struct spi_device *spi, struct can_frame *frame,
 			  int tx_buf_idx)
 {
+	struct mcp251x_priv *priv = dev_get_drvdata(&spi->dev);
 	u32 sid, eid, exide, rtr;
 	u8 buf[SPI_TRANSFER_BUF_LEN];
 
@@ -418,7 +424,10 @@ static void mcp251x_hw_tx(struct spi_dev
 	buf[TXBDLC_OFF] = (rtr << DLC_RTR_SHIFT) | frame->can_dlc;
 	memcpy(buf + TXBDAT_OFF, frame->data, frame->can_dlc);
 	mcp251x_hw_tx_frame(spi, buf, frame->can_dlc, tx_buf_idx);
-	mcp251x_write_reg(spi, TXBCTRL(tx_buf_idx), TXBCTRL_TXREQ);
+
+	/* use INSTRUCTION_RTS, to avoid "repeated frame problem" */
+	priv->spi_tx_buf[0] = INSTRUCTION_RTS(1 << tx_buf_idx);
+	mcp251x_spi_trans(priv->spi, 1);
 }
 
 static void mcp251x_hw_rx_frame(struct spi_device *spi, u8 *buf,


