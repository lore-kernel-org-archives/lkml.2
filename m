Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756847Ab2HTOuU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 10:50:20 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61196 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756788Ab2HTOuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 10:50:08 -0400
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Russell King <linux@arm.linux.org.uk>,
        Jason Wessel <jason.wessel@windriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>
Cc: =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        Colin Cross <ccross@android.com>, John Stultz <john.stultz@linaro.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-kernel@lists.linaro.org, patches@linaro.org,
        kernel-team@android.com, kgdb-bugreport@lists.sourceforge.net
Subject: [PATCH 04/12] tty/serial/core: Introduce poll_init callback
Date: Mon, 20 Aug 2012 07:47:22 -0700
Message-Id: <1345474050-8339-4-git-send-email-anton.vorontsov@linaro.org>
X-Mailer: git-send-email 1.7.11.5
In-Reply-To: <20120820144449.GA32560@lizard>
References: <20120820144449.GA32560@lizard>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It was noticed that polling drivers (like KGDB) are not able to use
serial ports if the ports were not previously initialized via console.
I.e.  when booting with console=ttyAMA0 kgdboc=ttyAMA0, everything works
fine, but with console=ttyFOO kgdboc=ttyAMA0, the kgdboc doesn't work.

This is because we don't initialize the hardware. Calling ->startup() is
not an option, because drivers request interrupts there, and drivers
fail to handle situations when tty isn't opened with interrupts enabled.

So, we have to implement a new callback (actually, tty_ops already have
a similar callback), which does everything needed to initialize just the
hardware.

Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
---
 drivers/tty/serial/serial_core.c | 15 +++++++++++++++
 include/linux/serial_core.h      |  1 +
 2 files changed, 16 insertions(+)

diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index a21dc8e..cba8443 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -2108,11 +2108,13 @@ static int uart_poll_init(struct tty_driver *driver, int line, char *options)
 {
 	struct uart_driver *drv = driver->driver_state;
 	struct uart_state *state = drv->state + line;
+	struct tty_port *tport;
 	struct uart_port *port;
 	int baud = 9600;
 	int bits = 8;
 	int parity = 'n';
 	int flow = 'n';
+	int ret;
 
 	if (!state || !state->uart_port)
 		return -1;
@@ -2121,6 +2123,19 @@ static int uart_poll_init(struct tty_driver *driver, int line, char *options)
 	if (!(port->ops->poll_get_char && port->ops->poll_put_char))
 		return -1;
 
+	tport = &state->port;
+	if (!(tport->flags & ASYNC_INITIALIZED) && port->ops->poll_init) {
+		mutex_lock(&tport->mutex);
+		ret = port->ops->poll_init(port);
+		/*
+		 * We don't set ASYNCB_INITIALIZED as we only initialized the
+		 * hw, e.g. state->xmit is still uninitialized.
+		 */
+		mutex_unlock(&tport->mutex);
+		if (ret)
+			return ret;
+	}
+
 	if (options) {
 		uart_parse_options(options, &baud, &parity, &bits, &flow);
 		return uart_set_options(port, NULL, baud, parity, bits, flow);
diff --git a/include/linux/serial_core.h b/include/linux/serial_core.h
index 0253c20..3642710 100644
--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -274,6 +274,7 @@ struct uart_ops {
 	int		(*verify_port)(struct uart_port *, struct serial_struct *);
 	int		(*ioctl)(struct uart_port *, unsigned int, unsigned long);
 #ifdef CONFIG_CONSOLE_POLL
+	int		(*poll_init)(struct uart_port *);
 	void	(*poll_put_char)(struct uart_port *, unsigned char);
 	int		(*poll_get_char)(struct uart_port *);
 #endif
-- 
1.7.11.5

