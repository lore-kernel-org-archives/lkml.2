Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751962Ab1LKOmt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Dec 2011 09:42:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59511 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750881Ab1LKOmq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Dec 2011 09:42:46 -0500
Date: Sun, 11 Dec 2011 16:44:29 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Amit Shah <amit.shah@redhat.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] virtio_net: fix refill related races
Message-ID: <20111211144428.GB14381@redhat.com>
References: <20111207152120.GA23417@redhat.com>
 <8739cvisqe.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8739cvisqe.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 08, 2011 at 03:07:29PM +1030, Rusty Russell wrote:
> On Wed, 7 Dec 2011 17:21:22 +0200, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> > Fix theoretical races related to refill work:
> > 1. After napi is disabled by ndo_stop, refill work
> >    can run and re-enable it.
> > 2. Refill can reschedule itself, if this happens
> >    it can run after cancel_delayed_work_sync,
> >    and will access device after it is destroyed.
> > 
> > As a solution, add flags to track napi state and
> > to disable refill, and toggle them on start, stop
> > and remove; check these flags on refill.
> 
> Why isn't a "dont-readd" flag sufficient?
> 
> Cheers,
> Rusty.

I started with that, but here's the problem I wanted to
address:

- we run out of descriptors and schedule refill work
- ndo_close runs
- refill work runs
- ndo_open runs


Now if we just disable refill, refill work will not add buffers and will
not reschedule.  Now we'll never get more buffers.
We can try starting refill work from ndo_open but overall
this seems to me more risky than just splitting flags.


-- 
MST
