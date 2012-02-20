Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751700Ab2BTE2g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 23:28:36 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:38412 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230Ab2BTE2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 23:28:34 -0500
MIME-Version: 1.0
In-Reply-To: <4F3E9909.7010301@linux.intel.com>
References: <4F3DA617.5030805@linux.intel.com>
	<20120217072808.GA26800@feng-i7>
	<CANKRQnhfQyUrMWaXJVsjmL-yFnHa9WuR5LfTkqv=QmRGnC2aTw@mail.gmail.com>
	<4F3E9909.7010301@linux.intel.com>
Date: Mon, 20 Feb 2012 13:28:33 +0900
Message-ID: <CANKRQnihp+CO9yz3SfEL=kFO18SMUJnU_LdELViPsNmd-Ew8yw@mail.gmail.com>
Subject: Re: pch_uart and pch_phub clock selection
From: Tomoya MORINAGA <tomoya.rohm@gmail.com>
To: Darren Hart <dvhart@linux.intel.com>, Feng Tang <feng.tang@intel.com>
Cc: "lkml," <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>, linux-serial@vger.kernel.org
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Considering Feng's/Darren's proposal/question,
I should have set 192MHz as default uart clock setting.
So, I created the following patch. (not formal patch but for review)
Let me know your opinion.

---
 drivers/misc/pch_phub.c       |   17 ++++++-----------
 drivers/tty/serial/pch_uart.c |   15 +++++++--------
 2 files changed, 13 insertions(+), 19 deletions(-)

diff --git a/drivers/misc/pch_phub.c b/drivers/misc/pch_phub.c
index 10fc478..8f9c1db 100644
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
@@ -715,8 +715,6 @@ static int __devinit pch_phub_probe(struct pci_dev *pdev,
 	chip->pdev = pdev; /* Save pci device struct */

 	if (id->driver_data == 1) { /* EG20T PCH */
-		const char *board_name;
-
 		retval = sysfs_create_file(&pdev->dev.kobj,
 					   &dev_attr_pch_mac.attr);
 		if (retval)
@@ -731,14 +729,11 @@ static int __devinit pch_phub_probe(struct pci_dev *pdev,
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
+		pch_phub_read_modify_write_reg(chip,
+					(unsigned int)CLKCFG_REG_OFFSET,
+					CLKCFG_UART_48MHZ | CLKCFG_BAUDDIV |
+					CLKCFG_PLL2VCO | CLKCFG_UARTCLKSEL,
+					CLKCFG_UART_MASK);

 		/* set the prefech value */
 		iowrite32(0x000affaa, chip->pch_phub_base_address + 0x14);
diff --git a/drivers/tty/serial/pch_uart.c b/drivers/tty/serial/pch_uart.c
index 17ae657..941f887 100644
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
@@ -1507,7 +1508,7 @@ static int __init pch_console_setup(struct
console *co, char *options)
 		return -ENODEV;

 	/* setup uartclock */
-	port->uartclk = DEFAULT_BAUD_RATE;
+	port->uartclk = clock_param ? clock_param : DEFAULT_UART_CLOCK;

 	if (options)
 		uart_parse_options(options, &baud, &parity, &bits, &flow);
@@ -1553,7 +1554,6 @@ static struct eg20t_port
*pch_uart_init_port(struct pci_dev *pdev,
 	int fifosize, base_baud;
 	int port_type;
 	struct pch_uart_driver_data *board;
-	const char *board_name;

 	board = &drv_dat[id->driver_data];
 	port_type = board->port_type;
@@ -1566,12 +1566,10 @@ static struct eg20t_port
*pch_uart_init_port(struct pci_dev *pdev,
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
@@ -1785,3 +1783,4 @@ module_exit(pch_uart_module_exit);
 MODULE_LICENSE("GPL v2");
 MODULE_DESCRIPTION("Intel EG20T PCH UART PCI Driver");
 module_param(default_baud, uint, S_IRUGO);
+module_param(clock_param, uint, (S_IRUSR | S_IWUSR));
-- 

thanks.
-- 
ROHM Co., Ltd.
tomoya

2012年2月18日3:14 Darren Hart <dvhart@linux.intel.com>:
> On 02/17/2012 01:50 AM, Tomoya MORINAGA wrote:
>> Hi
>>
>> 2012年2月17日16:28 Feng Tang <feng.tang@intel.com>:
>>> I see that the the CM-iTC board is special-cased to set a 192MHz uart_clock.
>>> This is done in pch_uart.c code, but there is some register manipulation done in
>>> the pch_phub.c driver and I don't understand the connection. How are the two
>>> related?
>> According to your use, need to configure clock registers which are in pch_phub .
>> Upstreamed version, UART_CLK can be used directly(neither multiple nor
>> division) as UART clock.
>
> I'm not following. I think you are saying that I need to configure the
> clock registers - but in my patch I don't touch them and it works. Are
> the registers intended to be read so I can determine HOW the device is
> configured, are they intended to be written in order to change how it is
> configured, or both.
>
> Firmware sets up some initial state and this has been what I'm trying to
> match in order to get an early serial console.
>
>>
>> You can get clock configuration information from SourceForge.
>> (http://sourceforge.net/projects/ml7213/files/Kernel%202.6.37/Release/Ver1.2.0/EG20TPCH_ML7213_ML7223_ML7831_linux-2.6.37_v120_20110930.tar.bz2/
>> and extract pch_phub. you can find readme.)
>> I extract it and show below.
>>
>> ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>> <Configuration>
>> =======================
>>
>> 1. Over 115K baud rate UART settings
>>     By default, UART can communicate less than 115Kbps.
>>     In case you want UART to work more than 115Kbps, the following
>> clock configuration is necessary.
>>     - Clock setting
>>           Set BAUDSEL = usb_48mhz
>>           Set PLL2VCO = "x 8" the clock
>>           Set BAUDDIV = "x 1/6" the clock
>>           Set UARTCLKSEL = PLL2 output
>>     For details, please refer to ML7213/ML7223 EDS "5 Chip Configuration"
>> ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>>
>> In case we want UART to work high baud rate(e.g.4Mbps), we set like above.
>> and execute "setserial /dev/ttyPCH0 baud_base 4000000".
>> I can see PCH_UART with 4Mbps works well.
>>
>> Darren, is this answer for your question ?
>
> Not quite. I need to be able to use the UART at boot as an early serial
> console. So I believe I need to match the firmware UART configuration
> early on (well before we could call setserial).
>
>>
>>> Tomoya, do you know if we can also set it to 192MHz for ML7223 IOH Bus-m/n?
>> Yes, you can.
>>
>
> --
> Darren Hart
> Intel Open Source Technology Center
> Yocto Project - Linux Kernel
