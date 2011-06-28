Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758672Ab1F1Pim (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 11:38:42 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:35347 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755990Ab1F1PgF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 11:36:05 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTin9=5Yp6W8S6hSuUZ8w08eUhRxxQw@mail.gmail.com>
References: <1309211120-2803-1-git-send-email-arnd@arndb.de>
	<1309211120-2803-3-git-send-email-arnd@arndb.de>
	<BANLkTin9=5Yp6W8S6hSuUZ8w08eUhRxxQw@mail.gmail.com>
Date: Tue, 28 Jun 2011 17:36:03 +0200
Message-ID: <BANLkTimnH81zys5Ab4XpsyuNXK2B+MqQrw@mail.gmail.com>
Subject: Re: [PATCH 2/7] serial/8250: move alchemy I/O handler to platform code
From: Manuel Lauss <manuel.lauss@googlemail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Ralf Baechle <ralf@linux-mips.org>, linux-serial@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 28, 2011 at 1:29 PM, Manuel Lauss
<manuel.lauss@googlemail.com> wrote:
> On Mon, Jun 27, 2011 at 11:45 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>> Only one platform ever sets the UPIO_AU iotype, so it's
>> cleaner to define the handlers in the code that actually
>> requires it, rather than building the same logic into
>> every 8250 driver.
>>
>> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>> Cc: Ralf Baechle <ralf@linux-mips.org>
>> Cc: Manuel Lauss <manuel.lauss@googlemail.com>
>> Cc: Greg Kroah-Hartman <gregkh@suse.de>
>> Cc: linux-serial@vger.kernel.org
>> ---
>>  arch/mips/alchemy/common/platform.c |   50 ++++++++++++++++++++++++++++++
>>  drivers/tty/serial/8250.c           |   58 -----------------------------------
>>  2 files changed, 50 insertions(+), 58 deletions(-)
>>
>> diff --git a/arch/mips/alchemy/common/platform.c b/arch/mips/alchemy/common/platform.c
>> index 3b2c18b..750441f 100644
>> --- a/arch/mips/alchemy/common/platform.c
>> +++ b/arch/mips/alchemy/common/platform.c
> [...]
>> @@ -55,6 +103,8 @@ static void alchemy_8250_pm(struct uart_port *port, unsigned int state,
>>                                  UPF_FIXED_TYPE,               \
>>                .type           = PORT_16550A,                  \
>>                .pm             = alchemy_8250_pm,              \
>> +               .serial_in      = au_serial_in,                 \
>> +               .serial_out     = au_serial_out                 \
>>        }
>
> This is very strange:  Just this part alone (leaving 8250.c intact)
> screws everything up.
> The assembly for au_serial_in/out is identical in both 8250.o and
> arch/mips/alchemy/common/platform.o (renamed the functions here obviously)
> I have no idea what's wrong...


Okay, found it.  the Alchemy headers have definitions for UART_RX/TX/... with
different values; they can be deleted safely since nothing depends on them.
Here's an updated and tested patch.  I took the liberty to rename the functions
a bit while at it.

diff --git a/arch/mips/alchemy/common/platform.c
b/arch/mips/alchemy/common/platform.c
index 932f697..301ccb7 100644
--- a/arch/mips/alchemy/common/platform.c
+++ b/arch/mips/alchemy/common/platform.c
@@ -16,6 +16,7 @@
 #include <linux/init.h>
 #include <linux/platform_device.h>
 #include <linux/serial_8250.h>
+#include <linux/serial_reg.h>
 #include <linux/slab.h>

 #include <asm/mach-au1x00/au1xxx.h>
@@ -45,6 +46,54 @@ static void alchemy_8250_pm(struct uart_port *port,
unsigned int state,
 #endif
 }

+/* Au1x00 UART hardware has a weird register layout */
+static const u8 alchemy_8250_inmap[] = {
+	[UART_RX]  = 0,
+	[UART_IER] = 2,
+	[UART_IIR] = 3,
+	[UART_LCR] = 5,
+	[UART_MCR] = 6,
+	[UART_LSR] = 7,
+	[UART_MSR] = 8,
+};
+
+static const u8 alchemy_8250_outmap[] = {
+	[UART_TX]  = 1,
+	[UART_IER] = 2,
+	[UART_FCR] = 4,
+	[UART_LCR] = 5,
+	[UART_MCR] = 6,
+};
+
+/* sane hardware needs no mapping */
+static inline int map_8250_in_reg(struct uart_port *p, int offset)
+{
+	if (p->iotype != UPIO_AU)
+		return offset;
+	return alchemy_8250_inmap[offset];
+}
+
+static inline int map_8250_out_reg(struct uart_port *p, int offset)
+{
+	if (p->iotype != UPIO_AU)
+		return offset;
+	return alchemy_8250_outmap[offset];
+}
+
+/* sane hardware needs no mapping */
+static unsigned int alchemy_8250_in(struct uart_port *p, int offset)
+{
+	offset = map_8250_in_reg(p, offset) << p->regshift;
+	return __raw_readl(p->membase + offset);
+}
+
+static void alchemy_8250_out(struct uart_port *p, int offset, int value)
+{
+	offset = map_8250_out_reg(p, offset) << p->regshift;
+	__raw_writel(value, p->membase + offset);
+}
+
+
 #define PORT(_base, _irq)					\
 	{							\
 		.mapbase	= _base,			\
@@ -55,6 +104,8 @@ static void alchemy_8250_pm(struct uart_port *port,
unsigned int state,
 				  UPF_FIXED_TYPE,		\
 		.type		= PORT_16550A,			\
 		.pm		= alchemy_8250_pm,		\
+		.serial_in	= alchemy_8250_in,		\
+		.serial_out	= alchemy_8250_out,		\
 	}

 static struct plat_serial8250_port au1x00_uart_data[][4] __initdata = {
diff --git a/arch/mips/include/asm/mach-au1x00/au1000.h
b/arch/mips/include/asm/mach-au1x00/au1000.h
index 610cc06..666de8e 100644
--- a/arch/mips/include/asm/mach-au1x00/au1000.h
+++ b/arch/mips/include/asm/mach-au1x00/au1000.h
@@ -1172,18 +1172,6 @@ enum soc_au1200_ints {
 #define MAC_RX_BUFF3_STATUS	0x30
 #define MAC_RX_BUFF3_ADDR	0x34

-#define UART_RX		0	/* Receive buffer */
-#define UART_TX		4	/* Transmit buffer */
-#define UART_IER	8	/* Interrupt Enable Register */
-#define UART_IIR	0xC	/* Interrupt ID Register */
-#define UART_FCR	0x10	/* FIFO Control Register */
-#define UART_LCR	0x14	/* Line Control Register */
-#define UART_MCR	0x18	/* Modem Control Register */
-#define UART_LSR	0x1C	/* Line Status Register */
-#define UART_MSR	0x20	/* Modem Status Register */
-#define UART_CLK	0x28	/* Baud Rate Clock Divider */
-#define UART_MOD_CNTRL	0x100	/* Module Control */
-
 /* SSIO */
 #define SSI0_STATUS		0xB1600000
 #  define SSI_STATUS_BF 	(1 << 4)
diff --git a/drivers/tty/serial/8250.c b/drivers/tty/serial/8250.c
index cf19b26..c8f107e 100644
--- a/drivers/tty/serial/8250.c
+++ b/drivers/tty/serial/8250.c
@@ -304,50 +304,9 @@ static const struct serial8250_config uart_config[] = {
 	},
 };

-#if defined(CONFIG_MIPS_ALCHEMY)
-
-/* Au1x00 UART hardware has a weird register layout */
-static const u8 au_io_in_map[] = {
-	[UART_RX]  = 0,
-	[UART_IER] = 2,
-	[UART_IIR] = 3,
-	[UART_LCR] = 5,
-	[UART_MCR] = 6,
-	[UART_LSR] = 7,
-	[UART_MSR] = 8,
-};
-
-static const u8 au_io_out_map[] = {
-	[UART_TX]  = 1,
-	[UART_IER] = 2,
-	[UART_FCR] = 4,
-	[UART_LCR] = 5,
-	[UART_MCR] = 6,
-};
-
-/* sane hardware needs no mapping */
-static inline int map_8250_in_reg(struct uart_port *p, int offset)
-{
-	if (p->iotype != UPIO_AU)
-		return offset;
-	return au_io_in_map[offset];
-}
-
-static inline int map_8250_out_reg(struct uart_port *p, int offset)
-{
-	if (p->iotype != UPIO_AU)
-		return offset;
-	return au_io_out_map[offset];
-}
-
-#else
-
-/* sane hardware needs no mapping */
 #define map_8250_in_reg(up, offset) (offset)
 #define map_8250_out_reg(up, offset) (offset)

-#endif
-
 static unsigned int hub6_serial_in(struct uart_port *p, int offset)
 {
 	offset = map_8250_in_reg(p, offset) << p->regshift;
@@ -386,18 +345,6 @@ static unsigned int mem32_serial_in(struct
uart_port *p, int offset)
 	return readl(p->membase + offset);
 }

-static unsigned int au_serial_in(struct uart_port *p, int offset)
-{
-	offset = map_8250_in_reg(p, offset) << p->regshift;
-	return __raw_readl(p->membase + offset);
-}
-
-static void au_serial_out(struct uart_port *p, int offset, int value)
-{
-	offset = map_8250_out_reg(p, offset) << p->regshift;
-	__raw_writel(value, p->membase + offset);
-}
-
 static unsigned int tsi_serial_in(struct uart_port *p, int offset)
 {
 	unsigned int tmp;
@@ -484,11 +431,6 @@ static void set_io_from_upio(struct uart_port *p)
 		p->serial_out = mem32_serial_out;
 		break;

-	case UPIO_AU:
-		p->serial_in = au_serial_in;
-		p->serial_out = au_serial_out;
-		break;
-
 	case UPIO_TSI:
 		p->serial_in = tsi_serial_in;
 		p->serial_out = tsi_serial_out;
