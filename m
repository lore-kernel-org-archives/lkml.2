Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752557Ab1GXV4n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jul 2011 17:56:43 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61843 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752398Ab1GXV4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jul 2011 17:56:40 -0400
MIME-Version: 1.0
In-Reply-To: <20110722120553.GZ32058@legolas.emea.dhcp.ti.com>
References: <1307713124-3946-1-git-send-email-carlos.chinea@nokia.com>
	<1308769914-15440-1-git-send-email-sjur.brandeland@stericsson.com>
	<1308834524.27256.3247.camel@groo>
	<81C3A93C17462B4BBD7E272753C105791A64C2735E@EXDCVYMBSTM005.EQ1STM.local>
	<1311331416.32639.34.camel@groo>
	<20110722110102.GR32058@legolas.emea.dhcp.ti.com>
	<1311335472.32639.75.camel@groo>
	<20110722120553.GZ32058@legolas.emea.dhcp.ti.com>
Date: Sun, 24 Jul 2011 23:56:39 +0200
Message-ID: <CAJK669bOjK38J3f5=UCXGLSkaB4aJ-jS4jqvp5gGfE2czH8OAQ@mail.gmail.com>
Subject: Re: [RFC PATCHv5 1/7] HSI: hsi: Introducing HSI framework
From: =?UTF-8?Q?Sjur_Br=C3=A6ndeland?= <sjurbren@gmail.com>
To: balbi@ti.com, Carlos Chinea <carlos.chinea@nokia.com>
Cc: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dmitry.tarnyagin@stericsson.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Carlos,

>Sorry for the long delay. My comments below:
No worries, I will probably be very slow when responding to you as
well for the next
couple of weeks...

>+ * @flow: RX flow type (SYNCHRONIZED or PIPELINE)
>+ * @arb_mode: Arbitration mode for TX frame (Round robin, priority)
>+ */
>+struct hsi_config {
>+	unsigned int	mode;
>+	unsigned int	channels;
>+	unsigned int	speed;

I have to pick up on one issue I missed earlier. The CAIF-HSI protocol
is going to use
separate RX and TX speeds, where modem and host side looks at the
throughput and
TX-queues and request their TX speeds accordingly. So I would prefer
to be able to set
the RX and TX speed in each direction individually.

...
>>>... Why don't you
>>> just remove the sync API altogether and use only async, then the OMAP
>>> HSI controller driver is supposed to know when it can go to sleep. If
>>> you receive some data before a client queues a request, you just defer
>>> processing of that data until a new request is queued, or something...
>>
>> Hmmm, Do you mean I remove the hsi_start_tx() and hsi_stop_tx()
>> completely ? Or Do I just create an async version of them ?
>
> I would say remove completely and add async-only version.

Yes, this is probably the best way, but I'm not too concerned how this is done,
as long as the API provides some way to assure that the TX FIFO is empty
before putting the WAKE line low.


> > > > > *Missing function*: hsi_rx_fifo_occupancy()
> > > > > Before putting the link asleep we need to know if the fifo is empty
> > > > > or not.
> > > > > So we would like to have a way to read out the number of bytes in the
> > > > > RX fifo.
> > > >
> > > > This should be handled only by hsi_controller. Clients should not care
> > > > about this.
> > >
> > > There is a corner case when going to low power mode and both side has put the WAKE line low,
> > > but a RX DMA job is ongoing or the RX-fifo is not empty.
> > > In this case the host side must wait for the DMA job to complete and RX-
> > > fifo to be empty, before canceling any pending RX jobs.
> > >
> > > One option would be to provide a function hsi_rx_sync() that guarantees that any ongoing
> > > RX-job is completed and that the RX FIFO is empty. Another option could be to be
> > > able to provide API for reading RX-job states and RX-fifo occupancy.
> > >
> >
> > I think we don't need another function to do this neither. The
> > hsi_controller driver should implement a usecount scheme to know when
> > the HW can be switch off. IMO it is not a good idea to relay just on the
> > wakelines to power on/off the device, exactly because of this kind of
> > issues.

For the RX FIFO maybe you are right that the controller can handle the
power down issues
on it's own. However I'm uneasy about not having the possibility to
read out the RX
FIFO-occupancy from the HSI-controller. In the CAIF HSI implementation
queued for the 3.1
kernel (git.kernel.org/?p=linux/kernel/git/davem/net.git;a=blob;f=drivers/net/caif/caif_hsi.c
)
we use this both in probe() and when wakeline go low.
There may also be other corner-cases related to wakeline handling or
speed change,
where we need this in the future. So from my point of view think we
still need to be able read
out the RX FIFO occupancy.

Regards,
Sjur
