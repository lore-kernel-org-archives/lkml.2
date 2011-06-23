Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755395Ab1FWNNE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 09:13:04 -0400
Received: from smtp.nokia.com ([147.243.1.48]:50542 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752054Ab1FWNNC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 09:13:02 -0400
Subject: Re: [RFC PATCHv5 1/7] HSI: hsi: Introducing HSI framework
From: Carlos Chinea <carlos.chinea@nokia.com>
To: ext Sjur =?ISO-8859-1?Q?Br=E6ndeland?= 
	<sjur.brandeland@stericsson.com>
Cc: sjurbren@gmail.com, linux-omap@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org
In-Reply-To: <1308769914-15440-1-git-send-email-sjur.brandeland@stericsson.com>
References: <1307713124-3946-1-git-send-email-carlos.chinea@nokia.com>
	 <1308769914-15440-1-git-send-email-sjur.brandeland@stericsson.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 23 Jun 2011 16:08:44 +0300
Message-ID: <1308834524.27256.3247.camel@groo>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sjur,

On Wed, 2011-06-22 at 21:11 +0200, ext Sjur Brændeland wrote:
> Hi Carlos,
> 
> Some weeks ago I submitted a CAIF-HSI protocol driver for
> Linux 3.0.1, located in drivers/net/caif in David Miller's net-next-2.6.
> This driver depends on a platform specific "glue-layer".
> It would be nice to adapt to a generic HSI API, so I'm looking forward
> to see a this patch going upstream.
> 
> I have tried to investigate if this API proposal fulfills the
> needs for the CAIF HSI protocol used by the ST-Ericsson modems.
> 
> Please find my review comments below.
> 
> 
> >+/**
> >+ * struct hsi_config - Configuration for RX/TX HSI modules 
> >+ * @mode: Bit transmission mode (STREAM or FRAME)
> >+ * @channels: Number of channels to use [1..16]
> >+ * @speed: Max bit transmission speed (Kbit/s)
> 
> Just for clarity maybe you should say if you meen 1000 bit/s or 1024 bit/s?
> 

I meant kbit/s -> 10^3 bit/s. I will change the capital K.

> >+ * @flow: RX flow type (SYNCHRONIZED or PIPELINE)
> >+ * @arb_mode: Arbitration mode for TX frame (Round robin, priority)
> >+ */
> >+struct hsi_config {
> >+	unsigned int	mode;
> >+	unsigned int	channels;
> >+	unsigned int	speed;
> 
> frame_size: Can we assume 32 bits the only supported frame size,
> or should this be configurable?

Correct me if I am wrong but the HSI spec sets 32 bits frame size into
stone. I know some HW (like OMAP SSI) allows changing the frame size,
but I can not for see why an hsi_client will need a lower frame size. If
a weird client needs this then this information should be pass to the
controller through other means.

> 
> >+	union {
> >+		unsigned int	flow;		/* RX only */
> >+		unsigned int	arb_mode;	/* TX only */
> >+	};
> 
> It would be usefull with the following RX counters:
>                       unsigned int    frame_timeout_counter:16;
>                       unsigned int    tailing_bit_counter:8;
>                       unsigned int    frame_burst_counter:8;
> >+};

IMHO clients do not need to care about this HW specific values. I will
pass this through the controller in some other way (e.g: platform_data)
and use the same values for all the clients.

> ...
> >+
> >+/**
> >+ * struct hsi_board_info - HSI client board info
> >+ * @name: Name for the HSI device
> >+ * @hsi_id: HSI controller id where the client sits
> >+ * @port: Port number in the controller where the client sits
> >+ * @tx_cfg: HSI TX configuration
> >+ * @rx_cfg: HSI RX configuration
> >+ * @platform_data: Platform related data
> >+ * @archdata: Architecture-dependent device data
> >+ */
> >+struct hsi_board_info {
> >+	const char		*name;
> >+	unsigned int		hsi_id;
> >+	unsigned int		port;
> >+	struct hsi_config	tx_cfg;
> >+	struct hsi_config	rx_cfg;
> >+	void			*platform_data;
> >+	struct dev_archdata	*archdata;
> >+};
> 
> What about information about the supported transmission speeds?
> Is it any way to obtain this information, so we can know the legal
> values for speed in hsi_config?

For TX speed sets the max tx speed the HSI should go. The controller
driver will try to get as close as it possible to that value without
going over.

For the RX path it sets min RX speed the HSI should use. The controller
should ensure that it does not drop under that value to avoid breaking
the communication.

All this values need to be and can be known beforehand and are platform
specific.

> 
> Can we really assume that all HW supports linked DMA jobs (scatter list),
> or do we need some information about DMA support in board_info as well?
> 

No we don't assume anything and we do not need DMA support info in the
board_info. The hsi_controller will know. I think Linus Walleij already
make a comment on this ;)

