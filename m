Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072Ab1LMBx2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 20:53:28 -0500
Received: from ozlabs.org ([203.10.76.45]:40227 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753685Ab1LMBxZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 20:53:25 -0500
From: Michael Neuling <mikey@neuling.org>
To: Paul Gortmaker <paul.gortmaker@windriver.com>, Greg KH <gregkh@suse.de>
cc: Alan Cox <alan@linux.intel.com>, linux-kernel@vger.kernel.org,
        sfr@canb.auug.org.au, linux-next@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>, Michal Marek <mmarek@suse.cz>
Subject: Re: [PATCH] serial: fix Kconfig for Freescale 16550
In-reply-to: <20111213005444.GA27190@suse.de>
References: <7963.1323736263@neuling.org> <20111213005444.GA27190@suse.de>
Comments: In-reply-to Greg KH <gregkh@suse.de>
   message dated "Mon, 12 Dec 2011 16:54:44 -0800."
X-Mailer: MH-E 8.2; nmh 1.3; GNU Emacs 23.3.1
Date: Tue, 13 Dec 2011 12:53:22 +1100
Message-ID: <21148.1323741202@neuling.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In message <20111213005444.GA27190@suse.de> you wrote:
> On Tue, Dec 13, 2011 at 11:31:03AM +1100, Michael Neuling wrote:
> > next-20111212 breaks with linking a pmac32_defconfig with:
> >   drivers/built-in.o: In function `fsl8250_handle_irq':
> >   (.text+0x7ba74): undefined reference to `serial8250_modem_status'
> >   drivers/built-in.o: In function `fsl8250_handle_irq':
> >   (.text+0x7baa4): undefined reference to `serial8250_tx_chars'
> >   drivers/built-in.o: In function `fsl8250_handle_irq':
> >   (.text+0x7bab4): undefined reference to `serial8250_rx_chars'
> > 
> > Caused by:
> >   9deaa53 serial: add irq handler for Freescale 16550 errata.
> > 
> > pmac32_defconfig results in SERIAL_8250_FSL=y but SERIAL_8250=m so
> > 8250_fsl.c doesn't link properly.  
> > 
> > This explicitly makes SERIAL_8250_FSL depends on SERIAL_8250=y. 
> > 
> > Signed-off-by: Michael Neuling <mikey@neuling.org>
> > ---
> > I'm not sure this is the right fix as it seems like a Kconfig bug.  
> > 
> > diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
> > index a1d55c3..c9046de 100644
> > --- a/drivers/tty/serial/Kconfig
> > +++ b/drivers/tty/serial/Kconfig
> > @@ -99,7 +99,7 @@ config SERIAL_8250_PNP
> >  
> >  config SERIAL_8250_FSL
> >  	bool
> > -	depends on SERIAL_8250 && PPC
> > +	depends on SERIAL_8250=y && PPC
> 
> Then you can't select SERIAL_8250 as a module at all, right?  

Correct, unless SERIAL_8250_FOL=n of course.

> Perhaps you should allow SERIAL_8250_FSL to be a module as well here?
> So changing the bool to a tristate should be the correct option?  Can
> you try that?

Yep, that works also.  New patch below.  

This should probably be aced by Paul to ensure he's cool with it being
a module now. 

Mikey


From: Michael Neuling <mikey@neuling.org>

serial: fix Kconfig for Freescale 16550

next-20111212 breaks with linking a pmac32_defconfig with:
  drivers/built-in.o: In function `fsl8250_handle_irq':
  (.text+0x7ba74): undefined reference to `serial8250_modem_status'
  drivers/built-in.o: In function `fsl8250_handle_irq':
  (.text+0x7baa4): undefined reference to `serial8250_tx_chars'
  drivers/built-in.o: In function `fsl8250_handle_irq':
  (.text+0x7bab4): undefined reference to `serial8250_rx_chars'

Caused by:
  9deaa53 serial: add irq handler for Freescale 16550 errata.

pmac32_defconfig results in SERIAL_8250_FSL=y but SERIAL_8250=m so
8250_fsl.c doesn't link properly for the kernel.  

This makes SERIAL_8250_FSL tristate.

Signed-off-by: Michael Neuling <mikey@neuling.org>
Suggested-by: Greg KH <gregkh@suse.de>

diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
index a1d55c3..d8832a4 100644
--- a/drivers/tty/serial/Kconfig
+++ b/drivers/tty/serial/Kconfig
@@ -98,7 +98,7 @@ config SERIAL_8250_PNP
 	  disable this feature if you only need legacy serial support.
 
 config SERIAL_8250_FSL
-	bool
+	tristate
 	depends on SERIAL_8250 && PPC
 	default PPC
 
