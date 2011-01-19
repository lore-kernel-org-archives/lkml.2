Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753867Ab1ASJkb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 04:40:31 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63249 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753519Ab1ASJk3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 04:40:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=FA7k4dVnJBIafziMAcJmHNIeND7rZki5gFWBoTxAd7eoHETr757yBOl3779lvagFn1
         QqpruDKhFTDJX32STx7i9D59Z0D8am3598mZWFlaZbOeD/BZSQYdC0oNiWA1UKTO3NWW
         EnsgbOyB0DSPgzKsaAe8niBnj+IInmN2gtLwM=
MIME-Version: 1.0
In-Reply-To: <1295284788.21277.65.camel@Joe-Laptop>
References: <1294919372-1904-1-git-send-email-ratbert.chuang@gmail.com>
 <1295256060-2091-1-git-send-email-ratbert.chuang@gmail.com> <1295284788.21277.65.camel@Joe-Laptop>
From: Po-Yu Chuang <ratbert.chuang@gmail.com>
Date: Wed, 19 Jan 2011 17:40:07 +0800
Message-ID: <AANLkTi=nJxwR89CF3i0+L6+yM4Bg_PN8PQByTAHP2nPM@mail.gmail.com>
Subject: Re: [PATCH v2] net: add Faraday FTMAC100 10/100 Ethernet driver
To: Joe Perches <joe@perches.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ratbert@faraday-tech.com, bhutchings@solarflare.com,
        eric.dumazet@gmail.com, dilinger@queued.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Joe,

On Tue, Jan 18, 2011 at 1:19 AM, Joe Perches <joe@perches.com> wrote:
> On Mon, 2011-01-17 at 17:21 +0800, Po-Yu Chuang wrote:
>
>> + * priveate data
>
> private

Fixed.

>> +static void ftmac100_enable_all_int(struct ftmac100 *priv)
>> +{
>> +     unsigned int imr;
>> +
>> +     imr = FTMAC100_INT_RPKT_FINISH | FTMAC100_INT_NORXBUF
>> +          | FTMAC100_INT_XPKT_OK | FTMAC100_INT_XPKT_LOST
>> +          | FTMAC100_INT_RPKT_LOST | FTMAC100_INT_AHB_ERR
>> +          | FTMAC100_INT_PHYSTS_CHG;
>
> This could be a #define.

OK, done.

>> +     maccr = FTMAC100_MACCR_XMT_EN |
>> +             FTMAC100_MACCR_RCV_EN |
>> +             FTMAC100_MACCR_XDMA_EN |
>> +             FTMAC100_MACCR_RDMA_EN |
>> +             FTMAC100_MACCR_CRC_APD |
>> +             FTMAC100_MACCR_FULLDUP |
>> +             FTMAC100_MACCR_RX_RUNT |
>> +             FTMAC100_MACCR_RX_BROADPKT;
>
> Here too.

OK, done.

>> +static int ftmac100_rx_packet_error(struct ftmac100 *priv,
>> +             struct ftmac100_rxdes *rxdes)
> []
>> +     if (unlikely(ftmac100_rxdes_frame_too_long(rxdes))) {
>> +             if (net_ratelimit())
>> +                     netdev_info(netdev, "rx frame too long\n");
>> +
>> +             netdev->stats.rx_length_errors++;
>> +             error = 1;
>> +     }
>> +
>> +     if (unlikely(ftmac100_rxdes_runt(rxdes))) {
>
> else if ?

OK, fixed.

>> +static int ftmac100_rx_packet(struct ftmac100 *priv, int *processed)
>> +{
>> +     struct net_device *netdev = priv->netdev;
>> +     struct ftmac100_rxdes *rxdes;
>> +     struct sk_buff *skb;
>> +     int length;
>> +     int copied = 0;
>> +     int done = 0;
>
> You could use bool/true/false here for copied and done
> and all the other uses of an int for a logical bool.

OK, fixed.

>> +static void ftmac100_txdes_set_dma_own(struct ftmac100_txdes *txdes)
>> +{
>> +     /*
>> +      * Make sure dma own bit will not be set before any other
>> +      * descriptor fiels.
>
> field/fields

Fixed.

>> +static int ftmac100_mdio_read(struct net_device *netdev, int phy_id, int reg)
>> +{
>> +     struct ftmac100 *priv = netdev_priv(netdev);
>> +     int phycr;
>> +     int i;
>> +
>> +     phycr = FTMAC100_PHYCR_PHYAD(phy_id) |
>> +             FTMAC100_PHYCR_REGAD(reg) |
>> +             FTMAC100_PHYCR_MIIRD;
>> +
>> +     iowrite32(phycr, priv->base + FTMAC100_OFFSET_PHYCR);
>> +     for (i = 0; i < 10; i++) {
>> +             phycr = ioread32(priv->base + FTMAC100_OFFSET_PHYCR);
>> +
>> +             if ((phycr & FTMAC100_PHYCR_MIIRD) == 0)
>> +                     return phycr & FTMAC100_PHYCR_MIIRDATA;
>> +
>> +             usleep_range(100, 1000);
>> +     }
>> +
>> +     netdev_err(netdev, "mdio read timed out\n");
>> +     return 0xffff;
>
> 0xffff is a rather odd return, perhaps a #define?

After a little digging in drivers/net/mii.c, it seems that mii lib does not
check return value if it is error. So I guess I should return 0 if error.

>> +/******************************************************************************
>> + * initialization / finalization
>> + *****************************************************************************/
>> +static int __init ftmac100_init(void)
>> +{
>> +     printk(KERN_INFO "Loading " DRV_NAME ": version " DRV_VERSION " ...\n");
>
> You could use
> #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> before any #include and
>        pr_info("Loading version " DRV_VERSION " ...\n");

OK

> One last comment on split long line indentation style
> and long function declarations.
>
> There's no required style so you can use what you are
> most comfortable doing.
>
> Most of drivers/net uses an alignment to open parenthesis
> using maximal tabs and minimal necessary spaces instead of
> an extra tabstop.
>
> Like:
>
> static int some_long_function(type var1, type var2...
>                              type varN)
> and
>        some_long_function(var1, var2, ...
>                           varN);
>
> not
> static int some_long_function(type var1, type var2...
>                                type varN)
> and
>        some_long_function(var1, var2, ...
>                                varN);

Well, TBH, I don't like this style because if I changed the
function name, the indentation might need to be adjusted.

Even worse, I got an infeasible case :-(

static struct ftmac100_rxdes *ftmac100_rx_locate_first_segment(
							       struct ftmac100 *priv)

I know my function names are quite long, but I like them to be descriptive.
Do you really insist on it?

Thanks,
Po-Yu Chuang
