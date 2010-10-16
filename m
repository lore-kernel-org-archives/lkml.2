Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754252Ab0JPLfj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 07:35:39 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:43593 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753295Ab0JPLfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 07:35:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=Ct00iRhvH3vWcqdGXpyobv1f5HwshQGN73KO/xywCv9ziaz7eFbofVjpZaxQUxdhHb
         kWoTkTgHxc91zP7BU18nvw4Vp29E6xBF7MuT4ZYAS9uPd+d/QkxVqBM7eBSjjCwpTzL9
         JwFq/znZ968TPUd/+m+MqdQo8OXJv591XHCdI=
Date: Sat, 16 Oct 2010 13:35:21 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Greg KH <gregkh@suse.de>, Randy Dunlap <randy.dunlap@oracle.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, lud <linux-usb@vger.kernel.org>,
        Andiry Xu <andiry.xu@amd.com>, Dong Nguyen <dong.nguyen@amd.com>,
        Libin Yang <libin.yang@amd.com>
Subject: Re: [PATCH] usb: Fix linker errors with CONFIG_PM=n
Message-ID: <20101016113521.GA2786@joi.lan>
References: <20101015205756.GA1757@xanatos>
 <20101015215915.GA25942@xanatos>
 <20101015222301.GA4080@joi.lan>
 <20101015232629.GA26031@xanatos>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20101015232629.GA26031@xanatos>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 15, 2010 at 04:26:29PM -0700, Sarah Sharp wrote:
> On Sat, Oct 16, 2010 at 12:23:01AM +0200, Marcin Slusarz wrote:
> > On Fri, Oct 15, 2010 at 02:59:15PM -0700, Sarah Sharp wrote:
> > > diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
> > > index c08928a..93d3bf4 100644
> > > --- a/drivers/usb/host/xhci.h
> > > +++ b/drivers/usb/host/xhci.h
> > > @@ -1405,8 +1405,15 @@ int xhci_init(struct usb_hcd *hcd);
> > >  int xhci_run(struct usb_hcd *hcd);
> > >  void xhci_stop(struct usb_hcd *hcd);
> > >  void xhci_shutdown(struct usb_hcd *hcd);
> > > +
> > > +#ifdef	CONFIG_PM
> > >  int xhci_suspend(struct xhci_hcd *xhci);
> > >  int xhci_resume(struct xhci_hcd *xhci, bool hibernated);
> > > +#else
> > > +#define	xhci_suspend	NULL
> > > +#define	xhci_resume	NULL
> > > +#endif
> > > +
> > 
> > "static inline int xhci_suspend(struct xhci_hcd *) {}"
> > has the same effect but saves types
> 
> That doesn't have the same effect.  Since those functions are only used
> as function pointers, the original patch compiles to less code when
> CONFIG_PM=n.  

xhci_suspend is not called through function pointer. xhci_bus_suspend is.

> Also, the original version will cause an oops if those
> functions are ever called when CONFIG_PM=n, which would indicate a bug
> in the callee (something we would rather catch anyway).  This is the
> style that other USB host controller drivers use, like EHCI.
> 
> I don't understand what you mean by "saves types".  Is there something
> I've missed?

Depending on CONFIG_PM xhci_suspend is a function or a constant.
If someone in the future would decide to call this function directly, without
CONFIG_PM, he would fail with "error: called object ‘0u’ is not a function".
So, strictly speaking, this patch is not losing type informations. It's just wrong.

Sometimes people are tempted to do something like this:
#define xhci_suspend(X) (-EINVAL)
or when "function" does not return anything:
#define void_fun(X) do {} while (0)
or even worse:
#define void fun(X) {}

And this loses type information.

Without CONFIG_PM sloppy developer could call this "function" like this:
struct whatever *p = xhci_suspend("foo bar");
and it would compile fine. Defining it as
static inline int xhci_suspend(struct xhci_hcd *) { return -EINVAL; }
would prevent it.

