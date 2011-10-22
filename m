Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612Ab1JVDrN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Oct 2011 23:47:13 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61857 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752253Ab1JVDrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Oct 2011 23:47:10 -0400
From: Paul Schilling <paul.s.schilling@gmail.com>
To: Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>, Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Boojin Kim <boojin.kim@samsung.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Cc: Paul Schilling <Paul.S.Schilling@gmail.com>,
        Paul Schilling <paul.s.schilling@gmail.com>
Subject: [PATCH 02/14] ARM : SAMSUNG : Add RS485 support.
Date: Fri, 21 Oct 2011 22:46:34 -0500
Message-Id: <1319255194-4799-1-git-send-email-paul.s.schilling@gmail.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <samsung_rs485>
References: <samsung_rs485>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add RS485 tranmit/recieve control line capabilities
This RS485 driver uses two methodes to determine if the transmit
should be disabled.

1.  It uses a timer and polling to determine when transmit has completed.
2.  Optionally uses a token used to terminate the message to be used in
    the recieve interrupt to disable the transmit.

Option 1 alone can be used but doesn't garentee that the transmit line
wont be disabled within 1 to 2 character times depending on system load.

This patch adds an additional variable to the serial RS-485 struct so
that a program can change the terminate token value via the IOCTL.

Signed-off-by: Paul Schilling <paul.s.schilling@gmail.com>
---
 arch/arm/plat-samsung/include/plat/regs-serial.h |    7 +
 drivers/tty/serial/Kconfig                       |   16 +
 drivers/tty/serial/samsung.c                     |  738 ++++++++++++++++++++--
 drivers/tty/serial/samsung.h                     |   15 +
 include/linux/serial.h                           |    5 +-
 5 files changed, 722 insertions(+), 59 deletions(-)

diff --git a/arch/arm/plat-samsung/include/plat/regs-serial.h b/arch/arm/plat-samsung/include/plat/regs-serial.h
index bac36fa..9618e7d 100644
--- a/arch/arm/plat-samsung/include/plat/regs-serial.h
+++ b/arch/arm/plat-samsung/include/plat/regs-serial.h
@@ -261,6 +261,13 @@ struct s3c2410_uartcfg {
 
 	struct s3c24xx_uart_clksrc *clocks;
 	unsigned int		    clocks_size;
+
+#ifdef CONFIG_SAMSUNG_HAS_RS485
+	signed int       gpio_transmit_en;
+	signed int       gpio_receive_en;
+	unsigned char	 enable_token;
+	unsigned char	 token;
+#endif
 };
 
 /* s3c24xx_uart_devs
diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
index 4dcb37b..dab33c2 100644
--- a/drivers/tty/serial/Kconfig
+++ b/drivers/tty/serial/Kconfig
@@ -464,6 +464,22 @@ config SERIAL_SAMSUNG_UARTS
 	  Select the number of available UART ports for the Samsung S3C
 	  serial driver
 	
+config SAMSUNG_HAS_RS485
+	bool "Enable RS485 support for Samsung"
+	depends on SERIAL_SAMSUNG && (MACH_CONDOR2440 || MACH_CONDOR2416 || MACH_MINI2440)
+	default y if (MACH_CONDOR2440 || MACH_CONDOR2416)
+	default n if (MACH_MINI2440)
+
+config SAMSUNG_485_LOW_RES_TIMER
+    bool "Samsung RS-485 use low res timer during transmit"
+    depends on SERIAL_SAMSUNG && SAMSUNG_HAS_RS485
+    default n
+    help
+      Use low resolution jiffies at 200 Hz for timer the RS-485
+      transmitter.  This works but doesn't garantee hard realtime.
+      Say no if you need the transmitter off immediatly after sending
+      a string or character.
+
 config SERIAL_SAMSUNG_DEBUG
 	bool "Samsung SoC serial debug"
 	depends on SERIAL_SAMSUNG && DEBUG_LL
diff --git a/drivers/tty/serial/samsung.c b/drivers/tty/serial/samsung.c
index 6edafb5..bf61579 100644
--- a/drivers/tty/serial/samsung.c
+++ b/drivers/tty/serial/samsung.c
@@ -4,12 +4,16 @@
  * Ben Dooks, Copyright (c) 2003-2008 Simtec Electronics
  *	http://armlinux.simtec.co.uk/
  *
+ * Paul Schilling, Copyright (c) 2011 Ecolab Corp.
+ *  http://www.ecolab.com/
+ *  Added RS-485 support to the Samsung UART driver.
+ *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
 */
 
-/* Hote on 2410 error handling
+/* Note on 2410 error handling
  *
  * The s3c2410 manual has a love/hate affair with the contents of the
  * UERSTAT register in the UART blocks, and keeps marking some of the
@@ -17,7 +21,7 @@
  * it copes with BREAKs properly, so I am happy to ignore the RESERVED
  * feature from the latter versions of the manual.
  *
- * If it becomes aparrent that latter versions of the 2410 remove these
+ * If it becomes apparent that latter versions of the 2410 remove these
  * bits, then action will have to be taken to differentiate the versions
  * and change the policy on BREAK
  *
@@ -42,6 +46,8 @@
 #include <linux/delay.h>
 #include <linux/clk.h>
 #include <linux/cpufreq.h>
+#include <linux/uaccess.h>
+#include <linux/gpio.h>
 
 #include <asm/irq.h>
 
@@ -66,11 +72,27 @@
 /* flag to ignore all characters coming in */
 #define RXSTAT_DUMMY_READ (0x10000000)
 
