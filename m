Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757989Ab1JEO6Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 10:58:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18477 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757832Ab1JEO6X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 10:58:23 -0400
Date: Wed, 5 Oct 2011 16:59:04 -0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v2 1/2] virtio-net: Verify page list size before fitting
 into  skb
Message-ID: <20111005185904.GA15444@redhat.com>
References: <1317220855-9352-1-git-send-email-levinsasha928@gmail.com>
 <20111003190416.GC22427@redhat.com>
 <1317822654.3676.1.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317822654.3676.1.camel@lappy>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 05, 2011 at 03:50:54PM +0200, Sasha Levin wrote:
> On Mon, 2011-10-03 at 21:04 +0200, Michael S. Tsirkin wrote:
> > On Wed, Sep 28, 2011 at 05:40:54PM +0300, Sasha Levin wrote:
> > > This patch verifies that the length of a buffer stored in a linked list
> > > of pages is small enough to fit into a skb.
> > > 
> > > If the size is larger than a max size of a skb, it means that we shouldn't
> > > go ahead building skbs anyway since we won't be able to send the buffer as
> > > the user requested.
> > > 
> > > Cc: Rusty Russell <rusty@rustcorp.com.au>
> > > Cc: "Michael S. Tsirkin" <mst@redhat.com>
> > > Cc: virtualization@lists.linux-foundation.org
> > > Cc: netdev@vger.kernel.org
> > > Cc: kvm@vger.kernel.org
> > > Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
> > > ---
> > >  drivers/net/virtio_net.c |   13 +++++++++++++
> > >  1 files changed, 13 insertions(+), 0 deletions(-)
> > > 
> > > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > > index 0c7321c..bde0dec 100644
> > > --- a/drivers/net/virtio_net.c
> > > +++ b/drivers/net/virtio_net.c
> > > @@ -195,6 +195,19 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
> > >  	len -= copy;
> > >  	offset += copy;
> > >  
> > > +	/*
> > > +	 * Verify that we can indeed put this data into a skb.
> > > +	 * This is here to handle cases when the device erroneously
> > > +	 * tries to receive more than is possible. This is usually
> > > +	 * the case of a broken device.
> > > +	 */
> > > +	if (unlikely(len > MAX_SKB_FRAGS * PAGE_SIZE)) {
> > > +		if (net_ratelimit())
> > > +			pr_debug("%s: too much data\n", skb->dev->name);
> > > +		dev_kfree_skb(skb);
> > > +		return NULL;
> > > +	}
> > > +
> > 
> > BTW, receive_mergeable does
> >                         pr_debug("%s: packet too long\n", skb->dev->name);
> >                         skb->dev->stats.rx_length_errors++;
> > 
> > which makes sense.
> 
> Do you think we should increase rx_length_errors here as well?

this is all debugging tool for devices/drivers, right?
so maybe not worth the noise.

> -- 
> 
> Sasha.
