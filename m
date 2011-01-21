Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750881Ab1AUFDo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 00:03:44 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:47138 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750695Ab1AUFDk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 00:03:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=NF9On9TRVkMLzoWX35L50sC59wBRYEgjFC5kpD6tsVrxQ2+Nnpcjk/AesYGJqDt6Ky
         fVmm6piauhSlpuQaWOJLCpqXv4xL6b8JCZKTDm9i0wYd04VQwZfcH975s5EI0DJO/rTm
         x6hIjhIZZaEjFTjLz0U/WmZ6/C8OPm82nvg1Q=
MIME-Version: 1.0
In-Reply-To: <1295550009.28001.59.camel@Joe-Laptop>
References: <1295256060-2091-1-git-send-email-ratbert.chuang@gmail.com>
 <1295537418-2057-1-git-send-email-ratbert.chuang@gmail.com> <1295550009.28001.59.camel@Joe-Laptop>
From: Po-Yu Chuang <ratbert.chuang@gmail.com>
Date: Fri, 21 Jan 2011 13:03:18 +0800
Message-ID: <AANLkTi=b9ma=xV1ovbJmy94BrDT696VR4OcyR9vqwGtB@mail.gmail.com>
Subject: Re: [PATCH v3] net: add Faraday FTMAC100 10/100 Ethernet driver
To: Joe Perches <joe@perches.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bhutchings@solarflare.com, eric.dumazet@gmail.com, dilinger@queued.net,
        Po-Yu Chuang <ratbert@faraday-tech.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Joe,

On Fri, Jan 21, 2011 at 3:00 AM, Joe Perches <joe@perches.com> wrote:
> On Thu, 2011-01-20 at 23:30 +0800, Po-Yu Chuang wrote:
>>  drivers/net/ftmac100.c | 1243 ++++++++++++++++++++++++++++++++++++++++++++++++
>
> []
>
>> +/******************************************************************************
>> + * struct napi_struct functions
>> + *****************************************************************************/
>> +static int ftmac100_poll(struct napi_struct *napi, int budget)
>> +{
>> +     struct ftmac100 *priv = container_of(napi, struct ftmac100, napi);
>> +     struct net_device *netdev = priv->netdev;
>> +     unsigned int status;
>> +     bool completed = true;
>> +     int rx = 0;
>> +
>> +     status = ioread32(priv->base + FTMAC100_OFFSET_ISR);
>> +
>> +     if (status & (FTMAC100_INT_RPKT_FINISH | FTMAC100_INT_NORXBUF)) {
>> +             /*
>> +              * FTMAC100_INT_RPKT_FINISH:
>> +              *      RX DMA has received packets into RX buffer successfully
>> +              *
>> +              * FTMAC100_INT_NORXBUF:
>> +              *      RX buffer unavailable
>> +              */
>> +             bool retry;
>> +
>> +             do {
>> +                     retry = ftmac100_rx_packet(priv, &rx);
>> +             } while (retry && rx < budget);
>> +
>> +             if (retry && rx == budget)
>> +                     completed = false;
>
> Is it useful to retry the NORXBUF case?

The idea is that if I miss packet finished interrupts (then rx buffers used up),
I should retrieve the received packets ASAP to free buffers to HW.
Maybe this is really unnecessary.
I am not quite sure, but I'll do your advice now.

>> +     }
>> +
>> +     if (status & FTMAC100_INT_NORXBUF) {
>> +             /* RX buffer unavailable */
>> +             if (net_ratelimit())
>> +                     netdev_info(netdev, "INT_NORXBUF\n");
>> +
>> +             netdev->stats.rx_over_errors++;
>> +     }
>
> Perhaps this "if (status & FTMAC100_INT_NORXBUF)" block should be
> moved into the test block above it before the retry?

Since status is not changed in the function, it does not matter where
the test is.
But I agree that it is better to handle error cases earlier.

> It's possible to miss multiple states because of the ratelimit.
>
> If multiple ISR status bits are possible, it might be better to
> combine all netdev_info uses into a single call.
>
> Something like:
>
>        if ((status & (FTMAC100_INT_NORXBUF | FTMAC100_INT_RPKT_LOST |
>                       FTMAC100_INT_AHB_ERR | FTMAC100_INT_PHYSTS_CHG)) &&
>            net_ratelimit())
>                netdev_info(netdev, "ISR status: %x%s%s%s%s\n",
>                            status & FTMAC100_INT_NORXBUF ? ": INT_NORXBUF" : "",
>                            status & FTMAC100_INT_RPKT_LOST ? ": INT_RPKT_LOST" : "",
>                            status & FTMAC100_INT_AHB_ERR ? ": INT_AHB_ERR" : "",
>                            status & FTMAC100_INT_PHYSTS_CHG ? " : INT_PHYSTS_CHG" : "");

Agree. Thanks.

best regards,
Po-Yu Chuang
