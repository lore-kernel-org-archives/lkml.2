Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030284Ab2HWKjb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 06:39:31 -0400
Received: from na3sys009aog137.obsmtp.com ([74.125.149.18]:53148 "EHLO
	na3sys009aog137.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933885Ab2HWKh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 06:37:58 -0400
From: Felipe Balbi <balbi@ti.com>
To: alan@linux.intel.com
Cc: Tony Lindgren <tony@atomide.com>, Kevin Hilman <khilman@ti.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        linux-serial@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Shubhrajyoti Datta <shubhrajyoti@ti.com>,
        Sourav Poddar <sourav.poddar@ti.com>, Felipe Balbi <balbi@ti.com>
Subject: [PATCH v3 19/23] serial: omap: make sure to put() on poll_get_char
Date: Thu, 23 Aug 2012 13:32:59 +0300
Message-Id: <1345717983-18179-20-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.7.12.rc3
In-Reply-To: <1345717983-18179-1-git-send-email-balbi@ti.com>
References: <1345717983-18179-1-git-send-email-balbi@ti.com>
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
index d6f5eed..c3579c0 100644
--- a/drivers/tty/serial/omap-serial.c
+++ b/drivers/tty/serial/omap-serial.c
@@ -991,12 +991,17 @@ static int serial_omap_poll_get_char(struct uart_port *port)
 
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

