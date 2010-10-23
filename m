Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756730Ab0JWMmt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 08:42:49 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:57857 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753645Ab0JWMmr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 08:42:47 -0400
X-Authenticated: #46851621
X-Provags-ID: V01U2FsdGVkX1/MnCNX8//MnFWpC/jY89fYfOY0pNsB1qba+xskEq
	Yz76pS1lHvp9ei
Message-ID: <4CC2D80E.1050807@gmx.de>
Date: Sat, 23 Oct 2010 14:41:50 +0200
From: Peter Henn <peter_henn@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.9.2.7) Gecko/20100713 Thunderbird/3.1.1
MIME-Version: 1.0
To: Carlos Chinea <carlos.chinea@nokia.com>
CC: Linux Kernel Development <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: Re: [RFC PATCHv3 1/7] HSI: Introducing HSI framework
References: <5BC1940B997A254A9C54B26A6B7E50C807A1810400@mucse403.eu.infineon.com>	 <4CBB1D13.3000709@gmx.de> <1287399186.6570.1044.camel@localhost>
In-Reply-To: <1287399186.6570.1044.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Carlos,
please find my comments inline

Am 18.10.2010 12:53, schrieb Carlos Chinea:
> Hi Peter,
> 
>>> +/**
>>> + * struct hsi_config - Configuration for RX/TX HSI modules
>>> + * @mode: Bit transmission mode (STREAM or FRAME)
>>> + * @flow: Flow type (SYNCHRONIZED or PIPELINE)
>>> + * @channels: Number of channels to use [1..16]
>>> + * @speed: Max bit transmission speed (Kbit/s)
>>> + * @arb_mode: Arbitration mode for TX frame (Round robin, priority)
>>> + */
>>> +struct hsi_config {
>>> +       unsigned int    mode;
>>> +       unsigned int    flow;
>>> +       unsigned int    channels;
>>> +       unsigned int    speed;
>>> +       unsigned int    arb_mode; /* TX only */
>>> +};
>>> +
>>
>> Enums for "mode" and "flow"!
>> Does the flow control be really a TX link property?
> 
> Hmm, yep it does not. I'll fix that.
> 
>> In RX direction a speed range helps changing the baudrate on the fly.
> 
> Clients just tell which is the TX max bit rate allowed. 
> In the case of TX the HW driver is allowed to change the speed from the maximum to the HW minimum.
yes

> In the case of RX the HW driver has to be able to handle that TX speed from the transmitter.
The RX speed shall setup the following things:
- the maximum system clock need to ensure proper data receiving. That
  effects not even the receiver, which mostly reconstruct the RX clock
  from data and flag, but all the other data management hardware behind.
  Too high values would prevent power saving here.
- the minimum value shall be used to setup the frame timeout and
  message timeout counter inside the HSI controller hardware

>  
>> A configuration flag for wakeup is missing, which defines the wakeup
>> either GPIO or Ready line controlled.
> 
> This is just tied to the HW controller, it is internal data that can be
> passed to HW driver through other ways.
Yes, it is a host controller setting. Could you add this to the
framework, which acts here as an API?

> Clients can only set HW configuration values that affects directly their
> protocol behavior.
> 
>> A maximum RX frame burst counter value for each channel is missing.
> 
> Again tied to the HW driver.
Yepp, the same as above.


>> A TX send priority for each channel is possibly missing, too.
>>
> 
> Do you have a HW implementing that kind of feature ? And also does
> any protocol make direct use of that feature, meaning it changes the
> behavior of the protocol ?
> 
> If the answers are yes, I am willing to add support for that, otherwise
> I will wait until someone really needs it. Please note the current
> ARB_PRIO value means that channel 0 has the highest priority and
> MAX_CHANNEL the lowest.
I know at least two HSI chip vendors, which has a more complex
arbitration and priority mechanism than only preferring channel 0 or
round robin. You may drop me a separate email, if you are interested to
known details. Just reserving a byte for each channel would work here to
represent such a special priority behavior.

> 
>> TX and RX initial port properties AKA config could be combined e.g.:
> 
> It is a matter of taste, and with the tx flow change the memory
> footprint will be the same.
Yepp, and I guess normally both hsi_config structures for tx and rx
setup will be handled mostly close together or not?

