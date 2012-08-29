Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754424Ab2H2Qus (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 12:50:48 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49041 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754172Ab2H2QuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 12:50:11 -0400
Date: Wed, 29 Aug 2012 09:50:06 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, tj@kernel.org, vgoyal@redhat.com,
        bharrosh@panasas.com, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v7 9/9] block: Avoid deadlocks with bio allocation by
 stacking drivers
Message-ID: <20120829165006.GB20312@google.com>
References: <1346175456-1572-1-git-send-email-koverstreet@google.com>
 <1346175456-1572-10-git-send-email-koverstreet@google.com>
 <Pine.LNX.4.64.1208291210180.774@file.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1208291210180.774@file.rdu.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 29, 2012 at 12:24:43PM -0400, Mikulas Patocka wrote:
> Hi
> 
> This fixes the bio allocation problems, but doesn't fix a similar deadlock 
> in device mapper when allocating from md->io_pool or other mempools in 
> the target driver.

Ick. That is a problem.

There are a bunch of mempools in drivers/md too :(

Though honestly bio_sets have the front_pad thing for a reason, for per
bio state it makes sense to use that anyways - simpler code because
you're doing fewer explicit allocations and more efficient too.

So I wonder if we fixed that if it'd still be a problem.

The other thing we could do is make the rescuer thread per block device
(which arguably makes more sense than per bio_set anyways), then
associate bio_sets with specific block devices/rescuers.

Then the rescuer code can be abstracted out from the bio allocation
code, and we just create a thin wrapper around mempool_alloc() that does
the same dance bio_alloc_bioset() does now.

I think that'd be pretty easy and work out really nicely.

> The problem is that majority of device mapper code assumes that if we 
> submit a bio, that bio will be finished in a finite time. The commit 
> d89d87965dcbe6fe4f96a2a7e8421b3a75f634d1 in 2.6.22 broke this assumption.
> 
> I suggest - instead of writing workarounds for this current->bio_list 
> misbehavior, why not remove current->bio_list at all? We could revert 
> d89d87965dcbe6fe4f96a2a7e8421b3a75f634d1, allocate a per-device workqueue, 
> test stack usage in generic_make_request, and if it is too high (more than 
> half of the stack used, or so), put the bio to the target device's 
> blockqueue.
> 
> That could be simpler than allocating per-bioset workqueue and it also 
> solves more problems (possible deadlocks in dm).

It certainly would be simpler, but honestly the potential for
performance regressions scares me (and bcache at least is used on fast
enough devices where it's going to matter). Also it's not so much the
performance overhead - we can just measure that - it's that if we're
just using the workqueue code the scheduler's getting involved and we
can't just measure what the effects of that are going to be in
production.
