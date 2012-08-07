Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752435Ab2HGSbn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 14:31:43 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:41554 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132Ab2HGSbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 14:31:41 -0400
Date: Tue, 7 Aug 2012 14:21:57 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        dgdegra@tycho.nsa.gov
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        Ian.Campbell@citrix.com, tim@xen.org,
        linux-arm-kernel@lists.infradead.org, linaro-dev@lists.linaro.org,
        catalin.marinas@arm.com, arnd@arndb.de
Subject: Re: [PATCH v2 10/23] xen/arm: compile and run xenbus
Message-ID: <20120807182157.GN15053@phenom.dumpdata.com>
References: <alpine.DEB.2.02.1208061428060.4645@kaball.uk.xensource.com>
 <1344263246-28036-10-git-send-email-stefano.stabellini@eu.citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344263246-28036-10-git-send-email-stefano.stabellini@eu.citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 06, 2012 at 03:27:13PM +0100, Stefano Stabellini wrote:
> bind_evtchn_to_irqhandler can legitimately return 0 (irq 0): it is not
> an error.
> 
> If Linux is running as an HVM domain and is running as Dom0, use
> xenstored_local_init to initialize the xenstore page and event channel.
> 
> Changes in v2:
> 
> - refactor xenbus_init.

Thank you. Lets also CC our friend at NSA who has been doing some work
in that area. Daniel are you OK with this change - will it still make
PV initial domain with with the MiniOS XenBus driver?

Thanks.
> 
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> ---
>  drivers/xen/xenbus/xenbus_comms.c |    2 +-
>  drivers/xen/xenbus/xenbus_probe.c |   62 +++++++++++++++++++++++++-----------
>  drivers/xen/xenbus/xenbus_xs.c    |    1 +
>  3 files changed, 45 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/xen/xenbus/xenbus_comms.c b/drivers/xen/xenbus/xenbus_comms.c
> index 52fe7ad..c5aa55c 100644
> --- a/drivers/xen/xenbus/xenbus_comms.c
> +++ b/drivers/xen/xenbus/xenbus_comms.c
> @@ -224,7 +224,7 @@ int xb_init_comms(void)
>  		int err;
>  		err = bind_evtchn_to_irqhandler(xen_store_evtchn, wake_waiting,
>  						0, "xenbus", &xb_waitq);
> -		if (err <= 0) {
> +		if (err < 0) {
>  			printk(KERN_ERR "XENBUS request irq failed %i\n", err);
>  			return err;
>  		}

> diff --git a/drivers/xen/xenbus/xenbus_probe.c b/drivers/xen/xenbus/xenbus_probe.c
> index b793723..a67ccc0 100644
> --- a/drivers/xen/xenbus/xenbus_probe.c
> +++ b/drivers/xen/xenbus/xenbus_probe.c
> @@ -719,37 +719,61 @@ static int __init xenstored_local_init(void)
>  	return err;
>  }
>  
> +enum xenstore_init {
> +	UNKNOWN,
> +	PV,
> +	HVM,
> +	LOCAL,
> +};
>  static int __init xenbus_init(void)
>  {
>  	int err = 0;
> +	enum xenstore_init usage = UNKNOWN;
> +	uint64_t v = 0;
>  
>  	if (!xen_domain())
>  		return -ENODEV;
>  
>  	xenbus_ring_ops_init();
>  
> -	if (xen_hvm_domain()) {
> -		uint64_t v = 0;
> -		err = hvm_get_parameter(HVM_PARAM_STORE_EVTCHN, &v);
> -		if (err)
> -			goto out_error;
> -		xen_store_evtchn = (int)v;
> -		err = hvm_get_parameter(HVM_PARAM_STORE_PFN, &v);
> -		if (err)
> -			goto out_error;
> -		xen_store_mfn = (unsigned long)v;
> -		xen_store_interface = ioremap(xen_store_mfn << PAGE_SHIFT, PAGE_SIZE);
> -	} else {
> -		xen_store_evtchn = xen_start_info->store_evtchn;
> -		xen_store_mfn = xen_start_info->store_mfn;
> -		if (xen_store_evtchn)
> -			xenstored_ready = 1;
> -		else {
> +	if (xen_pv_domain())
> +		usage = PV;
> +	if (xen_hvm_domain())
> +		usage = HVM;
> +	if (xen_hvm_domain() && xen_initial_domain())
> +		usage = LOCAL;
> +	if (xen_pv_domain() && !xen_start_info->store_evtchn)
> +		usage = LOCAL;
> +	if (xen_pv_domain() && xen_start_info->store_evtchn)
> +		xenstored_ready = 1;
> +
> +	switch (usage) {
> +		case LOCAL:
>  			err = xenstored_local_init();
>  			if (err)
>  				goto out_error;
> -		}
> -		xen_store_interface = mfn_to_virt(xen_store_mfn);
> +			xen_store_interface = mfn_to_virt(xen_store_mfn);
> +			break;
> +		case PV:
> +			xen_store_evtchn = xen_start_info->store_evtchn;
> +			xen_store_mfn = xen_start_info->store_mfn;
> +			xen_store_interface = mfn_to_virt(xen_store_mfn);
> +			break;
> +		case HVM:
> +			err = hvm_get_parameter(HVM_PARAM_STORE_EVTCHN, &v);
> +			if (err)
> +				goto out_error;
> +			xen_store_evtchn = (int)v;
> +			err = hvm_get_parameter(HVM_PARAM_STORE_PFN, &v);
> +			if (err)
> +				goto out_error;
> +			xen_store_mfn = (unsigned long)v;
> +			xen_store_interface =
> +				ioremap(xen_store_mfn << PAGE_SHIFT, PAGE_SIZE);
> +			break;
> +		default:
> +			pr_warn("Xenstore state unknown\n");
> +			break;
>  	}
>  
>  	/* Initialize the interface to xenstore. */
> diff --git a/drivers/xen/xenbus/xenbus_xs.c b/drivers/xen/xenbus/xenbus_xs.c
> index d1c217b..f7feb3d 100644
> --- a/drivers/xen/xenbus/xenbus_xs.c
> +++ b/drivers/xen/xenbus/xenbus_xs.c
> @@ -44,6 +44,7 @@
>  #include <linux/rwsem.h>
>  #include <linux/module.h>
>  #include <linux/mutex.h>
> +#include <asm/xen/hypervisor.h>
>  #include <xen/xenbus.h>
>  #include <xen/xen.h>
>  #include "xenbus_comms.h"
> -- 
> 1.7.2.5