+static struct s3c24xx_uart_port s3c24xx_serial_ports[CONFIG_SERIAL_SAMSUNG_UARTS];
+
+
 static inline struct s3c24xx_uart_port *to_ourport(struct uart_port *port)
 {
 	return container_of(port, struct s3c24xx_uart_port, port);
 }
 
+static inline struct s3c24xx_uart_info *s3c24xx_port_to_info(struct uart_port *port)
+{
+	return to_ourport(port)->info;
+}
+
+static inline struct s3c2410_uartcfg *s3c24xx_port_to_cfg(struct uart_port *port)
+{
+	if (port->dev == NULL)
+		return NULL;
+
+	return (struct s3c2410_uartcfg *)port->dev->platform_data;
+}
+
 /* translate a port to the device name */
 
 static inline const char *s3c24xx_serial_portname(struct uart_port *port)
@@ -83,6 +105,22 @@ static int s3c24xx_serial_txempty_nofifo(struct uart_port *port)
 	return (rd_regl(port, S3C2410_UTRSTAT) & S3C2410_UTRSTAT_TXE);
 }
 
+#ifdef CONFIG_SAMSUNG_HAS_RS485
+/* Get the current transmit fifo count */
+static int s3c24xx_serial_tx_getfifocnt(struct s3c24xx_uart_port *ourport)
+{
+	struct s3c24xx_uart_info *info = ourport->info;
+	unsigned long ufstat = rd_regl(&(ourport->port), S3C2410_UFSTAT);
+
+	/* If FIFO is full then return FIFO size. */
+	if (ufstat & info->tx_fifofull)
+		return info->fifosize;
+
+	/* Else return number of entries in the FIFO. */
+	return (ufstat & info->tx_fifomask) >> info->tx_fifoshift;
+}
+#endif
+
 static void s3c24xx_serial_rx_enable(struct uart_port *port)
 {
 	unsigned long flags;
@@ -121,15 +159,205 @@ static void s3c24xx_serial_rx_disable(struct uart_port *port)
 	spin_unlock_irqrestore(&port->lock, flags);
 }
 
