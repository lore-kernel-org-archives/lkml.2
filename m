Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754185Ab0KCKEu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 06:04:50 -0400
Received: from smtp.nokia.com ([192.100.122.233]:46991 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753736Ab0KCKEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 06:04:46 -0400
Subject: Re: [RFC PATCHv3 1/7] HSI: Introducing HSI framework
From: Carlos Chinea <carlos.chinea@nokia.com>
To: ext Peter Henn <peter_henn@gmx.de>
Cc: Linux Kernel Development <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
In-Reply-To: <4CC2D80E.1050807@gmx.de>
References: <5BC1940B997A254A9C54B26A6B7E50C807A1810400@mucse403.eu.infineon.com>
	 <4CBB1D13.3000709@gmx.de> <1287399186.6570.1044.camel@localhost>
	 <4CC2D80E.1050807@gmx.de>
Content-Type: text/plain
Date: Wed, 03 Nov 2010 12:05:26 +0200
Message-Id: <1288778726.6578.4582.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Nov 2010 10:04:33.0384 (UTC) FILETIME=[8374A680:01CB7B3E]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

my reply under

On Sat, 2010-10-23 at 14:41 +0200, ext Peter Henn wrote: 
> Hello Carlos,
> please find my comments inline
> 
> Am 18.10.2010 12:53, schrieb Carlos Chinea:
> > Hi Peter,
> >
> >>> +/**
> >>> + * struct hsi_config - Configuration for RX/TX HSI modules
> >>> + * @mode: Bit transmission mode (STREAM or FRAME)
> >>> + * @flow: Flow type (SYNCHRONIZED or PIPELINE)
> >>> + * @channels: Number of channels to use [1..16]
> >>> + * @speed: Max bit transmission speed (Kbit/s)
> >>> + * @arb_mode: Arbitration mode for TX frame (Round robin, priority)
> >>> + */
> >>> +struct hsi_config {
> >>> +       unsigned int    mode;
> >>> +       unsigned int    flow;
> >>> +       unsigned int    channels;
> >>> +       unsigned int    speed;
> >>> +       unsigned int    arb_mode; /* TX only */
> >>> +};
> >>> +
> >>
> >> Enums for "mode" and "flow"!
> >> Does the flow control be really a TX link property?
> >
> > Hmm, yep it does not. I'll fix that.
> >
> >> In RX direction a speed range helps changing the baudrate on the fly.
> >
> > Clients just tell which is the TX max bit rate allowed.
> > In the case of TX the HW driver is allowed to change the speed from the maximum to the HW minimum.
> yes
> 
> > In the case of RX the HW driver has to be able to handle that TX speed from the transmitter.
> The RX speed shall setup the following things:
> - the maximum system clock need to ensure proper data receiving. That
>   effects not even the receiver, which mostly reconstruct the RX clock
>   from data and flag, but all the other data management hardware behind.

You got me confuse here. It is my understanding that an RX clock is
indeed needed to poll the state of the FLAG/DATA lines for changes in
their levels. Maybe your HW is event driven, but the one I have access
to is not.

>   Too high values would prevent power saving here.

Well and that's actually the final point of this. With this value we can
prevent DVFS to set a too slow RX clock freq that will break HSI/SSI
communication.

And one of the reasons why speed is in the client configuration is that
I am expecting that DVFS support will be handled in the clients, as some
kind of handshaking will be needed with the other end.

> - the minimum value shall be used to setup the frame timeout and
>   message timeout counter inside the HSI controller hardware
> 

My current position on the RX timeout is that hsi clients do not need to
be bother about it. It is something that can be for example enabled by
default or configure through other means in the HW driver.
Even if the timeout is disabled by default, I will expect clients to
catch those kind of problems with their own protocol timers.


> >
> >> A configuration flag for wakeup is missing, which defines the wakeup
> >> either GPIO or Ready line controlled.
> >
> > This is just tied to the HW controller, it is internal data that can be
> > passed to HW driver through other ways.
> Yes, it is a host controller setting. Could you add this to the
> framework, which acts here as an API?
> 

No the clients do not know anything about the specifics of  the
underneath HW, like the use of GPIO wake lines. You get that info
through for example the platform resource data, along with irq numbers,
I/O memory areas, etc.

> > Clients can only set HW configuration values that affects directly their
> > protocol behavior.
> >
> >> A maximum RX frame burst counter value for each channel is missing.
> >
> > Again tied to the HW driver.
> Yepp, the same as above.
> 
> 
> >> A TX send priority for each channel is possibly missing, too.
> >>
> >
> > Do you have a HW implementing that kind of feature ? And also does
> > any protocol make direct use of that feature, meaning it changes the
> > behavior of the protocol ?
> >
> > If the answers are yes, I am willing to add support for that, otherwise
> > I will wait until someone really needs it. Please note the current
> > ARB_PRIO value means that channel 0 has the highest priority and
> > MAX_CHANNEL the lowest.
> I know at least two HSI chip vendors, which has a more complex
> arbitration and priority mechanism than only preferring channel 0 or
> round robin. You may drop me a separate email, if you are interested to
> known details. Just reserving a byte for each channel would work here to
> represent such a special priority behavior.
> 

Ok, but still I want to know: does any protocol make use of that
feature ? Otherwise, this can be added later on when needed.

> >
> >> TX and RX initial port properties AKA config could be combined e.g.:
> >
> > It is a matter of taste, and with the tx flow change the memory
> > footprint will be the same.
> Yepp, and I guess normally both hsi_config structures for tx and rx
> setup will be handled mostly close together or not?

So... Sometimes you may just want to change the configuration of one of
the modules. But this is beside the point. What you are proposing is a
cosmetic change for the sake of it, unless that this is enforce by the
kernel coding style, or there is any technical impact I will not change
this.

Of course I will still fix the flow field issue.

> 
> >
> >> struct hsi_port_properties {
> >>         __u16 tx_ch_count;      /* required number of TX channels */
> >>         __u16 rx_ch_count;      /* required number of RX channels */
> >>         __u32 tx_speed;         /* TX speed in HZ */
> >>         __u32 rx_min_speed;     /* RX min. speed in HZ */
> >>         __u32 rx_max_speed;     /* RX max. speed in HZ */
> >>         enum hsi_transfer_mode tx_transfer_mode;
> >>         enum hsi_transfer_mode rx_transfer_mode;
> >>         enum hsi_flow_ctrl_mode flow_ctrl_mode; /* only need for RX */
> >>         enum hsi_arb_mode arb_mode;             /* only need for TX */
> >>         bool tx_wakeup_mode;    /* true: wakeup line ... */
> >>         bool rx_wakeup_mode;    /* ... false: ready line */
> >> };
> >>
> >> Example for channel:
> >> struct hsi_channel_properties {
> >>         ...
> >>         unsigned char prio;             /* only need for TX */
> >>         unsigned short frame_burst;     /* only need for RX */
> >> }
> >>
> >>> +/**
> >>> + * struct hsi_board_info - HSI client board info
> >>> + * @name: Name for the HSI device
> >>> + * @hsi_id: HSI controller id where the client sits
> >>> + * @port: Port number in the controller where the client sits
> >>> + * @tx_cfg: HSI TX configuration
> >>> + * @rx_cfg: HSI RX configuration
> >>> + * @platform_data: Platform related data
> >>> + * @archdata: Architecture-dependent device data
> >>> + */
> >>> +struct hsi_board_info {
> >>> +       const char              *name;
> >>> +       int                     hsi_id;
> >>> +       unsigned int            port;
> >>> +       struct hsi_config       tx_cfg;
> >>> +       struct hsi_config       rx_cfg;
> >>> +       void                    *platform_data;
> >>> +       struct dev_archdata     *archdata;
> >>> +};
> >>> +
> >>> +#ifdef CONFIG_HSI
> >>> +extern int hsi_register_board_info(struct hsi_board_info const *info,
> >>> +                                                       unsigned int len);
> >>> +#else
> >>> +static inline int hsi_register_board_info(struct hsi_board_info const *info,
> >>> +                                                       unsigned int len)
> >>> +{
> >>> +       return 0;
> >>> +}
> >>> +#endif
> >>> +
> >>> +/**
> >>> + * struct hsi_client - HSI client attached to an HSI port
> >>> + * @device: Driver model representation of the device
> >>> + * @tx_cfg: HSI TX configuration
> >>> + * @rx_cfg: HSI RX configuration
> >>> + * @hsi_start_rx: Called after incoming wake line goes high
> >>> + * @hsi_stop_rx: Called after incoming wake line goes low
> >>> + */
> >>> +struct hsi_client {
> >>> +       struct device           device;
> >>> +       struct hsi_config       tx_cfg;
> >>> +       struct hsi_config       rx_cfg;
> >>> +       void                    (*hsi_start_rx)(struct hsi_client *cl);
> >>> +       void                    (*hsi_stop_rx)(struct hsi_client *cl);
> >>> +       /* private: */
> >>> +       unsigned int            pclaimed:1;
> >>> +       struct list_head        link;
> >>> +};
> >>> +
> >>> +#define to_hsi_client(dev) container_of(dev, struct hsi_client, device)
> >>> +
> >>> +static inline void hsi_client_set_drvdata(struct hsi_client *cl, void *data)
> >>> +{
> >>> +       dev_set_drvdata(&cl->device, data);
> >>> +}
> >>> +
> >>> +static inline void *hsi_client_drvdata(struct hsi_client *cl)
> >>> +{
> >>> +       return dev_get_drvdata(&cl->device);
> >>> +}
> >>> +
> >>> +/**
> >>> + * struct hsi_client_driver - Driver associated to an HSI client
> >>> + * @driver: Driver model representation of the driver
> >>> + */
> >>> +struct hsi_client_driver {
> >>> +       struct device_driver    driver;
> >>> +};
> >>
> >> Either using here direct "struct device_driver" or supporting an own
> >> hsi_probe, hsi_remove called from the framework, example:
> >>
> >> struct hsi_client_driver {
> >>         const char *name;
> >>         int (*probe) (struct hsi_client *);
> >>         void (*disconnect) (struct hsi_client *);
> >>         int (*suspend) (struct hsi_client *, pm_message_t);
> >>         int (*resume) (struct hsi_client *);
> >>         int (*event) (struct hsi_client *, u32 hsi_event);
> >>
> >>         struct device_driver driver;
> >> };
> >
> > Hmm, I will keep it as it is. No need to have currently custom probe()/
> > remove(). They will just be a wrap up. Having the device_driver wrap
> > like this forces the clients to register using
> Yes, SPI uses these simple wrappers.

And ? IMO they should get rid off them.

> 
> > hsi_register_client_driver instead of allowing them to use also the
> > device_register() directly which will be wrong as they will not be tied
> > to the HSI bus.
> So the hsi_client will also in future plans direct related to the Linux
> Device Core.  And there is no plan for some client specific
> configuration support by that framework as a general code part?
> 
> However, that becomes anyway difficult using the HSI-port sharing
> mechanism for different vendor specific HSI client drivers.


No I think you got this wrong. hsi_clients in general implement
protocols no HW drivers. hsi_controllers implement the HW drivers.
Port sharing is just there to handle the situation where there are two
or more protocols using the same port at the same time, which is the
case of N900 where APE communicates through SSI with the CMT DSP and the
CMT MPU at the same time.

-- snip -- 
> >>
> >> Either HSI transfer data or that break "1 bit message".
> >>
> >
> > And that's how it works. The omap_ssi driver works exactly like that.
> > Maybe some extra documentation explaining this is needed.
> >
> Yes, if sgt _and_ break_frame bit is defined, what shall the HSI
> controller do:
> - send/have received 1st the message, than the break frame
> - send/have received 1st the break frame, then the message
> - send/have received only the break frame
> 

Option 3: send/receive only the break frame.

> >> Normally a break affects all HSI channels of a HSI link and is planned
> >> to be used as an error indication of the HSI link.  It could be a
> >> special HSI port initialization/reset/flush or setup property.
> >>
> >
> > Yes but yet again the client wants to send/receive a frame. It is just
> > that turns to be a special one that only the HW can generate.
> > So I prefer to keep that on the HSI sending/receiving API.
> >
> >>
> >>> +
> >>> +struct hsi_msg *hsi_alloc_msg(unsigned int n_frag, gfp_t flags);
> >>> +void hsi_free_msg(struct hsi_msg *msg);
> >>> +
> >>> +/**
> >>> + * struct hsi_port - HSI port device
> >>> + * @device: Driver model representation of the device
> >>> + * @tx_cfg: Current TX path configuration
> >>> + * @rx_cfg: Current RX path configuration
> >>> + * @num: Port number
> >>> + * @shared: Set when port can be shared by different clients
> >>> + * @claimed: Reference count of clients which claimed the port
> >>> + * @lock: Serialize port claim
> >>> + * @async: Asynchronous transfer callback
> >>> + * @setup: Callback to set the HSI client configuration
> >>> + * @flush: Callback to clean the HW state and destroy all pending transfers
> >>> + * @start_tx: Callback to inform that a client wants to TX data
> >>> + * @stop_tx: Callback to inform that a client no longer wishes to TX data
> >>> + * @release: Callback to inform that a client no longer uses the port
> >>> + * @clients: List of hsi_clients using the port.
> >>> + * @clock: Lock to serialize access to the clients list.
> >>> + */
> >>> +struct hsi_port {
> >>> +       struct device                   device;
> >>> +       struct hsi_config               tx_cfg;
> >>> +       struct hsi_config               rx_cfg;
> >>> +       unsigned int                    num;
> >>> +       unsigned int                    shared:1;
> >>> +       int                             claimed;
> >>> +       struct mutex                    lock;
> >>> +       int                             (*async)(struct hsi_msg *msg);
> >>> +       int                             (*setup)(struct hsi_client *cl);
> >>
> >> A synchronous call makes problems using a HSI-USB dongle like the
> >> Asamalab with its delayed transaction over USB.
> >
> > I expect hsi_setup to be called in process context, therefore being able
> > to block. So in that case, the driver can wait for the transaction to
> > succeed before returning. Maybe some extra comments, about which
> > interfaces must be called in process context, are needed.
> That would make at least baudrate changes controlled by a link layer
> driver code difficult.  Please keep in mind that we might have something
> like a selective suspend known form USB in the future here, which
> requires more often changing the baudrate to reduce power consumption.
> 

Did you mean that HSI block will be switch off if not in use ?

It is the duty of HW driver to save the state before the block is switch
off. In fact, that is what the omap_ssi driver does. HSI clients do not
care about if the HW supports off-mode or not.

If you wanted to say that there will need for DVFS support then you have
two options:

- This can be handled completed by the HW and its driver and therefore
there is no need of hsi_setup. Something quite hard to achive with the
current specs IMO.

- This needs the help of a protocol (ex: telling the other end to stop
sending and switch to a different TX speed, change the clock freq, and
then tell him to restart communication) which will imply that you will
need to block anyway to wait for acks and responses.


> >
> >> Please add an
> >> completion callback here.
> >>
> >>> +       int                             (*flush)(struct hsi_client *cl);
> >>
> >> Name "flush" could be unclear, if it is indeed a "port reset".
> >>
> >
> > I'll give a thought on that.
> >
> >>> +       int                             (*start_tx)(struct hsi_client *cl);
> >>> +       int                             (*stop_tx)(struct hsi_client *cl);
> >>> +       int                             (*release)(struct hsi_client *cl);
> >>> +       struct list_head                clients;
> >>> +       spinlock_t                      clock;
> >>> +};
> >>
> >> The number of available DMA engines helps a link layer,
> >> if (DMA_engines < parallel_channel_endpoint_conections_via_DMA)
> >>
> >
> > Hmm, the whole idea here is that clients are not bother about DMAs. They
> > just sent a request and it is the HW driver which decides what to use
> > for the transfer. In the case of not having enough DMA channels
> > available, the HW driver can just fall back to PIO transfers (omap_ssi
> > does that) or just hold the request in its internal queue/s until DMA
> > resources are available.
> PIO mode for single frames or short frames would be ok and possibly more
> efficient than using DMA.  But how shall both link layer drivers - host
> and mode side - prevent one of the HSI Host controller drivers falling
> back into PIO mode for long HSI frame bursts, if that controller has
> limited resources?  

Well, it is the controllers decision to fallback or to queue. It is the
same for any resources managed by the driver, it is implementation
specific for that controllers driver what to do in case it runs out of
resources. Clients should not care if a DMA is used or not for
transmission/reception.

> That becomes especially important for the poor HSI
> controller, which has to spend all its DMA resources for incoming HSI
> frame burst, because the sender does take care here.
> 

Why does the sender care if the receiver uses a DMA or not ? 

> >
> >> Something like that filled up from the HCD and given by the registration
> >> call:
> >> struct hsi_hcd_limits {
> >>         unsigned int tx_max_ch_bits;
> >>         unsigned int rx_max_ch_bits;
> >>         unsigned int tx_min_speed;
> >>         unsigned int tx_max_speed;
> >>         unsigned int rx_min_speed;
> >>         unsigned int rx_max_speed;
> >>         unsigned int max_burst_jobs;
> >>         unsigned int tx_wakeup_support:1;
> >>         unsigned int rx_wakeup_support:1;
> >>         unsigned int tx_loopback_support:1;
> >> };
> >>
> >>
> >>> +
> >>> +#define to_hsi_port(dev) container_of(dev, struct hsi_port, device)
> >>> +#define hsi_get_port(cl) to_hsi_port((cl)->device.parent)
> >>> +
> >>> +void hsi_event(struct hsi_port *port, unsigned int event);
> >>> +int hsi_claim_port(struct hsi_client *cl, unsigned int share);
> >>> +void hsi_release_port(struct hsi_client *cl);
> >>> +
> >>> +static inline int hsi_port_claimed(struct hsi_client *cl)
> >>> +{
> >>> +       return cl->pclaimed;
> >>> +}
> Would you please explain, which use cases you have in mind for that type
> of "HSI port sharing" between HSI client drivers in the documentation?
> 
> I would expect you are thinking about some kind of HSI port/link/channel
> high-jacking between a vendor specific hsi_client driver and the
> hsi_char_driver.

See above my comment about port sharing in N900 case.

Br,
Carlos
-- 
Carlos Chinea <carlos.chinea@nokia.com>

