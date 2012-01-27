Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752208Ab2A0RPs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 12:15:48 -0500
Received: from smtp.eu.citrix.com ([62.200.22.115]:24729 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752084Ab2A0RPp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 12:15:45 -0500
X-IronPort-AV: E=Sophos;i="4.71,581,1320624000"; 
   d="scan'208";a="10338552"
Date: Fri, 27 Jan 2012 17:16:45 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Konrad Rzeszutek Wilk <konrad@darnok.org>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>
Subject: Re: [Xen-devel] [PATCH 2/2] hvc_xen: implement multiconsole
 support
In-Reply-To: <20120127160355.GA566@andromeda.dapyr.net>
Message-ID: <alpine.DEB.2.00.1201271713200.3196@kaball-desktop>
References: <alpine.DEB.2.00.1201261233050.3196@kaball-desktop> <1327581807-17276-2-git-send-email-stefano.stabellini@eu.citrix.com> <20120127160355.GA566@andromeda.dapyr.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Jan 2012, Konrad Rzeszutek Wilk wrote:
> On Thu, Jan 26, 2012 at 12:43:27PM +0000, Stefano Stabellini wrote:
> > This patch implements support for multiple consoles:
> > consoles other than the first one are setup using the traditional xenbus
> > and grant-table based mechanism.
> > We use a list to keep track of the allocated consoles, we don't
> > expect too many of them anyway.
> >
> > Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> > ---
> >  drivers/tty/hvc/hvc_xen.c |  439 +++++++++++++++++++++++++++++++++++++++------
> >  1 files changed, 383 insertions(+), 56 deletions(-)
> >
> > diff --git a/drivers/tty/hvc/hvc_xen.c b/drivers/tty/hvc/hvc_xen.c
> > index dd6641f..97732fb 100644
> > --- a/drivers/tty/hvc/hvc_xen.c
> > +++ b/drivers/tty/hvc/hvc_xen.c
> > @@ -23,6 +23,7 @@
> >  #include <linux/err.h>
> >  #include <linux/init.h>
> >  #include <linux/types.h>
> > +#include <linux/list.h>
> >
> >  #include <asm/io.h>
> >  #include <asm/xen/hypervisor.h>
> > @@ -30,47 +31,69 @@
> >  #include <xen/xen.h>
> >  #include <xen/interface/xen.h>
> >  #include <xen/hvm.h>
> > +#include <xen/grant_table.h>
> >  #include <xen/page.h>
> >  #include <xen/events.h>
> >  #include <xen/interface/io/console.h>
> >  #include <xen/hvc-console.h>
> > +#include <xen/xenbus.h>
> >
> >  #include "hvc_console.h"
> >
> >  #define HVC_COOKIE   0x58656e /* "Xen" in hex */
> >
> > -static struct hvc_struct *hvc;
> > -static int xencons_irq;
> > +struct xencons_info {
> > +     struct list_head list;
> > +     struct xenbus_device *xbdev;
> > +     struct xencons_interface *intf;
> > +     unsigned int evtchn;
> > +     struct hvc_struct *hvc;
> > +     int irq;
> > +     int vtermno;
> > +     grant_ref_t gntref;
> > +};
> > +
> > +static LIST_HEAD(xenconsoles);
> > +static DEFINE_SPINLOCK(xencons_lock);
> > +static struct xenbus_driver xencons_driver;
> >
> >  /* ------------------------------------------------------------------ */
> >
> > -static unsigned long console_pfn = ~0ul;
> > -static unsigned int console_evtchn = ~0ul;
> > -static struct xencons_interface *xencons_if = NULL;
> > +static struct xencons_info *vtermno_to_xencons(int vtermno)
> > +{
> > +     struct xencons_info *entry, *ret = NULL;
> > +
> > +     if (list_empty(&xenconsoles))
> > +                     return NULL;
> >
> > -static inline struct xencons_interface *xencons_interface(void)
> > +     spin_lock(&xencons_lock);
> 
> This spinlock gets hit everytime something is typed or written on the
> console right? Isn't there an spinlock already in the hvc driver...
> 
> Or are we protected by the vtermnos being checked for -1?

I think you are right: the spinlock is there to protect access to the
list, so we can change list_for_each_entry to list_for_each_entry_safe
in vtermno_to_xencons and we solve the problem. All the other spinlock
acquisitions are done at console creation/destruction.


> > +     list_for_each_entry(entry, &xenconsoles, list) {
> > +             if (entry->vtermno == vtermno) {
> > +                     ret  = entry;
> > +                     break;
> > +             }
> > +     }
> > +     spin_unlock(&xencons_lock);
> > +
> > +     return ret;
> > +}
> > +
> > +static inline int xenbus_devid_to_vtermno(int devid)
> >  {
> > -     if (xencons_if != NULL)
> > -             return xencons_if;
> > -     if (console_pfn == ~0ul)
> > -             return mfn_to_virt(xen_start_info->console.domU.mfn);
> > -     else
> > -             return __va(console_pfn << PAGE_SHIFT);
> > +     return devid + HVC_COOKIE;
> >  }
> >
> > -static inline void notify_daemon(void)
> > +static inline void notify_daemon(struct xencons_info *cons)
> >  {
> >       /* Use evtchn: this is called early, before irq is set up. */
> > -     if (console_evtchn == ~0ul)
> > -             notify_remote_via_evtchn(xen_start_info->console.domU.evtchn);
> > -     else
> > -             notify_remote_via_evtchn(console_evtchn);
> > +     notify_remote_via_evtchn(cons->evtchn);
> >  }
> >
> > -static int __write_console(const char *data, int len)
> > +static int __write_console(struct xencons_info *xencons,
> > +             const char *data, int len)
> >  {
> > -     struct xencons_interface *intf = xencons_interface();
> >       XENCONS_RING_IDX cons, prod;
> > +     struct xencons_interface *intf = xencons->intf;
> >       int sent = 0;
> >
> >       cons = intf->out_cons;
> > @@ -85,13 +108,16 @@ static int __write_console(const char *data, int len)
> >       intf->out_prod = prod;
> >
> >       if (sent)
> > -             notify_daemon();
> > +             notify_daemon(xencons);
> >       return sent;
> >  }
> >
> >  static int domU_write_console(uint32_t vtermno, const char *data, int len)
> >  {
> >       int ret = len;
> > +     struct xencons_info *cons = vtermno_to_xencons(vtermno);
> > +     if (cons == NULL)
> > +             return -EINVAL;
> >
> >       /*
> >        * Make sure the whole buffer is emitted, polling if
> > @@ -100,7 +126,7 @@ static int domU_write_console(uint32_t vtermno, const char *data, int len)
> >        * kernel is crippled.
> >        */
> >       while (len) {
> > -             int sent = __write_console(data, len);
> > +             int sent = __write_console(cons, data, len);
> >
> >               data += sent;
> >               len -= sent;
> > @@ -114,9 +140,13 @@ static int domU_write_console(uint32_t vtermno, const char *data, int len)
> >
> >  static int domU_read_console(uint32_t vtermno, char *buf, int len)
> >  {
> > -     struct xencons_interface *intf = xencons_interface();
> > +     struct xencons_interface *intf;
> >       XENCONS_RING_IDX cons, prod;
> >       int recv = 0;
> > +     struct xencons_info *xencons = vtermno_to_xencons(vtermno);
> > +     if (xencons == NULL)
> > +             return -EINVAL;
> > +     intf = xencons->intf;
> >
> >       cons = intf->in_cons;
> >       prod = intf->in_prod;
> > @@ -129,7 +159,7 @@ static int domU_read_console(uint32_t vtermno, char *buf, int len)
> >       mb();                   /* read ring before consuming */
> >       intf->in_cons = cons;
> >
> > -     notify_daemon();
> > +     notify_daemon(xencons);
> >       return recv;
> >  }
> >
> > @@ -172,33 +202,109 @@ static int xen_hvm_console_init(void)
> >       int r;
> >       uint64_t v = 0;
> >       unsigned long mfn;
> > +     struct xencons_info *info;
> >
> >       if (!xen_hvm_domain())
> >               return -ENODEV;
> >
> > -     if (xencons_if != NULL)
> > -             return -EBUSY;
> > +     info = vtermno_to_xencons(HVC_COOKIE);
> > +     if (!info) {
> > +             info = kmalloc(sizeof(struct xencons_info), GFP_KERNEL | __GFP_ZERO);
> > +             if (!info)
> > +                     return -ENOMEM;
> > +     }
> > +
> > +     /* already configured */
> > +     if (info->intf != NULL)
> > +             return 0;
> >
> >       r = hvm_get_parameter(HVM_PARAM_CONSOLE_EVTCHN, &v);
> > -     if (r < 0)
> > +     if (r < 0) {
> > +             kfree(info);
> >               return -ENODEV;
> > -     console_evtchn = v;
> > +     }
> > +     info->evtchn = v;
> >       hvm_get_parameter(HVM_PARAM_CONSOLE_PFN, &v);
> > -     if (r < 0)
> > +     if (r < 0) {
> > +             kfree(info);
> >               return -ENODEV;
> > +     }
> >       mfn = v;
> > -     xencons_if = ioremap(mfn << PAGE_SHIFT, PAGE_SIZE);
> > -     if (xencons_if == NULL)
> > +     info->intf = ioremap(mfn << PAGE_SHIFT, PAGE_SIZE);
> > +     if (info->intf == NULL) {
> > +             kfree(info);
> > +             return -ENODEV;
> > +     }
> > +     info->vtermno = HVC_COOKIE;
> > +
> > +     spin_lock(&xencons_lock);
> > +     list_add_tail(&info->list, &xenconsoles);
> > +     spin_unlock(&xencons_lock);
> > +
> > +     return 0;
> > +}
> > +
> > +static int xen_pv_console_init(void)
> > +{
> > +     struct xencons_info *info;
> > +
> > +     if (!xen_pv_domain())
> >               return -ENODEV;
> >
> > +     if (!xen_start_info->console.domU.evtchn)
> > +             return -ENODEV;
> > +
> > +     info = vtermno_to_xencons(HVC_COOKIE);
> > +     if (!info) {
> > +             info = kmalloc(sizeof(struct xencons_info), GFP_KERNEL | __GFP_ZERO);
> 
> Ugh. Use kzalloc here. Especially as you are testing it below (and
> kmalloc with certain CONFIG_DEBUG.. can make the the returned memory
> have bogus data.

OK