But in this particular case I think the cleanest solutions is to just ifdef
everything out, without fallbacks. There's only one caller of xhci_suspend
and it's wrongly guarded by CONFIG_PM. Let's just fix.

---
From: Marcin Slusarz <marcin.slusarz@gmail.com>
Subject: [PATCH] usb/xhci: fix !CONFIG_PM compile/link errors

drivers/usb/host/xhci.c:675: error: implicit declaration of function 'usb_root_hub_lost_power'

ERROR: "xhci_bus_resume" [drivers/usb/host/xhci-hcd.ko] undefined!
ERROR: "xhci_bus_suspend" [drivers/usb/host/xhci-hcd.ko] undefined!

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
---
 drivers/usb/host/xhci-hub.c |    5 -----
 drivers/usb/host/xhci-pci.c |    2 ++
 drivers/usb/host/xhci.c     |    2 ++
 drivers/usb/host/xhci.h     |    4 ++++
 4 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/host/xhci-hub.c b/drivers/usb/host/xhci-hub.c
index 7f2f63c..ac63141 100644
--- a/drivers/usb/host/xhci-hub.c
+++ b/drivers/usb/host/xhci-hub.c
@@ -742,9 +742,4 @@ int xhci_bus_resume(struct usb_hcd *hcd)
 	return 0;
 }
 
-#else
-
-#define	xhci_bus_suspend	NULL
-#define	xhci_bus_resume		NULL
-
 #endif
diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
index bb668a8..d10b45d 100644
--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -189,8 +189,10 @@ static const struct hc_driver xhci_pci_hc_driver = {
 	/* Root hub support */
 	.hub_control =		xhci_hub_control,
 	.hub_status_data =	xhci_hub_status_data,
+#ifdef CONFIG_PM
 	.bus_suspend =		xhci_bus_suspend,
 	.bus_resume =		xhci_bus_resume,
+#endif
 };
 
 /*-------------------------------------------------------------------------*/
diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 33d0034..c9fc85a 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -551,6 +551,7 @@ void xhci_shutdown(struct usb_hcd *hcd)
 		    xhci_readl(xhci, &xhci->op_regs->status));
 }
 
+#ifdef CONFIG_PM
 static void xhci_save_registers(struct xhci_hcd *xhci)
 {
 	xhci->s3.command = xhci_readl(xhci, &xhci->op_regs->command);
@@ -760,6 +761,7 @@ int xhci_resume(struct xhci_hcd *xhci, bool hibernated)
 	spin_unlock_irq(&xhci->lock);
 	return 0;
 }
+#endif
 
 /*-------------------------------------------------------------------------*/
 
diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index c08928a..6f6ee54 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1405,8 +1405,10 @@ int xhci_init(struct usb_hcd *hcd);
 int xhci_run(struct usb_hcd *hcd);
 void xhci_stop(struct usb_hcd *hcd);
 void xhci_shutdown(struct usb_hcd *hcd);
+#ifdef CONFIG_PM
 int xhci_suspend(struct xhci_hcd *xhci);
 int xhci_resume(struct xhci_hcd *xhci, bool hibernated);
+#endif
 int xhci_get_frame(struct usb_hcd *hcd);
 irqreturn_t xhci_irq(struct usb_hcd *hcd);
 irqreturn_t xhci_msi_irq(int irq, struct usb_hcd *hcd);
@@ -1481,8 +1483,10 @@ void xhci_ring_ep_doorbell(struct xhci_hcd *xhci, unsigned int slot_id,
 int xhci_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue, u16 wIndex,
 		char *buf, u16 wLength);
 int xhci_hub_status_data(struct usb_hcd *hcd, char *buf);
+#ifdef CONFIG_PM
 int xhci_bus_suspend(struct usb_hcd *hcd);
 int xhci_bus_resume(struct usb_hcd *hcd);
+#endif
 u32 xhci_port_state_to_neutral(u32 state);
 int xhci_find_slot_id_by_port(struct xhci_hcd *xhci, u16 port);
 void xhci_ring_device(struct xhci_hcd *xhci, int slot_id);
-- 
1.7.3

