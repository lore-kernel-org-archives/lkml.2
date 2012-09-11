Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758197Ab2IKJiP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 05:38:15 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60311 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758140Ab2IKJiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 05:38:09 -0400
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Andrew Morton <akpm@linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Wessel <jason.wessel@windriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>
Cc: =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        Colin Cross <ccross@android.com>, Brian Swetland <swetland@google.com>,
        John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com,
        kgdb-bugreport@lists.sourceforge.net, linux-serial@vger.kernel.org
Subject: [PATCH 04/12] tty/serial/core: Introduce poll_init callback
Date: Tue, 11 Sep 2012 02:34:58 -0700
Message-Id: <1347356106-25368-4-git-send-email-anton.vorontsov@linaro.org>
X-Mailer: git-send-email 1.7.11.5
In-Reply-To: <20120911093042.GA12471@lizard>
References: <20120911093042.GA12471@lizard>
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
 drivers/tty/serial/serial_core.c | 17 +++++++++++++++++
 include/linux/serial_core.h      |  1 +
 2 files changed, 18 insertions(+)

diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index 046279c..dcb2d5a 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -2129,6 +2129,7 @@ static int uart_poll_init(struct tty_driver *driver, int line, char *options)
 	int bits = 8;
 	int parity = 'n';
 	int flow = 'n';
+	int ret;
 
 	if (!state || !state->uart_port)
 		return -1;
@@ -2137,6 +2138,22 @@ static int uart_poll_init(struct tty_driver *driver, int line, char *options)
 	if (!(port->ops->poll_get_char && port->ops->poll_put_char))
 		return -1;
 
+	if (port->ops->poll_init) {
+		struct tty_port *tport = &state->port;
+
+		ret = 0;
+		mutex_lock(&tport->mutex);
+		/*
+		 * We don't set ASYNCB_INITIALIZED as we only initialized the
+		 * hw, e.g. state->xmit is still uninitialized.
+		 */
+		if (!test_bit(ASYNCB_INITIALIZED, &tport->flags))
+			ret = port->ops->poll_init(port);
+		mutex_unlock(&tport->mutex);
+		if (ret)
+			return ret;
+	}
+
 	if (options) {
 		uart_parse_options(options, &baud, &parity, &bits, &flow);
 		return uart_set_options(port, NULL, baud, parity, bits, flow);
diff --git a/include/linux/serial_core.h b/include/linux/serial_core.h
index 7cf0b68..822c887 100644
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

