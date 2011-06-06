Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756897Ab1FFO2M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 10:28:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51671 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752048Ab1FFO2K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 10:28:10 -0400
Date: Mon, 6 Jun 2011 10:28:04 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Paul Bolle <pebolle@tiscali.nl>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: Mysterious CFQ crash and RCU
Message-ID: <20110606142804.GA31757@redhat.com>
References: <20110519222404.GG12600@redhat.com>
 <20110521210013.GJ2271@linux.vnet.ibm.com>
 <20110523152141.GB4019@redhat.com>
 <20110523153848.GC2310@linux.vnet.ibm.com>
 <1306401337.27271.3.camel@t41.thuisdomein>
 <20110603050724.GB2304@linux.vnet.ibm.com>
 <1307191830.23387.24.camel@t41.thuisdomein>
 <20110604160326.GA6093@linux.vnet.ibm.com>
 <1307227686.28359.23.camel@t41.thuisdomein>
 <4DEB28A1.5090109@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DEB28A1.5090109@fusionio.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 05, 2011 at 08:56:33AM +0200, Jens Axboe wrote:
> On 2011-06-05 00:48, Paul Bolle wrote:
> > I think I finally found it!
> > 
> > The culprit seems to be io_context.ioc_data (not the most clear of
> > names!). It seems to be a single entry "last-hit cache" of an hlist
> > called cic_list. (There are three, subtly different, cic_lists in the
> > CFQ code!) It is not entirely clear, but that last-hit cache can get out
> > of sync with the hlist it is supposed to cache. My guess it that every
> > now and then a member of the hlist gets deleted while it's still in that
> > (single entry) cache. If it then gets retrieved from that cache it
> > already points to poisoned memory. For some strange reason this only
> > results in an Oops if one or more debugging options are set (as are set
> > in the Fedora Rawhide non-stable kernels that I ran into this). I have
> > no clue whatsoever, why that is ...
> > 
> > Anyhow, after ripping out ioc_data this bug seems to have disappeared!
> > Jens, Vivek, could you please have a look at this? In the mean time I
> > hope to pinpoint this issue and draft a small patch to really solve it
> > (ie, not by simply ripping out ioc_data).
> 
> Does this fix it? It will introduce a hierarchy that is queue -> ioc
> lock, but as far as I can remember (and tell from a quick look), we
> don't have any dependencies on that order of locking at this moment. So
> should be OK.

Excellent debugging PaulB. This bug was troubling us for a very long
time now.

While we are looking at races, I am wondering if we still have more races
in process exit vs queue exit path. That's a different thing that it is
not easy to hit the races.

So process exit path we do following.

cfq_exit_single_io_context {
	cfqd = cic_to_cfqd();
	q = cfqd->queue; <----- Racy
	spin_lock_irqsave(q->queue_lock, flags); <--- Racy
}

And in queue exit path we do following.

cfq_exit_queue()
{
	spin_lock_irq(q->queue_lock);
		__cfq_exit_single_io_context {
			cic->key = cfqd_dead_key(cfqd);	
		}
	spin_unlock_irq(q->queue_lock);
	kfree(cfqd);	
}

In process exit path, we retrieve cfqd without any locks (Except rcu read
lock), and it might race with queue exit path. Resulting in the fact that
by the time we fetch queue pointer from cfqd, cfqd might have already been
freed.

I think issue here seems to be that we fetch cfqd = cic->key under rcu
but free up cfqd without waiting for rcu grace period.

If we introduce an unconditional synchronize_rcu() in cfq_exit_queue()
then it takes a long time for drivers which create lots of queues
and tear them down during boot.

If we use call_rcu() to free cfqd(), then there is no gurantee that
request queue object is still around. (cfqd->queue).

Even if we take request queue reference to keep request queue object,
then there is no gurantee that queue->lock is around as driver might
have freed it up.

Not sure how to fix this cleanly. Just thought of raising the concern
though while we are at it.

Thanks
Vivek
