Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949Ab2K2KN2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 05:13:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15866 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753644Ab2K2KNX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 05:13:23 -0500
From: Jason Wang <jasowang@redhat.com>
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: rusty@rustcorp.com.au, mst@redhat.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [net-next RFC] pktgen: don't wait for the device who doesn't free skb immediately after sent
Date: Thu, 29 Nov 2012 18:13:13 +0800
Message-ID: <1570859.IePPxHAEX1@jason-thinkpad-t430s>
User-Agent: KMail/4.9.2 (Linux/3.7.0-rc6+; KDE/4.9.2; x86_64; ; )
In-Reply-To: <20121128085305.2b0503ce@nehalam.linuxnetplumber.net>
References: <1353916612-6357-1-git-send-email-jasowang@redhat.com> <50B5B3D4.1070106@redhat.com> <20121128085305.2b0503ce@nehalam.linuxnetplumber.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, November 28, 2012 08:53:05 AM Stephen Hemminger wrote:
> On Wed, 28 Nov 2012 14:48:52 +0800
> 
> Jason Wang <jasowang@redhat.com> wrote:
> > On 11/28/2012 12:49 AM, Stephen Hemminger wrote:
> > > On Tue, 27 Nov 2012 14:45:13 +0800
> > > 
> > > Jason Wang <jasowang@redhat.com> wrote:
> > >> On 11/27/2012 01:37 AM, Stephen Hemminger wrote:
> > >>> On Mon, 26 Nov 2012 15:56:52 +0800
> > >>> 
> > >>> Jason Wang <jasowang@redhat.com> wrote:
> > >>>> Some deivces do not free the old tx skbs immediately after it has
> > >>>> been sent
> > >>>> (usually in tx interrupt). One such example is virtio-net which
> > >>>> optimizes for virt and only free the possible old tx skbs during the
> > >>>> next packet sending. This would lead the pktgen to wait forever in
> > >>>> the refcount of the skb if no other pakcet will be sent afterwards.
> > >>>> 
> > >>>> Solving this issue by introducing a new flag IFF_TX_SKB_FREE_DELAY
> > >>>> which could notify the pktgen that the device does not free skb
> > >>>> immediately after it has been sent and let it not to wait for the
> > >>>> refcount to be one.
> > >>>> 
> > >>>> Signed-off-by: Jason Wang <jasowang@redhat.com>
> > >>> 
> > >>> Another alternative would be using skb_orphan() and skb->destructor.
> > >>> There are other cases where skb's are not freed right away.
> > >>> --
> > >>> To unsubscribe from this list: send the line "unsubscribe netdev" in
> > >>> the body of a message to majordomo@vger.kernel.org
> > >>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > >> 
> > >> Hi Stephen:
> > >> 
> > >> Do you mean registering a skb->destructor for pktgen then set and check
> > >> bits in skb->tx_flag?
> > > 
> > > Yes. Register a destructor that does something like update a counter
> > > (number of packets pending), then just spin while number of packets
> > > pending is over threshold.
> > > --
> > 
> > Not sure this is the best method, since pktgen was used to test the tx
> > process of the device driver and NIC. If we use skb_orhpan(), we would
> > miss the test of tx completion part.
> 
> There are other places that delay freeing and your solution would mean
> finding and fixing all those. Code that does that already has to use
> skb_orphan() to work, and I was looking for a way that could use that.
> Introducing another flag value seems like a long term burden.
> 

Get the point, will draft another version.
> Alternatively, virtio could do cleanup more aggressively. Maybe in response
> to ring getting half full, or add a cleanup timer or something to avoid the
> problem.

May worth to try. Another method is that virtio has a feature to notify guest 
when tx ring is empty, we could free the old tx skbs there. But it may brings 
extra overhead. If we could let virtio_net free the old tx skb timely, it 
would be easier to bring BQL support to virtio_net also.

Thanks
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
