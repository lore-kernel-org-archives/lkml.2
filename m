Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755252Ab1EFAYP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 20:24:15 -0400
Received: from kroah.org ([198.145.64.141]:36533 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753912Ab1EFAYK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:24:10 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May  5 17:22:05 2011
Message-Id: <20110506002205.851222803@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 05 May 2011 17:19:53 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        =?ISO-8859-15?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: [008/143] serial/imx: read cts state only after acking cts change irq
In-Reply-To: <20110506002311.GA15354@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>

commit 5680e94148a86e8c31fdc5cb0ea0d5c6810c05b0 upstream.

If cts changes between reading the level at the cts input (USR1_RTSS)
and acking the irq (USR1_RTSD) the last edge doesn't generate an irq and
uart_handle_cts_change is called with a outdated value for cts.

The race was introduced by commit

	ceca629 ([ARM] 2971/1: i.MX uart handle rts irq)

Reported-by: Arwed Springer <Arwed.Springer@de.trumpf.com>
Tested-by: Arwed Springer <Arwed.Springer@de.trumpf.com>
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/serial/imx.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/serial/imx.c
+++ b/drivers/serial/imx.c
@@ -382,12 +382,13 @@ static void imx_start_tx(struct uart_por
 static irqreturn_t imx_rtsint(int irq, void *dev_id)
 {
 	struct imx_port *sport = dev_id;
-	unsigned int val = readl(sport->port.membase + USR1) & USR1_RTSS;
+	unsigned int val;
 	unsigned long flags;
 
 	spin_lock_irqsave(&sport->port.lock, flags);
 
 	writel(USR1_RTSD, sport->port.membase + USR1);
+	val = readl(sport->port.membase + USR1) & USR1_RTSS;
 	uart_handle_cts_change(&sport->port, !!val);
 	wake_up_interruptible(&sport->port.state->port.delta_msr_wait);
 


