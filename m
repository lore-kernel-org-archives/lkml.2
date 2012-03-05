Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932513Ab2CEOHU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 09:07:20 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:34664 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932371Ab2CENxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 08:53:11 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>
Subject: [PATCH 41/68] TTY: simserial, remove static initialization
Date: Mon,  5 Mar 2012 14:52:28 +0100
Message-Id: <1330955575-26641-42-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1330955575-26641-1-git-send-email-jslaby@suse.cz>
References: <1330955575-26641-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We do not use any of the preinitialized rs_state members for something
real. So there is no need to initialize them. At the places we used
them for printing, just print the values.

And since only one port is supported, get rid of the loop. This
simplifies simrs_init a heap. Thus we can handle fail paths in a
standard way without panicing.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
---
 arch/ia64/hp/sim/simserial.c |   94 ++++++++++++------------------------------
 1 file changed, 27 insertions(+), 67 deletions(-)

diff --git a/arch/ia64/hp/sim/simserial.c b/arch/ia64/hp/sim/simserial.c
index c65c49d..64ab004 100644
--- a/arch/ia64/hp/sim/simserial.c
+++ b/arch/ia64/hp/sim/simserial.c
@@ -49,44 +49,7 @@
 static char *serial_name = "SimSerial driver";
 static char *serial_version = "0.6";
 
-/*
- * This has been extracted from asm/serial.h. We need one eventually but
- * I don't know exactly what we're going to put in it so just fake one
- * for now.
- */
-#define BASE_BAUD ( 1843200 / 16 )
-
-#define STD_COM_FLAGS (ASYNC_BOOT_AUTOCONF | ASYNC_SKIP_TEST)
-
-/*
- * Most of the values here are meaningless to this particular driver.
- * However some values must be preserved for the code (leveraged from serial.c
- * to work correctly).
- * port must not be 0
- * type must not be UNKNOWN
- * So I picked arbitrary (guess from where?) values instead
- */
-static struct serial_state rs_table[NR_PORTS]={
-  /* UART CLK   PORT IRQ     FLAGS        */
-  { BASE_BAUD, 0x3F8, 0, STD_COM_FLAGS, PORT_16550 }  /* ttyS0 */
-};
-
-/*
- * Just for the fun of it !
- */
-static struct serial_uart_config uart_config[] = {
-	{ "unknown", 1, 0 },
-	{ "8250", 1, 0 },
-	{ "16450", 1, 0 },
-	{ "16550", 1, 0 },
-	{ "16550A", 16, UART_CLEAR_FIFO | UART_USE_FIFO },
-	{ "cirrus", 1, 0 },
-	{ "ST16650", 1, UART_CLEAR_FIFO | UART_STARTECH },
-	{ "ST16650V2", 32, UART_CLEAR_FIFO | UART_USE_FIFO |
-		  UART_STARTECH },
-	{ "TI16750", 64, UART_CLEAR_FIFO | UART_USE_FIFO},
-	{ NULL, 0}
-};
+static struct serial_state rs_table[NR_PORTS];
 
 struct tty_driver *hp_simserial_driver;
 
@@ -592,11 +555,6 @@ static int startup(struct tty_struct *tty, struct serial_state *state)
 		goto errout;
 	}
 
-	if (!state->port || !state->type) {
-		set_bit(TTY_IO_ERROR, &tty->flags);
-		free_page(page);
-		goto errout;
-	}
 	if (state->xmit.buf)
 		free_page(page);
 	else
@@ -725,9 +683,8 @@ static int rs_open(struct tty_struct *tty, struct file * filp)
 
 static inline void line_info(struct seq_file *m, struct serial_state *state)
 {
-	seq_printf(m, "%d: uart:%s port:%lX irq:%d\n",
-		       state->line, uart_config[state->type].name,
-		       state->port, state->irq);
+	seq_printf(m, "%d: uart:16550 port:3F8 irq:%d\n",
+		       state->line, state->irq);
 }
 
 static int rs_proc_show(struct seq_file *m, void *v)
@@ -796,11 +753,10 @@ static const struct tty_operations hp_ops = {
 /*
  * The serial driver boot-time initialization code!
  */
-static int __init
-simrs_init (void)
+static int __init simrs_init(void)
 {
-	int			i, rc;
-	struct serial_state	*state;
+	struct serial_state *state;
+	int retval;
 
 	if (!ia64_platform_is("hpsim"))
 		return -ENODEV;
@@ -828,29 +784,33 @@ simrs_init (void)
 	/*
 	 * Let's have a little bit of fun !
 	 */
-	for (i = 0, state = rs_table; i < NR_PORTS; i++,state++) {
-		tty_port_init(&state->tport);
-		state->tport.close_delay = 0; /* XXX really 0? */
+	state = rs_table;
+	tty_port_init(&state->tport);
+	state->tport.close_delay = 0; /* XXX really 0? */
+
+	retval = hpsim_get_irq(KEYBOARD_INTR);
+	if (retval < 0) {
+		printk(KERN_ERR "%s: out of interrupt vectors!\n",
+				__func__);
+		goto err_free_tty;
+	}
 
-		if (state->type == PORT_UNKNOWN) continue;
+	state->irq = retval;
 
-		if (!state->irq) {
-			if ((rc = hpsim_get_irq(KEYBOARD_INTR)) < 0)
-				panic("%s: out of interrupt vectors!\n",
-				      __func__);
-			state->irq = rc;
-		}
+	/* the port is imaginary */
+	printk(KERN_INFO "ttyS%d at 0x03f8 (irq = %d) is a 16550\n",
+			state->line, state->irq);
 
-		printk(KERN_INFO "ttyS%d at 0x%04lx (irq = %d) is a %s\n",
-		       state->line,
-		       state->port, state->irq,
-		       uart_config[state->type].name);
+	retval = tty_register_driver(hp_simserial_driver);
+	if (retval) {
+		printk(KERN_ERR "Couldn't register simserial driver\n");
+		goto err_free_tty;
 	}
 
-	if (tty_register_driver(hp_simserial_driver))
-		panic("Couldn't register simserial driver\n");
-
 	return 0;
+err_free_tty:
+	put_tty_driver(hp_simserial_driver);
+	return retval;
 }
 
 #ifndef MODULE
-- 
1.7.9.2


