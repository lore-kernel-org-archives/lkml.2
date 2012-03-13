Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758912Ab2CMAve (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:51:34 -0400
Received: from mail.windriver.com ([147.11.1.11]:48040 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758841Ab2CMAXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:23:07 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 092/196] serial/imx: read cts state only after acking cts change irq
Date: Mon, 12 Mar 2012 20:20:05 -0400
Message-Id: <1331598109-31424-47-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
 <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 5680e94148a86e8c31fdc5cb0ea0d5c6810c05b0 upstream.

If cts changes between reading the level at the cts input (USR1_RTSS)
and acking the irq (USR1_RTSD) the last edge doesn't generate an irq and
uart_handle_cts_change is called with a outdated value for cts.

The race was introduced by commit

	ceca629 ([ARM] 2971/1: i.MX uart handle rts irq)

[PG: file in drivers/serial not drivers/tty/serial in .34]

Reported-by: Arwed Springer <Arwed.Springer@de.trumpf.com>
Tested-by: Arwed Springer <Arwed.Springer@de.trumpf.com>
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/serial/imx.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/serial/imx.c b/drivers/serial/imx.c
index eacb588..6d2028e 100644
--- a/drivers/serial/imx.c
+++ b/drivers/serial/imx.c
@@ -383,12 +383,13 @@ static void imx_start_tx(struct uart_port *port)
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
 
-- 
1.7.9.3

