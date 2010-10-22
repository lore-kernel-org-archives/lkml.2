Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753840Ab0JVSdd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 14:33:33 -0400
Received: from kroah.org ([198.145.64.141]:37723 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758826Ab0JVSYp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:24:45 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Volker Ernst <volker.ernst@txtr.com>, Daniel Mack <daniel@caiaq.de>,
        Andy Green <andy@warmcat.com>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 46/49] serial/imx: check that the buffer is non-empty before sending it out
Date: Fri, 22 Oct 2010 11:21:25 -0700
Message-Id: <1287771688-14805-46-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20101022175112.GC13489@kroah.com>
References: <20101022175112.GC13489@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Volker Ernst <volker.ernst@txtr.com>

The .start_tx callback (imx_start_tx here) isn't only called when the
buffer is non-empty.  E.g. after resume or when handshaking is enabled
and the other side starts to signal being ready.

So check for an empty puffer already before sending the first character.
This prevents sending out stale (or uninitialised) data.

Signed-off-by: Volker Ernst <volker.ernst@txtr.com>
Signed-off-by: Daniel Mack <daniel@caiaq.de>
Cc: Andy Green <andy@warmcat.com>
[ukl: reword commit log, put check in while condition]
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/serial/imx.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/serial/imx.c b/drivers/serial/imx.c
index 66ecc7a..dfcf4b1 100644
--- a/drivers/serial/imx.c
+++ b/drivers/serial/imx.c
@@ -327,14 +327,13 @@ static inline void imx_transmit_buffer(struct imx_port *sport)
 {
 	struct circ_buf *xmit = &sport->port.state->xmit;
 
-	while (!(readl(sport->port.membase + UTS) & UTS_TXFULL)) {
+	while (!uart_circ_empty(xmit) &&
+			!(readl(sport->port.membase + UTS) & UTS_TXFULL)) {
 		/* send xmit->buf[xmit->tail]
 		 * out the port here */
 		writel(xmit->buf[xmit->tail], sport->port.membase + URTX0);
 		xmit->tail = (xmit->tail + 1) & (UART_XMIT_SIZE - 1);
 		sport->port.icount.tx++;
-		if (uart_circ_empty(xmit))
-			break;
 	}
 
 	if (uart_circ_chars_pending(xmit) < WAKEUP_CHARS)
-- 
1.7.2

