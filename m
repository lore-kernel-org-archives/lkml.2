Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757267Ab0F3UHW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 16:07:22 -0400
Received: from 69-100-st.zelcom.ru ([80.92.100.69]:56876 "HELO
	feelingofgreen.ru" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with SMTP id S1757213Ab0F3UHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 16:07:19 -0400
From: Samium Gromoff <_deepfire@feelingofgreen.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] serial: MMIO32 support for 8250_early.c
In-Reply-To: <20100628134426.0558ac67.akpm@linux-foundation.org>
References: <87r5jxva3n.fsf@auriga.deep>
	<20100628134426.0558ac67.akpm@linux-foundation.org>
Date: Wed, 30 Jun 2010 23:12:43 +0400
Message-ID: <87mxucuyfo.fsf@auriga.deep>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jun 2010 13:44:26 -0700, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Wed, 23 Jun 2010 23:10:20 +0400
> Samium Gromoff <_deepfire@feelingofgreen.ru> wrote:
> 
> > This should be fairly uncontroversial, but YMMV.
> > 
> > Available from master branch at git://git.feelingofgreen.ru/linux
> > 
> > commit 67e21ada6739e0730fb28f855abf4202a1bb3f8c
> > Author: Samium Gromoff <deepfire@elvees.com>
> > Date:   Thu Jun 24 00:36:16 2010 +0400
> > 
> >     Provide MMIO32 support in 8250_early (aka earlycon)
> 
> Please update Documentation/kernel-parameters.txt.
> 
> > ...
> >
> > @@ -182,9 +199,9 @@ static int __init parse_options(struct early_serial8250_device *device,
> >  	}
> >  
> >  	printk(KERN_INFO "Early serial console at %s 0x%llx (options '%s')\n",
> > -		mmio ? "MMIO" : "I/O port",
> > -		mmio ? (unsigned long long) port->mapbase
> > -		     : (unsigned long long) port->iobase,
> > +		mmio ? "MMIO" : mmio32 ? "MMIO32" : "I/O port",
> > +		(mmio | mmio32) ? (unsigned long long) port->mapbase
> > +		                : (unsigned long long) port->iobase,
> >  		device->options);
> 
> That printk has just got out of control.  We should at the very least
> parenthesise that ?:?: thing before someone sees it and dies.  Or just
> rip it up and reimplement it.  Note that mapbase can be printed with %p
> and iobase with %pr, but the code munges them both into ull's and uses
> %llx.

Isn't the 

    cond1 ? case1 [ : condx ? casex ]* ... : case-else

constuct kind of idiomatic?  Well, I guess not very much, then..

Missing Common Lisp's powerful FORMAT function, with an embedded DSL
for conditional sub-directives and such -- the resulting substitute
is duplicate-ish..

So, the branch is again updated, and the delta is:

========================================================================

commit eb6a4309f9f1c56c6b600739c16d06ea1f1e74dd
Author: Samium Gromoff <_deepfire@feelingofgreen.ru>
Date:   Wed Jun 30 23:07:46 2010 +0400

    Provide MMIO32 support in 8250_early (aka earlycon)
    
    Signed-off-by: Samium Gromoff <_deepfire@feelingofgreen.ru>

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 1808f11..0bb9939 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -686,8 +686,11 @@ and is between 256 and 4096 characters. It is defined in the file
 	earlycon=	[KNL] Output early console device and options.
 		uart[8250],io,<addr>[,options]
 		uart[8250],mmio,<addr>[,options]
+		uart[8250],mmio32,<addr>[,options]
 			Start an early, polled-mode console on the 8250/16550
 			UART at the specified I/O port or MMIO address.
+			MMIO inter-register address stride is either 8bit (mmio)
+                        or 32bit (mmio32).
 			The options are the same as for ttyS, above.
 
 	earlyprintk=	[X86,SH,BLACKFIN]
diff --git a/drivers/serial/8250_early.c b/drivers/serial/8250_early.c
index f279745..7d10b62 100644
--- a/drivers/serial/8250_early.c
+++ b/drivers/serial/8250_early.c
@@ -19,9 +19,11 @@
  * The user can specify the device directly, e.g.,
  *	earlycon=uart8250,io,0x3f8,9600n8
  *	earlycon=uart8250,mmio,0xff5e0000,115200n8
