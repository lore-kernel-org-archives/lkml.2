Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752707Ab1LTT3P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 14:29:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24740 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751803Ab1LTT3E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 14:29:04 -0500
Date: Tue, 20 Dec 2011 21:30:55 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Amit Shah <amit.shah@redhat.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] virtio_net: fix refill related races
Message-ID: <20111220193055.GA26392@redhat.com>
References: <20111207152120.GA23417@redhat.com>
 <8739cvisqe.fsf@rustcorp.com.au>
 <20111211144428.GB14381@redhat.com>
 <878vmioh10.fsf@rustcorp.com.au>
 <20111212115405.GB7946@redhat.com>
 <87iplltd0g.fsf@rustcorp.com.au>
 <20111220190908.GC25689@redhat.com>
 <20111220190946.GD10752@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111220190946.GD10752@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 20, 2011 at 11:09:46AM -0800, Tejun Heo wrote:
> Hello, Michael.
> 
> On Tue, Dec 20, 2011 at 09:09:08PM +0200, Michael S. Tsirkin wrote:
> > Another question, wanted to make sure:
> > virtnet_poll does schedule_delayed_work(&vi->refill, 0);
> > separately refill work itself also does
> > schedule_delayed_work(&vi->refill, HZ/2);
> > If two such events happen twice, on different CPUs, we are still guaranteed
> > the work will only run once, right?
> 
> No, it's not.  Normal workqueues only guarantee non-reentrance on
> local CPU.  If you want to guarantee that only one instance of a given
> item is executing across all CPUs, you need to use the nrt workqueue.
> 
> Thanks.

Hmm, in that case it looks like a nasty race could get
triggered, with try_fill_recv run on multiple CPUs in parallel,
corrupting the linked list within the vq.

Using the mutex as my patch did will fix that naturally, as well.

Rusty, am I missing something?

> -- 
> tejun
