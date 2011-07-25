Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751374Ab1GYJW0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 05:22:26 -0400
Received: from smtp.nokia.com ([147.243.1.48]:17853 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750886Ab1GYJWU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 05:22:20 -0400
Subject: Re: [RFC PATCHv5 1/7] HSI: hsi: Introducing HSI framework
From: Carlos Chinea <carlos.chinea@nokia.com>
To: ext Sjur =?ISO-8859-1?Q?Br=E6ndeland?= <sjurbren@gmail.com>
Cc: balbi@ti.com, "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dmitry.tarnyagin@stericsson.com
In-Reply-To: <CAJK669bOjK38J3f5=UCXGLSkaB4aJ-jS4jqvp5gGfE2czH8OAQ@mail.gmail.com>
References: <1307713124-3946-1-git-send-email-carlos.chinea@nokia.com>
	 <1308769914-15440-1-git-send-email-sjur.brandeland@stericsson.com>
	 <1308834524.27256.3247.camel@groo>
	 <81C3A93C17462B4BBD7E272753C105791A64C2735E@EXDCVYMBSTM005.EQ1STM.local>
	 <1311331416.32639.34.camel@groo>
	 <20110722110102.GR32058@legolas.emea.dhcp.ti.com>
	 <1311335472.32639.75.camel@groo>
	 <20110722120553.GZ32058@legolas.emea.dhcp.ti.com>
	 <CAJK669bOjK38J3f5=UCXGLSkaB4aJ-jS4jqvp5gGfE2czH8OAQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 25 Jul 2011 12:17:09 +0300
Message-ID: <1311585429.32639.148.camel@groo>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, 2011-07-24 at 23:56 +0200, ext Sjur Brændeland wrote:
> Hi Carlos,
> 
> >Sorry for the long delay. My comments below:
> No worries, I will probably be very slow when responding to you as
> well for the next
> couple of weeks...
> 
> >+ * @flow: RX flow type (SYNCHRONIZED or PIPELINE)
> >+ * @arb_mode: Arbitration mode for TX frame (Round robin, priority)
> >+ */
> >+struct hsi_config {
> >+	unsigned int	mode;
> >+	unsigned int	channels;
> >+	unsigned int	speed;
> 
> I have to pick up on one issue I missed earlier. The CAIF-HSI protocol
> is going to use
> separate RX and TX speeds, where modem and host side looks at the
> throughput and
> TX-queues and request their TX speeds accordingly. So I would prefer
> to be able to set
> the RX and TX speed in each direction individually.
> 

You can already do that ;) RX and TX configuration are different.
/**
 * struct hsi_client - HSI client attached to an HSI port
 * @device: Driver model representation of the device
 * @tx_cfg: HSI TX configuration
 * @rx_cfg: HSI RX configuration
 * @hsi_start_rx: Called after incoming wake line goes high
 * @hsi_stop_rx: Called after incoming wake line goes low
 */
struct hsi_client {
	struct device		device;
	struct hsi_config	tx_cfg;
	struct hsi_config	rx_cfg;
...

> ...
> >>>... Why don't you
> >>> just remove the sync API altogether and use only async, then the OMAP
> >>> HSI controller driver is supposed to know when it can go to sleep. If
> >>> you receive some data before a client queues a request, you just defer
> >>> processing of that data until a new request is queued, or something...
> >>
> >> Hmmm, Do you mean I remove the hsi_start_tx() and hsi_stop_tx()
> >> completely ? Or Do I just create an async version of them ?
> >
> > I would say remove completely and add async-only version.
> 
> Yes, this is probably the best way, but I'm not too concerned how this is done,
> as long as the API provides some way to assure that the TX FIFO is empty
> before putting the WAKE line low.

Ok let's see. We can rephrase this problem as that you want to be
certain that the last TX frame has gone through the wires before doing
something, like bringing the wake line down.

This can be done and should be done in the hsi_controller. It is just a
matter of calling the complete() callback on the right time. Meaning,
that the hsi_controller does not call the complete() callback when the
DMA transfer for TX has completed, but when the last TX frame is already
in the wires. As optimization, you may also do this only when there is
no more TX requests in the hsi_controller driver queue.

> 
> 
> > > > > > *Missing function*: hsi_rx_fifo_occupancy()
> > > > > > Before putting the link asleep we need to know if the fifo is empty
> > > > > > or not.
> > > > > > So we would like to have a way to read out the number of bytes in the
> > > > > > RX fifo.
> > > > >
> > > > > This should be handled only by hsi_controller. Clients should not care
> > > > > about this.
> > > >
> > > > There is a corner case when going to low power mode and both side has put the WAKE line low,
> > > > but a RX DMA job is ongoing or the RX-fifo is not empty.
> > > > In this case the host side must wait for the DMA job to complete and RX-
> > > > fifo to be empty, before canceling any pending RX jobs.
> > > >
> > > > One option would be to provide a function hsi_rx_sync() that guarantees that any ongoing
> > > > RX-job is completed and that the RX FIFO is empty. Another option could be to be
> > > > able to provide API for reading RX-job states and RX-fifo occupancy.
> > > >
> > >
> > > I think we don't need another function to do this neither. The
> > > hsi_controller driver should implement a usecount scheme to know when
> > > the HW can be switch off. IMO it is not a good idea to relay just on the
> > > wakelines to power on/off the device, exactly because of this kind of
> > > issues.
> 
> For the RX FIFO maybe you are right that the controller can handle the
> power down issues
> on it's own. However I'm uneasy about not having the possibility to
> read out the RX
> FIFO-occupancy from the HSI-controller. In the CAIF HSI implementation
> queued for the 3.1
> kernel (git.kernel.org/?p=linux/kernel/git/davem/net.git;a=blob;f=drivers/net/caif/caif_hsi.c
> )
> we use this both in probe() and when wakeline go low.
> There may also be other corner-cases related to wakeline handling or
> speed change,
> where we need this in the future. So from my point of view think we
> still need to be able read
> out the RX FIFO occupancy.

In the case of wakeline handling: 
- The HSI HW block should be kept power on as long as there is some
activity, regardless of the wake line state.

In the case of speed change:
- Could you explain a little bit more which is the problem ?
How can the data already stored in the  RX FIFO be affected by changes
in the RX and/or TX HSI functional clock ?

Br,
-- 
Carlos Chinea <carlos.chinea@nokia.com>

