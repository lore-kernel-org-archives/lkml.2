Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755661Ab2K1QyV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 11:54:21 -0500
Received: from mail.vyatta.com ([76.74.103.46]:43293 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754453Ab2K1QyQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 11:54:16 -0500
Date: Wed, 28 Nov 2012 08:53:05 -0800
From: Stephen Hemminger <shemminger@vyatta.com>
To: Jason Wang <jasowang@redhat.com>
Cc: rusty@rustcorp.com.au, mst@redhat.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [net-next RFC] pktgen: don't wait for the device who doesn't
 free skb immediately after sent
Message-ID: <20121128085305.2b0503ce@nehalam.linuxnetplumber.net>
In-Reply-To: <50B5B3D4.1070106@redhat.com>
References: <1353916612-6357-1-git-send-email-jasowang@redhat.com>
	<20121126093728.0a10f97f@nehalam.linuxnetplumber.net>
	<50B46179.4040809@redhat.com>
	<20121127084919.1587c647@nehalam.linuxnetplumber.net>
	<50B5B3D4.1070106@redhat.com>
Organization: Vyatta
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Nov 2012 14:48:52 +0800
Jason Wang <jasowang@redhat.com> wrote:

> On 11/28/2012 12:49 AM, Stephen Hemminger wrote:
> > On Tue, 27 Nov 2012 14:45:13 +0800
> > Jason Wang <jasowang@redhat.com> wrote:
> >
> >> On 11/27/2012 01:37 AM, Stephen Hemminger wrote:
> >>> On Mon, 26 Nov 2012 15:56:52 +0800
> >>> Jason Wang <jasowang@redhat.com> wrote:
> >>>
> >>>> Some deivces do not free the old tx skbs immediately after it has been sent
> >>>> (usually in tx interrupt). One such example is virtio-net which optimizes for
> >>>> virt and only free the possible old tx skbs during the next packet sending. This
> >>>> would lead the pktgen to wait forever in the refcount of the skb if no other
> >>>> pakcet will be sent afterwards.
> >>>>
> >>>> Solving this issue by introducing a new flag IFF_TX_SKB_FREE_DELAY which could
> >>>> notify the pktgen that the device does not free skb immediately after it has
> >>>> been sent and let it not to wait for the refcount to be one.
> >>>>
> >>>> Signed-off-by: Jason Wang <jasowang@redhat.com>
> >>> Another alternative would be using skb_orphan() and skb->destructor.
> >>> There are other cases where skb's are not freed right away.
> >>> --
> >>> To unsubscribe from this list: send the line "unsubscribe netdev" in
> >>> the body of a message to majordomo@vger.kernel.org
> >>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >> Hi Stephen:
> >>
> >> Do you mean registering a skb->destructor for pktgen then set and check
> >> bits in skb->tx_flag?
> > Yes. Register a destructor that does something like update a counter (number of packets pending),
> > then just spin while number of packets pending is over threshold.
> > --
> 
> Not sure this is the best method, since pktgen was used to test the tx 
> process of the device driver and NIC. If we use skb_orhpan(), we would 
> miss the test of tx completion part.

There are other places that delay freeing and your solution would mean finding
and fixing all those. Code that does that already has to use skb_orphan() to
work, and I was looking for a way that could use that. Introducing another flag
value seems like a long term burden.

Alternatively, virtio could do cleanup more aggressively. Maybe in response to
ring getting half full, or add a cleanup timer or something to avoid the problem.



