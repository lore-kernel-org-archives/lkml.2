Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756482Ab0I1Otk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 10:49:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59620 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756145Ab0I1Otj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 10:49:39 -0400
Date: Tue, 28 Sep 2010 16:43:11 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Ben Hutchings <bhutchings@solarflare.com>, xiaohui.xin@intel.com,
        netdev@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, mingo@elte.hu, davem@davemloft.net,
        herbert@gondor.hengli.com.au, jdike@linux.intel.com,
        Sridhar Samudrala <sri@us.ibm.com>
Subject: Re: [PATCH v11 13/17] Add mp(mediate passthru) device.
Message-ID: <20100928144311.GB15294@redhat.com>
References: <1285388855-27410-1-git-send-email-xiaohui.xin@intel.com>
 <1285622613.2263.550.camel@achroite.uk.solarflarecom.com>
 <20100928130654.GD14385@redhat.com>
 <201009281639.59417.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201009281639.59417.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 28, 2010 at 04:39:59PM +0200, Arnd Bergmann wrote:
> On Tuesday 28 September 2010, Michael S. Tsirkin wrote:
> > > > +   skb_reserve(skb, NET_IP_ALIGN);
> > > > +   skb_put(skb, len);
> > > > +
> > > > +   if (skb_copy_datagram_from_iovec(skb, 0, iov, 0, len)) {
> > > > +           kfree_skb(skb);
> > > > +           return -EAGAIN;
> > > > +   }
> > > > +
> > > > +   skb->protocol = eth_type_trans(skb, mp->dev);
> > > 
> > > Why are you calling eth_type_trans() on transmit?
> > 
> > So that GSO can work.  BTW macvtap does:
> > 
> >         skb_set_network_header(skb, ETH_HLEN);
> >         skb_reset_mac_header(skb);
> >         skb->protocol = eth_hdr(skb)->h_proto;
> > 
> > and I think this is broken for vlans. Arnd?
> 
> Hmm, that code (besides set_network_header) was added by Sridhar
> for GSO support. I believe I originally did eth_type_trans but
> had to change it before that time because it broke something.
> Unfortunately, my memory on that is not very good any more.
> 
> Can you be more specific what the problem is? Do you think
> it breaks when a guest sends VLAN tagged frames or when macvtap
> is connected to a VLAN interface that adds another tag (or
> only the combination)?
> 
> 	Arnd

I expect the protocol value to be wrong when guest sends vlan tagged
frames as 802.1q frames have a different format.

-- 
MST
