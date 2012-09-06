Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755717Ab2IFMwh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 08:52:37 -0400
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:51637 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755655Ab2IFMvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 08:51:05 -0400
From: Felipe Balbi <balbi@ti.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: alan@linux.intel.com, Tony Lindgren <tony@atomide.com>,
        Kevin Hilman <khilman@ti.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        linux-serial@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Shubhrajyoti Datta <shubhrajyoti@ti.com>,
        Sourav Poddar <sourav.poddar@ti.com>, Felipe Balbi <balbi@ti.com>
Subject: [PATCH v4 17/21] serial: omap: make sure to put() on poll_get_char
Date: Thu,  6 Sep 2012 15:45:36 +0300
Message-Id: <1346935540-1792-18-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.7.12.rc3
In-Reply-To: <1346935540-1792-1-git-send-email-balbi@ti.com>
References: <20120906122948.GC29202@arwen.pp.htv.fi>
 <1346935540-1792-1-git-send-email-balbi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

if we would reach serial_omap_get_char() while
Data Ready bit isn't set, we would return from
it without kicking our pm timer. This would mean
we would, eventually, have an unbalanced
pm_runtime_get on our device which would prevent
it from ever sleeping again.

Tested-by: Shubhrajyoti D <shubhrajyoti@ti.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 drivers/tty/serial/omap-serial.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/omap-serial.c b/drivers/tty/serial/omap-serial.c
index 7531147..6a58f4f 100644
--- a/drivers/tty/serial/omap-serial.c
+++ b/drivers/tty/serial/omap-serial.c
@@ -1005,12 +1005,17 @@ static int serial_omap_poll_get_char(struct uart_port *port)
 
 	pm_runtime_get_sync(up->dev);
 	status = serial_in(up, UART_LSR);
-	if (!(status & UART_LSR_DR))
-		return NO_POLL_CHAR;
+	if (!(status & UART_LSR_DR)) {
+		status = NO_POLL_CHAR;
+		goto out;
+	}
 
 	status = serial_in(up, UART_RX);
+
+out:
 	pm_runtime_mark_last_busy(up->dev);
 	pm_runtime_put_autosuspend(up->dev);
+
 	return status;
 }
 
-- 
1.7.12.rc3

