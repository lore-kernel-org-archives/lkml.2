Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934786Ab0EEKmY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 06:42:24 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54826 "EHLO
	bob.linux.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934690Ab0EEKlx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 06:41:53 -0400
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH 19/20] serial: trim locking on the helpers
To: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org, arnd@arndb.de
Date: Wed, 05 May 2010 11:03:27 +0100
Message-ID: <20100505100327.3595.69817.stgit@localhost.localdomain>
In-Reply-To: <20100505100144.3595.65633.stgit@localhost.localdomain>
References: <20100505100144.3595.65633.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The port mutex protects port->tty, but these paths never need to walk from
port->tty. They do need the low level lock as the API expects that but they
already also take it.

Thus we can drop the extra mutex lock calls here.

Signed-off-by: Alan Cox <alan@linux.intel.com>
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