> 
>> struct hsi_port_properties {
>>         __u16 tx_ch_count;      /* required number of TX channels */
>>         __u16 rx_ch_count;      /* required number of RX channels */
>>         __u32 tx_speed;         /* TX speed in HZ */
>>         __u32 rx_min_speed;     /* RX min. speed in HZ */
>>         __u32 rx_max_speed;     /* RX max. speed in HZ */
>>         enum hsi_transfer_mode tx_transfer_mode;
>>         enum hsi_transfer_mode rx_transfer_mode;
>>         enum hsi_flow_ctrl_mode flow_ctrl_mode; /* only need for RX */
>>         enum hsi_arb_mode arb_mode;             /* only need for TX */
>>         bool tx_wakeup_mode;    /* true: wakeup line ... */
>>         bool rx_wakeup_mode;    /* ... false: ready line */
>> };
>>
>> Example for channel:
>> struct hsi_channel_properties {
>>         ...
>>         unsigned char prio;             /* only need for TX */
>>         unsigned short frame_burst;     /* only need for RX */
>> }
>>
>>> +/**
>>> + * struct hsi_board_info - HSI client board info
>>> + * @name: Name for the HSI device
>>> + * @hsi_id: HSI controller id where the client sits
>>> + * @port: Port number in the controller where the client sits
>>> + * @tx_cfg: HSI TX configuration
>>> + * @rx_cfg: HSI RX configuration
>>> + * @platform_data: Platform related data
>>> + * @archdata: Architecture-dependent device data
>>> + */
>>> +struct hsi_board_info {
>>> +       const char              *name;
>>> +       int                     hsi_id;
>>> +       unsigned int            port;
>>> +       struct hsi_config       tx_cfg;
>>> +       struct hsi_config       rx_cfg;
>>> +       void                    *platform_data;
>>> +       struct dev_archdata     *archdata;
>>> +};
>>> +
>>> +#ifdef CONFIG_HSI
>>> +extern int hsi_register_board_info(struct hsi_board_info const *info,
>>> +                                                       unsigned int len);
>>> +#else
>>> +static inline int hsi_register_board_info(struct hsi_board_info const *info,
>>> +                                                       unsigned int len)
>>> +{
>>> +       return 0;
>>> +}
>>> +#endif
>>> +
>>> +/**
>>> + * struct hsi_client - HSI client attached to an HSI port
>>> + * @device: Driver model representation of the device
>>> + * @tx_cfg: HSI TX configuration
>>> + * @rx_cfg: HSI RX configuration
>>> + * @hsi_start_rx: Called after incoming wake line goes high
>>> + * @hsi_stop_rx: Called after incoming wake line goes low
>>> + */
>>> +struct hsi_client {
>>> +       struct device           device;
>>> +       struct hsi_config       tx_cfg;
>>> +       struct hsi_config       rx_cfg;
>>> +       void                    (*hsi_start_rx)(struct hsi_client *cl);
>>> +       void                    (*hsi_stop_rx)(struct hsi_client *cl);
>>> +       /* private: */
>>> +       unsigned int            pclaimed:1;
>>> +       struct list_head        link;
>>> +};
>>> +
>>> +#define to_hsi_client(dev) container_of(dev, struct hsi_client, device)
>>> +
>>> +static inline void hsi_client_set_drvdata(struct hsi_client *cl, void *data)
>>> +{
>>> +       dev_set_drvdata(&cl->device, data);
>>> +}
>>> +
>>> +static inline void *hsi_client_drvdata(struct hsi_client *cl)
>>> +{
>>> +       return dev_get_drvdata(&cl->device);
>>> +}
>>> +
>>> +/**
>>> + * struct hsi_client_driver - Driver associated to an HSI client
>>> + * @driver: Driver model representation of the driver
>>> + */
>>> +struct hsi_client_driver {
>>> +       struct device_driver    driver;
>>> +};
>>
>> Either using here direct "struct device_driver" or supporting an own
>> hsi_probe, hsi_remove called from the framework, example:
>>
>> struct hsi_client_driver {
>>         const char *name;
>>         int (*probe) (struct hsi_client *);
>>         void (*disconnect) (struct hsi_client *);
>>         int (*suspend) (struct hsi_client *, pm_message_t);
>>         int (*resume) (struct hsi_client *);
>>         int (*event) (struct hsi_client *, u32 hsi_event);
>>
>>         struct device_driver driver;
>> };
> 
> Hmm, I will keep it as it is. No need to have currently custom probe()/
> remove(). They will just be a wrap up. Having the device_driver wrap
> like this forces the clients to register using
Yes, SPI uses these simple wrappers.