+ *	earlycon=uart8250,mmio32,0xff5e0000,115200n8
  * or
  *	console=uart8250,io,0x3f8,9600n8
  *	console=uart8250,mmio,0xff5e0000,115200n8
+ *	console=uart8250,mmio32,0xff5e0000,115200n8
  */
 
 #include <linux/tty.h>
@@ -48,18 +50,31 @@ static struct early_serial8250_device early_device;
 
 static unsigned int __init serial_in(struct uart_port *port, int offset)
 {
-	if (port->iotype == UPIO_MEM)
-		return readb(port->membase + offset);
-	else
-		return inb(port->iobase + offset);
+	switch (port->iotype) {
+		case UPIO_MEM:
+			return readb(port->membase + offset);
+		case UPIO_MEM32:
+			return readl(port->membase + (offset << 2));
+		case UPIO_PORT:
+			return inb(port->iobase + offset);
+		default:
+			return 0;
+	}
 }
 
 static void __init serial_out(struct uart_port *port, int offset, int value)
 {
-	if (port->iotype == UPIO_MEM)
-		writeb(value, port->membase + offset);
-	else
-		outb(value, port->iobase + offset);
+	switch (port->iotype) {
+		case UPIO_MEM:
+			writeb(value, port->membase + offset);
+			break;
+		case UPIO_MEM32:
+			writel(value, port->membase + (offset << 2));
+			break;
+		case UPIO_PORT:
+			outb(value, port->iobase + offset);
+			break;
+	}
 }
 
 #define BOTH_EMPTY (UART_LSR_TEMT | UART_LSR_THRE)
@@ -137,15 +152,20 @@ static int __init parse_options(struct early_serial8250_device *device,
 								char *options)
 {
 	struct uart_port *port = &device->port;
-	int mmio, length;
+	int mmio, mmio32, length;
 
 	if (!options)
 		return -ENODEV;
 
 	port->uartclk = BASE_BAUD * 16;
-	if (!strncmp(options, "mmio,", 5)) {
-		port->iotype = UPIO_MEM;
-		port->mapbase = simple_strtoul(options + 5, &options, 0);
+
+	mmio = !strncmp(options, "mmio,", 5);
+	mmio32 = !strncmp(options, "mmio32,", 7);
+	if (mmio || mmio32) {
+		port->iotype = (mmio ? UPIO_MEM : UPIO_MEM32);
+		port->mapbase = simple_strtoul(options + (mmio ? 5 : 7), &options, 0);
+		if (mmio32)
+			port->regshift = 2;
 #ifdef CONFIG_FIX_EARLYCON_MEM
 		set_fixmap_nocache(FIX_EARLYCON_MEM_BASE,
 					port->mapbase & PAGE_MASK);
@@ -157,11 +177,10 @@ static int __init parse_options(struct early_serial8250_device *device,
 		if (!port->membase) {
 			printk(KERN_ERR "%s: Couldn't ioremap 0x%llx\n",
 				__func__,
-			       (unsigned long long)port->mapbase);
+			       (unsigned long long) port->mapbase);
 			return -ENOMEM;
 		}
 #endif
-		mmio = 1;
 	} else if (!strncmp(options, "io,", 3)) {
 		port->iotype = UPIO_PORT;
 		port->iobase = simple_strtoul(options + 3, &options, 0);
@@ -181,11 +200,14 @@ static int __init parse_options(struct early_serial8250_device *device,
 			device->baud);
 	}
 
-	printk(KERN_INFO "Early serial console at %s 0x%llx (options '%s')\n",
-		mmio ? "MMIO" : "I/O port",
-		mmio ? (unsigned long long) port->mapbase
-		     : (unsigned long long) port->iobase,
-		device->options);
+        if (mmio || mmio32)
+                printk(KERN_INFO "Early serial console at MMIO%s 0x%p (options '%s')\n",
+                       mmio32 ? "32" : "", (unsigned long long) port->mapbase,
+                       device->options);
+        else
+                printk(KERN_INFO "Early serial console at I/O port 0x%pr (options '%s')\n",
+                       (unsigned long long) port->iobase, device->options);
+                
 	return 0;
 }
 


-- 
regards,
  Samium Gromoff
--
"Actually I made up the term 'object-oriented', and I can tell you I
did not have C++ in mind." - Alan Kay (OOPSLA 1997 Keynote)