+static void s3c24xx_serial_rx_fifo_enable(
+		struct uart_port *port,
+		unsigned int en)
+{
+	unsigned long flags;
+	unsigned int ucon;
+	static unsigned int last_state = 1;
+/* FIXME */
+	#if 0
+	if (last_state != en) {
+
+		struct s3c2410_uartcfg *cfg = s3c24xx_port_to_cfg(port);
+
+		spin_lock_irqsave(&port->lock, flags);
+
+		ucon = rd_regl(port, S3C2410_UCON);
+
+		ucon &= ~(S3C2440_UFCON_RXTRIG32 | S3C2410_UCON_RXILEVEL);
+
+		if (en) {
+			ucon |= cfg->ucon;
+		}
+
+		wr_regl(port, S3C2410_UCON, ucon);
+
+		spin_unlock_irqrestore(&port->lock, flags);
+	}
+#endif
+}
+
+#ifdef CONFIG_SAMSUNG_HAS_RS485
+/* Timer function to toggle RTS when using FAST_TIMER */
+#ifdef SAMSUNG485_LOW_RES_TIMER
+	static void rs485_toggle_rts_timer_function(unsigned long _data)
+	{
+		struct uart_port *port = (struct uart_port *)_data;
+		struct s3c2410_uartcfg *cfg = s3c24xx_port_to_cfg(port);
+
+		struct s3c24xx_uart_port *ourport = to_ourport(port);
+
+		unsigned long utrstat;
+
+		utrstat = rd_regl(port, S3C2410_UTRSTAT);
+
+		if ((utrstat & S3C2410_UTRSTAT_TXE) ? 1 : 0) {
+			if (cfg->gpio_transmit_en > -1) {
+				gpio_set_value(cfg->gpio_transmit_en, 0);
+			}
+
+			if (cfg->gpio_receive_en > -1) {
+				gpio_set_value(cfg->gpio_receive_en, 0);
+			}
+		} else {
+			/* Set a short timer to toggle RTS */
+			mod_timer(
+					&(ourport->rs485_tx_timer),
+					jiffies + usecs_to_jiffies(
+							ourport->char_time_usec
+							/ 10));
+		}
+	}
+#else
+
+
+static enum hrtimer_restart rs485_toggle_rts_timer_function(
+		struct s3c24xx_uart_port *ourport)
+{
+	struct s3c2410_uartcfg *cfg =
+			s3c24xx_port_to_cfg(&(ourport->port));
+
+	unsigned long utrstat;
+	enum hrtimer_restart ret;
+
+	/* Read UART transmit status register */
+	utrstat = rd_regl(&(ourport->port), S3C2410_UTRSTAT);
+
+	/* Check if the UART and shift register is empty*/
+	if ((utrstat & S3C2410_UTRSTAT_TXE) ? 1 : 0) {
+		/* Is the GPIO valid for RS485  transmit enable*/
+		if (cfg->gpio_transmit_en > -1) {
+			/* Request, Set, Free the transmit GPIO*/
+			gpio_set_value(cfg->gpio_transmit_en, 0);
+		}
+
+		/* Is the GPIO valid for the RS485 receive enable*/
+		if (cfg->gpio_receive_en > -1) {
+			/* Request, Set, Free the receive GPIO*/
+			gpio_set_value(cfg->gpio_receive_en, 0);
+		}
+
+		s3c24xx_serial_rx_fifo_enable(&(ourport->port), 1);
+
+		/* The timer has completed its task now we can disable it. */
+		ret = HRTIMER_NORESTART;
+	} else {
+
+		ktime_t kt;
+
+		if (s3c24xx_serial_tx_getfifocnt(ourport) > 1) {
+			kt = ktime_set(0, ourport->char_time_nanosec);
+			hrtimer_forward(&(ourport->hr_rs485_tx_timer),
+					ourport->hr_rs485_tx_timer.base->softirq_time,
+					kt);
+		} else {
+			kt = ktime_set(0, ourport->char_time_nanosec / 2);
+			hrtimer_forward(&(ourport->hr_rs485_tx_timer),
+					ourport->hr_rs485_tx_timer.base->softirq_time,
+					kt);
+		}
+
+		/* Timer will be enabled after the interrupt context */
+		ret = HRTIMER_RESTART;
+	}
+
+	return ret;
+}
+
+/* Uart 0 RS-485 timer callback */
+enum hrtimer_restart rs485_hr_timer_callback_uart0(struct hrtimer *timer)
+{
+
+	return rs485_toggle_rts_timer_function(&s3c24xx_serial_ports[0]);
+}
+
+/* Uart 0 RS-485 timer callback */
+enum hrtimer_restart rs485_hr_timer_callback_uart1(struct hrtimer *timer)
+{
+
+	return rs485_toggle_rts_timer_function(&s3c24xx_serial_ports[1]);
+}
+
+/* Uart 0 RS-485 timer callback */
+#if CONFIG_SERIAL_SAMSUNG_UARTS > 2
+enum hrtimer_restart rs485_hr_timer_callback_uart2(struct hrtimer *timer)
+{
+
+	return rs485_toggle_rts_timer_function(&s3c24xx_serial_ports[2]);
+}
+#endif
+
+/* Uart 0 RS-485 timer callback */
+#if CONFIG_SERIAL_SAMSUNG_UARTS > 3
+enum hrtimer_restart rs485_hr_timer_callback_uart3(struct hrtimer *timer)
+{
+
+	return rs485_toggle_rts_timer_function(&s3c24xx_serial_ports[3]);
+}
+#endif
+
+
+/* Callback array*/
+enum hrtimer_restart (*callback_list[CONFIG_SERIAL_SAMSUNG_UARTS])(struct hrtimer *) = {
+		&rs485_hr_timer_callback_uart0,
+		&rs485_hr_timer_callback_uart1,
+
+#if CONFIG_SERIAL_SAMSUNG_UARTS > 2
+		&rs485_hr_timer_callback_uart2,
+#endif
+
+#if CONFIG_SERIAL_SAMSUNG_UARTS > 3
+		&rs485_hr_timer_callback_uart3,
+#endif
+};
+
+#endif
+#endif /* CONFIG_SAMSUNG_HAS_RS485 */
+
+
 static void s3c24xx_serial_stop_tx(struct uart_port *port)
 {
 	struct s3c24xx_uart_port *ourport = to_ourport(port);
 
 	if (tx_enabled(port)) {
+#ifdef CONFIG_SAMSUNG_HAS_RS485
+		if (ourport->rs485.flags & SER_RS485_ENABLED) {
+#ifdef CONFIG_SAMSUNG_485_LOW_RES_TIMER
+			/* Set a short timer to toggle RTS */
+			mod_timer(&(ourport->rs485_tx_timer),
+					jiffies + usecs_to_jiffies(ourport->char_time_usec * s3c24xx_serial_tx_getfifocnt(ourport)));
+#else
+			ktime_t kt;
+
+			/* Set time struct to one char time. */
+			kt = ktime_set(0, ourport->char_time_nanosec);
+
+			/* Start the high res timer. */
+			hrtimer_start(&(ourport->hr_rs485_tx_timer), kt, HRTIMER_MODE_REL);
+#endif /* CONFIG_SAMSUNG_485_LOW_RES_TIMER */
+
+			s3c24xx_serial_rx_fifo_enable(port, 0);
+
+		}
+#endif /* CONFIG_SAMSUNG_HAS_RS485 */
+
 		disable_irq_nosync(ourport->tx_irq);
 		tx_enabled(port) = 0;
-		if (port->flags & UPF_CONS_FLOW)
+		if (port->flags & UPF_CONS_FLOW) {
 			s3c24xx_serial_rx_enable(port);
+		}
 	}
 }
 
