Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753847Ab2A0SgS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 13:36:18 -0500
Received: from andromeda.dapyr.net ([206.212.254.10]:49720 "EHLO
	andromeda.dapyr.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753807Ab2A0SgP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 13:36:15 -0500
Date: Fri, 27 Jan 2012 14:36:02 -0400
From: Konrad Rzeszutek Wilk <konrad@darnok.org>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>
Subject: Re: [Xen-devel] [PATCH 2/2] hvc_xen: implement multiconsole support
Message-ID: <20120127183602.GA9780@andromeda.dapyr.net>
References: <alpine.DEB.2.00.1201261233050.3196@kaball-desktop> <1327581807-17276-2-git-send-email-stefano.stabellini@eu.citrix.com> <20120127160355.GA566@andromeda.dapyr.net> <alpine.DEB.2.00.1201271713200.3196@kaball-desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1201271713200.3196@kaball-desktop>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 27, 2012 at 05:16:45PM +0000, Stefano Stabellini wrote:
> On Fri, 27 Jan 2012, Konrad Rzeszutek Wilk wrote:
> > On Thu, Jan 26, 2012 at 12:43:27PM +0000, Stefano Stabellini wrote:
> > > This patch implements support for multiple consoles:
> > > consoles other than the first one are setup using the traditional xenbus
> > > and grant-table based mechanism.
> > > We use a list to keep track of the allocated consoles, we don't
> > > expect too many of them anyway.
> > >
> > > Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> > > ---
> > >  drivers/tty/hvc/hvc_xen.c |  439 +++++++++++++++++++++++++++++++++++++++------
> > >  1 files changed, 383 insertions(+), 56 deletions(-)
> > >
> > > diff --git a/drivers/tty/hvc/hvc_xen.c b/drivers/tty/hvc/hvc_xen.c
> > > index dd6641f..97732fb 100644
> > > --- a/drivers/tty/hvc/hvc_xen.c
> > > +++ b/drivers/tty/hvc/hvc_xen.c
> > > @@ -23,6 +23,7 @@
> > >  #include <linux/err.h>
> > >  #include <linux/init.h>
> > >  #include <linux/types.h>
> > > +#include <linux/list.h>
> > >
> > >  #include <asm/io.h>
> > >  #include <asm/xen/hypervisor.h>
> > > @@ -30,47 +31,69 @@
> > >  #include <xen/xen.h>
> > >  #include <xen/interface/xen.h>
> > >  #include <xen/hvm.h>
> > > +#include <xen/grant_table.h>
> > >  #include <xen/page.h>
> > >  #include <xen/events.h>
> > >  #include <xen/interface/io/console.h>
> > >  #include <xen/hvc-console.h>
> > > +#include <xen/xenbus.h>
> > >
> > >  #include "hvc_console.h"
> > >
> > >  #define HVC_COOKIE   0x58656e /* "Xen" in hex */
> > >
> > > -static struct hvc_struct *hvc;
> > > -static int xencons_irq;
> > > +struct xencons_info {
> > > +     struct list_head list;
> > > +     struct xenbus_device *xbdev;
> > > +     struct xencons_interface *intf;
> > > +     unsigned int evtchn;
> > > +     struct hvc_struct *hvc;
> > > +     int irq;
> > > +     int vtermno;
> > > +     grant_ref_t gntref;
> > > +};
> > > +
> > > +static LIST_HEAD(xenconsoles);
> > > +static DEFINE_SPINLOCK(xencons_lock);
> > > +static struct xenbus_driver xencons_driver;
> > >
> > >  /* ------------------------------------------------------------------ */
> > >
> > > -static unsigned long console_pfn = ~0ul;
> > > -static unsigned int console_evtchn = ~0ul;
> > > -static struct xencons_interface *xencons_if = NULL;
> > > +static struct xencons_info *vtermno_to_xencons(int vtermno)
> > > +{
> > > +     struct xencons_info *entry, *ret = NULL;
> > > +
> > > +     if (list_empty(&xenconsoles))
> > > +                     return NULL;
> > >
> > > -static inline struct xencons_interface *xencons_interface(void)
> > > +     spin_lock(&xencons_lock);
> > 
> > This spinlock gets hit everytime something is typed or written on the
> > console right? Isn't there an spinlock already in the hvc driver...
> > 
> > Or are we protected by the vtermnos being checked for -1?
> 
> I think you are right: the spinlock is there to protect access to the
> list, so we can change list_for_each_entry to list_for_each_entry_safe
> in vtermno_to_xencons and we solve the problem. All the other spinlock
> acquisitions are done at console creation/destruction.

Right. So I think this will work as long as you mkae the call
to hvc_remove _before_ your remove entries from the xenconsoles.

That way hvc_remove will set vtermnos[x] to -1 and inhibit
any callers from calling into us.

This means you will need to redo the xencons_remove and xencons_free
a bit.. Hmm, there looks to be dead-lock there - let me send the
details.
