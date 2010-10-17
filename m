Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932340Ab0JQP7I (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 11:59:08 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:50760 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1757020Ab0JQP7G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 11:59:06 -0400
X-Authenticated: #46851621
X-Provags-ID: V01U2FsdGVkX196lBQoEv96HNwV7LKmnS6gDxNFLBcna07aZCx2tG
	DdILOQce0uf3Vt
Message-ID: <4CBB1D13.3000709@gmx.de>
Date: Sun, 17 Oct 2010 17:58:11 +0200
From: Peter Henn <peter_henn@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.9.2.7) Gecko/20100713 Thunderbird/3.1.1
MIME-Version: 1.0
To: Carlos Chinea <carlos.chinea@nokia.com>
CC: Linux Kernel Development <linux-kernel@vger.kernel.org>,
        linux-omap@vger.kernel.org
Subject: Re: [RFC PATCHv3 1/7] HSI: Introducing HSI framework
References: <5BC1940B997A254A9C54B26A6B7E50C807A1810400@mucse403.eu.infineon.com>
In-Reply-To: <5BC1940B997A254A9C54B26A6B7E50C807A1810400@mucse403.eu.infineon.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Carlos,

* Carlos Chinea <carlos.chinea@nokia.com> [101011 01:58]:
> Adds HSI framework in to the linux kernel.
> 
> High Speed Synchronous Serial Interface (HSI) is a
> serial interface mainly used for connecting application
> engines (APE) with cellular modem engines (CMT) in cellular
> handsets.
> 

...

> diff --git a/include/linux/hsi/hsi.h b/include/linux/hsi/hsi.h
> new file mode 100644
> index 0000000..54ae22a
> --- /dev/null
> +++ b/include/linux/hsi/hsi.h
> @@ -0,0 +1,376 @@
> +/*
> + * hsi.h
> + *
> + * HSI core header file.
> + *
> + * Copyright (C) 2010 Nokia Corporation. All rights reserved.
> + *
> + * Contact: Carlos Chinea <carlos.chinea@nokia.com>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * version 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful, but
> + * WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + * General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
> + * 02110-1301 USA
> + */
> +
> +#ifndef __LINUX_HSI_H__
> +#define __LINUX_HSI_H__
> +
> +#include <linux/device.h>
> +#include <linux/mutex.h>
> +#include <linux/scatterlist.h>
> +#include <linux/spinlock.h>
> +#include <linux/list.h>
> +
> +/* HSI message ttype */
> +#define HSI_MSG_READ   0
> +#define HSI_MSG_WRITE  1
> +
> +/* HSI configuration values */
> +#define HSI_MODE_STREAM        1
> +#define HSI_MODE_FRAME 2
> +#define HSI_FLOW_SYNC  0       /* Synchronized flow */
> +#define HSI_FLOW_PIPE  1       /* Pipelined flow */
> +#define HSI_ARB_RR     0       /* Round-robin arbitration */
> +#define HSI_ARB_PRIO   1       /* Channel priority arbitration */
> +
> +#define HSI_MAX_CHANNELS       16
> +
> +/* HSI message status codes */
> +enum {
> +       HSI_STATUS_COMPLETED,   /* Message transfer is completed */
> +       HSI_STATUS_PENDING,     /* Message pending to be read/write (POLL) */
> +       HSI_STATUS_PROCEEDING,  /* Message transfer is ongoing */
> +       HSI_STATUS_QUEUED,      /* Message waiting to be served */
> +       HSI_STATUS_ERROR,       /* Error when message transfer was ongoing */
> +};
> +
> +/* HSI port event codes */
> +enum {
> +       HSI_EVENT_START_RX,
> +       HSI_EVENT_STOP_RX,
> +};
> +
> +/**
> + * struct hsi_config - Configuration for RX/TX HSI modules
> + * @mode: Bit transmission mode (STREAM or FRAME)
> + * @flow: Flow type (SYNCHRONIZED or PIPELINE)
> + * @channels: Number of channels to use [1..16]
> + * @speed: Max bit transmission speed (Kbit/s)
> + * @arb_mode: Arbitration mode for TX frame (Round robin, priority)
> + */
> +struct hsi_config {
> +       unsigned int    mode;
> +       unsigned int    flow;
> +       unsigned int    channels;
> +       unsigned int    speed;
> +       unsigned int    arb_mode; /* TX only */
> +};
> +

