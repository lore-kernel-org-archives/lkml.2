Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932101Ab2JZGQY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 02:16:24 -0400
Received: from us01smtp3.synopsys.com ([198.182.44.81]:57406 "EHLO
	hermes.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753559Ab2JZGQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 02:16:20 -0400
Message-ID: <508A2AA5.608@synopsys.com>
Date: Fri, 26 Oct 2012 11:46:05 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: <alan@linux.intel.com>, <arc-linux-dev@synopsys.com>,
        <linux-serial@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] serial/arc-uart: Add new driver
References: <1351146608-21044-1-git-send-email-vgupta@synopsys.com> <1351146608-21044-2-git-send-email-vgupta@synopsys.com> <20121025183619.GA22545@kroah.com>
In-Reply-To: <20121025183619.GA22545@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.56]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 26 October 2012 12:06 AM, Greg KH wrote:
> On Thu, Oct 25, 2012 at 12:00:08PM +0530, Vineet.Gupta1@synopsys.com wrote:
>> From: Vineet Gupta <vgupta@synopsys.com>
>>
>> Driver for non-standard on-chip UART, instantiated in the ARC (Synopsys)
>> FPGA Boards such as ARCAngel4/ML50x
>>
>> Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
>> ---
>>  drivers/tty/serial/Kconfig       |   25 ++
>>  drivers/tty/serial/Makefile      |    1 +
>>  drivers/tty/serial/arc_uart.c    |  747 ++++++++++++++++++++++++++++++++++++++
>>  include/uapi/linux/serial_core.h |    2 +
>>  4 files changed, 775 insertions(+), 0 deletions(-)
>>  create mode 100644 drivers/tty/serial/arc_uart.c
>>
>> diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
>> index 2a53be5..efee7fe 100644
>> --- a/drivers/tty/serial/Kconfig
>> +++ b/drivers/tty/serial/Kconfig
>> @@ -1423,4 +1423,29 @@ config SERIAL_EFM32_UART_CONSOLE
>>  	depends on SERIAL_EFM32_UART=y
>>  	select SERIAL_CORE_CONSOLE
>>  
>> +config SERIAL_ARC
>> +	bool "ARC UART driver support"
>> +	select SERIAL_CORE
>> +	default y
>> +	help
>> +	  Driver for on-chip UART for ARC(Synopsys) for the legacy
>> +	  FPGA Boards (ML50x/ARCAngel4)
> Unless you will break a user's box, NEVER define a default value for a
> new configuration option as y.

OK !

> And why can't I select this driver as a module?

Because it's missing the equivalent of following (plus some more changes)
-       bool "ARC UART driver support"
+      tristate "ARC UART driver support"

ARC platform (where this driver originates from) always had system
console on UART - thus we never had the need for making it a loadable
module. But I guess as a matter of principle it nevertheless needs to
work - fixed in the next revision !

>> +
>> +config SERIAL_ARC_CONSOLE
>> +	bool
>> +	select SERIAL_CORE_CONSOLE
>> +	depends on SERIAL_ARC=y
>> +	default y
>> +	help
>> +	  Enable system Console on ARC UART
>> +
>> +config SERIAL_ARC_NR_PORTS
>> +	int 'Number of ports'
>> +	range 1 3
>> +	default 1
>> +	depends on SERIAL_ARC
>> +	help
>> +	  Set this to the number of serial ports you want the driver
>> +	  to support.
>> +
>>  endmenu
>> diff --git a/drivers/tty/serial/Makefile b/drivers/tty/serial/Makefile
>> index 4f694da..df1b998 100644
>> --- a/drivers/tty/serial/Makefile
>> +++ b/drivers/tty/serial/Makefile
>> @@ -82,3 +82,4 @@ obj-$(CONFIG_SERIAL_XILINX_PS_UART) += xilinx_uartps.o
>>  obj-$(CONFIG_SERIAL_SIRFSOC) += sirfsoc_uart.o
>>  obj-$(CONFIG_SERIAL_AR933X)   += ar933x_uart.o
>>  obj-$(CONFIG_SERIAL_EFM32_UART) += efm32-uart.o
>> +obj-$(CONFIG_SERIAL_ARC)	+= arc_uart.o
>> diff --git a/drivers/tty/serial/arc_uart.c b/drivers/tty/serial/arc_uart.c
>> new file mode 100644
>> index 0000000..9215bf4
>> --- /dev/null
>> +++ b/drivers/tty/serial/arc_uart.c
>> @@ -0,0 +1,747 @@
>> +/*
>> + * ARC On-Chip(fpga) UART Driver
>> + *
>> + * Copyright (C) 2010-2012 Synopsys, Inc. (www.synopsys.com)
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + *
>> + * vineetg: July 10th 2012
>> + *  -Decoupled the driver from arch/arc
>> + *    +Using platform_get_resource() for irq/membase (thx to bfin_uart.c)
>> + *    +Using early_platform_xxx() for early console (thx to mach-shmobile/xxx)
>> + *
>> + * Vineetg: Aug 21st 2010
>> + *  -Is uart_tx_stopped() not done in tty write path as it has already been
>> + *   taken care of, in serial core
>> + *
>> + * Vineetg: Aug 18th 2010
>> + *  -New Serial Core based ARC UART driver
>> + *  -Derived largely from blackfin driver albiet with some major tweaks
>> + *
>> + * TODO:
>> + *  -check if sysreq works
>> + */
>> +
>> +#if defined(CONFIG_SERIAL_ARC_CONSOLE) && defined(CONFIG_MAGIC_SYSRQ)
>> +#define SUPPORT_SYSRQ
>> +#endif
> Are you sure this works?  Don't you usually need to include some .h
> files before you check these config values?

