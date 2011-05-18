Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932604Ab1ERQCu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 12:02:50 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:52721 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757141Ab1ERQCr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 12:02:47 -0400
Subject: Re: [PATCH V5 2/6 net-next] netdevice.h: Add zero-copy flag in
 netdevice
From: Shirley Ma <mashirle@us.ibm.com>
To: =?UTF-8?Q?Micha=C5=82_Miros=C5=82aw?= <mirqus@gmail.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
        Ben Hutchings <bhutchings@solarflare.com>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>, Avi Kivity <avi@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1305729507.32080.6.camel@localhost.localdomain>
References: <1305574128.3456.23.camel@localhost.localdomain>
	 <1305574518.2885.25.camel@bwh-desktop>
	 <1305574680.3456.33.camel@localhost.localdomain>
	 <1305575253.2885.28.camel@bwh-desktop> <20110516211459.GE18148@redhat.com>
	 <1305588738.3456.65.camel@localhost.localdomain>
	 <BANLkTimvOK3tyo6+L5AD=so5DjiDPV-AAA@mail.gmail.com>
	 <1305671318.10756.49.camel@localhost.localdomain>
	 <20110518103819.GL7589@redhat.com>
	 <BANLkTimc1RbC3uQsra1HUvS_Trg63iMWGA@mail.gmail.com>
	 <20110518111734.GO7589@redhat.com>
	 <BANLkTi=g_PFfS5653K8ZoQ2Jhp8DhCV1hg@mail.gmail.com>
	 <1305729507.32080.6.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 18 May 2011 09:02:23 -0700
Message-ID: <1305734543.32080.50.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-05-18 at 07:38 -0700, Shirley Ma wrote:
> On Wed, 2011-05-18 at 13:40 +0200, Michał Mirosław wrote:
> > >> >> Not more other restrictions, skb clone is OK.
> pskb_expand_head()
> > looks
> > >> >> OK to me from code review.
> > >> > Hmm. pskb_expand_head calls skb_release_data while keeping
> > >> > references to pages. How is that ok? What do I miss?
> > >> It's making copy of the skb_shinfo earlier, so the pages refcount
> > >> stays the same.
> > > Exactly. But the callback is invoked so the guest thinks it's ok
> to
> > > change this memory. If it does a corrupted packet will be sent
> out.
> > 
> > Hmm. I tool a quick look at skb_clone(), and it looks like this
> > sequence will break this scheme:
> > 
> > skb2 = skb_clone(skb...);
> > kfree_skb(skb) or pskb_expand_head(skb);  /* callback called */
> > [use skb2, pages still referenced]
> > kfree_skb(skb); /* callback called again */
> > 
> > This sequence is common in bridge, might be in other places.
> > 
> > Maybe this ubuf thing should just track clones? This will make it
> work
> > on all devices then.
> 
> The callback was only invoked when last reference of skb was gone.
> skb_clone does increase skb refcnt. I tested tcpdump on lower device,
> it
> worked.
> 
> For the sequence of:
> 
> skb_clone  -> last refcnt + 1
> kfree_skb() or pskb_expand_head -> callback not called
> kfree_skb() -> callback called
> 
> I will check page refcount to see whether it's balanced. 

The page refcounts are balanced too. 

In macvtap/vhost Real NIC zerocopy case, it always goes to fastpath in
pskb_expand_head, so I didn't hit any issue.

But rethinking about pskb_expand_head(), it calls skb_release_data() to
free old skb head when it's not in the fastpath (pskb_expand_head is not
the last reference of this skb); And it's impossible to track which skb
head (old one or new one) will be the last one to free. So better to
return error for zero-copy skbs when not using fastpath. Does it make
sense? 

Besides this, any other issue?


Thanks
Shirley