@@ -137,7 +365,42 @@ static void s3c24xx_serial_start_tx(struct uart_port *port)
 {
 	struct s3c24xx_uart_port *ourport = to_ourport(port);
 
+#ifdef CONFIG_SAMSUNG_HAS_RS485
+	hrtimer_try_to_cancel(&(ourport->hr_rs485_tx_timer));
+#endif
+
 	if (!tx_enabled(port)) {
+#ifdef CONFIG_SAMSUNG_HAS_RS485
+		/* enable RS-485 */
+		if (ourport->rs485.flags & SER_RS485_ENABLED) {
+			struct s3c2410_uartcfg *cfg = s3c24xx_port_to_cfg(port);
+
+			/* Is transmit GPIO valid */
+			if (cfg->gpio_transmit_en > -1) {
+				/* GPIO Request, Config, Direction, Value, and
+				 *  Free the pin*/
+				WARN_ON(s3c_gpio_cfgpin(cfg->gpio_transmit_en,
+						S3C_GPIO_OUTPUT));
+				gpio_direction_output(cfg->gpio_transmit_en, 1);
+				gpio_set_value(cfg->gpio_transmit_en, 1);
+			}
+
+			/* Is receive GPIO valid */
+			if ((cfg->gpio_receive_en > -1) &&
+					(!(ourport->rs485.flags &
+							SER_RS485_ALWAYS_LISTEN
+							))) {
+				/* GPIO Request, Config, Direction, Value, and
+				 *  Free the pin*/
+				WARN_ON(s3c_gpio_cfgpin(cfg->gpio_receive_en,
+						S3C_GPIO_OUTPUT));
+				gpio_direction_output(cfg->gpio_receive_en, 1);
+				gpio_set_value(cfg->gpio_receive_en, 1);
+			}
+
+		}
+#endif /*CONFIG_SAMSUNG_HAS_RS485 */
+
 		if (port->flags & UPF_CONS_FLOW)
 			s3c24xx_serial_rx_disable(port);
 
@@ -162,18 +425,6 @@ static void s3c24xx_serial_enable_ms(struct uart_port *port)
 {
 }
 
-static inline struct s3c24xx_uart_info *s3c24xx_port_to_info(struct uart_port *port)
-{
-	return to_ourport(port)->info;
-}
-
-static inline struct s3c2410_uartcfg *s3c24xx_port_to_cfg(struct uart_port *port)
-{
-	if (port->dev == NULL)
-		return NULL;
-
-	return (struct s3c2410_uartcfg *)port->dev->platform_data;
-}
 
 static int s3c24xx_serial_rx_fifocnt(struct s3c24xx_uart_port *ourport,
 				     unsigned long ufstat)
@@ -186,6 +437,99 @@ static int s3c24xx_serial_rx_fifocnt(struct s3c24xx_uart_port *ourport,
 	return (ufstat & info->rx_fifomask) >> info->rx_fifoshift;
 }
 
+static inline int
+s3c24xx_serial_getsource(struct uart_port *port, struct s3c24xx_uart_clksrc *c)
+{
+	struct s3c24xx_uart_info *info = s3c24xx_port_to_info(port);
+
+	return (info->get_clksrc)(port, c);
+}
+
+static inline int
+s3c24xx_serial_setsource(struct uart_port *port, struct s3c24xx_uart_clksrc *c)
+{
+	struct s3c24xx_uart_info *info = s3c24xx_port_to_info(port);
+
+	return (info->set_clksrc)(port, c);
+}
+
+#ifdef CONFIG_SAMSUNG_HAS_RS485
+static void
+samsung_uart_get_options(struct uart_port *port, int *baud,
+			   int *parity, int *stop, int *bits)
+{
+	struct s3c24xx_uart_clksrc clksrc;
+	struct clk *clk;
+	unsigned int ulcon;
+	unsigned int ucon;
+	unsigned int ubrdiv;
+	unsigned long rate;
+
+	ulcon  = rd_regl(port, S3C2410_ULCON);
+	ucon   = rd_regl(port, S3C2410_UCON);
+	ubrdiv = rd_regl(port, S3C2410_UBRDIV);
+
+	dbg("s3c24xx_serial_get_options: port=%p\n"
+	    "registers: ulcon=%08x, ucon=%08x, ubdriv=%08x\n",
+	    port, ulcon, ucon, ubrdiv);
+
+	if ((ucon & 0xf) != 0) {
+		/* consider the serial port configured if the tx/rx mode set */
+
+		switch (ulcon & S3C2410_LCON_CSMASK) {
+		case S3C2410_LCON_CS5:
+			*bits = 5;
+			break;
+		case S3C2410_LCON_CS6:
+			*bits = 6;
+			break;
+		case S3C2410_LCON_CS7:
+			*bits = 7;
+			break;
+		default:
+		case S3C2410_LCON_CS8:
+			*bits = 8;
+			break;
+		}
+
+		switch (ulcon & S3C2410_LCON_PMASK) {
+		case S3C2410_LCON_PEVEN:
+			*parity = 'e';
+			break;
+
+		case S3C2410_LCON_PODD:
+			*parity = 'o';
+			break;
+
+		case S3C2410_LCON_PNONE:
+		default:
+			*parity = 'n';
+		}
+
+		if (ulcon | S3C2410_LCON_STOPB) {
+			*stop = 2;
+		} else {
+			*stop = 1;
+		}
+
+		/* now calculate the baud rate */
+
+		s3c24xx_serial_getsource(port, &clksrc);
+
+		clk = clk_get(port->dev, clksrc.name);
+		if (!IS_ERR(clk) && clk != NULL)
+			rate = clk_get_rate(clk) / clksrc.divisor;
+		else
+			rate = 1;
+
+
+		*baud = rate / (16 * (ubrdiv + 1));
+		dbg("calculated baud %d\n", *baud);
+	}
+
+}
+#endif /* CONFIG_SAMSUNG_HAS_RS485 */
+
 
 /* ? - where has parity gone?? */
 #define S3C2410_UERSTAT_PARITY (0x1000)
@@ -209,6 +553,33 @@ s3c24xx_serial_rx_chars(int irq, void *dev_id)
 		uerstat = rd_regl(port, S3C2410_UERSTAT);
 		ch = rd_regb(port, S3C2410_URXH);
 
+		if (ourport->rs485.flags & SER_RS485_ENABLED) {
+			struct s3c2410_uartcfg *cfg = s3c24xx_port_to_cfg(port);
+
+#ifdef CONFIG_TEST_485
+			/* Is the GPIO valid for the RS485 receive enable*/
+			if (cfg->gpio_receive_en > -1) {
+				/* Request, Set, Free the receive GPIO*/
+				gpio_set_value(cfg->gpio_receive_en, 1);
+				gpio_set_value(cfg->gpio_receive_en, 0);
+			}
+#endif
+
+			if ((SER_RS485_TOGGLE_ON_TOKEN & ourport->rs485.flags) &&
+					(ourport->rs485.toggle_token == ch)) {
+				/* Is the GPIO valid for RS485
+				 * transmit enable*/
+				if (cfg->gpio_transmit_en > -1) {
+					/* Set the transmit GPIO line*/
+
+					gpio_set_value(cfg->gpio_transmit_en, 0);
+
+				}
+
+				s3c24xx_serial_rx_fifo_enable(port, 1);
+			}
+		}
+
 		if (port->flags & UPF_CONS_FLOW) {
 			int txe = s3c24xx_serial_txempty_nofifo(port);
 
@@ -488,21 +859,7 @@ static struct s3c24xx_uart_clksrc tmp_clksrc = {
 	.divisor	= 1,
 };
 
-static inline int
-s3c24xx_serial_getsource(struct uart_port *port, struct s3c24xx_uart_clksrc *c)
-{
-	struct s3c24xx_uart_info *info = s3c24xx_port_to_info(port);
-
-	return (info->get_clksrc)(port, c);
-}
 
-static inline int
-s3c24xx_serial_setsource(struct uart_port *port, struct s3c24xx_uart_clksrc *c)
-{
-	struct s3c24xx_uart_info *info = s3c24xx_port_to_info(port);
-
-	return (info->set_clksrc)(port, c);
-}
 
 struct baud_calc {
 	struct s3c24xx_uart_clksrc	*clksrc;
@@ -512,6 +869,41 @@ struct baud_calc {
 	struct clk			*src;
 };
 
+#ifdef CONFIG_SAMSUNG_HAS_RS485
+/* Calculate the char_time depending on baudrate, number of bits etc. */
+static void update_char_time(struct uart_port *port)
+{
+
+	int bits = 8;
+	int baud = 9600;
+	int parity = 'n';
+	int stop = 1;
+
+	samsung_uart_get_options(port, &baud, &parity, &stop, &bits);
+
+	/* calc. number of bits / data byte */
+	/* databits + startbit and 1 stopbit */
+	bits++;
+
+	/* 2 stopbits ? */
+	bits += stop;
+
+	/* is parity enabled. */
+	if ('n' != parity) {
+		bits++;
+	}
+
+#ifdef CONFIG_SAMSUNG_485_LOW_RES_TIMER
+	/* calc timeout */
+	to_ourport(port)->char_time_usec = ((1000000 / baud) * bits) + 1;
+#else
+	/* calc timeout */
+	to_ourport(port)->char_time_nanosec = ((1000000000 / baud) * bits) + 1;
+#endif
+}
+
+#endif /*CONFIG_SAMSUNG_HAS_RS485 */
+
 static int s3c24xx_serial_calcbaud(struct baud_calc *calc,
 				   struct uart_port *port,
 				   struct s3c24xx_uart_clksrc *clksrc,
@@ -785,7 +1177,7 @@ static void s3c24xx_serial_set_termios(struct uart_port *port,
 	port->ignore_status_mask = 0;
 	if (termios->c_iflag & IGNPAR)
 		port->ignore_status_mask |= S3C2410_UERSTAT_OVERRUN;
-	if (termios->c_iflag & IGNBRK && termios->c_iflag & IGNPAR)
+	if ((termios->c_iflag & IGNBRK) && (termios->c_iflag & IGNPAR))
 		port->ignore_status_mask |= S3C2410_UERSTAT_FRAME;
 
 	/*
@@ -795,6 +1187,12 @@ static void s3c24xx_serial_set_termios(struct uart_port *port,
 		port->ignore_status_mask |= RXSTAT_DUMMY_READ;
 
 	spin_unlock_irqrestore(&port->lock, flags);
+
+#ifdef CONFIG_SAMSUNG_HAS_RS485
+	/* Update character time. */
+	update_char_time(port);
+#endif /* CONFIG_SAMSUNG_HAS_RS485 */
+
 }
 
 static const char *s3c24xx_serial_type(struct uart_port *port)
@@ -830,7 +1228,7 @@ static void s3c24xx_serial_config_port(struct uart_port *port, int flags)
 {
 	struct s3c24xx_uart_info *info = s3c24xx_port_to_info(port);
 
-	if (flags & UART_CONFIG_TYPE &&
+	if ((flags & UART_CONFIG_TYPE) &&
 	    s3c24xx_serial_request_port(port) == 0)
 		port->type = info->type;
 }
@@ -849,6 +1247,73 @@ s3c24xx_serial_verify_port(struct uart_port *port, struct serial_struct *ser)
 	return 0;
 }
 
+#ifdef CONFIG_SAMSUNG_HAS_RS485
+/*
+ * Enable RS-485 called by IOCTL.
+ */
+static int
+s3c24xx_serial_enable_rs485(struct uart_port *port, struct serial_rs485 *r)
+{
+	struct s3c2410_uartcfg *cfg = s3c24xx_port_to_cfg(port);
+	struct s3c24xx_uart_port *ourport = to_ourport(port);
+
+	/* Is GPIO valid for transmit enable. */
+	if (cfg->gpio_transmit_en > -1) {
+		/* GPIO Request, Config, Direction, Value, and Free the pin*/
+		gpio_set_value(cfg->gpio_transmit_en, 0);
+	}
+
+	/* Is GPIO valid for receive enable. */
+	if (cfg->gpio_receive_en > -1) {
+		/* GPIO Request, Config, Direction, Value, and Free the pin*/
+		gpio_set_value(cfg->gpio_receive_en, 0);
+	}
+
+	ourport->rs485 = *r;
+
+	/* Maximum delay before RTS equal to 1000 */
+	if (ourport->rs485.delay_rts_before_send >= 1000)
+		ourport->rs485.delay_rts_before_send = 1000;
+
+#if 0
+	dev_info(port., "rts: on send = %i, after = %i, enabled = %i",
+			info->rs485.rts_on_send,
+			info->rs485.rts_after_sent,
+			info->rs485.enabled
+	);
+#endif
+
+	return 0;
+}
+
+
+static int s3c24xx_serial_ioctl(struct uart_port *port, unsigned int cmd, unsigned long arg)
+{
+
+	struct serial_rs485 rs485conf;
+
+	switch (cmd) {
+	case TIOCSRS485:
+		if (copy_from_user(&rs485conf, (struct serial_rs485 *) arg,
+					sizeof(rs485conf)))
+			return -EFAULT;
+
+		s3c24xx_serial_enable_rs485(port, &rs485conf);
+		break;
+
+	case TIOCGRS485:
+		if (copy_to_user((struct serial_rs485 *) arg,
+					&(to_ourport(port)->rs485),
+					sizeof(rs485conf)))
+			return -EFAULT;
+		break;
+
+	default:
+		return -ENOIOCTLCMD;
+	}
+	return 0;
+}
+#endif /*CONFIG_SAMSUNG_HAS_RS485*/
 
 #ifdef CONFIG_SERIAL_SAMSUNG_CONSOLE
 
@@ -877,6 +1342,9 @@ static struct uart_ops s3c24xx_serial_ops = {
 	.request_port	= s3c24xx_serial_request_port,
 	.config_port	= s3c24xx_serial_config_port,
 	.verify_port	= s3c24xx_serial_verify_port,
+#ifdef CONFIG_SAMSUNG_HAS_RS485
+	.ioctl			= s3c24xx_serial_ioctl,
+#endif /* CONFIG_SAMSUNG_HAS_RS485 */
 };
 
 
@@ -955,9 +1423,16 @@ static struct s3c24xx_uart_port s3c24xx_serial_ports[CONFIG_SERIAL_SAMSUNG_UARTS
 static inline int s3c24xx_serial_resetport(struct uart_port *port,
 					   struct s3c2410_uartcfg *cfg)
 {
+	int ret;
 	struct s3c24xx_uart_info *info = s3c24xx_port_to_info(port);
 
-	return (info->reset_port)(port, cfg);
+	ret = (info->reset_port)(port, cfg);
+
+#ifdef CONFIG_SAMSUNG_HAS_RS485
+	update_char_time(port);
+#endif /* CONFIG_SAMSUNG_HAS_RS485 */
+
+	return ret;
 }
 
 
@@ -1077,6 +1552,42 @@ static int s3c24xx_serial_init_port(struct s3c24xx_uart_port *ourport,
 	port->dev	= &platdev->dev;
 	ourport->info	= info;
 
+#ifdef CONFIG_SAMSUNG_HAS_RS485
+
+	dev_info(port->dev, "port TX GPIO (%d)\n", cfg->gpio_transmit_en);
+	dev_info(port->dev, "port TX GPIO (%d)\n", cfg->gpio_receive_en);
+
+	if (cfg->gpio_transmit_en > -1) {
+		/* Setup 485 as default on capable ports.*/
+		ourport->rs485.flags = (SER_RS485_ENABLED | SER_RS485_ALWAYS_LISTEN |
+				(cfg->enable_token ? SER_RS485_TOGGLE_ON_TOKEN : 0));
+		ourport->rs485.toggle_token = cfg->token;
+
+#ifdef CONFIG_SAMSUNG_485_LOW_RES_TIMER
+		dev_info(&(port->dev), "Enable Lo Res Timer\n");
+		setup_timer(&(ourport->rs485_tx_timer),
+				rs485_toggle_rts_timer_function,
+				(unsigned long)port);
+#else
+		dev_info(port->dev, "Enable Hi Res Timer\n");
+
+		/* Initialize HR timer to relative and monotonic mode. */
+		hrtimer_init(&(ourport->hr_rs485_tx_timer),
+				CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+
+		/* register Callback to appropriate UART */
+		ourport->hr_rs485_tx_timer.function =
+				callback_list[ourport->port.line];
+
+#endif
+
+		dev_info(port->dev, "Port (%d) 485 Enabled\n", ourport->port.line);
+	} else {
+		/* disable 485 on ports inacable of mode. */
+		ourport->rs485.flags = 0;
+	}
+#endif /* CONFIG_SAMSUNG_HAS_RS485*/
+
 	/* copy the info in from provided structure */
 	ourport->port.fifosize = info->fifosize;
 
@@ -1137,6 +1648,55 @@ static ssize_t s3c24xx_serial_show_clksrc(struct device *dev,
 
 static DEVICE_ATTR(clock_source, S_IRUGO, s3c24xx_serial_show_clksrc, NULL);
 
+
+#ifdef CONFIG_SAMSUNG_HAS_RS485
+
+static ssize_t s3c24xx_serial_show_485_status(struct device *dev,
+					  struct device_attribute *attr,
+					  char *buf)
+{
+	int ret = 0;
+	struct uart_port *port = s3c24xx_dev_to_port(dev);
+	struct s3c24xx_uart_port *ourport = to_ourport(port);
+
+	if (ourport->rs485.flags & SER_RS485_ENABLED) {
+		ret = snprintf(buf, PAGE_SIZE, "[Enabled] Disabled\n");
+	} else {
+		ret = snprintf(buf, PAGE_SIZE, "Enabled [Disabled]\n");
+	}
+
+	return ret;
+}
+
+static ssize_t s3c24xx_serial_set_485_mode(struct device *dev,
+		struct device_attribute *attr,
+		const char *buf, size_t count)
+
+{
+	struct uart_port *port = s3c24xx_dev_to_port(dev);
+	struct s3c24xx_uart_port *ourport = to_ourport(port);
+
+	if (!strncmp(buf, "Enabled", 7)) {
+		ourport->rs485.flags |= SER_RS485_ENABLED;
+	} else if (!strncmp(buf, "Disabled", 8)) {
+		ourport->rs485.flags &= ~SER_RS485_ENABLED;
+	} else {
+		dev_err(port->dev, "unknown string\n");
+
+		return -EINVAL;
+	}
+
+	return count;
+
+}
+
+static DEVICE_ATTR(485_status,
+		S_IRUGO | S_IWUSR,
+		s3c24xx_serial_show_485_status,
+		s3c24xx_serial_set_485_mode);
+
+#endif
+
 /* Device driver serial port probe */
 
 static int probe_index;
@@ -1144,8 +1704,10 @@ static int probe_index;
 int s3c24xx_serial_probe(struct platform_device *dev,
 			 struct s3c24xx_uart_info *info)
 {
-	struct s3c24xx_uart_port *ourport;
 	int ret;
+	struct s3c24xx_uart_port *ourport;
+	struct s3c2410_uartcfg *cfg = s3c24xx_dev_to_cfg(&dev->dev);
+
 
 	dbg("s3c24xx_serial_probe(%p, %p) %d\n", dev, info, probe_index);
 
@@ -1170,6 +1732,33 @@ int s3c24xx_serial_probe(struct platform_device *dev,
 	if (ret < 0)
 		dev_err(&dev->dev, "failed to add cpufreq notifier\n");
 
+#ifdef CONFIG_SAMSUNG_HAS_RS485
+
+	ret = device_create_file(&dev->dev, &dev_attr_485_status);
+	if (ret < 0)
+		printk(KERN_ERR "%s: failed to add 485 status attr.\n", __func__);
+
+
+	if (cfg->gpio_transmit_en > -1) {
+		WARN_ON(gpio_request(cfg->gpio_transmit_en, "RS485TX"));
+		WARN_ON(s3c_gpio_cfgpin(cfg->gpio_transmit_en, S3C_GPIO_OUTPUT));
+		gpio_direction_output(cfg->gpio_transmit_en, 0);
+		gpio_set_value(cfg->gpio_transmit_en, 0);
+
+		dev_info(ourport->port.dev, "Initialize TX(%d) GPIO\n", ourport->port.line);
+
+		if (cfg->gpio_receive_en > -1) {
+			WARN_ON(gpio_request(cfg->gpio_receive_en , "RS485RX"));
+			WARN_ON(s3c_gpio_cfgpin(cfg->gpio_receive_en, S3C_GPIO_OUTPUT));
+			gpio_direction_output(cfg->gpio_receive_en, 0);
+			gpio_set_value(cfg->gpio_receive_en, 0);
+
+			dev_info(ourport->port.dev, "Initialize RX(%d) GPIO\n", ourport->port.line);
+		}
+	}
+#endif
+
+
 	return 0;
 
  probe_err:
@@ -1181,8 +1770,33 @@ EXPORT_SYMBOL_GPL(s3c24xx_serial_probe);
 int __devexit s3c24xx_serial_remove(struct platform_device *dev)
 {
 	struct uart_port *port = s3c24xx_dev_to_port(&dev->dev);
+	struct s3c2410_uartcfg *cfg = s3c24xx_dev_to_cfg(&dev->dev);
 
 	if (port) {
+
+#ifdef CONFIG_SAMSUNG_HAS_RS485
+		if (cfg->gpio_transmit_en > -1) {
+			gpio_free(cfg->gpio_transmit_en);
+
+			dev_info(port->dev,
+					"Uninitialize TX(%d) GPIO\n", port->line);
+
+			if (cfg->gpio_receive_en > -1) {
+				gpio_free(cfg->gpio_receive_en);
+
+				dev_info(port->dev,
+						"Uninitialize RX(%d) GPIO\n",
+						port->line);
+			}
+		}
+
+		/* Delete timer after device is removed. */
+#ifdef CONFIG_SAMSUNG_485_LOW_RES_TIMER
+		del_timer_sync(&(to_ourport(port)->rs485_tx_timer));
+#else
+		hrtimer_cancel(&(to_ourport(port)->hr_rs485_tx_timer));
+#endif
+#endif /* CONFIG_SAMSUNG_HAS_RS485 */
 		s3c24xx_serial_cpufreq_deregister(to_ourport(port));
 		device_remove_file(&dev->dev, &dev_attr_clock_source);
 		uart_remove_one_port(&s3c24xx_uart_drv, port);
@@ -1308,9 +1922,33 @@ s3c24xx_serial_console_write(struct console *co, const char *s,
 	uart_console_write(cons_uart, s, count, s3c24xx_serial_console_putchar);
 }
 
+
+/* s3c24xx_serial_init_ports
+ *
+ * initialise the serial ports from the machine provided initialisation
+ * data.
+*/
+
+static int s3c24xx_serial_init_ports(struct s3c24xx_uart_info **info)
+{
+	struct s3c24xx_uart_port *ptr = s3c24xx_serial_ports;
+	struct platform_device **platdev_ptr;
+	int i;
+
+	dbg("s3c24xx_serial_init_ports: initialising ports...\n");
+
+	platdev_ptr = s3c24xx_uart_devs;
+
+	for (i = 0; i < CONFIG_SERIAL_SAMSUNG_UARTS; i++, ptr++, platdev_ptr++) {
+		s3c24xx_serial_init_port(ptr, info[i], *platdev_ptr);
+	}
+
+	return 0;
+}
+
 static void __init
 s3c24xx_serial_get_options(struct uart_port *port, int *baud,
-			   int *parity, int *bits)
+			   int *parity, int *stop, int *bits)
 {
 	struct s3c24xx_uart_clksrc clksrc;
 	struct clk *clk;
@@ -1360,6 +1998,12 @@ s3c24xx_serial_get_options(struct uart_port *port, int *baud,
 			*parity = 'n';
 		}
 
+		if (ulcon | S3C2410_LCON_STOPB) {
+			*stop = 2;
+		} else {
+			*stop = 1;
+		}
+
 		/* now calculate the baud rate */
 
 		s3c24xx_serial_getsource(port, &clksrc);
@@ -1377,29 +2021,6 @@ s3c24xx_serial_get_options(struct uart_port *port, int *baud,
 
 }
 
-/* s3c24xx_serial_init_ports
- *
- * initialise the serial ports from the machine provided initialisation
- * data.
-*/
-
-static int s3c24xx_serial_init_ports(struct s3c24xx_uart_info **info)
-{
-	struct s3c24xx_uart_port *ptr = s3c24xx_serial_ports;
-	struct platform_device **platdev_ptr;
-	int i;
-
-	dbg("s3c24xx_serial_init_ports: initialising ports...\n");
-
-	platdev_ptr = s3c24xx_uart_devs;
-
-	for (i = 0; i < CONFIG_SERIAL_SAMSUNG_UARTS; i++, ptr++, platdev_ptr++) {
-		s3c24xx_serial_init_port(ptr, info[i], *platdev_ptr);
-	}
-
-	return 0;
-}
-
 static int __init
 s3c24xx_serial_console_setup(struct console *co, char *options)
 {
@@ -1408,6 +2029,7 @@ s3c24xx_serial_console_setup(struct console *co, char *options)
 	int bits = 8;
 	int parity = 'n';
 	int flow = 'n';
+	int stop = 1;
 
 	dbg("s3c24xx_serial_console_setup: co=%p (%d), %s\n",
 	    co, co->index, options);
@@ -1436,7 +2058,7 @@ s3c24xx_serial_console_setup(struct console *co, char *options)
 	if (options)
 		uart_parse_options(options, &baud, &parity, &bits, &flow);
 	else
-		s3c24xx_serial_get_options(port, &baud, &parity, &bits);
+		s3c24xx_serial_get_options(port, &baud, &parity, &stop, &bits);
 
 	dbg("s3c24xx_serial_console_setup: baud %d\n", baud);
 
diff --git a/drivers/tty/serial/samsung.h b/drivers/tty/serial/samsung.h
index a69d9a5..f550dc3 100644
--- a/drivers/tty/serial/samsung.h
+++ b/drivers/tty/serial/samsung.h
@@ -4,6 +4,10 @@
  * Ben Dooks, Copyright (c) 2003-2008 Simtec Electronics
  *	http://armlinux.simtec.co.uk/
  *
+ * Paul Schilling, Copyright (c) 2011 Ecolab Corp.
+ * Added RS-485 support to the Samsung driver..
+ *
+ *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
@@ -31,6 +35,7 @@ struct s3c24xx_uart_info {
 
 	/* uart controls */
 	int (*reset_port)(struct uart_port *, struct s3c2410_uartcfg *);
+
 };
 
 struct s3c24xx_uart_port {
@@ -48,6 +53,16 @@ struct s3c24xx_uart_port {
 	struct clk			*baudclk;
 	struct uart_port		port;
 
+	struct serial_rs485	rs485;				/* RS-485 support */
+
+#ifdef CONFIG_SAMSUNG_485_LOW_RES_TIMER
+	unsigned long char_time_usec;			/* The time for 1 char, in micro secs */
+	struct timer_list rs485_tx_timer;
+#else
+	unsigned long char_time_nanosec;	/* The time for 1 char, in nano secs */
+	struct hrtimer  hr_rs485_tx_timer;		/* Timer for RS-485 Receive enable*/
+#endif
+
 #ifdef CONFIG_CPU_FREQ
 	struct notifier_block		freq_transition;
 #endif
diff --git a/include/linux/serial.h b/include/linux/serial.h
index ef91406..826b1c0 100644
--- a/include/linux/serial.h
+++ b/include/linux/serial.h
@@ -211,9 +211,12 @@ struct serial_rs485 {
 #define SER_RS485_RTS_ON_SEND		(1 << 1)
 #define SER_RS485_RTS_AFTER_SEND	(1 << 2)
 #define SER_RS485_RTS_BEFORE_SEND	(1 << 3)
+#define SER_RS485_ALWAYS_LISTEN		(1 << 4)
+#define SER_RS485_TOGGLE_ON_TOKEN	(1 << 5)
 	__u32	delay_rts_before_send;	/* Milliseconds */
 	__u32	delay_rts_after_send;	/* Milliseconds */
-	__u32	padding[5];		/* Memory is cheap, new structs
+	__u32	toggle_token;			/* Token used to toggle to receive */
+	__u32	padding[4];		/* Memory is cheap, new structs
 					   are a royal PITA .. */
 };
 
-- 
1.7.6.4

