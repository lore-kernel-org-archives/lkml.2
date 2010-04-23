Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756837Ab0DWRgb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 13:36:31 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:46895 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755552Ab0DWRg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 13:36:29 -0400
Date: Fri, 23 Apr 2010 10:36:20 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Carlos Chinea <carlos.chinea@nokia.com>
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Subject: Re: [RFC PATCH 1/5] HSI: Introducing HSI framework
Message-Id: <20100423103620.e14ba593.randy.dunlap@oracle.com>
In-Reply-To: <1272035728-6933-2-git-send-email-carlos.chinea@nokia.com>
References: <1272035728-6933-1-git-send-email-carlos.chinea@nokia.com>
	<1272035728-6933-2-git-send-email-carlos.chinea@nokia.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090201.4BD1DA9B.0113:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Apr 2010 18:15:24 +0300 Carlos Chinea wrote:

> Adds HSI framework in to the linux kernel.
> 
> High Speed Synchronous Serial Interface (HSI) is a
             ^^^^^^^^^^^
             yes, correct spelling

> serial interface mainly used for connecting application
> engines (APE) with cellular modem engines (CMT) in cellular
> handsets.
> 
> HSI provides multiplexing for up to 16 logical channels,
> low-latency and full duplex communication.
> 
> Signed-off-by: Carlos Chinea <carlos.chinea@nokia.com>
> ---
>  drivers/Kconfig         |    2 +
>  drivers/Makefile        |    1 +
>  drivers/hsi/Kconfig     |   13 ++
>  drivers/hsi/Makefile    |    4 +
>  drivers/hsi/hsi.c       |  487 +++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/hsi/hsi.h |  365 +++++++++++++++++++++++++++++++++++
>  6 files changed, 872 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/hsi/Kconfig
>  create mode 100644 drivers/hsi/Makefile
>  create mode 100644 drivers/hsi/hsi.c
>  create mode 100644 include/linux/hsi/hsi.h
> 

> diff --git a/drivers/hsi/Kconfig b/drivers/hsi/Kconfig
> new file mode 100644
> index 0000000..e122584
> --- /dev/null
> +++ b/drivers/hsi/Kconfig
> @@ -0,0 +1,13 @@
> +#
> +# HSI driver configuration
> +#
> +menuconfig HSI
> +	bool "HSI support"
> +	---help---
> +	  The "High speed syncrhonous Serial Interface" is
                          ~~~~~~~~~~~

> +	  synchrnous serial interface used mainly to connect
	  ~~~~~~~~~~

Fix spelling mistakes (or typos).

> +	  application engines and celluar modems.
> +
> +if HSI
> +
> +endif # HSI

> diff --git a/drivers/hsi/hsi.c b/drivers/hsi/hsi.c
> new file mode 100644
> index 0000000..f6fd777
> --- /dev/null
> +++ b/drivers/hsi/hsi.c
> @@ -0,0 +1,487 @@
> +/*
> + * hsi.c
> + *
> + * HSI core.
> + *
> + * Copyright (C) 2010 Nokia Corporation. All rights reserved.
> + *
> + * Contact: Carlos Chinea <carlos.chinea@nokia.com>
> + */
> +#include <linux/hsi/hsi.h>
> +#include <linux/rwsem.h>

Need
#include <linux/list.h>
for LIST_HEAD().

> +
> +struct hsi_cl_info {
> +	struct list_head	list;
> +	struct hsi_board_info	info;
> +};
> +
> +static LIST_HEAD(hsi_board_list);
> +


> +
> +static int hsi_bus_uevent(struct device *dev, struct kobj_uevent_env *env)

#include <linux/kobject.h>


> +{
> +	add_uevent_var(env, "MODALIAS=hsi:%s", dev_name(dev));
> +
> +	return 0;
> +}
> +
> +static int hsi_bus_match(struct device *dev, struct device_driver *driver)
> +{
> +	return strcmp(dev_name(dev), driver->name) == 0;

string.h

> +}
> +
> +struct bus_type hsi_bus_type = {
> +	.name		= "hsi",
> +	.dev_attrs	= hsi_bus_dev_attrs,
> +	.match		= hsi_bus_match,
> +	.uevent		= hsi_bus_uevent,
> +};
> +
> +static void hsi_client_release(struct device *dev)
> +{
> +	kfree(to_hsi_client(dev));

slab.h

> +}
> +
> +static void hsi_new_client(struct hsi_port *port, struct hsi_board_info *info)
> +{
> +	struct hsi_client *cl;
> +
> +	cl = kzalloc(sizeof(*cl), GFP_KERNEL);

slab.h

> +	if (!cl)
> +		return;
> +	cl->device.type = &hsi_cl;
> +	cl->tx_cfg = info->tx_cfg;
> +	cl->rx_cfg = info->rx_cfg;
> +	cl->device.bus = &hsi_bus_type;
> +	cl->device.parent = &port->device;
> +	cl->device.release = hsi_client_release;
> +	dev_set_name(&cl->device, info->name);
> +	cl->device.platform_data = info->platform_data;
> +	if (info->archdata)
> +		cl->device.archdata = *info->archdata;
> +	if (device_register(&cl->device) < 0) {
> +		pr_err("hsi: failed to register client: %s\n", info->name);
> +		kfree(cl);
> +	}
> +}

