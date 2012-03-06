Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932101Ab2CFVes (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 16:34:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55964 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757578Ab2CFVer (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 16:34:47 -0500
Date: Tue, 6 Mar 2012 16:34:37 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>, axboe@kernel.dk, hughd@google.com,
        avi@redhat.com, nate@cpanel.net, cl@linux-foundation.org,
        linux-kernel@vger.kernel.org, dpshah@google.com, ctalbott@google.com,
        rni@google.com
Subject: Re: [PATCHSET] mempool, percpu, blkcg: fix percpu stat allocation
 and remove stats_lock
Message-ID: <20120306213437.GG32148@redhat.com>
References: <20120223231204.GM22536@google.com>
 <20120224142033.GA5095@redhat.com>
 <20120225214421.GA3401@dhcp-172-17-108-109.mtv.corp.google.com>
 <20120227031146.GA25187@redhat.com>
 <20120227091141.GG3401@dhcp-172-17-108-109.mtv.corp.google.com>
 <20120227194321.GF27677@redhat.com>
 <20120229173639.GB5930@redhat.com>
 <20120305221321.GF1263@google.com>
 <20120306210954.GF32148@redhat.com>
 <20120306132034.ecaf8b20.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120306132034.ecaf8b20.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 06, 2012 at 01:20:34PM -0800, Andrew Morton wrote:

[..]
> > @@ -391,6 +400,9 @@ void blkiocg_update_dispatch_stats(struc
> >  	struct blkio_group_stats_cpu *stats_cpu;
> >  	unsigned long flags;
> >  
> > +	if (pd->stats_cpu == NULL)
> > +		return;
> 
> Maybe add a comment explaining how this comes about?  It isn't very
> obvious..
> 

Will do. This basically says that if stats are not allocated yet, return
and don't try to account anything.

[..]
> > +static void blkio_stat_alloc_fn(struct work_struct *work)
> > +{
> > +
> > +	struct blkio_group *blkg, *n;
> > +	int i;
> > +
> > +alloc_stats:
> > +	spin_lock_irq(&alloc_list_lock);
> > +		if (list_empty(&alloc_list)) {
> > +			/* Nothing to do */
> 
> That's not a very helpful comment, given that we weren't told what the
> function is supposed to do in the first place.

Will add some comments. Once we create a new group, we add it to the 
linked list and wake up the worker thread. This is the work function which
is run by worker thread. Once it finds that list is empty, it knows there
is no group waiting for allocation and worker exits.

> > +	for (i = 0; i < BLKIO_NR_POLICIES; i++) {
> > +		if (pcpu_stats[i] != NULL)
> > +			continue;
> > +
> > +		pcpu_stats[i] = alloc_percpu(struct blkio_group_stats_cpu);
> > +		if (pcpu_stats[i] == NULL)
> > +			goto alloc_stats;
> 
> hoo boy that looks like an infinite loop.  What's going on here?

If allocation fails, I am trying to allocate it again in infinite loop.
What should I do? Try it after sleeping a bit? Or give up after certain
number of tries? This is in worker thread context though, so main IO path
is not impacted.

[..]
> > +		}
> > +		list_del_init(&blkg->alloc_node);
> > +		break;
> > +	}
> > +	spin_unlock(&alloc_list_lock);
> > +	spin_unlock_irq(&blkio_list_lock);
> > +	goto alloc_stats;
> > +}
> 
> So the function runs until alloc_list is empty.  Very mysterious.

Yes. Once alloc_list is empty, we know there are no groups needing 
per cpu stat allocation and worker exits. Once a new group is created
it will be added to the list and work will be scheduled again.

Thanks
Vivek
