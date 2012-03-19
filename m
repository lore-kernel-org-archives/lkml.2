Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032194Ab2CSRqW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 13:46:22 -0400
Received: from am1ehsobe004.messaging.microsoft.com ([213.199.154.207]:32001
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754527Ab2CSRqU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 13:46:20 -0400
X-SpamScore: -19
X-BigFish: VS-19(zz9371I936eK542M1432N98dK4015Izz1202hzz8275bh8275dhz2fh2a8h668h839h93fhd25h)
X-Forefront-Antispam-Report: CIP:131.107.125.8;KIP:(null);UIP:(null);IPV:NLI;H:TK5EX14HUBC104.redmond.corp.microsoft.com;RD:none;EFVD:NLI
From: Haiyang Zhang <haiyangz@microsoft.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: KY Srinivasan <kys@microsoft.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
Subject: RE: [PATCH 1/1] net/hyperv: Fix the code handling tx busy
Thread-Topic: [PATCH 1/1] net/hyperv: Fix the code handling tx busy
Thread-Index: AQHNBfEpJGzSBBPeR0eW4jFoAPxN+ZZx2uYAgAACBIA=
Date: Mon, 19 Mar 2012 17:46:00 +0000
Message-ID: <A1F3067C9B68744AA19F6802BAB8FFDC0DCEA84D@TK5EX14MBXC223.redmond.corp.microsoft.com>
References: <1332176549-30960-1-git-send-email-haiyangz@microsoft.com>
	 <1332176549-30960-2-git-send-email-haiyangz@microsoft.com>
 <1332177118.9397.32.camel@edumazet-glaptop>
In-Reply-To: <1332177118.9397.32.camel@edumazet-glaptop>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.37]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q2JHkSJ0028900



> -----Original Message-----
> From: Eric Dumazet [mailto:eric.dumazet@gmail.com]
> Sent: Monday, March 19, 2012 1:12 PM
> To: Haiyang Zhang
> Cc: KY Srinivasan; davem@davemloft.net; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org; devel@linuxdriverproject.org
> Subject: Re: [PATCH 1/1] net/hyperv: Fix the code handling tx busy
> 
> On Mon, 2012-03-19 at 10:02 -0700, Haiyang Zhang wrote:
> > Instead of dropping the packet, we keep the skb buffer, and return
> > NETDEV_TX_BUSY to let upper layer retry send. This will not cause
> > endless loop, because the host is taking data away from ring buffer.
> >
> > Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> > Reviewed-by: K. Y. Srinivasan <kys@microsoft.com>
> > ---
> >  drivers/net/hyperv/netvsc_drv.c |    5 +----
> >  1 files changed, 1 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/net/hyperv/netvsc_drv.c
> > b/drivers/net/hyperv/netvsc_drv.c index 2517d20..dd29478 100644
> > --- a/drivers/net/hyperv/netvsc_drv.c
> > +++ b/drivers/net/hyperv/netvsc_drv.c
> > @@ -223,13 +223,10 @@ static int netvsc_start_xmit(struct sk_buff *skb,
> struct net_device *net)
> >  		net->stats.tx_bytes += skb->len;
> >  		net->stats.tx_packets++;
> >  	} else {
> > -		/* we are shutting down or bus overloaded, just drop packet
> */
> > -		net->stats.tx_dropped++;
> >  		kfree(packet);
> > -		dev_kfree_skb_any(skb);
> >  	}
> >
> > -	return NETDEV_TX_OK;
> > +	return ret ? NETDEV_TX_BUSY : NETDEV_TX_OK;
> >  }
> >
> >  /*
> 
> Thats simply not true at all.
> 
> A start_xmit() cannot do that.
> 
> TX_BUSY should never be returned at all, its a deprecated code, for pretty
> good reasons. (assuming queue is not stopped)

We actually stop queue when the ring buffer is busy, see the code in netvsc.c

> Try this on a machine with one CPU, I am pretty sure this can trigger
> complete freezes.

I have tested with one CPU. After NETDEV_TX_BUSY is returned, the Linux
guest OS continues to respond without any problem.

Thanks,
- Haiyang

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
