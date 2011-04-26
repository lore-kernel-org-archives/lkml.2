Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932584Ab1DZVUj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 17:20:39 -0400
Received: from mga14.intel.com ([143.182.124.37]:1640 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932512Ab1DZVPB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 17:15:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,270,1301900400"; 
   d="scan'208";a="425951489"
From: Andi Kleen <andi@firstfloor.org>
References: <20110426212.641772347@firstfloor.org>
In-Reply-To: <20110426212.641772347@firstfloor.org>
To: u.kleine-koenig@pengutronix.de, Arwed.Springer@de.trumpf.com,
        gregkh@suse.de, ak@linux.intel.com, linux-kernel@vger.kernel.org,
        stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [90/106] serial/imx: read cts state only after acking cts change irq
Message-Id: <20110426211412.676AE3E1886@tassilo.jf.intel.com>
Date: Tue, 26 Apr 2011 14:14:12 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/serial/imx.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux-2.6.35.y/drivers/serial/imx.c
===================================================================
--- linux-2.6.35.y.orig/drivers/serial/imx.c
+++ linux-2.6.35.y/drivers/serial/imx.c
@@ -383,12 +383,13 @@ static void imx_start_tx(struct uart_por
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
 
