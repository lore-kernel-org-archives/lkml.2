Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757360Ab0FAU7N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 16:59:13 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:61601 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757358Ab0FAUxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 16:53:30 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       John Kacur <jkacur@redhat.com>, Alan Cox <alan@linux.intel.com>
Subject: [PATCH 19/31] serial: trim locking on the helpers
Date: Tue,  1 Jun 2010 22:52:59 +0200
Message-Id: <1275425591-8803-20-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1275425591-8803-1-git-send-email-arnd@arndb.de>
References: <1275425591-8803-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+JQYTltkDK1PXHucqGt+P/W8tmqTsw1WHsOvy
 emFej1Larll82h8tBywZpWRTACrVM8dnzIDZAdfuEoJbhN8kQg
 kNofob9uKHjsLMhr6eLXQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

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
-- 
1.7.0.4

