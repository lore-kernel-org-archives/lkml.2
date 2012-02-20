Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752134Ab2BTF6Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 00:58:16 -0500
Received: from mga09.intel.com ([134.134.136.24]:20978 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751230Ab2BTF6O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 00:58:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="109975049"
Date: Mon, 20 Feb 2012 13:57:08 +0800
From: Feng Tang <feng.tang@intel.com>
To: Tomoya MORINAGA <tomoya.rohm@gmail.com>
Cc: Darren Hart <dvhart@linux.intel.com>,
        "lkml," <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>, linux-serial@vger.kernel.org
Subject: Re: pch_uart and pch_phub clock selection
Message-ID: <20120220055708.GA4903@feng-i7>
References: <4F3DA617.5030805@linux.intel.com>
 <20120217072808.GA26800@feng-i7>
 <CANKRQnhfQyUrMWaXJVsjmL-yFnHa9WuR5LfTkqv=QmRGnC2aTw@mail.gmail.com>
 <4F3E9909.7010301@linux.intel.com>
 <CANKRQnihp+CO9yz3SfEL=kFO18SMUJnU_LdELViPsNmd-Ew8yw@mail.gmail.com>
 <20120220044322.GA4113@feng-i7>
 <CANKRQniP+OxrqhL=7eE1NpGf_umyA-GHLSYaiF+o-o=OT2iL_w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANKRQniP+OxrqhL=7eE1NpGf_umyA-GHLSYaiF+o-o=OT2iL_w@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomoya,

On Mon, Feb 20, 2012 at 02:42:32PM +0900, Tomoya MORINAGA wrote:
> 2012年2月20日13:43 Feng Tang <feng.tang@intel.com>:
> > Can we also set ML7213/7223's
> > default clk to 192MHz? 192MHz works fine on my ML7213 board. And using an
> > unified default clock rate for all EG20T compatible IOHs will save extra
> > effort of setting the uart clock.
> >
> Yes, you can also use 192MHz for both ML7213 and ML7223.
> In fact, we've already confirmed 192MHz works fine. (Windows driver).
> thanks,

Great! and glad to hear that. Could you update your patch which only touches
the EG20T UART clock setting? like taking the register setting code out of
the "switch/case" loop. something like:

---------------
diff --git a/drivers/misc/pch_phub.c b/drivers/misc/pch_phub.c
index 10fc478..299524c 100644
--- a/drivers/misc/pch_phub.c
+++ b/drivers/misc/pch_phub.c
@@ -55,7 +55,7 @@
 #define CLKCFG_CANCLK_MASK 0xFF000000
 #define CLKCFG_UART_MASK			0xFFFFFF
 
-/* CM-iTC */
+/* 192MHz Clock configuration. USB_48MHz / 2 * 8 = 192 */
 #define CLKCFG_UART_48MHZ			(1 << 16)
 #define CLKCFG_BAUDDIV				(2 << 20)
 #define CLKCFG_PLL2VCO				(8 << 9)
@@ -714,9 +714,13 @@ static int __devinit pch_phub_probe(struct pci_dev *pdev,
 
 	chip->pdev = pdev; /* Save pci device struct */
 
-	if (id->driver_data == 1) { /* EG20T PCH */
-		const char *board_name;
+	pch_phub_read_modify_write_reg(chip,
+					(unsigned int)CLKCFG_REG_OFFSET,
+					CLKCFG_UART_48MHZ | CLKCFG_BAUDDIV |
+					CLKCFG_PLL2VCO | CLKCFG_UARTCLKSEL,
+					CLKCFG_UART_MASK);
 
+	if (id->driver_data == 1) { /* EG20T PCH */
 		retval = sysfs_create_file(&pdev->dev.kobj,
 					   &dev_attr_pch_mac.attr);
 		if (retval)
@@ -731,15 +735,6 @@ static int __devinit pch_phub_probe(struct pci_dev *pdev,
 					       CLKCFG_CAN_50MHZ,
 					       CLKCFG_CANCLK_MASK);
 
-		/* quirk for CM-iTC board */
-		board_name = dmi_get_system_info(DMI_BOARD_NAME);
-		if (board_name && strstr(board_name, "CM-iTC"))
-			pch_phub_read_modify_write_reg(chip,
-						(unsigned int)CLKCFG_REG_OFFSET,
-						CLKCFG_UART_48MHZ | CLKCFG_BAUDDIV |
-						CLKCFG_PLL2VCO | CLKCFG_UARTCLKSEL,
-						CLKCFG_UART_MASK);
-
 		/* set the prefech value */
 		iowrite32(0x000affaa, chip->pch_phub_base_address + 0x14);
 		/* set the interrupt delay value */
diff --git a/drivers/tty/serial/pch_uart.c b/drivers/tty/serial/pch_uart.c
index 17ae657..b6ec42a 100644
--- a/drivers/tty/serial/pch_uart.c
+++ b/drivers/tty/serial/pch_uart.c
@@ -203,7 +203,7 @@ enum {
 
 #define BOTH_EMPTY (UART_LSR_TEMT | UART_LSR_THRE)
 
-#define DEFAULT_BAUD_RATE 1843200 /* 1.8432MHz */
+#define DEFAULT_UART_CLOCK 192000000 /* 192.0MHz */
 
 struct pch_uart_buffer {
 	unsigned char *buf;
@@ -287,6 +287,7 @@ static struct pch_uart_driver_data drv_dat[] = {
 static struct eg20t_port *pch_uart_ports[PCH_UART_NR];
 #endif
 static unsigned int default_baud = 9600;
+static unsigned int clock_param = 0;
 static const int trigger_level_256[4] = { 1, 64, 128, 224 };
 static const int trigger_level_64[4] = { 1, 16, 32, 56 };
 static const int trigger_level_16[4] = { 1, 4, 8, 14 };
@@ -1507,7 +1508,7 @@ static int __init pch_console_setup(struct console *co, char *options)
 		return -ENODEV;
 
 	/* setup uartclock */
-	port->uartclk = DEFAULT_BAUD_RATE;
+	port->uartclk = clock_param ? clock_param : DEFAULT_UART_CLOCK;
 
 	if (options)
 		uart_parse_options(options, &baud, &parity, &bits, &flow);
@@ -1553,7 +1554,6 @@ static struct eg20t_port *pch_uart_init_port(struct pci_dev *pdev,
 	int fifosize, base_baud;
 	int port_type;
 	struct pch_uart_driver_data *board;
-	const char *board_name;
 
 	board = &drv_dat[id->driver_data];
 	port_type = board->port_type;
@@ -1566,12 +1566,10 @@ static struct eg20t_port *pch_uart_init_port(struct pci_dev *pdev,
 	if (!rxbuf)
 		goto init_port_free_txbuf;
 
-	base_baud = DEFAULT_BAUD_RATE;
+	base_baud = DEFAULT_UART_CLOCK;
 
-	/* quirk for CM-iTC board */
-	board_name = dmi_get_system_info(DMI_BOARD_NAME);
-	if (board_name && strstr(board_name, "CM-iTC"))
-		base_baud = 192000000; /* 192.0MHz */
+	/* The module parameter overrides default. */
+	uart_clock = clock_param ? clock_param : uart_clock;
 
 	switch (port_type) {
 	case PORT_UNKNOWN:
> 
> ---
> ROHM Co., Ltd.
> tomoya
