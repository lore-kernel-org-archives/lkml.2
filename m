Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752484Ab1LLLwS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 06:52:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16426 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752085Ab1LLLwQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 06:52:16 -0500
Date: Mon, 12 Dec 2011 13:54:06 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Amit Shah <amit.shah@redhat.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] virtio_net: fix refill related races
Message-ID: <20111212115405.GB7946@redhat.com>
References: <20111207152120.GA23417@redhat.com>
 <8739cvisqe.fsf@rustcorp.com.au>
 <20111211144428.GB14381@redhat.com>
 <878vmioh10.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878vmioh10.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 12, 2011 at 09:25:07AM +1030, Rusty Russell wrote:
> On Sun, 11 Dec 2011 16:44:29 +0200, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> > On Thu, Dec 08, 2011 at 03:07:29PM +1030, Rusty Russell wrote:
> > > On Wed, 7 Dec 2011 17:21:22 +0200, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> > > > Fix theoretical races related to refill work:
> > > > 1. After napi is disabled by ndo_stop, refill work
> > > >    can run and re-enable it.
> > > > 2. Refill can reschedule itself, if this happens
> > > >    it can run after cancel_delayed_work_sync,
> > > >    and will access device after it is destroyed.
> > > > 
> > > > As a solution, add flags to track napi state and
> > > > to disable refill, and toggle them on start, stop
> > > > and remove; check these flags on refill.
> > > 
> > > Why isn't a "dont-readd" flag sufficient?
> > > 
> > > Cheers,
> > > Rusty.
> > 
> > I started with that, but here's the problem I wanted to
> > address:
> > 
> > - we run out of descriptors and schedule refill work
> > - ndo_close runs
> > - refill work runs
> > - ndo_open runs
> 
> (s/ndo_close/ndo_stop/)
> 
> You don't think we should do any refills on a closed device?  If so, we
> simply move the refill-stop code into ndo_stop (aka virtnet_close), and
> the refill-start code into ndo_open (aka. virtnet_open).  Right?

We can do that, yes. We'll have to also cancel work if outstanding.
It seems a bigger change though. I'm especially concerned
about putting refill-start in virtnet_open, suddenly
it's always running where it used to only run after
we have consumed some buffers. I'm just concerned about
doing big changes that late in release cycle but maybe
that's OK.

> Orthogonally, the refill-stop code is still buggy, as you noted.

Sorry I don't understand how it's still buggy.

>  And
> for self-rearming timers the pattern I've always used is a flag.
> 
> Or am I being obtuse again? :)
> Rusty.