> hsi_register_client_driver instead of allowing them to use also the
> device_register() directly which will be wrong as they will not be tied
> to the HSI bus. 
So the hsi_client will also in future plans direct related to the Linux
Device Core.  And there is no plan for some client specific
configuration support by that framework as a general code part?

However, that becomes anyway difficult using the HSI-port sharing
mechanism for different vendor specific HSI client drivers.

> 
>> #define to_hsi_client_driver(d) \
>>         container_of(d, struct hsi_client_driver, driver)
>>
> Ok for the cosmetic change.
>>
>>> +
>>> +#define to_hsi_client_driver(drv) container_of(drv, struct hsi_client_driver,\
>>> +                                                                       driver)
>>> +
>>> +int hsi_register_client_driver(struct hsi_client_driver *drv);
>>> +
>>> +static inline void hsi_unregister_client_driver(struct hsi_client_driver *drv)
>>> +{
>>> +       driver_unregister(&drv->driver);
>>> +}
>>> +
>>> +/**
>>> + * struct hsi_msg - HSI message descriptor
>>> + * @link: Free to use by the current descriptor owner
>>> + * @cl: HSI device client that issues the transfer
>>> + * @sgt: Head of the scatterlist array
>>> + * @context: Client context data associated to the transfer
>>> + * @complete: Transfer completion callback
>>> + * @destructor: Destructor to free resources when flushing
>>> + * @status: Status of the transfer when completed
>>> + * @actual_len: Actual length of data transfered on completion
>>> + * @channel: Channel were to TX/RX the message
>>> + * @ttype: Transfer type (TX if set, RX otherwise)
>>> + * @break_frame: if true HSI will send/receive a break frame (FRAME MODE)
>>> + */
>>> +struct hsi_msg {
>>> +       struct list_head        link;
>>> +       struct hsi_client       *cl;
>>> +       struct sg_table         sgt;
>>> +       void                    *context;
>>> +
>>> +       void                    (*complete)(struct hsi_msg *msg);
>>> +       void                    (*destructor)(struct hsi_msg *msg);
>>> +
>>> +       int                     status;
>>> +       unsigned int            actual_len;
>>> +       unsigned int            channel;
>>> +       unsigned int            ttype:1;
>>> +       unsigned int            break_frame:1;
>>> +};
>>
>> Either HSI transfer data or that break "1 bit message".
>>
> 
> And that's how it works. The omap_ssi driver works exactly like that.
> Maybe some extra documentation explaining this is needed.
> 
Yes, if sgt _and_ break_frame bit is defined, what shall the HSI
controller do:
- send/have received 1st the message, than the break frame
- send/have received 1st the break frame, then the message
- send/have received only the break frame