...



> +/**
> + * hsi_alloc_msg - Allocate an HSI message
> + * @nents: Number of memory entries
> + * @flags: Kernel allocation flags
> + *
> + * NOTE: nents can be 0. This mainly makes sense for read transfer.
> + * In that case, HSI drivers will call the complete callback when
> + * there is data to be read without cosuming it.

                                       consuming

> + *
> + * Return NULL on failure or a pointer to an hsi_msg on success.
> + */
> +struct hsi_msg *hsi_alloc_msg(unsigned int nents, gfp_t flags)
> +{
...
> +}
> +EXPORT_SYMBOL_GPL(hsi_alloc_msg);

...


> +/**
> + * hsi_event -Notifies clients about port events
> + * @port: Port where the event occurred
> + * @event: The event type:
> + *		- HSI_EVENT_START_RX: Incoming wake line high
> + *		- HSI_EVENT_STOP_RX: Incoming wake line down
> + *
> + * Note: Clients should not be concerned about wake line behavior. But due
> + * to a race condition in HSI HW protocol when the wake lines are in used,

                                                                 are in use,

> + * they need to be notified about wake line changes, so they can implement
> + * a workaround for it.
> + */
> +void hsi_event(struct hsi_port *port, unsigned int event)
> +{
...
> +}

> diff --git a/include/linux/hsi/hsi.h b/include/linux/hsi/hsi.h
> new file mode 100644
> index 0000000..b272f23
> --- /dev/null
> +++ b/include/linux/hsi/hsi.h
> @@ -0,0 +1,365 @@
> +/*
> + * hsi.h
> + *
> + * HSI core header file.
> + *
> + * Copyright (C) 2010 Nokia Corporation. All rights reserved.
> + *
> + * Contact: Carlos Chinea <carlos.chinea@nokia.com>
> + */
> +
> +#ifndef __LINUX_HSI_H__
> +#define __LINUX_HSI_H__
> +
> +#include <linux/device.h>
> +#include <linux/mutex.h>
> +#include <linux/scatterlist.h>
> +
> +/* HSI message ttype */
> +#define HSI_MSG_READ	0
> +#define HSI_MSG_WRITE	1
> +
> +/* HSI configuration values */
> +#define HSI_MODE_STREAM	1
> +#define HSI_MODE_FRAME	2
> +#define HSI_FLOW_SYNC	0	/* Synchronized flow */
> +#define HSI_FLOW_PIPE	1	/* Pipelined flow */
> +#define HSI_ARB_RR	0	/* Round-robin arbitration */
> +#define HSI_ARB_PRIO	1	/* Channel priority arbitration */
> +
> +#define HSI_MAX_CHANNELS	16

> +/**
> + * struct hsi_client - HSI client attached to an HSI port
> + * @device: Driver model representation of the device
> + * @tx_cfg: HSI TX configuration
> + * @rx_cfg: HSI RX configuration
> + * @hsi_start_rx: Called after incoming wake line goes high
> + * @hsi_stop_rx: Called after incoming wake line goes low
> + * @pclaimed: Set when successfully claimed a port. Internal, do not touch.
> + */
> +struct hsi_client {
> +	struct device		device;
> +	struct hsi_config	tx_cfg;
> +	struct hsi_config	rx_cfg;
> +	void			(*hsi_start_rx)(struct hsi_client *cl);
> +	void			(*hsi_stop_rx)(struct hsi_client *cl);

You can put:
	/* private: */
here and that struct field won't show up in the generated kernel-doc output...

> +	unsigned int		pclaimed:1; /* Private, do not touch */
> +};
> +
> +#define to_hsi_client(dev) container_of(dev, struct hsi_client, device)
> +



---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
