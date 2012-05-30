Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932315Ab2E3IgP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 04:36:15 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:55488 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756199Ab2E3IgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 04:36:12 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6726"; a="193555759"
Message-ID: <4FC5DBFA.2030300@codeaurora.org>
Date: Wed, 30 May 2012 01:36:10 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Ohad Ben-Cohen <ohad@wizery.com>
CC: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Fernando Guzman Lugo <fernando.lugo@ti.com>
Subject: Re: [PATCH 1/2] remoteproc: maintain a generic child device for each
 rproc
References: <1338017791-9442-1-git-send-email-ohad@wizery.com>
In-Reply-To: <1338017791-9442-1-git-send-email-ohad@wizery.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/26/2012 12:36 AM, Ohad Ben-Cohen wrote:
> For each registered rproc, maintain a generic remoteproc device whose
> parent is the low level platform-specific device (commonly a pdev, but
> it may certainly be any other type of device too).
>
> With this in hand, the resulting device hierarchy might then look like:
>
> omap-rproc.0
>  |
>  - remoteproc.0

It looks like remoteproc0, remoteproc1, etc. is what's used.

>     |
>     - virtio0
>     |
>     - virtio1
>        |
>        - rpmsg0
>        |
>        - rpmsg1
>        |
>        - rpmsg2
>
> Where:
> - omap-rproc.0 is the low level device that's bound to the
>   driver which invokes rproc_register()
> - remoteproc.0 is the result of this patch, and will be added by the
>   remoteproc framework when rproc_register() is invoked
> - virtio0 and virtio1 are vdevs that are registered by remoteproc
>   when it realizes that they are supported by the firmware
>   of the physical remote processor represented by omap-rproc.0
> - rpmsg0, rpmsg1 and rpmsg2 are rpmsg devices that represent rpmsg
>   channels, and are registerd by the rpmsg bus when it gets notified
>   about their existence
>
> Technically, this patch:
> - changes 'struct rproc' to contain this generic remoteproc.x device
> - creates a new "remoteproc" class, to which this new generic remoteproc.x
>   device belong to.
> - adds a super simple enumeration method for the indices of the
>   remoteproc.x devices
> - updates all dev_* messaging to use the generic remoteproc.x device
>   instead of the low level platform-specific device

One complaint I've gotten is that the error messages are essentially
useless now. I believe there are some ongoing discussions on lkml to fix
this by traversing the device hierarchy to find the "real" device but
the hard part is finding the real device.

> - updates all dma_* allocations to use the parent of remoteproc.x (where
>   the platform-specific memory pools, most commonly CMA, are to be found)
>
> Adding this generic device has several merits:
> - we can now add remoteproc runtime PM support simply by hooking onto the
>   new "remoteproc" class
> - all remoteproc log messages will now carry a common name prefix
>   instead of having a platform-specific one
> - having a device as part of the rproc struct makes it possible to simplify
>   refcounting (see subsequent patch)
>
> Thanks to Stephen Boyd <sboyd@codeaurora.org> for suggesting and
> discussing these ideas in one of the remoteproc review threads and
> to Fernando Guzman Lugo <fernando.lugo@ti.com> for trying them out
> with the (upcoming) runtime PM support for remoteproc.
[snip]
>
> diff --git a/drivers/remoteproc/remoteproc_core.c b/drivers/remoteproc/remoteproc_core.c
> index 464ea4f..9e3d4cf 100644
> --- a/drivers/remoteproc/remoteproc_core.c
> +++ b/drivers/remoteproc/remoteproc_core.c
> @@ -66,6 +66,9 @@ typedef int (*rproc_handle_resources_t)(struct rproc *rproc,
>  				struct resource_table *table, int len);
>  typedef int (*rproc_handle_resource_t)(struct rproc *rproc, void *, int avail);
>  
> +/* Unique numbering for remoteproc devices */
> +static unsigned int dev_index;
> +

Hm... perhaps use that ida stuff instead of a raw integer?

> +static struct class rproc_class = {
> +	.name		= "remoteproc",
> +	.owner		= THIS_MODULE,
> +	.dev_release	= rproc_class_release,
> +};

I'm not clear on busses versus classes. I recall seeing a thread where
someone said classes were on the way out and shouldn't be used but I
can't find it anymore. Should we use classes for devices that will never
have a matching driver?

> +
>  /**
>   * rproc_alloc() - allocate a remote processor handle
>   * @dev: the underlying device
> @@ -1492,12 +1516,19 @@ struct rproc *rproc_alloc(struct device *dev, const char *name,
>  		return NULL;
>  	}
>  
> -	rproc->dev = dev;
>  	rproc->name = name;
>  	rproc->ops = ops;
>  	rproc->firmware = firmware;
>  	rproc->priv = &rproc[1];
>  
> +	device_initialize(&rproc->dev);
> +	rproc->dev.parent = dev;
> +	rproc->dev.class = &rproc_class;
> +
> +	/* Assign a unique device index and name */
> +	rproc->index = dev_index++;
> +	dev_set_name(&rproc->dev, "remoteproc%d", rproc->index);
> +

This doesn't look thread safe. ida would fix this (ida_simple_get/remove
looks like what you want).

> diff --git a/include/linux/remoteproc.h b/include/linux/remoteproc.h
> index f1ffabb..0b835d3 100644
> --- a/include/linux/remoteproc.h
> +++ b/include/linux/remoteproc.h
> @@ -383,6 +383,7 @@ enum rproc_state {
>   * @bootaddr: address of first instruction to boot rproc with (optional)
>   * @rvdevs: list of remote virtio devices
>   * @notifyids: idr for dynamically assigning rproc-wide unique notify ids
> + * @index: index of this rproc device
>   */
>  struct rproc {
>  	struct klist_node node;
> @@ -391,7 +392,7 @@ struct rproc {
>  	const char *firmware;
>  	void *priv;
>  	const struct rproc_ops *ops;
> -	struct device *dev;
> +	struct device dev;

I'm not sure if the kernel-doc for this field is accurate anymore. Is it
an 'underlying device' still?

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