>> Normally a break affects all HSI channels of a HSI link and is planned
>> to be used as an error indication of the HSI link.  It could be a
>> special HSI port initialization/reset/flush or setup property.
>>
> 
> Yes but yet again the client wants to send/receive a frame. It is just
> that turns to be a special one that only the HW can generate.
> So I prefer to keep that on the HSI sending/receiving API. 
> 
>>
>>> +
>>> +struct hsi_msg *hsi_alloc_msg(unsigned int n_frag, gfp_t flags);
>>> +void hsi_free_msg(struct hsi_msg *msg);
>>> +
>>> +/**
>>> + * struct hsi_port - HSI port device
>>> + * @device: Driver model representation of the device
>>> + * @tx_cfg: Current TX path configuration
>>> + * @rx_cfg: Current RX path configuration
>>> + * @num: Port number
>>> + * @shared: Set when port can be shared by different clients
>>> + * @claimed: Reference count of clients which claimed the port
>>> + * @lock: Serialize port claim
>>> + * @async: Asynchronous transfer callback
>>> + * @setup: Callback to set the HSI client configuration
>>> + * @flush: Callback to clean the HW state and destroy all pending transfers
>>> + * @start_tx: Callback to inform that a client wants to TX data
>>> + * @stop_tx: Callback to inform that a client no longer wishes to TX data
>>> + * @release: Callback to inform that a client no longer uses the port
>>> + * @clients: List of hsi_clients using the port.
>>> + * @clock: Lock to serialize access to the clients list.
>>> + */
>>> +struct hsi_port {
>>> +       struct device                   device;
>>> +       struct hsi_config               tx_cfg;
>>> +       struct hsi_config               rx_cfg;
>>> +       unsigned int                    num;
>>> +       unsigned int                    shared:1;
>>> +       int                             claimed;
>>> +       struct mutex                    lock;
>>> +       int                             (*async)(struct hsi_msg *msg);
>>> +       int                             (*setup)(struct hsi_client *cl);
>>
>> A synchronous call makes problems using a HSI-USB dongle like the
>> Asamalab with its delayed transaction over USB.  
> 
> I expect hsi_setup to be called in process context, therefore being able
> to block. So in that case, the driver can wait for the transaction to
> succeed before returning. Maybe some extra comments, about which
> interfaces must be called in process context, are needed.
That would make at least baudrate changes controlled by a link layer
driver code difficult.  Please keep in mind that we might have something
like a selective suspend known form USB in the future here, which
requires more often changing the baudrate to reduce power consumption.

> 
>> Please add an
>> completion callback here.
>>
>>> +       int                             (*flush)(struct hsi_client *cl);
>>
>> Name "flush" could be unclear, if it is indeed a "port reset".
>>
> 
> I'll give a thought on that.
> 
>>> +       int                             (*start_tx)(struct hsi_client *cl);
>>> +       int                             (*stop_tx)(struct hsi_client *cl);
>>> +       int                             (*release)(struct hsi_client *cl);
>>> +       struct list_head                clients;
>>> +       spinlock_t                      clock;
>>> +};
>>
>> The number of available DMA engines helps a link layer,
>> if (DMA_engines < parallel_channel_endpoint_conections_via_DMA)
>>
> 
> Hmm, the whole idea here is that clients are not bother about DMAs. They
> just sent a request and it is the HW driver which decides what to use
> for the transfer. In the case of not having enough DMA channels
> available, the HW driver can just fall back to PIO transfers (omap_ssi
> does that) or just hold the request in its internal queue/s until DMA
> resources are available.
PIO mode for single frames or short frames would be ok and possibly more
efficient than using DMA.  But how shall both link layer drivers - host
and mode side - prevent one of the HSI Host controller drivers falling
back into PIO mode for long HSI frame bursts, if that controller has
limited resources?  That becomes especially important for the poor HSI
controller, which has to spend all its DMA resources for incoming HSI
frame burst, because the sender does take care here.

> 
>> Something like that filled up from the HCD and given by the registration
>> call:
>> struct hsi_hcd_limits {
>>         unsigned int tx_max_ch_bits;
>>         unsigned int rx_max_ch_bits;
>>         unsigned int tx_min_speed;
>>         unsigned int tx_max_speed;
>>         unsigned int rx_min_speed;
>>         unsigned int rx_max_speed;
>>         unsigned int max_burst_jobs;
>>         unsigned int tx_wakeup_support:1;
>>         unsigned int rx_wakeup_support:1;
>>         unsigned int tx_loopback_support:1;
>> };
>>
>>
>>> +
>>> +#define to_hsi_port(dev) container_of(dev, struct hsi_port, device)
>>> +#define hsi_get_port(cl) to_hsi_port((cl)->device.parent)
>>> +
>>> +void hsi_event(struct hsi_port *port, unsigned int event);
>>> +int hsi_claim_port(struct hsi_client *cl, unsigned int share);
>>> +void hsi_release_port(struct hsi_client *cl);
>>> +
>>> +static inline int hsi_port_claimed(struct hsi_client *cl)
>>> +{
>>> +       return cl->pclaimed;
>>> +}
Would you please explain, which use cases you have in mind for that type
of "HSI port sharing" between HSI client drivers in the documentation?

I would expect you are thinking about some kind of HSI port/link/channel
high-jacking between a vendor specific hsi_client driver and the
hsi_char_driver.

