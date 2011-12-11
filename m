Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752872Ab1LLDFT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Dec 2011 22:05:19 -0500
Received: from ozlabs.org ([203.10.76.45]:56789 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752779Ab1LLDFQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Dec 2011 22:05:16 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Amit Shah <amit.shah@redhat.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] virtio_net: fix refill related races
In-Reply-To: <20111211144428.GB14381@redhat.com>
References: <20111207152120.GA23417@redhat.com> <8739cvisqe.fsf@rustcorp.com.au> <20111211144428.GB14381@redhat.com>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Mon, 12 Dec 2011 09:25:07 +1030
Message-ID: <878vmioh10.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 11 Dec 2011 16:44:29 +0200, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> On Thu, Dec 08, 2011 at 03:07:29PM +1030, Rusty Russell wrote:
> > On Wed, 7 Dec 2011 17:21:22 +0200, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> > > Fix theoretical races related to refill work:
> > > 1. After napi is disabled by ndo_stop, refill work
> > >    can run and re-enable it.
> > > 2. Refill can reschedule itself, if this happens
> > >    it can run after cancel_delayed_work_sync,
> > >    and will access device after it is destroyed.
> > > 
> > > As a solution, add flags to track napi state and
> > > to disable refill, and toggle them on start, stop
> > > and remove; check these flags on refill.
> > 
> > Why isn't a "dont-readd" flag sufficient?
> > 
> > Cheers,
> > Rusty.
> 
> I started with that, but here's the problem I wanted to
> address:
> 
> - we run out of descriptors and schedule refill work
> - ndo_close runs
> - refill work runs
> - ndo_open runs

(s/ndo_close/ndo_stop/)

You don't think we should do any refills on a closed device?  If so, we
simply move the refill-stop code into ndo_stop (aka virtnet_close), and
the refill-start code into ndo_open (aka. virtnet_open).  Right?

Orthogonally, the refill-stop code is still buggy, as you noted.  And
for self-rearming timers the pattern I've always used is a flag.

Or am I being obtuse again? :)
Rusty.
