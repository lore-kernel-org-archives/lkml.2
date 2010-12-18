Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756669Ab0LRAS2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 19:18:28 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57166 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756487Ab0LRAS1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 19:18:27 -0500
Date: Fri, 17 Dec 2010 16:17:56 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexander Gordeev <lasaine@lvk.cs.msu.su>
Cc: linux-kernel@vger.kernel.org, "Nikita V\. Youshchenko" <yoush@cs.msu.su>,
        linuxpps@ml.enneenne.com, Rodolfo Giometti <giometti@enneenne.com>
Subject: Re: [PATCHv6 15/16] pps: add parallel port PPS client
Message-Id: <20101217161756.664b8d8b.akpm@linux-foundation.org>
In-Reply-To: <5aad62a4e5290f8baa5994b227e7fe6edaa7841a.1292604060.git.lasaine@lvk.cs.msu.su>
References: <cover.1292604060.git.lasaine@lvk.cs.msu.su>
	<5aad62a4e5290f8baa5994b227e7fe6edaa7841a.1292604060.git.lasaine@lvk.cs.msu.su>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Dec 2010 22:54:39 +0300
Alexander Gordeev <lasaine@lvk.cs.msu.su> wrote:

> Add parallel port PPS client. It uses a standard method for capturing
> timestamps for assert edge transitions: getting a timestamp soon after
> an interrupt has happened. This is not a very precise source of time
> information due to interrupt handling delays. However, timestamps for
> clear edge transitions are much more precise because the interrupt
> handler continuously polls hardware port until the transition is done.
> Hardware port operations require only about 1us so the maximum error
> should not exceed this value. This was my primary goal when developing
> this client.
> Clear edge capture could be disabled using clear_wait parameter.
> 
> ...
>
> +/* parport interrupt handler */
> +static void parport_irq(void *handle)
> +{
> +	struct pps_event_time ts_assert, ts_clear;
> +	struct pps_client_pp *dev = handle;
> +	struct parport *port = dev->pardev->port;
> +	unsigned int i;
> +	unsigned long flags;
> +
> +	/* first of all we get the time stamp... */
> +	pps_get_ts(&ts_assert);
> +
> +	if (dev->cw == 0)
> +		/* clear edge capture disabled */
> +		goto out_assert;
> +
> +	/* try capture the clear edge */
> +	local_irq_save(flags);
> +	/* check the signal (no signal means the pulse is lost this time) */
> +	if (!signal_is_set(port)) {
> +		local_irq_restore(flags);
> +		dev_err(dev->pps->dev, "lost the signal\n");
> +		goto out_assert;
> +	}
> +
> +	/* poll the port until the signal is unset */
> +	for (i = dev->cw; i; i--)
> +		if (!signal_is_set(port)) {
> +			pps_get_ts(&ts_clear);
> +			local_irq_restore(flags);
> +			dev->cw_err = 0;
> +			goto out_both;
> +		}
> +	local_irq_restore(flags);

Why is this function paying around with local_irq_save()?  It's unusual
and looks buggy because local_irq_save() doesn't stop other CPUs from
taking an interrupt and coming in and playing with the "protected" data.

I have a feeling I asked this before, but you didn't add a comment
explaining it, so I went and asked it again!  Cause, effect.

> +static void parport_attach(struct parport *port)
> +{
> +	struct pps_client_pp *device;
> +	struct pps_source_info info = {
> +		.name		= KBUILD_MODNAME,
> +		.path		= "",
> +		.mode		= PPS_CAPTUREBOTH | \
> +				  PPS_OFFSETASSERT | PPS_OFFSETCLEAR | \
> +				  PPS_ECHOASSERT | PPS_ECHOCLEAR | \
> +				  PPS_CANWAIT | PPS_TSFMT_TSPEC,
> +		.echo		= pps_echo,
> +		.owner		= THIS_MODULE,
> +		.dev		= NULL
> +	};
> +
> +	device = kzalloc(sizeof(struct pps_client_pp), GFP_KERNEL);
> +	if (!device) {
> +		pr_err("memory allocation failed, not attaching\n");
> +		return;

And the void-returning parport_driver.attach() still sucks.

> +	}
> +
> +	device->pardev = parport_register_device(port, KBUILD_MODNAME,
> +			NULL, NULL, parport_irq, 0, device);
> +	if (!device->pardev) {
> +		pr_err("couldn't register with %s\n", port->name);
> +		goto err_free;
> +	}
> +
> +	if (parport_claim_or_block(device->pardev) < 0) {
> +		pr_err("couldn't claim %s\n", port->name);
> +		goto err_unregister_dev;
> +	}
> +
> +	device->pps = pps_register_source(&info,
> +			PPS_CAPTUREBOTH | PPS_OFFSETASSERT | PPS_OFFSETCLEAR);
> +	if (device->pps == NULL) {
> +		pr_err("couldn't register PPS source\n");
> +		goto err_release_dev;
> +	}
> +
> +	device->cw = clear_wait;
> +
> +	port->ops->enable_irq(port);
> +
> +	pr_info("attached to %s\n", port->name);
> +
> +	return;
> +
> +err_release_dev:
> +	parport_release(device->pardev);
> +err_unregister_dev:
> +	parport_unregister_device(device->pardev);
> +err_free:
> +	kfree(device);
> +}
> +