We've been using the exact same driver for years - literally.

AFAIK, all the CONFIG_xxx items come in from generated autoconf.h which
is included implicitly by build system via cmd line based -include
kconfig.h, thus any explicit header is not needed for them. Also
SUPPORT_SYSRQ needs to be defined BEFORE including any header because
that is the way serial_core.h build can be influenced in a non-ambiguous
way.

>> +
>> +#include <linux/module.h>
>> +#include <linux/serial.h>
>> +#include <linux/console.h>
>> +#include <linux/sysrq.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/tty.h>
>> +#include <linux/tty_flip.h>
>> +#include <linux/serial_core.h>
>> +#include <linux/io.h>
>> +
>> +/*************************************
>> + * ARC UART Hardware Specs
>> + ************************************/
>> +#define ARC_UART_TX_FIFO_SIZE  1
>> +
>> +/*
>> + * UART Register set (this is not a Standards Compliant IP)
>> + * Also each reg is Word aligned, but only 8 bits wide
>> + */
>> +#define R_ID0	0
>> +#define R_ID1	1
>> +#define R_ID2	2
>> +#define R_ID3	3
>> +#define R_DATA	4
>> +#define R_STS	5
>> +#define R_BAUDL	6
>> +#define R_BAUDH	7
>> +
>> +/* Bits for UART Status Reg (R/W) */
>> +#define RXIENB  0x04	/* Receive Interrupt Enable */
>> +#define TXIENB  0x40	/* Transmit Interrupt Enable */
>> +
>> +#define RXEMPTY 0x20	/* Receive FIFO Empty: No char receivede */
>> +#define TXEMPTY 0x80	/* Transmit FIFO Empty, thus char can be written into */
>> +
>> +#define RXFULL  0x08	/* Receive FIFO full */
>> +#define RXFULL1 0x10	/* Receive FIFO has space for 1 char (tot space=4) */
>> +
>> +#define RXFERR  0x01	/* Frame Error: Stop Bit not detected */
>> +#define RXOERR  0x02	/* OverFlow Err: Char recv but RXFULL still set */
>> +
>> +/* Uart bit fiddling helpers: lowest level */
>> +#define RBASE(uart, reg)      ((unsigned int *)uart->port.membase + reg)
>> +#define UART_REG_SET(u, r, v) writeb((v), RBASE(u, r))
>> +#define UART_REG_GET(u, r)    readb(RBASE(u, r))
> What happens when you run sparse on this driver?

(1) The cast was indeed causing warning - that's now fixed, with an
equivalent of following:

-#define R_ID1  1
-#define R_ID2  2
-#define R_ID3  3
-#define R_DATA 4
-#define R_STS  5
-#define R_BAUDL        6
-#define R_BAUDH        7
+#define R_ID1  4
+#define R_ID2  8
+#define R_ID3  12
+#define R_DATA 16
+#define R_STS  20
+#define R_BAUDL        24
+#define R_BAUDH        28

-#define RBASE(uart, reg)      ((unsigned int *)uart->port.membase + reg)
+#define RBASE(uart, reg)     (uart->port.membase + reg)

(2) Other two seem to be false warnings for imbalance of
spin_lock_irqsave/restore, which otherwise seem OK to me!


>
> thanks,
>
> greg k-h