Enums for "mode" and "flow"!
Does the flow control be really a TX link property?
In RX direction a speed range helps changing the baudrate on the fly.
A configuration flag for wakeup is missing, which defines the wakeup
either GPIO or Ready line controlled.
A maximum RX frame burst counter value for each channel is missing.
A TX send priority for each channel is possibly missing, too.

TX and RX initial port properties AKA config could be combined e.g.:
struct hsi_port_properties {
	__u16 tx_ch_count;	/* required number of TX channels */
	__u16 rx_ch_count;	/* required number of RX channels */
	__u32 tx_speed;		/* TX speed in HZ */
	__u32 rx_min_speed;	/* RX min. speed in HZ */
	__u32 rx_max_speed;	/* RX max. speed in HZ */
	enum hsi_transfer_mode tx_transfer_mode;
	enum hsi_transfer_mode rx_transfer_mode;
	enum hsi_flow_ctrl_mode flow_ctrl_mode;	/* only need for RX */	
	enum hsi_arb_mode arb_mode;		/* only need for TX */
	bool tx_wakeup_mode;	/* true: wakeup line ... */
	bool rx_wakeup_mode;	/* ... false: ready line */
};

Example for channel:
struct hsi_channel_properties {
	...
	unsigned char prio; 		/* only need for TX */
	unsigned short frame_burst;	/* only need for RX */
}

> +/**
> + * struct hsi_board_info - HSI client board info
> + * @name: Name for the HSI device
> + * @hsi_id: HSI controller id where the client sits
> + * @port: Port number in the controller where the client sits
> + * @tx_cfg: HSI TX configuration
> + * @rx_cfg: HSI RX configuration
> + * @platform_data: Platform related data
> + * @archdata: Architecture-dependent device data
> + */
> +struct hsi_board_info {
> +       const char              *name;
> +       int                     hsi_id;
> +       unsigned int            port;
> +       struct hsi_config       tx_cfg;
> +       struct hsi_config       rx_cfg;
> +       void                    *platform_data;
> +       struct dev_archdata     *archdata;
> +};
> +
> +#ifdef CONFIG_HSI
> +extern int hsi_register_board_info(struct hsi_board_info const *info,
> +                                                       unsigned int len);
> +#else
> +static inline int hsi_register_board_info(struct hsi_board_info const *info,
> +                                                       unsigned int len)
> +{
> +       return 0;
> +}
> +#endif
> +
> +/**
> + * struct hsi_client - HSI client attached to an HSI port
> + * @device: Driver model representation of the device
> + * @tx_cfg: HSI TX configuration
> + * @rx_cfg: HSI RX configuration
> + * @hsi_start_rx: Called after incoming wake line goes high
> + * @hsi_stop_rx: Called after incoming wake line goes low
> + */
> +struct hsi_client {
> +       struct device           device;
> +       struct hsi_config       tx_cfg;
> +       struct hsi_config       rx_cfg;
> +       void                    (*hsi_start_rx)(struct hsi_client *cl);
> +       void                    (*hsi_stop_rx)(struct hsi_client *cl);
> +       /* private: */
> +       unsigned int            pclaimed:1;
> +       struct list_head        link;
> +};
> +
> +#define to_hsi_client(dev) container_of(dev, struct hsi_client, device)
> +
> +static inline void hsi_client_set_drvdata(struct hsi_client *cl, void *data)
> +{
> +       dev_set_drvdata(&cl->device, data);
> +}
> +
> +static inline void *hsi_client_drvdata(struct hsi_client *cl)
> +{
> +       return dev_get_drvdata(&cl->device);
> +}
> +
> +/**
> + * struct hsi_client_driver - Driver associated to an HSI client
> + * @driver: Driver model representation of the driver
> + */
> +struct hsi_client_driver {
> +       struct device_driver    driver;
> +};

Either using here direct "struct device_driver" or supporting an own
hsi_probe, hsi_remove called from the framework, example:

