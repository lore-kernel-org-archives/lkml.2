Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754117Ab2LCGp6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 01:45:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17093 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750882Ab2LCGp5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 01:45:57 -0500
From: Jason Wang <jasowang@redhat.com>
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: rusty@rustcorp.com.au, mst@redhat.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [net-next RFC] pktgen: don't wait for the device who doesn't free skb immediately after sent
Date: Mon, 03 Dec 2012 14:45:46 +0800
Message-ID: <2663254.1vRFru9xhh@jason-thinkpad-t430s>
User-Agent: KMail/4.9.2 (Linux/3.7.0-rc6+; KDE/4.9.2; x86_64; ; )
In-Reply-To: <20121127084919.1587c647@nehalam.linuxnetplumber.net>
References: <1353916612-6357-1-git-send-email-jasowang@redhat.com> <50B46179.4040809@redhat.com> <20121127084919.1587c647@nehalam.linuxnetplumber.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, November 27, 2012 08:49:19 AM Stephen Hemminger wrote:
> On Tue, 27 Nov 2012 14:45:13 +0800
> 
> Jason Wang <jasowang@redhat.com> wrote:
> > On 11/27/2012 01:37 AM, Stephen Hemminger wrote:
> > > On Mon, 26 Nov 2012 15:56:52 +0800
> > > 
> > > Jason Wang <jasowang@redhat.com> wrote:
> > >> Some deivces do not free the old tx skbs immediately after it has been
> > >> sent
> > >> (usually in tx interrupt). One such example is virtio-net which
> > >> optimizes for virt and only free the possible old tx skbs during the
> > >> next packet sending. This would lead the pktgen to wait forever in the
> > >> refcount of the skb if no other pakcet will be sent afterwards.
> > >> 
> > >> Solving this issue by introducing a new flag IFF_TX_SKB_FREE_DELAY
> > >> which could notify the pktgen that the device does not free skb
> > >> immediately after it has been sent and let it not to wait for the
> > >> refcount to be one.
> > >> 
> > >> Signed-off-by: Jason Wang <jasowang@redhat.com>
> > > 
> > > Another alternative would be using skb_orphan() and skb->destructor.
> > > There are other cases where skb's are not freed right away.
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe netdev" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> > Hi Stephen:
> > 
> > Do you mean registering a skb->destructor for pktgen then set and check
> > bits in skb->tx_flag?
> 
> Yes. Register a destructor that does something like update a counter (number
> of packets pending), then just spin while number of packets pending is over
> threshold.

Have some experiments on this, looks like it does not work weel when clone_skb 
is used. For driver that call skb_orphan() in ndo_start_xmit, the destructor 
is only called when the first packet were sent, but what we need to know is 
when the last were sent. Any thoughts on this or we can just introduce another 
flag (anyway we have something like IFF_TX_SKB_SHARING) ?

Thanks
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