>>> +
>>> +static inline void hsi_port_set_drvdata(struct hsi_port *port, void *data)
>>> +{
>>> +       dev_set_drvdata(&port->device, data);
>>> +}
>>> +
>>> +static inline void *hsi_port_drvdata(struct hsi_port *port)
>>> +{
>>> +       return dev_get_drvdata(&port->device);
>>> +}
>>> +
>>> +/**
>>> + * struct hsi_controller - HSI controller device
>>> + * @device: Driver model representation of the device
>>> + * @id: HSI controller ID
>>> + * @num_ports: Number of ports in the HSI controller
>>> + * @port: Array of HSI ports
>>> + */
>>> +struct hsi_controller {
>>> +       struct device           device;
>>
>> Device is only needed for platform device.  PCIe or USB related
>> controller would have their own device, like in USB-core in the hcd.c
>>
> 
> Hmmm no. It is needed. The device is not tied to the platform bus is
> tied to the HSI bus. In the case of USB , it is expected that
> registration of the HSI controller device is done in the probe()
> function of the usb_driver. This works pretty much the same also for the
> platform bus (see omap_ssi) and others.
Yes, you are right!  I had another approach in mind.

> 
>>> +       int                     id;
>>> +       unsigned int            num_ports;
>>> +       struct hsi_port         *port;
>>> +};
>>> +
>>> +#define to_hsi_controller(dev) container_of(dev, struct hsi_controller, device)
>>> +
>>> +struct hsi_controller *hsi_alloc_controller(unsigned int n_ports, gfp_t flags);
>>> +void hsi_free_controller(struct hsi_controller *hsi);
>>> +int hsi_register_controller(struct hsi_controller *hsi);
>>> +void hsi_unregister_controller(struct hsi_controller *hsi);
>>> +
>>> +static inline void hsi_controller_set_drvdata(struct hsi_controller *hsi,
>>> +                                                               void *data)
>>> +{
>>> +       dev_set_drvdata(&hsi->device, data);
>>> +}
>>> +
>>> +static inline void *hsi_controller_drvdata(struct hsi_controller *hsi)
>>> +{
>>> +       return dev_get_drvdata(&hsi->device);
>>> +}
>>> +
>>> +static inline struct hsi_port *hsi_find_port_num(struct hsi_controller *hsi,
>>> +                                                       unsigned int num)
>>> +{
>>> +       return (num < hsi->num_ports) ? &hsi->port[num] : NULL;
>>> +}
>>> +
>>> +/*
>>> + * API for HSI clients
>>> + */
>>> +int hsi_async(struct hsi_client *cl, struct hsi_msg *msg);
>>> +
>>> +/**
>>> + * hsi_setup - Configure the client's port
>>> + * @cl: Pointer to the HSI client
>>> + *
>>> + * When sharing ports, clients should either relay on a single
>>> + * client setup or have the same setup for all of them.
>>> + *
>>> + * Return -errno on failure, 0 on success
>>> + */
>>> +static inline int hsi_setup(struct hsi_client *cl)
>>> +{
>>> +       if (!hsi_port_claimed(cl))
>>> +               return -EACCES;
>>> +       return  hsi_get_port(cl)->setup(cl);
>>> +}
>>> +
>>> +/**
>>> + * hsi_flush - Flush all pending transactions on the client's port
>>> + * @cl: Pointer to the HSI client
>>> + *
>>> + * This function will destroy all pending hsi_msg in the port and reset
>>> + * the HW port so it is ready to receive and transmit from a clean state.
>>> + *
>>> + * Return -errno on failure, 0 on success
>>> + */
>>> +static inline int hsi_flush(struct hsi_client *cl)
>>> +{
>>> +       if (!hsi_port_claimed(cl))
>>> +               return -EACCES;
>>> +       return hsi_get_port(cl)->flush(cl);
>>> +}
>>
>> Also here "hsi_port_reset" would be more self-explanatory than hsi_flush.
> 
> Well, as I said I will have a look to this, but reset can also be
> understood that you reset the whole port (=> reseting also the
> configuration to the default HW values) and does not what this function
> does. It is just destroying all pending request and flush all the
> internal buffers, leaving the port in a clean state ready to
> send/receive more frames with the same configuration.
> 
>> Regards,
>>
>> Peter
>>
> 
> Br,
> Carlos
Kind Regards,

Peter

