Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758459Ab2IKJkP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 05:40:15 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:41808 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758183Ab2IKJiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 05:38:14 -0400
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
Subject: [PATCH 06/12] tty/serial/kgdboc: Add and wire up clear_irqs callback
Date: Tue, 11 Sep 2012 02:35:00 -0700
Message-Id: <1347356106-25368-6-git-send-email-anton.vorontsov@linaro.org>
X-Mailer: git-send-email 1.7.11.5
In-Reply-To: <20120911093042.GA12471@lizard>
References: <20120911093042.GA12471@lizard>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements a new callback: clear_irqs. It is used for the
cases when KDB-entry (e.g. NMI) and KDB IO (e.g. serial port) shares the
same interrupt. To get the idea, let's take some real example (ARM
machine): we have a serial port which interrupt is routed to an NMI, and
the interrupt is used to enter KDB. Once there is some activity on the
serial port, the CPU receives NMI exception, and we fall into KDB shell.
So, it is our "debug console", and it is able to interrupt (and thus
debug) even IRQ handlers themselves.

When used that way, the interrupt never reaches serial driver's IRQ
handler routine, which means that serial driver will not silence the
interrupt. NMIs behaviour are quite arch-specific, and we can't assume
that we can use them as ordinary IRQs, e.g. on some arches (like ARM) we
can't handle data aborts, the behaviour is undefined then. So we can't
just handle execution to serial driver's IRQ handler from the NMI
context once we're done with KDB (plus this would defeat the debugger's
purpose: we want the NMI handler be as simple as possible, so it will
have less chances to hang).

So, given that have to deal with it somehow, we have two options:

1. Implement something that clears the interrupt; 2. Implement a whole
new concept of grabbing tty for exclusive KDB use, plus implement
mask/unmask callbacks, i.e.:
   - Since consoles might use ttys w/o opending them, we would have to
     make kdb respect CON_ENABLED flag (maybe a good idea to do it
     anyway);
   - Add 'bool exclusive' argument to tty_find_polling_driver(), if set
     to 1, the function will refuse to return an already opened tty; and
     will use the flag in tty_reopen() to not allow multiple users
     (there are already checks for pty masters, which are "open once"
     ttys);
   - Once we got the tty exclusively, we would need to call some new
     uart->mask_all_but_rx_interrupts call before we want to use the
     port for NMI/KDB, and unmask_all_but_rx_interrupts after we're done
     with it.

The second option is obviously more complex, needlessly so, and less
generic. So I went with the first one: we just consume all the
interrupts.  The tty becomes silently unusable for the rest of the world
when we use it with KDB; but once we reroute the serial IRQ source back
from NMI to an ordinary IRQ (in KDB this can be done with 'disable_nmi'
command), it will behave as normal.

p.s. Since the callback is so far used only by polling users, we place
it under the appropriate #ifdef.

Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
---
 drivers/tty/serial/kgdboc.c      | 10 ++++++++++
 drivers/tty/serial/serial_core.c | 15 +++++++++++++++
 include/linux/kgdb.h             |  1 +
 include/linux/serial_core.h      |  1 +
 include/linux/tty_driver.h       |  1 +
 5 files changed, 28 insertions(+)

diff --git a/drivers/tty/serial/kgdboc.c b/drivers/tty/serial/kgdboc.c
index 2b42a01..0aa08c8 100644
--- a/drivers/tty/serial/kgdboc.c
+++ b/drivers/tty/serial/kgdboc.c
@@ -227,6 +227,15 @@ static int kgdboc_get_char(void)
 						kgdb_tty_line);
 }
 
+static void kgdboc_clear_irqs(void)
+{
+	if (!kgdb_tty_driver)
+		return;
+	if (kgdb_tty_driver->ops->clear_irqs)
+		kgdb_tty_driver->ops->clear_irqs(kgdb_tty_driver,
+						 kgdb_tty_line);
+}
+
 static void kgdboc_put_char(u8 chr)
 {
 	if (!kgdb_tty_driver)
@@ -298,6 +307,7 @@ static struct kgdb_io kgdboc_io_ops = {
 	.name			= "kgdboc",
 	.read_char		= kgdboc_get_char,
 	.write_char		= kgdboc_put_char,
+	.clear_irqs		= kgdboc_clear_irqs,
 	.pre_exception		= kgdboc_pre_exp_handler,
 	.post_exception		= kgdboc_post_exp_handler,
 };
diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index dcb2d5a..93c36cb 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -2187,6 +2187,20 @@ static void uart_poll_put_char(struct tty_driver *driver, int line, char ch)
 	port = state->uart_port;
 	port->ops->poll_put_char(port, ch);
 }
+
+static void uart_clear_irqs(struct tty_driver *driver, int line)
+{
+	struct uart_driver *drv = driver->driver_state;
+	struct uart_state *state = drv->state + line;
+	struct uart_port *port;
+
+	if (!state || !state->uart_port)
+		return;
+
+	port = state->uart_port;
+	if (port->ops->clear_irqs)
+		port->ops->clear_irqs(port);
+}
 #endif
 
 static const struct tty_operations uart_ops = {
@@ -2219,6 +2233,7 @@ static const struct tty_operations uart_ops = {
 	.poll_init	= uart_poll_init,
 	.poll_get_char	= uart_poll_get_char,
 	.poll_put_char	= uart_poll_put_char,
+	.clear_irqs	= uart_clear_irqs,
 #endif
 };
 
diff --git a/include/linux/kgdb.h b/include/linux/kgdb.h
index 3b111a6..1fd1cf0 100644
--- a/include/linux/kgdb.h
+++ b/include/linux/kgdb.h
@@ -295,6 +295,7 @@ struct kgdb_io {
 	const char		*name;
 	int			(*read_char) (void);
 	void			(*write_char) (u8);
+	void			(*clear_irqs) (void);
 	void			(*flush) (void);
 	int			(*init) (void);
 	void			(*pre_exception) (void);
diff --git a/include/linux/serial_core.h b/include/linux/serial_core.h
index 822c887..855fb6e 100644
--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -277,6 +277,7 @@ struct uart_ops {
 	int		(*poll_init)(struct uart_port *);
 	void	(*poll_put_char)(struct uart_port *, unsigned char);
 	int		(*poll_get_char)(struct uart_port *);
+	void	(*clear_irqs)(struct uart_port *);
 #endif
 };
 
diff --git a/include/linux/tty_driver.h b/include/linux/tty_driver.h
index dd976cf..42f8a87 100644
--- a/include/linux/tty_driver.h
+++ b/include/linux/tty_driver.h
@@ -282,6 +282,7 @@ struct tty_operations {
 	int (*poll_init)(struct tty_driver *driver, int line, char *options);
 	int (*poll_get_char)(struct tty_driver *driver, int line);
 	void (*poll_put_char)(struct tty_driver *driver, int line, char ch);
+	void (*clear_irqs)(struct tty_driver *driver, int line);
 #endif
 	const struct file_operations *proc_fops;
 };
-- 
1.7.11.5

