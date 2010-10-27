Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753614Ab0J0RsZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 13:48:25 -0400
Received: from LUNGE.MIT.EDU ([18.54.1.69]:43537 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753408Ab0J0RsX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 13:48:23 -0400
Date: Wed, 27 Oct 2010 10:48:18 -0700
From: Andres Salomon <dilinger@queued.net>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: devicetree-discuss@lists.ozlabs.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org, Mitch Bradley <wmb@laptop.org>
Subject: Re: [PATCH] x86: OLPC: add OLPC device-tree support (v3)
Message-ID: <20101027104818.6baff775@queued.net>
In-Reply-To: <20101027101933.GD6797@angua.secretlab.ca>
References: <20101022155846.66cde32f@queued.net>
	<20101027101933.GD6797@angua.secretlab.ca>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Oct 2010 11:19:33 +0100
Grant Likely <grant.likely@secretlab.ca> wrote:

> On Fri, Oct 22, 2010 at 03:58:46PM -0700, Andres Salomon wrote:
> > 
> > Make use of PROC_DEVICETREE to export the tree, and sparc's
> > PROMTREE code to call into OLPC's Open Firmware to build the tree.
> > 
> > v3: rename olpc_prom to olpc_dt
> >   - rework Kconfig entries
> >   - drop devtree build hook from proc, instead adding a call to
> > x86's paging_init (similarly to how sparc64 does it)
> >   - switch allocation from using slab to alloc_bootmem.  this allows
> >     the DT to be built earlier during boot (during setup_arch); the
> >     downside is that there are some 1200 bootmem reservations that
> > are done during boot.  Not ideal..
> >   - add a helper olpc_ofw_is_installed function to test for the
> >     existence and successful detection of OLPC's OFW.
> > 
> > Signed-off-by: Andres Salomon <dilinger@queued.net>
> 
> Overall this patch looks fine, but it needs to be acked from the x86
> maintainers, and I'd like it to have a cycle through linux-next before
> it gets merged, so that means 2.6.38 because the 2.6.37 merge window
> has already been open for almost a week.
> 
> The promtree patches have been merged though.

I saw that; thanks!

It would be good to get an Ack on that additional x86 patch, too..


> 
> Comments below.
> 
> g.
> 
> > ---
> >  arch/x86/Kconfig                |    6 ++
> >  arch/x86/include/asm/olpc_ofw.h |    9 ++
> >  arch/x86/include/asm/prom.h     |    1 +
> >  arch/x86/kernel/Makefile        |    1 +
> >  arch/x86/kernel/olpc_dt.c       |  165
> > +++++++++++++++++++++++++++++++++++++++
> > arch/x86/kernel/olpc_ofw.c      |    5 +
> > arch/x86/mm/init_32.c           |    2 + 7 files changed, 189
> > insertions(+), 0 deletions(-) create mode 100644
> > arch/x86/include/asm/prom.h create mode 100644
> > arch/x86/kernel/olpc_dt.c
> > 
> > diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> > index cea0cd9..1d57e2b 100644
> > --- a/arch/x86/Kconfig
> > +++ b/arch/x86/Kconfig
> > @@ -2069,11 +2069,17 @@ config OLPC_OPENFIRMWARE
> >  	bool "Support for OLPC's Open Firmware"
> >  	depends on !X86_64 && !X86_PAE
> >  	default y if OLPC
> > +	select OF
> >  	help
> >  	  This option adds support for the implementation of Open
> > Firmware that is used on the OLPC XO-1 Children's Machine.
> >  	  If unsure, say N here.
> >  
> > +config OLPC_OPENFIRMWARE_DT
> > +	bool
> > +	default y if OLPC_OPENFIRMWARE && PROC_DEVICETREE
> > +	select OF_PROMTREE
> > +
> >  endif # X86_32
> >  
> >  config K8_NB
> > diff --git a/arch/x86/include/asm/olpc_ofw.h
> > b/arch/x86/include/asm/olpc_ofw.h index 08fde47..a41250e 100644
> > --- a/arch/x86/include/asm/olpc_ofw.h
> > +++ b/arch/x86/include/asm/olpc_ofw.h
> > @@ -8,6 +8,8 @@
> >  
> >  #ifdef CONFIG_OLPC_OPENFIRMWARE
> >  
> > +extern bool olpc_ofw_is_installed(void);
> > +
> >  /* run an OFW command by calling into the firmware */
> >  #define olpc_ofw(name, args, res) \
> >  	__olpc_ofw((name), ARRAY_SIZE(args), args,
> > ARRAY_SIZE(res), res) @@ -23,9 +25,16 @@ extern void
> > setup_olpc_ofw_pgd(void); 
> >  #else /* !CONFIG_OLPC_OPENFIRMWARE */
> >  
> > +static inline bool olpc_ofw_is_installed(void) { return false; }
> >  static inline void olpc_ofw_detect(void) { }
> >  static inline void setup_olpc_ofw_pgd(void) { }
> >  
> >  #endif /* !CONFIG_OLPC_OPENFIRMWARE */
> >  
> > +#ifdef CONFIG_OLPC_OPENFIRMWARE_DT
> > +extern void olpc_dt_build_devicetree(void);
> > +#else
> > +static inline void olpc_dt_build_devicetree(void) { }
> > +#endif /* CONFIG_OLPC_OPENFIRMWARE_DT */
> > +
> >  #endif /* _ASM_X86_OLPC_OFW_H */
> > diff --git a/arch/x86/include/asm/prom.h
> > b/arch/x86/include/asm/prom.h new file mode 100644
> > index 0000000..b4ec95f
> > --- /dev/null
> > +++ b/arch/x86/include/asm/prom.h
> > @@ -0,0 +1 @@
> > +/* dummy prom.h; here to make linux/of.h's #includes happy */
> > diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
> > index fedf32a..519539a 100644
> > --- a/arch/x86/kernel/Makefile
> > +++ b/arch/x86/kernel/Makefile
> > @@ -107,6 +107,7 @@ scx200-y			+= scx200_32.o
> >  
> >  obj-$(CONFIG_OLPC)		+= olpc.o
> >  obj-$(CONFIG_OLPC_OPENFIRMWARE)	+= olpc_ofw.o
> > +obj-$(CONFIG_OLPC_OPENFIRMWARE_DT)	+= olpc_dt.o
> 
> olpc_ofw_dt.o perhaps?
> 
> >  obj-$(CONFIG_X86_MRST)		+= mrst.o
> >  
> >  microcode-y				:= microcode_core.o
> > diff --git a/arch/x86/kernel/olpc_dt.c b/arch/x86/kernel/olpc_dt.c
> > new file mode 100644
> > index 0000000..f660a11
> > --- /dev/null
> > +++ b/arch/x86/kernel/olpc_dt.c
> > @@ -0,0 +1,165 @@
> > +/*
> > + * olpc_dt.c: OLPC-specific OFW device tree support code.
> 
> Nit: I personally prefer not to see the file name encoded in the
> header block.
> 
> > + *
> > + * Paul Mackerras	August 1996.
> > + * Copyright (C) 1996-2005 Paul Mackerras.
> > + *
> > + *  Adapted for 64bit PowerPC by Dave Engebretsen and Peter
> > Bergner.
> > + *    {engebret|bergner}@us.ibm.com
> > + *
> > + *  Adapted for sparc by David S. Miller davem@davemloft.net
> > + *  Adapted for x86/OLPC by Andres Salomon <dilinger@queued.net>
> > + *
> > + *      This program is free software; you can redistribute it
> > and/or
> > + *      modify it under the terms of the GNU General Public License
> > + *      as published by the Free Software Foundation; either
> > version
> > + *      2 of the License, or (at your option) any later version.
> > + */
> > +
> > +#include <linux/kernel.h>
> > +#include <linux/bootmem.h>
> > +#include <linux/of.h>
> > +#include <linux/of_pdt.h>
> > +#include <asm/olpc_ofw.h>
> > +
> > +static phandle __init olpc_dt_getsibling(phandle node)
> > +{
> > +	const void *args[] = { (void *)node };
> > +	void *res[] = { &node };
> > +
> > +	if (node == -1)
> > +		return 0;
> 
> phandle is a u32, so testing against a negative value is not sane.
> 
> > +
> > +	if (olpc_ofw("peer", args, res) || node == -1)
> > +		return 0;
> > +
> > +	return node;
> > +}
> > +
> > +static phandle __init olpc_dt_getchild(phandle node)
> > +{
> > +	const void *args[] = { (void *)node };
> > +	void *res[] = { &node };
> > +
> > +	if (node == -1)
> > +		return 0;
> > +
> > +	if (olpc_ofw("child", args, res) || node == -1) {
> > +		pr_err("PROM: %s: fetching child failed!\n",
> > __func__);
> > +		return 0;
> > +	}
> > +
> > +	return node;
> > +}
> > +
> > +static int __init olpc_dt_getproplen(phandle node, const char
> > *prop) +{
> > +	const void *args[] = { (void *)node, prop };
> > +	int len;
> > +	void *res[] = { &len };
> > +
> > +	if (node == -1)
> > +		return -1;
> > +
> > +	if (olpc_ofw("getproplen", args, res)) {
> > +		pr_err("PROM: %s: getproplen failed!\n", __func__);
> > +		return -1;
> > +	}
> > +
> > +	return len;
> > +}
> > +
> > +static int __init olpc_dt_getproperty(phandle node, const char
> > *prop,
> > +		char *buf, int bufsize)
> > +{
> > +	int plen;
> > +
> > +	plen = olpc_dt_getproplen(node, prop);
> > +	if (plen > bufsize || plen < 1)
> > +		return -1;
> > +	else {
> 
> Nit: If there are braces on the else clause, then please use them on
> the if() clause also.
> 
> > +		const void *args[] = { (void *)node, prop, buf,
> > (void *)plen };
> > +		void *res[] = { &plen };
> > +
> > +		if (olpc_ofw("getprop", args, res)) {
> > +			pr_err("PROM: %s: getprop failed!\n",
> > __func__);
> > +			return -1;
> > +		}
> > +	}
> > +
> > +	return plen;
> > +}
> > +
> > +static int __init olpc_dt_nextprop(phandle node, char *prev, char
> > *buf) +{
> > +	const void *args[] = { (void *)node, prev, buf };
> 
> This looks wrong.  It does not look sane to cast node as a pointer
> (which won't be the same size on x86_64), and then recast it to an int
> inside __olpc_ofw().  Do you know why the api is implemented in this
> way?
> 

The __olpc_ofw API is implemented this way because Ingo didn't like the
original one which used varargs.  Using an array like this is cleaner
in terms of not needing to manually pass the number of arguments (as
the olpc_ofw macro deduces them using ARRAY_SIZE).

The recast to an int is required by OFW's cif interface.  I don't know
why it's done that way; I've cc'd Mitch on that.
