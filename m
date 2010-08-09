Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753058Ab0HIFcw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 01:32:52 -0400
Received: from LUNGE.MIT.EDU ([18.54.1.69]:33902 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752086Ab0HIFcv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 01:32:51 -0400
Date: Mon, 9 Aug 2010 01:32:45 -0400
From: Andres Salomon <dilinger@queued.net>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: devicetree-discuss@lists.ozlabs.org, sparclinux@vger.kernel.org,
        davem@davemloft.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] sparc: make driver/of/pdt no longer sparc-specific
Message-ID: <20100809013245.1cefb9bf@dev.queued.net>
In-Reply-To: <AANLkTimG7u5eXWSn5VznKfuFcFD+evTzo1_QpAFmCdpL@mail.gmail.com>
References: <20100808231116.21c7d6f3@dev.queued.net>
	<AANLkTimG7u5eXWSn5VznKfuFcFD+evTzo1_QpAFmCdpL@mail.gmail.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.12.12; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 8 Aug 2010 23:12:21 -0600
Grant Likely <grant.likely@secretlab.ca> wrote:

> Hi Andres, thanks for the patch.  Comments below.
> 
> g.
> 
> On Sun, Aug 8, 2010 at 9:11 PM, Andres Salomon <dilinger@queued.net>
> wrote:
[...]
> > +
> >  unsigned int prom_early_allocated __initdata;
> >
> > -#include "../../../drivers/of/pdt.c"
> > +static struct of_pdt_ops prom_sparc_ops __initdata = {
> > +       .firstprop = prom_common_firstprop,
> > +       .nextprop = prom_common_nextprop,
> > +       .getproplen = (int (*)(phandle, const char
> > *))prom_getproplen,
> > +       .getproperty = (int (*)(phandle, const char *, char *,
> > int))prom_getproperty,
> > +       .getchild = (phandle (*)(phandle))prom_getchild,
> > +       .getsibling = (phandle (*)(phandle))prom_getsibling,
> 
> If you have to explicitly cast these function pointers, then you're
> doing it wrong.  :-)  Listen to and fix the compiler complaint here.
> 

Hm, can you please expand on that?  The reason it's necessary to cast is
because sparc's prom_* functions are using ints instead of phandles.  I
don't understand why casting is the wrong thing here.

I could write some 1-line wrapper functions that simply call prom_*
rather than casting, I suppose.

[...]
> > +}
> > diff --git a/drivers/of/Kconfig b/drivers/of/Kconfig
> > index 1678dbc..c8a4b7c 100644
> > --- a/drivers/of/Kconfig
> > +++ b/drivers/of/Kconfig
> > @@ -5,6 +5,10 @@ config OF_FLATTREE
> >        bool
> >        depends on OF
> >
> > +config OF_PROMTREE
> > +       bool
> > +       depends on OF
> > +
> 
> I can tell from the context here you're working from an older tree.
> Please rebase onto Linus' current top-of-tree.  :-)  A bunch of OF
> related patches have been merged for 2.6.36 that will conflict with
> this patch.
> 

Sorry, will do.  Was just looking for more feedback (while testing)
before sending final versions of this stuff.


[...]
> 
> > +
> > +#if defined(CONFIG_SPARC)
> > +static unsigned int prom_unique_id __initdata;
> > +
> > +#define inc_unique_id(p) do { \
> > +       (p)->unique_id = prom_unique_id++; \
> > +} while (0)
> 
> Use a static inline.  C code is preferred over preprocessor code.
> Also preserver the namespace and use the of_pdt_ prefix (that goes for
> all the new functions here in this file).

This is processing multiple types, that's the reason for the macro.

'p' can be either a property struct, or device_node struct.


[...]
> > -       of_console_init();
> > +void __init of_pdt_set_ops(struct of_pdt_ops *ops)
> > +{
> > +       BUG_ON(!ops);
> >
> > -       printk("PROM: Built device tree with %u bytes of memory.\n",
> > -              prom_early_allocated);
> > +       prom_ops = *ops;
> 
> As mentioned above, why is the structure copied instead of just
> storing the pointer.
> 

Er, right, because originally the struct was handled differently.  No
reason for it to be copied anymore.

Thanks for the feedback!
