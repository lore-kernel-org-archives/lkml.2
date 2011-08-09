Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752804Ab1HIJXN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 05:23:13 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:33305 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144Ab1HIJXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 05:23:10 -0400
X-IronPort-AV: E=Sophos;i="4.67,342,1309737600"; 
   d="scan'208";a="7172159"
Subject: Re: [Xen-devel] [PATCH 3/3] xen/pv-on-hvm kexec+kdump: reset PV
 devices in kexec or crash kernel
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Olaf Hering <olaf@aepfle.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Jeremy Fitzhardinge" <jeremy@goop.org>,
        Konrad <konrad.wilk@oracle.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
In-Reply-To: <20110804162054.806626433@aepfle.de>
References: <20110804162053.723541930@aepfle.de>
	 <20110804162054.806626433@aepfle.de>
Content-Type: text/plain; charset="UTF-8"
Organization: Citrix Systems, Inc.
Date: Tue, 9 Aug 2011 10:23:08 +0100
Message-ID: <1312881788.26263.50.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-08-04 at 17:20 +0100, Olaf Hering wrote:
> After triggering a crash dump in a HVM guest, the PV backend drivers
> will remain in Connected state. When the kdump kernel starts the PV
> drivers will skip such devices. As a result, no root device is found and
> the vmcore cant be saved.  
> 
> A similar situation happens after a kexec boot, here the devices will be
> in the Closed state.
> 
> With this change all frontend devices with state XenbusStateConnected or
> XenbusStateClosed will be reset by changing the state file to
> Closing/Closed/Initializing.  This will trigger a disconnect in the
> backend drivers. Now the frontend drivers will find the backend drivers
> in state Initwait and can connect.
> 
> Signed-off-by: Olaf Hering <olaf@aepfle.de>
> 
> ---
>  drivers/xen/xenbus/xenbus_comms.c          |    4 -
>  drivers/xen/xenbus/xenbus_probe_frontend.c |  116 +++++++++++++++++++++++++++++
>  2 files changed, 119 insertions(+), 1 deletion(-)
> 
> Index: linux-3.0/drivers/xen/xenbus/xenbus_comms.c
> ===================================================================
> --- linux-3.0.orig/drivers/xen/xenbus/xenbus_comms.c
> +++ linux-3.0/drivers/xen/xenbus/xenbus_comms.c
> @@ -212,7 +212,9 @@ int xb_init_comms(void)
>  		printk(KERN_WARNING "XENBUS response ring is not quiescent "
>  		       "(%08x:%08x): fixing up\n",
>  		       intf->rsp_cons, intf->rsp_prod);
> -		intf->rsp_cons = intf->rsp_prod;
> +		/* breaks kdump */
> +		if (!reset_devices)
> +			intf->rsp_cons = intf->rsp_prod;
>  	}
>  
>  	if (xenbus_irq) {
> Index: linux-3.0/drivers/xen/xenbus/xenbus_probe_frontend.c
> ===================================================================
> --- linux-3.0.orig/drivers/xen/xenbus/xenbus_probe_frontend.c
> +++ linux-3.0/drivers/xen/xenbus/xenbus_probe_frontend.c
> @@ -252,10 +252,126 @@ int __xenbus_register_frontend(struct xe
>  }
>  EXPORT_SYMBOL_GPL(__xenbus_register_frontend);
>  
> +static DECLARE_WAIT_QUEUE_HEAD(backend_state_wq);
> +static int backend_state;
> +
> +static void xenbus_reset_backend_state_changed(struct xenbus_watch *w,
> +					const char **v, unsigned int l)
> +{
> +	xenbus_scanf(XBT_NIL, v[XS_WATCH_PATH], "", "%i", &backend_state);
> +	printk(KERN_DEBUG "XENBUS: %s %s\n",
> +			v[XS_WATCH_PATH], xenbus_strstate(backend_state));
> +	wake_up(&backend_state_wq);
> +}
> +
> +static void xenbus_reset_wait_for_backend(int expected)
> +{
> +	wait_event_interruptible(backend_state_wq, backend_state == expected);
> +}
> +
> +/*
> + * Reset frontend if it is in Connected or Closed state.
> + * Wait for backend to catch up.
> + * State Connected happens during kdump, Closed after kexec.
> + */
> +static void xenbus_reset_frontend(char *fe, char *be, int be_state)
> +{
> +	struct xenbus_watch be_watch;
> +
> +	printk(KERN_DEBUG "XENBUS: backend %s %s\n",
> +			be, xenbus_strstate(be_state));
> +
> +	memset(&be_watch, 0, sizeof(be_watch));
> +	be_watch.node = kasprintf(GFP_NOIO | __GFP_HIGH, "%s/state", be);
> +	if (!be_watch.node)
> +		return;
> +
> +	be_watch.callback = xenbus_reset_backend_state_changed;
> +	backend_state = XenbusStateUnknown;
> +
> +	printk(KERN_INFO "XENBUS: triggering reconnect on %s\n", be);
> +	register_xenbus_watch(&be_watch);
> +
> +	switch (be_state) {
> +	case XenbusStateConnected:
> +		xenbus_printf(XBT_NIL, fe, "state", "%d", XenbusStateClosing);
> +		xenbus_reset_wait_for_backend(XenbusStateClosing);
> +
> +	case XenbusStateClosing:
> +		xenbus_printf(XBT_NIL, fe, "state", "%d", XenbusStateClosed);
> +		xenbus_reset_wait_for_backend(XenbusStateClosed);
> +
> +	case XenbusStateClosed:
> +		xenbus_printf(XBT_NIL, fe, "state", "%d", XenbusStateInitialising);
> +		xenbus_reset_wait_for_backend(XenbusStateInitWait);
> +	}
> +
> +	unregister_xenbus_watch(&be_watch);
> +	printk(KERN_INFO "XENBUS: reconnect done on %s\n", be);
> +	kfree(be_watch.node);
> +}
> +
> +static void xenbus_check_frontend(char *class, char *dev)
> +{
> +	int be_state, fe_state, err;
> +	char *backend, *frontend;
> +
> +	frontend = kasprintf(GFP_NOIO | __GFP_HIGH, "device/%s/%s", class, dev);
> +	if (!frontend)
> +		return;
> +
> +	err = xenbus_scanf(XBT_NIL, frontend, "state", "%i", &fe_state);
> +	if (err != 1)
> +		goto out;
> +
> +	switch (fe_state) {
> +	case XenbusStateConnected:
> +	case XenbusStateClosed:
> +		printk(KERN_DEBUG "XENBUS: frontend %s %s\n",
> +				frontend, xenbus_strstate(fe_state));
> +		backend = xenbus_read(XBT_NIL, frontend, "backend", NULL);
> +		if (!backend || IS_ERR(backend))
> +			goto out;
> +		err = xenbus_scanf(XBT_NIL, backend, "state", "%i", &be_state);
> +		if (err == 1)
> +			xenbus_reset_frontend(frontend, backend, be_state);
> +		kfree(backend);
> +		break;
> +	default:
> +		break;
> +	}
> +out:
> +	kfree(frontend);
> +}
> +
> +static void xenbus_reset_state(void)
> +{
> +	char **devclass, **dev;
> +	int devclass_n, dev_n;
> +	int i, j;
> +
> +	devclass = xenbus_directory(XBT_NIL, "device", "", &devclass_n);
> +	if (IS_ERR(devclass))
> +		return;
> +
> +	for (i = 0; i < devclass_n; i++) {
> +		dev = xenbus_directory(XBT_NIL, "device", devclass[i], &dev_n);
> +		if (IS_ERR(dev))
> +			continue;
> +		for (j = 0; j < dev_n; j++)
> +			xenbus_check_frontend(devclass[i], dev[j]);
> +		kfree(dev);
> +	}
> +	kfree(devclass);
> +}
> +
>  static int frontend_probe_and_watch(struct notifier_block *notifier,
>  				   unsigned long event,
>  				   void *data)
>  {
> +	/* reset devices in Connected or Closed state */
> +	if (xen_hvm_domain())
                               && reset_devices ??

How long should we wait for the backend to respond? Should we add a
timeout and countdown similar to wait_for_devices?

It's unfortunate that this code is effectively serialising on each
device. It would be much preferable to kick off all the resets and then
wait for them to occur. You could probably do this by incrementing a
counter for each device you reset and decrementing it each time a watch
triggers then wait for the counter to hit zero.

> +		xenbus_reset_state();
>  	/* Enumerate devices in xenstore and watch for changes. */
>  	xenbus_probe_devices(&xenbus_frontend);
>  	register_xenbus_watch(&fe_watch);
> 
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xensource.com
> http://lists.xensource.com/xen-devel


