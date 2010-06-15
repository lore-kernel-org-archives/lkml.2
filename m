Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932163Ab0FOOW5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 10:22:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52846 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757820Ab0FOOW4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 10:22:56 -0400
Date: Tue, 15 Jun 2010 16:22:19 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Mel Gorman <mel@csn.ul.ie>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
       Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>, Nick Piggin <npiggin@suse.de>,
       Rik van Riel <riel@redhat.com>
Subject: Re: [RFC PATCH 0/6] Do not call ->writepage[s] from direct reclaim
 and use a_ops->writepages() where possible
Message-ID: <20100615142219.GE28052@random.random>
References: <1275987745-21708-1-git-send-email-mel@csn.ul.ie>
 <20100615140011.GD28052@random.random>
 <20100615141122.GA27893@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100615141122.GA27893@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 15, 2010 at 10:11:22AM -0400, Christoph Hellwig wrote:
> On Tue, Jun 15, 2010 at 04:00:11PM +0200, Andrea Arcangeli wrote:
> > collecting clean cache doesn't still satisfy the allocation), during
> > allocations in direct reclaim and increase the THREAD_SIZE than doing
> > this purely for stack reasons as the VM will lose reliability if we
> 
> This basically means doubling the stack size, as you can splice together
> two extremtly stack hungry codepathes in the worst case.  Do you really
> want order 2 stack allocations?

If we were forbidden to call ->writepage just because of stack
overflow yes as I don't think it's big deal with memory compaction and
I see this as a too limiting design to allow ->writepage only in
kernel thread. ->writepage is also called by the pagecache layer,
msync etc.. not just by kswapd.

But let's defer this after we have any resemblance of hard numbers of
worst-case stack usage measured during the aforementioned workload, I
didn't read all the details as I'm quite against this design, but I
didn't see any stack usage number or any sign of stack-overflow debug
triggering. I'd suggest to measure the max stack usage first and worry
later.

And if ->writepage is a stack hog in some fs, I'd rather see
->writepage made less stack hungry (with proper warning at runtime
with debug option enabled) than vetoed. The VM itself shouldn't be a
stack hog already. I don't see a particular reason why writepage
should be so stuck hungry compared to the rest of the kernel, it just
have to do I/O, if it requires complex data structure it should
kmalloc those and stay light on stack as everybody else.

And if something I'm worried more about slab shrink than ->writepage
as that enters the vfs layer and then the lowlevel fs to collect the
dentry, inode etc...