struct hsi_client_driver {
	const char *name;
	int (*probe) (struct hsi_client *);
	void (*disconnect) (struct hsi_client *);
	int (*suspend) (struct hsi_client *, pm_message_t);
	int (*resume) (struct hsi_client *);
	int (*event) (struct hsi_client *, u32 hsi_event);

	struct device_driver driver;
};
#define	to_hsi_client_driver(d) \
	container_of(d, struct hsi_client_driver, driver)


> +
> +#define to_hsi_client_driver(drv) container_of(drv, struct hsi_client_driver,\
> +                                                                       driver)
> +
> +int hsi_register_client_driver(struct hsi_client_driver *drv);
> +
> +static inline void hsi_unregister_client_driver(struct hsi_client_driver *drv)
> +{
> +       driver_unregister(&drv->driver);
> +}
> +
> +/**
> + * struct hsi_msg - HSI message descriptor
> + * @link: Free to use by the current descriptor owner
> + * @cl: HSI device client that issues the transfer
> + * @sgt: Head of the scatterlist array
> + * @context: Client context data associated to the transfer
> + * @complete: Transfer completion callback
> + * @destructor: Destructor to free resources when flushing
> + * @status: Status of the transfer when completed
> + * @actual_len: Actual length of data transfered on completion
> + * @channel: Channel were to TX/RX the message
> + * @ttype: Transfer type (TX if set, RX otherwise)
> + * @break_frame: if true HSI will send/receive a break frame (FRAME MODE)
> + */
> +struct hsi_msg {
> +       struct list_head        link;
> +       struct hsi_client       *cl;
> +       struct sg_table         sgt;
> +       void                    *context;
> +
> +       void                    (*complete)(struct hsi_msg *msg);
> +       void                    (*destructor)(struct hsi_msg *msg);
> +
> +       int                     status;
> +       unsigned int            actual_len;
> +       unsigned int            channel;
> +       unsigned int            ttype:1;
> +       unsigned int            break_frame:1;
> +};

Either HSI transfer data or that break "1 bit message".

Normally a break affects all HSI channels of a HSI link and is planned
to be used as an error indication of the HSI link.  It could be a
special HSI port initialization/reset/flush or setup property.


> +
> +struct hsi_msg *hsi_alloc_msg(unsigned int n_frag, gfp_t flags);
> +void hsi_free_msg(struct hsi_msg *msg);
> +
> +/**
> + * struct hsi_port - HSI port device
> + * @device: Driver model representation of the device
> + * @tx_cfg: Current TX path configuration
> + * @rx_cfg: Current RX path configuration
> + * @num: Port number
> + * @shared: Set when port can be shared by different clients
> + * @claimed: Reference count of clients which claimed the port
> + * @lock: Serialize port claim
> + * @async: Asynchronous transfer callback
> + * @setup: Callback to set the HSI client configuration
> + * @flush: Callback to clean the HW state and destroy all pending transfers
> + * @start_tx: Callback to inform that a client wants to TX data
> + * @stop_tx: Callback to inform that a client no longer wishes to TX data
> + * @release: Callback to inform that a client no longer uses the port
> + * @clients: List of hsi_clients using the port.
> + * @clock: Lock to serialize access to the clients list.
> + */
> +struct hsi_port {
> +       struct device                   device;
> +       struct hsi_config               tx_cfg;
> +       struct hsi_config               rx_cfg;
> +       unsigned int                    num;
> +       unsigned int                    shared:1;
> +       int                             claimed;
> +       struct mutex                    lock;
> +       int                             (*async)(struct hsi_msg *msg);
> +       int                             (*setup)(struct hsi_client *cl);

A synchronous call makes problems using a HSI-USB dongle like the
Asamalab with its delayed transaction over USB.  Please add an
completion callback here.

> +       int                             (*flush)(struct hsi_client *cl);

Name "flush" could be unclear, if it is indeed a "port reset".

> +       int                             (*start_tx)(struct hsi_client *cl);
> +       int                             (*stop_tx)(struct hsi_client *cl);
> +       int                             (*release)(struct hsi_client *cl);
> +       struct list_head                clients;
> +       spinlock_t                      clock;
> +};

The number of available DMA engines helps a link layer,
if (DMA_engines < parallel_channel_endpoint_conections_via_DMA)