> ...
> >+/**
> >+ * struct hsi_msg - HSI message descriptor
> >+ * @link: Free to use by the current descriptor owner
> >+ * @cl: HSI device client that issues the transfer
> >+ * @sgt: Head of the scatterlist array
> >+ * @context: Client context data associated to the transfer
> >+ * @complete: Transfer completion callback
> >+ * @destructor: Destructor to free resources when flushing
> >+ * @status: Status of the transfer when completed
> 
> I guess you refer to the enum "HSI message status codes".
> I think this would be more readable if you don't use anynomus enums,
> but use enum-name to reference the enum here in the documentation.

Hmm HSI_STATUS_X I think it is quite self explanatory.
> 
> >+ * @actual_len: Actual length of data transfered on completion
> >+ * @channel: Channel were to TX/RX the message
> >+ * @ttype: Transfer type (TX if set, RX otherwise)
> >+ * @break_frame: if true HSI will send/receive a break frame. Data buffers are
> >+ *		ignored in the request.
> >+ */
> >+struct hsi_msg {
> >+	struct list_head	link;
> >+	struct hsi_client	*cl;
> >+	struct sg_table		sgt;
> >+	void			*context;
> >+
> >+	void			(*complete)(struct hsi_msg *msg);
> >+	void			(*destructor)(struct hsi_msg *msg);
> >+
> >+	int			status;
> >+	unsigned int		actual_len;
> 
> size_t ?

Yeah maybe better, but I follow here the scatterlist API (see length and
dma_length) and I'll continue using unsigned int as long as the
scatterlist API uses it.

> 
> >+	unsigned int		channel;
> >+	unsigned int		ttype:1;
> >+	unsigned int		break_frame:1;
> >+};
> ...
> >+/*
> >+ * API for HSI clients
> >+ */
> >+int hsi_async(struct hsi_client *cl, struct hsi_msg *msg);
> >+
> >+/**
> 
> I'm pleased to see scatter list support. But is this supported by all HW?
> What is the behavior if HW doesn't support this, will hsi_async fail, or
> is the scatter-list handled 'under the hood'?

Linus Walleij already explained quite well ;)

> 
> Q: Can multiple Read operations be queued?

Yes

> Will multiple read queued operations result in chained DMA operations, or single read operations?
> 

Well, it is up to you, but my initial idea is that the complete callback
is called right after the request has been fulfilled. This may be not
possible if you chain several read requests.

> ...
> >+/**
> >+ * hsi_flush - Flush all pending transactions on the client's port
> >+ * @cl: Pointer to the HSI client
> >+ *
> >+ * This function will destroy all pending hsi_msg in the port and reset
> >+ * the HW port so it is ready to receive and transmit from a clean state.
> >+ *
> >+ * Return -errno on failure, 0 on success
> >+ */
> >+static inline int hsi_flush(struct hsi_client *cl)
> >+{
> >+	if (!hsi_port_claimed(cl))
> >+		return -EACCES;
> >+	return hsi_get_port(cl)->flush(cl);
> >+}
> 
> For CAIF we need to have independent RX and TX flush operations.
> 

The current framework assumes that in the unlikely case of an error or
whenever you need to to do some cleanup, you will end up cleaning up the
two sides anyway. Moreover, you will reset the state of the HW also. 

Exactly, in which case CAIF will only need to cleanup the TX path but
not the RX or vice versa ?

> Flushing the TX FIFO can be long duration operation due to HSI flow control,
> if counterpart is not receiving data. I would prefer to see a callback here.
> 

No, flush should not wait for an ongoing TX transfer to finish. You
should stop all ongoing transfers, call the destructor callback on all
the requests (queued and ongoing) and clean up the HW state.

> ...
> 
> >+/**
> >+ * hsi_start_tx - Signal the port that the client wants to start a TX
> >+ * @cl: Pointer to the HSI client
> >+ *
> >+ * Return -errno on failure, 0 on success
> >+ */
> >+static inline int hsi_start_tx(struct hsi_client *cl)
> >+{
> >+	if (!hsi_port_claimed(cl))
> >+		return -EACCES;
> >+	return hsi_get_port(cl)->start_tx(cl);
> >+}
> >+
> >+/**
> >+ * hsi_stop_tx - Signal the port that the client no longer wants to transmit
> >+ * @cl: Pointer to the HSI client
> >+ *
> >+ * Return -errno on failure, 0 on success
> >+ */
> >+static inline int hsi_stop_tx(struct hsi_client *cl)
> >+{
> >+	if (!hsi_port_claimed(cl))
> >+		return -EACCES;
> >+	return hsi_get_port(cl)->stop_tx(cl);
> >+}
> 
> What exactly do hsi_start_tx and hsi_stop_tx functions do?
> Do they set ACWAKE_UP and ACWAKE_DOWN lines high?
> 

Yes.

> *Missing function*: hsi_reset()
> I would also like to see a hsi_reset function.

This is currently done also in the hsi_flush. See my previous comment.

> 
> In modem-restart scenarios or when coming up from low power state we need the ability
> to perform SW reset in order to discard any garbage received in these states.
> We also have the need to force the lines DATA and FLAG (and READY) low,
> this could be done by the hsi_reset function as well.
> It would be nice to have a callback function to be called upon completion as well.
> 

Coming up from low power state should be handled by the hsi_controller
and the hsi_client should not be concerned about this. I think also the
workaround of setting the DATA and FLAG lines low can be implemented
just in the hsi_controller without hsi_client intervention. 

> *Missing function*: hsi_rx_fifo_occupancy()
> Before putting the link asleep we need to know if the fifo is empty or not.
> So we would like to have a way to read out the number of bytes in the RX fifo.
> 

This should be handled only by hsi_controller. Clients should not care
about this.

> Regards,
> Sjur
> 

Br,

Carlos Chinea <carlos.chinea@nokia.com>

