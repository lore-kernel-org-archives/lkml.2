Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754274Ab1LMC7A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 21:59:00 -0500
Received: from ozlabs.org ([203.10.76.45]:41942 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753468Ab1LMC67 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 21:58:59 -0500
From: Michael Neuling <mikey@neuling.org>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
cc: Greg KH <gregkh@suse.de>, Alan Cox <alan@linux.intel.com>,
        linux-kernel@vger.kernel.org, sfr@canb.auug.org.au,
        linux-next@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Michal Marek <mmarek@suse.cz>
Subject: Re: [PATCH] serial: fix Kconfig for Freescale 16550
In-reply-to: <20111213024738.GA17663@windriver.com>
References: <7963.1323736263@neuling.org> <20111213005444.GA27190@suse.de> <21148.1323741202@neuling.org> <20111213024738.GA17663@windriver.com>
Comments: In-reply-to Paul Gortmaker <paul.gortmaker@windriver.com>
   message dated "Mon, 12 Dec 2011 21:47:38 -0500."
X-Mailer: MH-E 8.2; nmh 1.3; GNU Emacs 23.3.1
Date: Tue, 13 Dec 2011 13:58:56 +1100
Message-ID: <749.1323745136@neuling.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In message <20111213024738.GA17663@windriver.com> you wrote:
> [Re: [PATCH] serial: fix Kconfig for Freescale 16550] On 13/12/2011 (Tue 12:5
3) Michael Neuling wrote:
> 
> > In message <20111213005444.GA27190@suse.de> you wrote:
> 
> [...]
> 
> > > Then you can't select SERIAL_8250 as a module at all, right?  
> > 
> > Correct, unless SERIAL_8250_FOL=n of course.
> > 
> > > Perhaps you should allow SERIAL_8250_FSL to be a module as well here?
> > > So changing the bool to a tristate should be the correct option?  Can
> > > you try that?
> > 
> > Yep, that works also.  New patch below.  
> > 
> > This should probably be aced by Paul to ensure he's cool with it being
> > a module now. 
> 
> This will still be broken, but in a different place and for different
> boards.  [The legacy_serial.c won't link for 8250=m on FSL boards.]
> 
> I think your original fix was closer to the right one.   Let me expand
> on that.   This thing isn't a real stand alone driver.  It is an errata
> fix that is specific to Freescale boards, and only is relevant in fixing
> magic SysRQ functionality on the serial console.   The Freescale boards
> are almost exclusively headless, with a serial console interface to
> u-boot as the only way to do initial interaction with the board at
> bootup.  So having serial as a module on these boards is largely
> academic.  (But if you want modular serial, you still can, and you
> dont need the errata fix for that.)
> 
> So, with all that in mind, I think this is the right fix.  I'll launch
> some build coverage against it, but it seems straightforward.  Thanks
> for the report, and sorry for catching pmac in the fallout.
> 
> Paul.
> ---
> 
>  From 675520f2d175bd71bf857b75a5a9b5a08ee0ee54 Mon Sep 17 00:00:00 2001
> From: Paul Gortmaker <paul.gortmaker@windriver.com>
> Date: Mon, 12 Dec 2011 21:18:15 -0500
> Subject: [PATCH] serial: make FSL errata depend on 8250_CONSOLE, not just
>  8250
> 
> The recent commit "serial: add irq handler for Freescale 16550 errata"
> would allow Kconfig choices that had 8250 support as a module and
> yet still try and build in the errata fix non-modular, resulting
> in build failures for some non-embedded PPC targets.
> 
> Since we hook in the errata fix from legacy_serial.c, which is
> built only for PPC_UDBG_16550, and since the errata is only really
> relevant for SysRQ on serial console, tighten up the dependencies
> to be exactly that.
> 
> We'll get coverage on the relevant Freescale boards because the
> Kconfig for their CPU types all select the PPC_UDBG_16550 option,
> and the defconfigs also all select the 8250_CONSOLE option.  Also,
> the 8250_CONSOLE option has a strict dependency on "SERIAL_8250=y"
> which resolves the reported problem for non Freescale targets.
> 
> Reported-by: Michael Neuling <mikey@neuling.org>
> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>

Works here for me (although it still seems like a Kconfig bug).

Tested-by: Michael Neuling <mikey@neuling.org>

> 
> diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
> index aa46993..5c46e90 100644
> --- a/drivers/tty/serial/Kconfig
> +++ b/drivers/tty/serial/Kconfig
> @@ -99,7 +99,7 @@ config SERIAL_8250_PNP
>  
>  config SERIAL_8250_FSL
>  	bool
> -	depends on SERIAL_8250 && PPC
> +	depends on SERIAL_8250_CONSOLE && PPC_UDBG_16550
>  	default PPC
>  
>  config SERIAL_8250_HP300
> -- 
> 1.7.7
> 
