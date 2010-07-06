Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756322Ab0GFVz3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 17:55:29 -0400
Received: from LUNGE.MIT.EDU ([18.54.1.69]:47979 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756083Ab0GFVz2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 17:55:28 -0400
Date: Tue, 6 Jul 2010 14:54:46 -0700
From: Andres Salomon <dilinger@queued.net>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: devicetree-discuss@lists.ozlabs.org, sparclinux@vger.kernel.org,
       x86@kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       cjb@laptop.org, Mitch Bradley <wmb@laptop.org>, pgf@laptop.org,
       linux-kernel@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH 2/4] sparc: break out some prom device-tree building
 code  out into drivers/of
Message-ID: <20100706145446.5e8540aa@Nokia-N900-42-11>
In-Reply-To: <AANLkTikDdAuDOxBVgV_QDY-YZOOZCyl1O5aYzDXCjW10@mail.gmail.com>
References: <20100628215407.2017bf2f@debian>
	<20100628220037.5744c207@debian>
	<AANLkTikDdAuDOxBVgV_QDY-YZOOZCyl1O5aYzDXCjW10@mail.gmail.com>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.14.7; arm-unknown-linux-gnueabi)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Jul 2010 03:21:21 -0600
Grant Likely <grant.likely@secretlab.ca> wrote:

> On Mon, Jun 28, 2010 at 8:00 PM, Andres Salomon <dilinger@queued.net>
> wrote:
> >
> > Stick code into drivers/of/pdt.c (Prom Device Tree) that other
> > architectures with OpenFirmware resident in memory can make use of.
> >
> > Signed-off-by: Andres Salomon <dilinger@queued.net>
> 
> Some more comments below...
> 

Thanks for the review!



> >  arch/sparc/Kconfig              |    1 +
> >  arch/sparc/include/asm/prom.h   |   15 +++-
> >  arch/sparc/kernel/prom.h        |   14 ---
> >  arch/sparc/kernel/prom_common.c |  173
> > +------------------------------ drivers/of/Kconfig              |
> >  4 + drivers/of/Makefile             |    1 +
> >  drivers/of/pdt.c                |  225
> > +++++++++++++++++++++++++++++++++++++++ include/linux/of_pdt.h
> >      |   37 +++++++ 8 files changed, 282 insertions(+), 188
> > deletions(-) create mode 100644 drivers/of/pdt.c
> >  create mode 100644 include/linux/of_pdt.h
> >
> > diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
> > index 6f1470b..b4cb63b 100644
> > --- a/arch/sparc/Kconfig
> > +++ b/arch/sparc/Kconfig
> > @@ -150,6 +150,7 @@ config ARCH_NO_VIRT_TO_BUS
> >
> >  config OF
> >        def_bool y
> > +       select OF_PROMTREE
> >
> >  config ARCH_SUPPORTS_DEBUG_PAGEALLOC
> >        def_bool y if SPARC64
> > diff --git a/arch/sparc/include/asm/prom.h
> > b/arch/sparc/include/asm/prom.h index f845828..0834c2a 100644
> > --- a/arch/sparc/include/asm/prom.h
> > +++ b/arch/sparc/include/asm/prom.h
> > @@ -18,6 +18,7 @@
> >  * 2 of the License, or (at your option) any later version.
> >  */
> >  #include <linux/types.h>
> > +#include <linux/of_pdt.h>
> >  #include <linux/proc_fs.h>
> >  #include <linux/mutex.h>
> >  #include <asm/atomic.h>
> > @@ -65,8 +66,18 @@ extern struct device_node *of_console_device;
> >  extern char *of_console_path;
> >  extern char *of_console_options;
> >
> > -extern void (*prom_build_more)(struct device_node *dp, struct
> > device_node ***nextp); -extern char *build_full_name(struct
> > device_node *dp); +/* stuff used by of/pdt */
> > +extern void * prom_early_alloc(unsigned long size);
> > +extern void irq_trans_init(struct device_node *dp);
> > +extern char *build_path_component(struct device_node *dp);
> > +
> > +extern char *prom_firstprop(int node, char *buffer);
> > +extern char *prom_nextprop(int node, const char *oprop, char
> > *buffer); +extern int prom_getproplen(int node, const char *prop);
> > +extern int prom_getproperty(int node, const char *prop,
> > +                           char *buffer, int bufsize);
> > +extern int prom_getchild(int node);
> > +extern int prom_getsibling(int node);
> 
> These become the API required by of/pdt.  They should be defined in a
> arch-independent header file.  Something like include/linux/of_pdt.h
> 
> Right now only OLPC will be using this, so static function definitions
> are just fine.  However, if there is ever more than one method for
> talking to OFW, then these hooks will need to be converted into an ops
> structure so the right one can be passed in at runtime.
> 

Note that sparc and OLPC actually use slightly different function
signatures; OLPC uses phandles for nodes, while sparc uses ints.  Not a
huge difference, but enough that I didn't want to mess w/ a generic
version of it early in the process.  I agree that op structs would be
nicer, and will probably move towards that. 

[...]

> > diff --git a/include/linux/of_pdt.h b/include/linux/of_pdt.h
> > new file mode 100644
> > index 0000000..f62616e
> > --- /dev/null
> > +++ b/include/linux/of_pdt.h
> > @@ -0,0 +1,37 @@
> > +#include <linux/of.h>  /* linux/of.h gets to determine #include
> > ordering */
> 
> Do you really need this #include in this way?  Can it be moved inside
> the #ifndef OF_PDT block below?
> 

Not sure, will try out different variants and see what breaks.

[...]

> Another general comment, I'm still not thrilled with this code having
> its own independent method for building the tree, but I doubt the
> existing add/remove nodes and properties code is usable early enough
> to be suitable for sparc.  How early do you extract the device tree on
> OLPC?  How are you going to use the data?

Not that early; very early code fetches information necessary to call
into the PROM, and ensures that the kernel doesn't clobber OFW's
memory.   After that, we can build the dt at any point during init.
The data is to be exported via proc for userspace to use in
determining hardware (and firmware) info.

