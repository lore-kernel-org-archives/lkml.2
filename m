Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757318Ab1F1Lw7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 07:52:59 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:54675 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757144Ab1F1LwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 07:52:05 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 7/7] serial/8250: make PIO support optional
Date: Tue, 28 Jun 2011 13:52:01 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: "Greg Kroah-Hartman" <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
References: <1309211120-2803-1-git-send-email-arnd@arndb.de> <1309211120-2803-8-git-send-email-arnd@arndb.de> <20110628110500.1cf60104@lxorguk.ukuu.org.uk>
In-Reply-To: <20110628110500.1cf60104@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106281352.01459.arnd@arndb.de>
X-Provags-ID: V02:K0:3xBtP4uViwKGn259GVUWdnp1FC18aJDFr0IwdQTXfYc
 4LpYwiMvHHBaKi9IIe/BEHJC14lc/8eTfEsD4uEyAcu2e6DMX0
 XwsINXbKk/ymGShUa0ULt+mv1eSher3T3iXudq4sGFWtZKDuv2
 AnhlA+RM/LP73CaaAGlY5ipeD3VYj3XmR/DYVtUUYcWke113cF
 7WuqHtpzGHbsmE44LF1cQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 28 June 2011, Alan Cox wrote:
> > This makes the PIO support in the 8250 driver completely
> > conditional on CONFIG_HAS_IOPORT so we can remove the bogus
> > definitions from all the places that only need them for 8250.
> 
> NAK this as last time.
> 
> We had a discussion about how to fix this properly. I even posted some
> sketched out patches to show how it could be addressed
> 
> Shotgunning the code with ifdefs was not that.
> 
> 
> Get the port methods out of the core code as was proposed.

I got this done for all the obscure ones in patches 1-6, leaving
only the common UPIO_PORT and UPIO_MEM ones. Changing those would
mean a lot more churn, and also solving a few other problems:

Back then, I wrote:
>On Friday 11 March 2011, Alan Cox wrote:
>
>> For 8250 the way to do that is to remove all the switches and port type
>> stuff and propogate to setting ->serial_in and ->serial_out rather than
>> splattering the code with ifdefs. At that point you'd have a "lib8250" or
>> similar and an 8250_io/pci driver.
>
>Right, this absolutely makes sense. It's a lot more work than the originally
>suggested patch, but the result is much cleaner.

One of the problems I encountered now is that most of the frontend drivers
(pci, of, platform, pcmcia) still require access to both MEM and PORT
methods on some platforms, but we want to use the same drivers (platform
and of) on systems that don't have port methods, so it's back to #ifdef
anyway.

Another problem is that the platform devices that set ->iotype are
usually defined in builtin code. Changing the device definitions to
set serial_in/serial_out directly means we also have to link those
functions into the kernel, even if the actual 8250 driver is a module.

A possible option might be to use ioread/iowrite to replace the
choice between MEM and PORT I/O with a common function. I thought
about that, but wasn't sure if we can alwasy call ioport_map early
enough for the console driver.

On Tuesday 28 June 2011, Alan Cox wrote:
> > -             p->serial_in = io_serial_in;
> > -             p->serial_out = io_serial_out;
> > +             p->serial_in = mem_serial_in;
> > +             p->serial_out = mem_serial_out;
> >               break;
>
>And this kind of stuff changing defaults is asking for trouble.

I went back and forth between a few versions on this one, and only
later thought of one that would have been better. I did make sure
that the "default" case is only there for UPIO_PORT before and only
for UPIO_MEM after the patch. I can fix this in a better way.

The easiest approach would be to conditionalize just the inb/outb,
as below. As I explained the last time, the 8250 driver is really
the only one that has this problem because it doesn't use
ioread/iowrite and is common on both PC-style hardware and embedded
into SOCs that don't have PIO.

I would much prefer getting a build error on inb/outb for the latter
kind than having to provide bogus definitions in a lot of architectures.
For request_region, it's probably better to stub out the macro than
the users.

	Arnd

--- a/drivers/tty/serial/8250.c
+++ b/drivers/tty/serial/8250.c
@@ -499,14 +499,18

 static unsigned int io_serial_in(struct uart_port *p, int offset)
 {
-       offset = map_8250_in_reg(p, offset) << p->regshift;
+#ifdef CONFIG_HAS_IOPORT
        return inb(p->iobase + offset);
+#else
+       return 0xff;
+#endif
 }

 static void io_serial_out(struct uart_port *p, int offset, int value)
 {
-       offset = map_8250_out_reg(p, offset) << p->regshift;
+#ifdef CONFIG_HAS_IOPORT
        outb(value, p->iobase + offset);
+#endif
 }

 static void set_io_from_upio(struct uart_port *p)
--- a/include/linux/ioport.h
+++ b/include/linux/ioport.h
@@ -145,8 +145,13 @@ static inline unsigned long resource_type(const struct resource *res)
 }

 /* Convenience shorthand with allocation */
+#ifdef CONFIG_HAS_IOPORT
 #define request_region(start,n,name)           __request_region(&ioport_resource, (start), (n), (name), 0)
 #define request_muxed_region(start,n,name)     __request_region(&ioport_resource, (start), (n), (name), IORESOURCE_MUXED)
+#else
+#define request_region(start,n,name)           NULL
+#define request_muxed_region(start,n,name)     NULL
+#endif
 #define __request_mem_region(start,n,name, excl) __request_region(&iomem_resource, (start), (n), (name), excl)
 #define request_mem_region(start,n,name) __request_region(&iomem_resource, (start), (n), (name), 0)
 #define request_mem_region_exclusive(start,n,name) \
