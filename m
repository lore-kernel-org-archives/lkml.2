Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754748Ab0IMSsD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 14:48:03 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:43910 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752433Ab0IMSsA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 14:48:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=GLNn0UXxazrQgl/x3fyopXeMiAK9byhkicfxuY/5Y3ZSxo8N9YehQ+xwFMUDbvfWsD
         xhuSvTxfRXVrvV+PmaIkcmWslkm4mgD21Ra6ri5/VlKDZ9joU+LCeZARUk6B+W2AwAan
         myTSI2ntd2ZKsSN+6WUvJtmeuoGHEsh2qd+7Y=
MIME-Version: 1.0
In-Reply-To: <4C8E1773.9090000@dsn.okisemi.com>
References: <4C8E1773.9090000@dsn.okisemi.com>
Date: Mon, 13 Sep 2010 21:47:59 +0300
Message-ID: <AANLkTikLLmH-L_KZ8YOBgw6gxCpxPqSxr43pZF1Y8_-x@mail.gmail.com>
Subject: Re: [MeeGo-Dev][PATCH v2] Topcliff: Update PCH_CAN driver to 2.6.35
From: Daniel Baluta <daniel.baluta@gmail.com>
To: Masayuki Ohtak <masa-korg@dsn.okisemi.com>
Cc: Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Christian Pellegrin <chripell@fsfe.org>,
        Barry Song <21cnbao@gmail.com>, Samuel Ortiz <sameo@linux.intel.com>,
        socketcan-core@lists.berlios.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, meego-dev@meego.com,
        "Andrew\"" <andrew.chih.howe.khor@intel.com>,
        "Wang Qi\"" <qi.wang@intel.com>, gregkh@suse.de,
        "Wang Yong Y\"" <yong.y.wang@intel.com>,
        Tomoya MORINAGA <morinaga526@dsn.okisemi.com>, arjan@linux.intel.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 13, 2010 at 3:22 PM, Masayuki Ohtak
<masa-korg@dsn.okisemi.com> wrote:
> CAN driver of Topcliff PCH
>
> Topcliff PCH is the platform controller hub that is going to be used in
> Intel's upcoming general embedded platform. All IO peripherals in
> Topcliff PCH are actually devices sitting on AMBA bus.
> Topcliff PCH has CAN I/F. This driver enables CAN function.
>
> Signed-off-by: Masayuki Ohtake <masa-korg@dsn.okisemi.com>
> +#define MAX_CAN_DEVICES              1
Where is this used?

> +#define MAX_BITRATE            0x3e8
> +#define NUM_NODES              2000    /* Maximum number of
> +                                                Software FIFO nodes. */
I think you don't need NUM_NODES.
> +/**
> + * struct pch_can_msg - CAN message structure
> + * @ide:       Standard/extended msg
> + * @id:                11 or 29 bit msg id
> + * @dlc:       Size of data
> + * @data:      Message pay load
> + * @rtr:       RTR message
> + */
> +struct pch_can_msg {
> +       unsigned short ide;
> +       unsigned int id;
> +       unsigned short dlc;
> +       unsigned char data[PCH_CAN_MSG_DATA_LEN];
> +       unsigned short rtr;
> +};

I think you should use can_frame, and try to get rid of pch_can hardware
abstraction.


> +struct can_hw {
> +       void __iomem *io_base;
> +};

Why do you need can_hw?

> +static int pch_can_get_rx_enable(struct can_hw *can, u32 buff_num, u32 *enable,
> +                                struct net_device *ndev)
Here ndev is used only for debugging purposes. It doesn't seem a natural
approach.

> +static irqreturn_t pch_can_handler(int irq, void *dev_id)
> +{
> +       irqreturn_t retval = IRQ_NONE;
> +       u32 int_stat;
> +       struct pch_can_os *can_os;
> +       struct net_device *ndev = (struct net_device *)dev_id;
> +       struct pch_can_priv *priv = netdev_priv(ndev);
> +       dev_dbg(&can_os->ndev->dev, "%s -> Invoked.\n", __func__);
> +
> +       can_os = &priv->pch_can_os_p;
> +       int_stat = pch_can_int_pending(can_os->can);

Where are the interrupt status bit(s) cleared?

> +       dev_dbg(&can_os->ndev->dev,
> +         "%s -> pch_can_int_pending returned value: %x\n", __func__, int_stat);
> +

As someone stated before I think you are trying to port an
old fashion CAN character device based driver.

Although, having the old source code, should be helpful
I think you should read the existing CAN drivers (drivers/net/can)
and start from scratch trying to follow the ideas implemented there.

I also have a character driver very similar with yours
(ICP CAN for EP80579) and I struggle for some time
to get a working version with Socket CAN interface.

I don't have any 'official' position towards Linux Socket CAN
so please consider my comments as being advisory.

thanks,
Daniel.
