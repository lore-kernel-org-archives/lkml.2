Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753047Ab2IJWJR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 18:09:17 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43169 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750841Ab2IJWJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 18:09:15 -0400
Date: Mon, 10 Sep 2012 15:09:10 -0700
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, axboe@kernel.dk, Vivek Goyal <vgoyal@redhat.com>,
        Mikulas Patocka <mpatocka@redhat.com>, bharrosh@panasas.com,
        david@fromorbit.com
Subject: Re: [PATCH 2/2] block: Avoid deadlocks with bio allocation by
 stacking drivers
Message-ID: <20120910220910.GB7677@google.com>
References: <1347055973-11581-1-git-send-email-koverstreet@google.com>
 <1347055973-11581-3-git-send-email-koverstreet@google.com>
 <20120908193641.GB12773@dhcp-172-17-108-109.mtv.corp.google.com>
 <20120910002810.GA23241@moria.home.lan>
 <20120910172210.GC14103@google.com>
 <20120910202435.GG16360@google.com>
 <20120910204010.GA32310@google.com>
 <20120910213349.GH16360@google.com>
 <20120910213710.GA7677@google.com>
 <20120910215633.GA19739@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120910215633.GA19739@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Kent.

On Mon, Sep 10, 2012 at 02:56:33PM -0700, Kent Overstreet wrote:
> commit df7e63cbffa3065fcc4ba2b9a93418d7c7312243
> Author: Kent Overstreet <koverstreet@google.com>
> Date:   Mon Sep 10 14:33:46 2012 -0700
> 
>     block: Avoid deadlocks with bio allocation by stacking drivers
>     
>     Previously, if we ever try to allocate more than once from the same bio
>     set while running under generic_make_request() (i.e. a stacking block
>     driver), we risk deadlock.
>     
>     This is because of the code in generic_make_request() that converts
>     recursion to iteration; any bios we submit won't actually be submitted
>     (so they can complete and eventually be freed) until after we return -
>     this means if we allocate a second bio, we're blocking the first one
>     from ever being freed.
>     
>     Thus if enough threads call into a stacking block driver at the same
>     time with bios that need multiple splits, and the bio_set's reserve gets
>     used up, we deadlock.
>     
>     This can be worked around in the driver code - we could check if we're
>     running under generic_make_request(), then mask out __GFP_WAIT when we
>     go to allocate a bio, and if the allocation fails punt to workqueue and
>     retry the allocation.
>     
>     But this is tricky and not a generic solution. This patch solves it for
>     all users by inverting the previously described technique. We allocate a
>     rescuer workqueue for each bio_set, and then in the allocation code if
>     there are bios on current->bio_list we would be blocking, we punt them
>     to the rescuer workqueue to be submitted.
>     
>     This guarantees forward progress for bio allocations under
>     generic_make_request() provided each bio is submitted before allocating
>     the next, and provided the bios are freed after they complete.
>     
>     Note that this doesn't do anything for allocation from other mempools.
>     Instead of allocating per bio data structures from a mempool, code
>     should use bio_set's front_pad.
>     
>     Tested it by forcing the rescue codepath to be taken (by disabling the
>     first GFP_NOWAIT) attempt, and then ran it with bcache (which does a lot
>     of arbitrary bio splitting) and verified that the rescuer was being
>     invoked.
>     
>     Signed-off-by: Kent Overstreet <koverstreet@google.com>
>     CC: Jens Axboe <axboe@kernel.dk>

I'm still a bit scared but think this is correct.

 Acked-by: Tejun Heo <tj@kernel.org>

One last thing is that we may want to add @name on bioset creation so
that we can name the workqueue properly but that's for another patch.

Thanks.

-- 
tejun
