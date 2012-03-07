Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757650Ab2CGXIL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 18:08:11 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:52357 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095Ab2CGXIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 18:08:07 -0500
Date: Wed, 7 Mar 2012 15:08:06 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Tejun Heo <tj@kernel.org>
Cc: Vivek Goyal <vgoyal@redhat.com>, axboe@kernel.dk, hughd@google.com,
        avi@redhat.com, nate@cpanel.net, cl@linux-foundation.org,
        linux-kernel@vger.kernel.org, dpshah@google.com, ctalbott@google.com,
        rni@google.com
Subject: Re: [PATCHSET] mempool, percpu, blkcg: fix percpu stat allocation
 and remove stats_lock
Message-Id: <20120307150806.1804a8b1.akpm@linux-foundation.org>
In-Reply-To: <20120307225629.GE30676@google.com>
References: <20120305221321.GF1263@google.com>
	<20120306210954.GF32148@redhat.com>
	<20120306132034.ecaf8b20.akpm@linux-foundation.org>
	<20120306213437.GG32148@redhat.com>
	<20120306135531.828ca78e.akpm@linux-foundation.org>
	<20120307145556.GA11262@redhat.com>
	<20120307170544.GA30676@google.com>
	<20120307191334.GG13430@redhat.com>
	<20120307192219.GC30676@google.com>
	<20120307194229.GH13430@redhat.com>
	<20120307225629.GE30676@google.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Mar 2012 14:56:29 -0800
Tejun Heo <tj@kernel.org> wrote:

> On Wed, Mar 07, 2012 at 02:42:29PM -0500, Vivek Goyal wrote:
> > blk-cgroup: Alloc per cpu stats from worker thread in a delayed manner
> > 
> > Current per cpu stat allocation assumes GFP_KERNEL allocation flag. But in
> > IO path there are times when we want GFP_NOIO semantics. As there is no
> > way to pass the allocation flags to alloc_percpu(), this patch delays the
> > allocation of stats using a worker thread.
> > 
> > v2-> tejun suggested following changes. Changed the patch accordingly.
> > 	- move alloc_node location in structure
> > 	- reduce the size of names of some of the fields
> > 	- Reduce the scope of locking of alloc_list_lock
> > 	- Simplified stat_alloc_fn() by allocating stats for all
> > 	  policies in one go and then assigning these to a group.
> > 
> > v3 -> Andrew suggested to put some comments in the code. Also raised
> >       concerns about trying to allocate infinitely in case of allocation
> >       failure. I have changed the logic to sleep for 10ms before retrying.
> >       That should take care of non-preemptible UP kernels.
> > 
> > v4 -> Tejun had more suggestions.
> > 	- drop list_for_each_entry_all()
> > 	- instead of msleep() use queue_delayed_work()
> > 	- Some cleanups realted to more compact coding.
> >  
> > v5-> tejun suggested more cleanups leading to more compact code.
> > 
> > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> 
> Looks good to me.  I'll roll it into the stats series.  Andrew, if you
> still have objections, please scream.

Just the "msleep adds to load average" issue needs thinking about.

It's rather a miserable patch :(
