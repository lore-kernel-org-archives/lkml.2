Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933021Ab1ERL4F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 07:56:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41871 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932763Ab1ERL4C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 07:56:02 -0400
Date: Wed, 18 May 2011 14:56:02 +0300
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
Message-ID: <20110518115602.GT7589@redhat.com>
References: <1305574680.3456.33.camel@localhost.localdomain>
 <1305575253.2885.28.camel@bwh-desktop>
 <20110516211459.GE18148@redhat.com>
 <1305588738.3456.65.camel@localhost.localdomain>
 <BANLkTimvOK3tyo6+L5AD=so5DjiDPV-AAA@mail.gmail.com>
 <1305671318.10756.49.camel@localhost.localdomain>
 <20110518103819.GL7589@redhat.com>
 <BANLkTimc1RbC3uQsra1HUvS_Trg63iMWGA@mail.gmail.com>
 <20110518111734.GO7589@redhat.com>
 <BANLkTim9RQ94MT4L0QHx-yzZT5nXdbi0aQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTim9RQ94MT4L0QHx-yzZT5nXdbi0aQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 18, 2011 at 01:47:33PM +0200, Michał Mirosław wrote:
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
> >> > Not just recycling skbs, keeping reference to any of the pages in the
> >> > skb. Another requirement is to invoke the callback
> >> > in a timely fashion.  For example virtio-net doesn't limit the time until
> >> > that happens (skbs are only freed when some other packet is
> >> > transmitted), so we need to avoid zcopy for such (nested-virt)
> >> > scenarious, right?
> >> Hmm. But every hardware driver supporting SG will keep reference to
> >> the pages until the packet is sent (or DMA'd to the device). This can
> >> take a long time if hardware queue happens to stall for some reason.
> > That's a fundamental property of zero copy transmit.
> > You can't let the application/guest reuse the memory until
> > no one looks at it anymore.
> 
> One more question: is userspace (or whatever is sending those packets)
> denied from modifying passed pages? I assume it is, but just want to
> be sure.
> 
> Best Regards,
> Michał Mirosław

Good point.

It's not denied in the sense that it still can modify them if it's
buggy (the pages might not be read-only).
But well-behaved userspace won't modify them until the callback
is invoked.

That would be a problem if the underlying device is
a bridge where we might try to e.g. filter these packets -
data can get modified after the filter. We'd have to copy
whatever the filter accesses and use the copy - it's rarely
the data itself.

That's not normally a problem for macvtap connected to a physical NIC,
as that already bypasses any and all filtering.

But that's another limitation we should note in the comment,
and another reason to limit to specific devices.

-- 
MST
