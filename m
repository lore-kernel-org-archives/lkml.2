Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030294Ab2HWKkE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 06:40:04 -0400
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:52736 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933875Ab2HWKhx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 06:37:53 -0400
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
        Sourav Poddar <sourav.poddar@ti.com>, Ruchika Kharwar <ruchika@ti.com>,
        Pavan Savoy <pavan_savoy@ti.com>, Vijay Badawadagi <bvijay@ti.com>,
        Felipe Balbi <balbi@ti.com>
Subject: [PATCH v3 17/23] serial: omap: unlock the port lock
Date: Thu, 23 Aug 2012 13:32:57 +0300
Message-Id: <1345717983-18179-18-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.7.12.rc3
In-Reply-To: <1345717983-18179-1-git-send-email-balbi@ti.com>
References: <1345717983-18179-1-git-send-email-balbi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ruchika Kharwar <ruchika@ti.com>

This patch unlocks the port lock before calling a serial_core API
and re-acquires the port lock after calling it.
This patch fixes a system freeze issue seen when the serial_core
API uart_write_wakeup() eventually attempts to acquire the port lock
already acquired by omap serial interrupt handler.

Tested-by: Shubhrajyoti D <shubhrajyoti@ti.com>
Signed-off-by: Ruchika Kharwar <ruchika@ti.com>
Signed-off-by: Pavan Savoy <pavan_savoy@ti.com>
Signed-off-by: Vijay Badawadagi <bvijay@ti.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 drivers/tty/serial/omap-serial.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/serial/omap-serial.c b/drivers/tty/serial/omap-serial.c
index ba22247..e871635 100644
--- a/drivers/tty/serial/omap-serial.c
+++ b/drivers/tty/serial/omap-serial.c
@@ -223,8 +223,11 @@ static void transmit_chars(struct uart_omap_port *up, unsigned int lsr)
 			break;
 	} while (--count > 0);
 
-	if (uart_circ_chars_pending(xmit) < WAKEUP_CHARS)
+	if (uart_circ_chars_pending(xmit) < WAKEUP_CHARS) {
+		spin_unlock(&up->port.lock);
 		uart_write_wakeup(&up->port);
+		spin_lock(&up->port.lock);
+	}
 
 	if (uart_circ_empty(xmit))
 		serial_omap_stop_tx(&up->port);
-- 
1.7.12.rc3

