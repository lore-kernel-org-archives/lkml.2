Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757426Ab1F0IrY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 04:47:24 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:13990 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754649Ab1F0Ipl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 04:45:41 -0400
X-IronPort-AV: E=Sophos;i="4.65,431,1304294400"; 
   d="scan'208";a="6490902"
Subject: Re: [Xen-devel] [PATCH 2/2] xen: Add alias to autoload backend
 drivers
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Bastian Blank <waldi@debian.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>
CC: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20110624215155.GB4735@wavehammer.waldi.eu.org>
References: <20110624215155.GB4735@wavehammer.waldi.eu.org>
Content-Type: text/plain; charset="UTF-8"
Organization: Citrix Systems, Inc.
Date: Mon, 27 Jun 2011 09:45:39 +0100
Message-ID: <1309164339.32717.155.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-06-24 at 22:51 +0100, Bastian Blank wrote:
> All the Xen backend drivers are assigned to a special bus type
> xen-backend. This allows userspace to load the modules on request.
> 
> This patch defines xen-backend:* aliases on the modules and exports this
> names through modalias and uevent.

Excellent, this was a big missing piece of functionality for distros.
Thanks!

> Signed-off-by: Bastian Blank <waldi@debian.org>

Acked-by: Ian Campbell <ian.campbell@citrix.com>

> ---
>  drivers/block/xen-blkback/blkback.c       |    1 +
>  drivers/net/xen-netback/netback.c         |    1 +
>  drivers/xen/xenbus/xenbus_probe.c         |    3 ++-
>  drivers/xen/xenbus/xenbus_probe_backend.c |    3 +++
>  4 files changed, 7 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/block/xen-blkback/blkback.c b/drivers/block/xen-blkback/blkback.c
> index 5cf2993..ed62008 100644
> --- a/drivers/block/xen-blkback/blkback.c
> +++ b/drivers/block/xen-blkback/blkback.c
> @@ -824,3 +824,4 @@ static int __init xen_blkif_init(void)
>  module_init(xen_blkif_init);
>  
>  MODULE_LICENSE("Dual BSD/GPL");
> +MODULE_ALIAS("xen-backend:vbd");
> diff --git a/drivers/net/xen-netback/netback.c b/drivers/net/xen-netback/netback.c
> index 0e4851b..fd00f25 100644
> --- a/drivers/net/xen-netback/netback.c
> +++ b/drivers/net/xen-netback/netback.c
> @@ -1743,3 +1743,4 @@ failed_init:
>  module_init(netback_init);
>  
>  MODULE_LICENSE("Dual BSD/GPL");
> +MODULE_ALIAS("xen-backend:vif");
> diff --git a/drivers/xen/xenbus/xenbus_probe.c b/drivers/xen/xenbus/xenbus_probe.c
> index 2ed0b04..bd2f90c 100644
> --- a/drivers/xen/xenbus/xenbus_probe.c
> +++ b/drivers/xen/xenbus/xenbus_probe.c
> @@ -393,7 +393,8 @@ static ssize_t devtype_show(struct device *dev,
>  static ssize_t modalias_show(struct device *dev,
>  			     struct device_attribute *attr, char *buf)
>  {
> -	return sprintf(buf, "xen:%s\n", to_xenbus_device(dev)->devicetype);
> +	return sprintf(buf, "%s:%s\n", dev->bus->name,
> +		       to_xenbus_device(dev)->devicetype);
>  }
>  
>  struct device_attribute xenbus_dev_attrs[] = {
> diff --git a/drivers/xen/xenbus/xenbus_probe_backend.c b/drivers/xen/xenbus/xenbus_probe_backend.c
> index ec510e5..60adf91 100644
> --- a/drivers/xen/xenbus/xenbus_probe_backend.c
> +++ b/drivers/xen/xenbus/xenbus_probe_backend.c
> @@ -107,6 +107,9 @@ static int xenbus_uevent_backend(struct device *dev,
>  	if (xdev == NULL)
>  		return -ENODEV;
>  
> +	if (add_uevent_var(env, "MODALIAS=xen-backend:%s", xdev->devicetype))
> +		return -ENOMEM;
> +
>  	/* stuff we want to pass to /sbin/hotplug */
>  	if (add_uevent_var(env, "XENBUS_TYPE=%s", xdev->devicetype))
>  		return -ENOMEM;