Something like that filled up from the HCD and given by the registration
call:
struct hsi_hcd_limits {
	unsigned int tx_max_ch_bits;
	unsigned int rx_max_ch_bits;
	unsigned int tx_min_speed;
	unsigned int tx_max_speed;
	unsigned int rx_min_speed;
	unsigned int rx_max_speed;
	unsigned int max_burst_jobs;
	unsigned int tx_wakeup_support:1;
	unsigned int rx_wakeup_support:1;
	unsigned int tx_loopback_support:1;
};


> +
> +#define to_hsi_port(dev) container_of(dev, struct hsi_port, device)
> +#define hsi_get_port(cl) to_hsi_port((cl)->device.parent)
> +
> +void hsi_event(struct hsi_port *port, unsigned int event);
> +int hsi_claim_port(struct hsi_client *cl, unsigned int share);
> +void hsi_release_port(struct hsi_client *cl);
> +
> +static inline int hsi_port_claimed(struct hsi_client *cl)
> +{
> +       return cl->pclaimed;
> +}
> +
> +static inline void hsi_port_set_drvdata(struct hsi_port *port, void *data)
> +{
> +       dev_set_drvdata(&port->device, data);
> +}
> +
> +static inline void *hsi_port_drvdata(struct hsi_port *port)
> +{
> +       return dev_get_drvdata(&port->device);
> +}
> +
> +/**
> + * struct hsi_controller - HSI controller device
> + * @device: Driver model representation of the device
> + * @id: HSI controller ID
> + * @num_ports: Number of ports in the HSI controller
> + * @port: Array of HSI ports
> + */
> +struct hsi_controller {
> +       struct device           device;

Device is only needed for platform device.  PCIe or USB related
controller would have their own device, like in USB-core in the hcd.c

> +       int                     id;
> +       unsigned int            num_ports;
> +       struct hsi_port         *port;
> +};
> +
> +#define to_hsi_controller(dev) container_of(dev, struct hsi_controller, device)
> +
> +struct hsi_controller *hsi_alloc_controller(unsigned int n_ports, gfp_t flags);
> +void hsi_free_controller(struct hsi_controller *hsi);
> +int hsi_register_controller(struct hsi_controller *hsi);
> +void hsi_unregister_controller(struct hsi_controller *hsi);
> +
> +static inline void hsi_controller_set_drvdata(struct hsi_controller *hsi,
> +                                                               void *data)
> +{
> +       dev_set_drvdata(&hsi->device, data);
> +}
> +
> +static inline void *hsi_controller_drvdata(struct hsi_controller *hsi)
> +{
> +       return dev_get_drvdata(&hsi->device);
> +}
> +
> +static inline struct hsi_port *hsi_find_port_num(struct hsi_controller *hsi,
> +                                                       unsigned int num)
> +{
> +       return (num < hsi->num_ports) ? &hsi->port[num] : NULL;
> +}
> +
> +/*
> + * API for HSI clients
> + */
> +int hsi_async(struct hsi_client *cl, struct hsi_msg *msg);
> +
> +/**
> + * hsi_setup - Configure the client's port
> + * @cl: Pointer to the HSI client
> + *
> + * When sharing ports, clients should either relay on a single
> + * client setup or have the same setup for all of them.
> + *
> + * Return -errno on failure, 0 on success
> + */
> +static inline int hsi_setup(struct hsi_client *cl)
> +{
> +       if (!hsi_port_claimed(cl))
> +               return -EACCES;
> +       return  hsi_get_port(cl)->setup(cl);
> +}
> +
> +/**
> + * hsi_flush - Flush all pending transactions on the client's port
> + * @cl: Pointer to the HSI client
> + *
> + * This function will destroy all pending hsi_msg in the port and reset
> + * the HW port so it is ready to receive and transmit from a clean state.
> + *
> + * Return -errno on failure, 0 on success
> + */
> +static inline int hsi_flush(struct hsi_client *cl)
> +{
> +       if (!hsi_port_claimed(cl))
> +               return -EACCES;
> +       return hsi_get_port(cl)->flush(cl);
> +}

Also here "hsi_port_reset" would be more self-explanatory than hsi_flush.

Regards,

Peter

