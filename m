Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933010Ab1ERLr5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 07:47:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37047 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932811Ab1ERLry (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 07:47:54 -0400
Date: Wed, 18 May 2011 14:47:54 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: =?utf-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirqus@gmail.com>
Cc: Shirley Ma <mashirle@us.ibm.com>,
        Ben Hutchings <bhutchings@solarflare.com>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>, Avi Kivity <avi@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V5 2/6 net-next] netdevice.h: Add zero-copy flag in
 netdevice
Message-ID: <20110518114754.GS7589@redhat.com>
References: <1305574680.3456.33.camel@localhost.localdomain>
 <1305575253.2885.28.camel@bwh-desktop>
 <20110516211459.GE18148@redhat.com>
 <1305588738.3456.65.camel@localhost.localdomain>
 <BANLkTimvOK3tyo6+L5AD=so5DjiDPV-AAA@mail.gmail.com>
 <1305671318.10756.49.camel@localhost.localdomain>
 <20110518103819.GL7589@redhat.com>
 <BANLkTimc1RbC3uQsra1HUvS_Trg63iMWGA@mail.gmail.com>
 <20110518111734.GO7589@redhat.com>
 <BANLkTi=g_PFfS5653K8ZoQ2Jhp8DhCV1hg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTi=g_PFfS5653K8ZoQ2Jhp8DhCV1hg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 18, 2011 at 01:40:29PM +0200, Michał Mirosław wrote:
> W dniu 18 maja 2011 13:17 użytkownik Michael S. Tsirkin
> <mst@redhat.com> napisał:
> > On Wed, May 18, 2011 at 01:10:50PM +0200, Michał Mirosław wrote:
> >> 2011/5/18 Michael S. Tsirkin <mst@redhat.com>:
> >> > On Tue, May 17, 2011 at 03:28:38PM -0700, Shirley Ma wrote:
> >> >> On Tue, 2011-05-17 at 23:48 +0200, Michał Mirosław wrote:
> >> >> > 2011/5/17 Shirley Ma <mashirle@us.ibm.com>:
> >> >> > > Hello Michael,
> >> >> > >
> >> >> > > Looks like to use a new flag requires more time/work. I am thinking
> >> >> > > whether we can just use HIGHDMA flag to enable zero-copy in macvtap
> >> >> > to
> >> >> > > avoid the new flag for now since mavctap uses real NICs as lower
> >> >> > device?
> >> >> >
> >> >> > Is there any other restriction besides requiring driver to not recycle
> >> >> > the skb? Are there any drivers that recycle TX skbs?
> >> >
> >> > Not just recycling skbs, keeping reference to any of the pages in the
> >> > skb. Another requirement is to invoke the callback
> >> > in a timely fashion.  For example virtio-net doesn't limit the time until
> >> > that happens (skbs are only freed when some other packet is
> >> > transmitted), so we need to avoid zcopy for such (nested-virt)
> >> > scenarious, right?
> >>
> >> Hmm. But every hardware driver supporting SG will keep reference to
> >> the pages until the packet is sent (or DMA'd to the device). This can
> >> take a long time if hardware queue happens to stall for some reason.
> >
> > That's a fundamental property of zero copy transmit.
> > You can't let the application/guest reuse the memory until
> > no one looks at it anymore.
> >
> >> Is it that you mean keeping a reference after all skbs pointing to the
> >> pages are released?
> > No one should reference the pages after the callback is invoked, yes.
> 
> >> >> Not more other restrictions, skb clone is OK. pskb_expand_head() looks
> >> >> OK to me from code review.
> >> > Hmm. pskb_expand_head calls skb_release_data while keeping
> >> > references to pages. How is that ok? What do I miss?
> >> It's making copy of the skb_shinfo earlier, so the pages refcount
> >> stays the same.
> > Exactly. But the callback is invoked so the guest thinks it's ok to
> > change this memory. If it does a corrupted packet will be sent out.
> 
> Hmm. I tool a quick look at skb_clone(), and it looks like this
> sequence will break this scheme:
> 
> skb2 = skb_clone(skb...);
> kfree_skb(skb) or pskb_expand_head(skb);  /* callback called */
> [use skb2, pages still referenced]
> kfree_skb(skb); /* callback called again */
> 
> This sequence is common in bridge, might be in other places.
> 
> Maybe this ubuf thing should just track clones? This will make it work
> on all devices then.
> 
> Best Regards,
> Michał Mirosław

Long term that's a good plan, but it's a lot of work.
pages can also get into weird places like VFS
or devices might hang on to them for a long time.

So I think as a first step, using a flag to white-list
simple devices that don't do any tricks like the
above makes sense.

Just be sure to list all of the restrictions in
the comment where the flag is described.

And hey, we get features extended to 64 bit as a bonus :)

-- 
MST
