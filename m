Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753394Ab2APHWd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 02:22:33 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58062 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752618Ab2APHWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 02:22:32 -0500
Date: Sun, 15 Jan 2012 23:22:26 -0800
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jens Axboe <axboe@kernel.dk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Block IO bits for 3.3-rc
Message-ID: <20120116072226.GA3399@mtj.dyndns.org>
References: <4F12A025.2090207@kernel.dk>
 <CA+55aFxyiMXg0BHrZ0LJtCeE+u+pNSM1n=zDbW5-7CtZnh2O=Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxyiMXg0BHrZ0LJtCeE+u+pNSM1n=zDbW5-7CtZnh2O=Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sun, Jan 15, 2012 at 12:33:20PM -0800, Linus Torvalds wrote:
> On Sun, Jan 15, 2012 at 1:45 AM, Jens Axboe <axboe@kernel.dk> wrote:
> > See below for the initial 3.3-rc1 git pull request in the block IO area.
> > Not too much queued up for this round, mostly some code churn to improve
> > some of the existing functionality.
> >
> > It has the following changes:
> >
> > - The big io context cleanup from Tejun.
> 
> Ok. This got some conflicts that I think I got right, but I'd really
> like Tejun to check it out. There were changes mainly to things he had
> removed, and I think all the changes were made irrelevant by his
> cleanups, but...

In cfq-iosched.c, there were the following three mainline commits
which weren't in the block branch.

- 2984ff38cc "cfq-iosched: free cic_index if blkio_alloc_blkg_stats fails"

	This fixes cic->cic_index freeing in alloc failure path.
	cic_index got moved to q->id which is allocated in
	blk_alloc_queue_node() and properly freed after any failure.
	This doesn't cause any conflict per-se but causes compiler
	failure as cic_index no longer exists.  Changes made by this
	patch should be removed.

- 5eb46851de "cfq-iosched: fix cfq_cic_link() race confition"

	This fixes install race handling in unlock-alloc-lock-install
	sequence.  The logic got moved to ioc_create_icq() which
	already deals with it properly.  Ignoring conflict and
	removing the conflicted part from mainline should do.

- 6ae0516b8a "block, cfq: fix empty queue crash caused by request merge"

	The same commit existed in block as 4a0b75c7d0.  Nothing to
	do.

In blk-ioc.c, the following commit.

- bb9d97b6df "cgroup: don't use subsys->can_attach_task() or ->attach_task()"

	It conflicts with three block commits updating how ioc is
	obtained and the changed flag is set.  Putting the updated
	per-task logic from block inside cgroup_taskset_for_each()
	loop is the correct resolution.

So, yeap, my merge matches yours exactly and everything looks good to
me.

Thanks.

--
tejun
