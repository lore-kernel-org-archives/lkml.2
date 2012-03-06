Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759167Ab2CFVze (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 16:55:34 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42619 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756390Ab2CFVzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 16:55:33 -0500
Date: Tue, 6 Mar 2012 13:55:31 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, axboe@kernel.dk, hughd@google.com,
        avi@redhat.com, nate@cpanel.net, cl@linux-foundation.org,
        linux-kernel@vger.kernel.org, dpshah@google.com, ctalbott@google.com,
        rni@google.com
Subject: Re: [PATCHSET] mempool, percpu, blkcg: fix percpu stat allocation
 and remove stats_lock
Message-Id: <20120306135531.828ca78e.akpm@linux-foundation.org>
In-Reply-To: <20120306213437.GG32148@redhat.com>
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
	<20120306213437.GG32148@redhat.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Mar 2012 16:34:37 -0500
Vivek Goyal <vgoyal@redhat.com> wrote:

> On Tue, Mar 06, 2012 at 01:20:34PM -0800, Andrew Morton wrote:
> 
> > > +	for (i = 0; i < BLKIO_NR_POLICIES; i++) {
> > > +		if (pcpu_stats[i] != NULL)
> > > +			continue;
> > > +
> > > +		pcpu_stats[i] = alloc_percpu(struct blkio_group_stats_cpu);
> > > +		if (pcpu_stats[i] == NULL)
> > > +			goto alloc_stats;
> > 
> > hoo boy that looks like an infinite loop.  What's going on here?
> 
> If allocation fails, I am trying to allocate it again in infinite loop.
> What should I do? Try it after sleeping a bit? Or give up after certain
> number of tries? This is in worker thread context though, so main IO path
> is not impacted.

On a non-preemptible unprocessor kernel it's game over, isn't it? 
Unless someone frees some memory from interrupt context it is time for
the Big Red Button.

I'm not sure what to suggest, really - if an allocation failed then
there's nothing the caller can reliably do to fix that.  The best
approach is to fail all the way back to userspace with -ENOMEM.

In this context I suppose you could drop a warning into the logs then
bale out and retry on the next IO attempt.


> [..]
> > > +		}
> > > +		list_del_init(&blkg->alloc_node);
> > > +		break;
> > > +	}
> > > +	spin_unlock(&alloc_list_lock);
> > > +	spin_unlock_irq(&blkio_list_lock);
> > > +	goto alloc_stats;
> > > +}
> > 
> > So the function runs until alloc_list is empty.  Very mysterious.
> 
> Yes. Once alloc_list is empty, we know there are no groups needing 
> per cpu stat allocation and worker exits. Once a new group is created
> it will be added to the list and work will be scheduled again.
> 

Oh, is that what alloc_list does ;)


btw, speaking of uniprocessor: please do perform a uniprocessor build
and see what impact the patch has upon the size(1) output for the .o
files.  We should try to minimize the pointless bloat for the UP
kernel.
