Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755990Ab2HFLRf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 07:17:35 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:47009 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755898Ab2HFLRe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 07:17:34 -0400
X-IronPort-AV: E=Sophos;i="4.77,718,1336348800"; 
   d="scan'208";a="13864255"
Date: Mon, 6 Aug 2012 12:17:10 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Ian Campbell <Ian.Campbell@citrix.com>, "Tim (Xen.org)" <tim@xen.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "arnd@arndb.de" <arnd@arndb.de>
Subject: Re: [PATCH 09/24] xen/arm: compile and run xenbus
In-Reply-To: <20120801142840.GG7227@phenom.dumpdata.com>
Message-ID: <alpine.DEB.2.02.1208061200130.4645@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1207251741470.26163@kaball.uk.xensource.com> <1343316846-25860-9-git-send-email-stefano.stabellini@eu.citrix.com> <20120801142840.GG7227@phenom.dumpdata.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Aug 2012, Konrad Rzeszutek Wilk wrote:
> On Thu, Jul 26, 2012 at 04:33:51PM +0100, Stefano Stabellini wrote:
> > bind_evtchn_to_irqhandler can legitimately return 0 (irq 0): it is not
> > an error.
> > 
> > If Linux is running as an HVM domain and is running as Dom0, use
> > xenstored_local_init to initialize the xenstore page and event channel.
> > 
> > Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> > ---
> >  drivers/xen/xenbus/xenbus_comms.c |    2 +-
> >  drivers/xen/xenbus/xenbus_probe.c |   27 +++++++++++++++++----------
> >  drivers/xen/xenbus/xenbus_xs.c    |    1 +
> >  3 files changed, 19 insertions(+), 11 deletions(-)
> > 
> > diff --git a/drivers/xen/xenbus/xenbus_comms.c b/drivers/xen/xenbus/xenbus_comms.c
> > index 52fe7ad..c5aa55c 100644
> > --- a/drivers/xen/xenbus/xenbus_comms.c
> > +++ b/drivers/xen/xenbus/xenbus_comms.c
> > @@ -224,7 +224,7 @@ int xb_init_comms(void)
> >  		int err;
> >  		err = bind_evtchn_to_irqhandler(xen_store_evtchn, wake_waiting,
> >  						0, "xenbus", &xb_waitq);
> > -		if (err <= 0) {
> > +		if (err < 0) {
> >  			printk(KERN_ERR "XENBUS request irq failed %i\n", err);
> >  			return err;
> >  		}
> > diff --git a/drivers/xen/xenbus/xenbus_probe.c b/drivers/xen/xenbus/xenbus_probe.c
> > index b793723..3ae47c2 100644
> > --- a/drivers/xen/xenbus/xenbus_probe.c
> > +++ b/drivers/xen/xenbus/xenbus_probe.c
> > @@ -729,16 +729,23 @@ static int __init xenbus_init(void)
> >  	xenbus_ring_ops_init();
> >  
> >  	if (xen_hvm_domain()) {
> > -		uint64_t v = 0;
> > -		err = hvm_get_parameter(HVM_PARAM_STORE_EVTCHN, &v);
> > -		if (err)
> > -			goto out_error;
> > -		xen_store_evtchn = (int)v;
> > -		err = hvm_get_parameter(HVM_PARAM_STORE_PFN, &v);
> > -		if (err)
> > -			goto out_error;
> > -		xen_store_mfn = (unsigned long)v;
> > -		xen_store_interface = ioremap(xen_store_mfn << PAGE_SHIFT, PAGE_SIZE);
> > +		if (xen_initial_domain()) {
> > +			err = xenstored_local_init();
> > +			xen_store_interface =
> > +				phys_to_virt(xen_store_mfn << PAGE_SHIFT);
> > +		} else {
> > +			uint64_t v = 0;
> > +			err = hvm_get_parameter(HVM_PARAM_STORE_EVTCHN, &v);
> > +			if (err)
> > +				goto out_error;
> > +			xen_store_evtchn = (int)v;
> > +			err = hvm_get_parameter(HVM_PARAM_STORE_PFN, &v);
> > +			if (err)
> > +				goto out_error;
> > +			xen_store_mfn = (unsigned long)v;
> > +			xen_store_interface =
> > +				ioremap(xen_store_mfn << PAGE_SHIFT, PAGE_SIZE);
> > +		}
> 
> This, and along with the Hybrid PV dom0 (not yet posted, but it was doing
> similar manipulation here) is getting more and more like a rat-mess.
> 
> 
> Any chance we can just abstract the three different XenStore access
> ways and just have something like this:
> 
> 	enum {
> 		USE_UNKNOWN
> 		USE_HVM,
> 		USE_PV,
> 		USE_LOCAL
> 		USE_ALREADY_INIT
> 	};
> 	int usage = USE_UNKNOWN;
> 	if (xen_pv_domain())
> 		usage = USE_PV;
> 	if (xen_hvm_domain())
> 		usage = USE_HVM;
> 	if (xen_initial_domain())
> 		usage = USE_LOCAL;
> 
> 	if (xen_start_info->store_evtchn)
> 		usage = USE_ALREADY_INIT;
> 	
> 	.. other overwrites..
> 
> 	switch (usage) {
> 		.. blah blah.
> 	}

I'll give it a try.
