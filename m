Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932331Ab0HEWYs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 18:24:48 -0400
Received: from kroah.org ([198.145.64.141]:37657 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760794Ab0HEWYM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 18:24:12 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Alan Cox <alan@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 32/67] serial: trim locking on the helpers
Date: Thu,  5 Aug 2010 15:22:59 -0700
Message-Id: <1281047014-23429-32-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <20100805213528.GA13794@kroah.com>
References: <20100805213528.GA13794@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

The port mutex protects port->tty, but these paths never need to walk from
port->tty. They do need the low level lock as the API expects that but they
already also take it.

Thus we can drop the extra mutex lock calls here.

Signed-off-by: Alan Cox <alan@linux.intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/serial/serial_core.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/serial/serial_core.c b/drivers/serial/serial_core.c
index 2379045..0603e0d 100644
--- a/drivers/serial/serial_core.c
+++ b/drivers/serial/serial_core.c
@@ -1506,12 +1506,10 @@ static int uart_carrier_raised(struct tty_port *port)
 	struct uart_state *state = container_of(port, struct uart_state, port);
 	struct uart_port *uport = state->uart_port;
 	int mctrl;
-	mutex_lock(&port->mutex);
 	spin_lock_irq(&uport->lock);
 	uport->ops->enable_ms(uport);
 	mctrl = uport->ops->get_mctrl(uport);
 	spin_unlock_irq(&uport->lock);
-	mutex_unlock(&port->mutex);
 	if (mctrl & TIOCM_CAR)
 		return 1;
 	return 0;
@@ -1521,12 +1519,11 @@ static void uart_dtr_rts(struct tty_port *port, int onoff)
 {
 	struct uart_state *state = container_of(port, struct uart_state, port);
 	struct uart_port *uport = state->uart_port;
-	mutex_lock(&port->mutex);
+
 	if (onoff)
 		uart_set_mctrl(uport, TIOCM_DTR | TIOCM_RTS);
 	else
 		uart_clear_mctrl(uport, TIOCM_DTR | TIOCM_RTS);
-	mutex_unlock(&port->mutex);
 }
 
 /*
-- 
1.7.2

