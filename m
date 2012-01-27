Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756058Ab2A0P20 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 10:28:26 -0500
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:64083 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755846Ab2A0P2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 10:28:24 -0500
X-IronPort-AV: E=Sophos;i="4.71,580,1320624000"; 
   d="scan'208";a="10334879"
Date: Fri, 27 Jan 2012 15:29:06 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] hvc_xen: support PV on HVM consoles
In-Reply-To: <20120127140234.GA32469@phenom.dumpdata.com>
Message-ID: <alpine.DEB.2.00.1201271427080.3196@kaball-desktop>
References: <alpine.DEB.2.00.1201261233050.3196@kaball-desktop> <1327581807-17276-1-git-send-email-stefano.stabellini@eu.citrix.com> <20120127140234.GA32469@phenom.dumpdata.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Jan 2012, Konrad Rzeszutek Wilk wrote:
> On Thu, Jan 26, 2012 at 12:43:26PM +0000, Stefano Stabellini wrote:
> > Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> > ---
> >  drivers/tty/hvc/hvc_xen.c          |   86 +++++++++++++++++++++++++++++-------
> >  include/xen/interface/hvm/params.h |    6 ++-
> >  2 files changed, 75 insertions(+), 17 deletions(-)
> > 
> > diff --git a/drivers/tty/hvc/hvc_xen.c b/drivers/tty/hvc/hvc_xen.c
> > index 52fdf60..dd6641f 100644
> > --- a/drivers/tty/hvc/hvc_xen.c
> > +++ b/drivers/tty/hvc/hvc_xen.c
> > @@ -24,9 +24,12 @@
> >  #include <linux/init.h>
> >  #include <linux/types.h>
> >  
> > +#include <asm/io.h>
> >  #include <asm/xen/hypervisor.h>
> >  
> >  #include <xen/xen.h>
> > +#include <xen/interface/xen.h>
> > +#include <xen/hvm.h>
> >  #include <xen/page.h>
> >  #include <xen/events.h>
> >  #include <xen/interface/io/console.h>
> > @@ -42,9 +45,13 @@ static int xencons_irq;
> >  /* ------------------------------------------------------------------ */
> >  
> >  static unsigned long console_pfn = ~0ul;
> > +static unsigned int console_evtchn = ~0ul;
> > +static struct xencons_interface *xencons_if = NULL;
> >  
> >  static inline struct xencons_interface *xencons_interface(void)
> >  {
> > +	if (xencons_if != NULL)
> > +		return xencons_if;
> >  	if (console_pfn == ~0ul)
> >  		return mfn_to_virt(xen_start_info->console.domU.mfn);
> >  	else
> > @@ -54,7 +61,10 @@ static inline struct xencons_interface *xencons_interface(void)
> >  static inline void notify_daemon(void)
> >  {
> >  	/* Use evtchn: this is called early, before irq is set up. */
> > -	notify_remote_via_evtchn(xen_start_info->console.domU.evtchn);
> > +	if (console_evtchn == ~0ul)
> > +		notify_remote_via_evtchn(xen_start_info->console.domU.evtchn);
> > +	else
> > +		notify_remote_via_evtchn(console_evtchn);
> >  }
> >  
> >  static int __write_console(const char *data, int len)
> > @@ -157,28 +167,65 @@ static struct hv_ops dom0_hvc_ops = {
> >  	.notifier_hangup = notifier_hangup_irq,
> >  };
> >  
> > +static int xen_hvm_console_init(void)
> > +{
> > +	int r;
> > +	uint64_t v = 0;
> > +	unsigned long mfn;
> > +
> > +	if (!xen_hvm_domain())
> > +		return -ENODEV;
> > +
> > +	if (xencons_if != NULL)
> > +		return -EBUSY;
> > +
> > +	r = hvm_get_parameter(HVM_PARAM_CONSOLE_EVTCHN, &v);
> > +	if (r < 0)
> > +		return -ENODEV;
> > +	console_evtchn = v;
> > +	hvm_get_parameter(HVM_PARAM_CONSOLE_PFN, &v);
> > +	if (r < 0)
> > +		return -ENODEV;
> 
> If we fail here, the console_evtchn is still going to be set
> meaning that "notify_daemon"  will use the event channel. Thought
> I can't think of the notify daemon being called after the init had
> failed so this might not be an issue.
> 
> > +	mfn = v;
> > +	xencons_if = ioremap(mfn << PAGE_SHIFT, PAGE_SIZE);
> > +	if (xencons_if == NULL)
> > +		return -ENODEV;
> 
> Ditto. If we fail, we have the 'console_evtchn' set to something
> else than ~0UL.

Like you wrote, I think it doesn't matter.



> > +	return 0;
> > +}
> > +
> >  static int __init xen_hvc_init(void)
> >  {
> >  	struct hvc_struct *hp;
> >  	struct hv_ops *ops;
> > +	int r;
> >  
> > -	if (!xen_pv_domain())
> > +	if (!xen_domain())
> > +		return -ENODEV;
> > +
> > +	if (xen_pv_domain() && !xen_initial_domain() &&
> > +			!xen_start_info->console.domU.evtchn)
> 
> Ewww.. What about just leaving the check:
> >  		return -ENODEV;
> >  
> >  	if (xen_initial_domain()) {
> >  		ops = &dom0_hvc_ops;
> >  		xencons_irq = bind_virq_to_irq(VIRQ_CONSOLE, 0);
> >  	} else {
> > -		if (!xen_start_info->console.domU.evtchn)
> > -			return -ENODEV;
> 
> this one as 'if (xen_pv_domain()) && !xen-..)
> 
> That might make the code nicer to read?

Yes, good idea.
