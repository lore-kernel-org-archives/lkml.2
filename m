Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755197Ab0JYLor (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 07:44:47 -0400
Received: from static-64-22-42-202.albyny.csvoip.net ([64.22.42.202]:5340 "EHLO
	svr3.sixnetio.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752729Ab0JYLoq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 07:44:46 -0400
Content-class: urn:content-classes:message
Subject: RE: [PATCH] macb: Don't re-enable interrupts while in polling mode
MIME-Version: 1.0
Date: Mon, 25 Oct 2010 07:44:22 -0400
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <C8F551D39A7C724E987CF8DD11D3178304D7CC86@svr3.sixnetio.com>
X-MimeOLE: Produced By Microsoft Exchange V6.5
In-Reply-To: <20101024.152306.48512783.davem@davemloft.net>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] macb: Don't re-enable interrupts while in polling mode
Thread-Index: ActzyfAkTBQI7TVDRU6wYMkHQ30e2QAbpxkg
References: <C8F551D39A7C724E987CF8DD11D3178304D02F88@svr3.sixnetio.com> <20101024.152306.48512783.davem@davemloft.net>
From: "Joshua Hoke" <Joshua.Hoke@sixnet.com>
To: "David Miller" <davem@davemloft.net>
Cc: <nicolas.ferre@atmel.com>, <jpirko@redhat.com>,
        <peter.korsgaard@barco.com>, <eric.dumazet@gmail.com>,
        <haavard.skinnemoen@atmel.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Your email client is breaking up long lines which corrupts the
> patch.
> 
> Please fix this up in your email client and resubmit.

Thanks for pointing this out. It looks fine in my sent folder but here's
a second try. In case this doesn't work, I've attached the contents to the bug as: https://bugzilla.kernel.org/attachment.cgi?id=34972

Contents of first e-mail follow, maybe not mangled this time.



From: Joshua Hoke <joshua.hoke@sixnet.com>

[PATCH] macb: Don't re-enable interrupts while in polling mode

On a busy network, the macb driver could get stuck in the interrupt
handler, quickly triggering the watchdog, due to a confluence of
factors:

 1. macb_poll re-enables interrupts unconditionally, even when it will
    be called again because it exhausted its rx budget

 2. macb_interrupt only disables interrupts after scheduling
    macb_poll, but scheduling fails when macb_poll is already scheduled
    because it didn't call napi_complete

 3. macb_interrupt loops until the interrupt status register is clear,
    which will never happen in this case if the driver doesn't disable
    the RX interrupt

Since macb_interrupt runs in interrupt context, this effectively locks
up the machine, triggering the hardware watchdog.

This issue was readily reproducible on a flooded network with a
modified 2.6.27.48 kernel. The same problem appears to still be in the
2.6.36-rc8 driver code, so I am submitting this patch against that
version. I have not tested this version of the patch except to make
sure the kernel compiles.

Signed-off-by: Joshua Hoke <joshua.hoke@sixnet.com>

---

I'm submitting this at the request of Andrew Morton in this bug:

  https://bugzilla.kernel.org/show_bug.cgi?id=20732

This version of the patch applies to 2.6.36-rc8 but has not been
tested. In particular I am assuming that napi_schedule_prep() behaves
the same as netif_rx_schedule_prep() did by failing when the macb_poll
callback is already scheduled.

diff --git a/drivers/net/macb.c b/drivers/net/macb.c
index ff2f158..36cf594 100644
--- a/drivers/net/macb.c
+++ b/drivers/net/macb.c
@@ -515,14 +515,15 @@ static int macb_poll(struct napi_struct *napi, int budget)
 		(unsigned long)status, budget);
 
 	work_done = macb_rx(bp, budget);
-	if (work_done < budget)
+	if (work_done < budget) {
 		napi_complete(napi);
 
-	/*
-	 * We've done what we can to clean the buffers. Make sure we
-	 * get notified when new packets arrive.
-	 */
-	macb_writel(bp, IER, MACB_RX_INT_FLAGS);
+		/*
+		 * We've done what we can to clean the buffers. Make sure we
+		 * get notified when new packets arrive.
+		 */
+		macb_writel(bp, IER, MACB_RX_INT_FLAGS);
+	}
 
 	/* TODO: Handle errors */
 
@@ -550,12 +551,16 @@ static irqreturn_t macb_interrupt(int irq, void *dev_id)
 		}
 
 		if (status & MACB_RX_INT_FLAGS) {
+			/*
+			 * There's no point taking any more interrupts
+			 * until we have processed the buffers. The
+			 * scheduling call may fail if the poll routine
+			 * is already scheduled, so disable interrupts
+			 * now.
+			 */
+			macb_writel(bp, IDR, MACB_RX_INT_FLAGS);
+
 			if (napi_schedule_prep(&bp->napi)) {
-				/*
-				 * There's no point taking any more interrupts
-				 * until we have processed the buffers
-				 */
-				macb_writel(bp, IDR, MACB_RX_INT_FLAGS);
 				dev_dbg(&bp->pdev->dev,
 					"scheduling RX softirq\n");
 				__napi_schedule(&bp->napi);
