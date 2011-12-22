Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756011Ab1LVVpf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 16:45:35 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:37320 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752932Ab1LVVpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 16:45:33 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org, avi@redhat.com, nate@cpanel.net,
        cl@linux-foundation.org, oleg@redhat.com, axboe@kernel.dk,
        vgoyal@redhat.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCHSET] block, mempool, percpu: implement percpu mempool and fix blkcg percpu alloc deadlock
Date: Thu, 22 Dec 2011 13:45:19 -0800
Message-Id: <1324590326-10135-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, guys.

This patchset implements mempool for percpu memory and use it to solve
allocation deadlock problem in block cgroup paths.  Percpu memory
allocator can't be called from memory reclaim path, mostly because its
on-demand chunk filling hooks into vmalloc area management, which in
turn hooks into arch pagetable code.

This usually isn't a problem but block cgroup code wants to do
opportunistic percpu allocation to track statistics in IO issue path.
Currently, it directly calls alloc_percpu() from IO path triggering
lockdep warning and falling into deadlocks under the right conditions.

This patchset adds percpu mempool which supports async refilling and
uses that as allocation buffer to solve the above problem.  It solves
the problem for the next merge window but I'm not sure about what to
do about this window and -stable.  The mempool updates seems a bit too
invasive.  Maybe implement a stripped down allocation buffer in
block-cgroup?

This patchset contains the following seven patches.

 0001-mempool-fix-and-document-synchronization-and-memory-.patch
 0002-mempool-drop-unnecessary-and-incorrect-BUG_ON-from-m.patch
 0003-mempool-fix-first-round-failure-behavior.patch
 0004-mempool-factor-out-mempool_fill.patch
 0005-mempool-separate-out-__mempool_create.patch
 0006-mempool-percpu-implement-percpu-mempool.patch
 0007-block-fix-deadlock-through-percpu-allocation-in-blk-.patch

0001-0003 are general mempool updates and already in -mm.  Note that
Oleg has an alternative patch for 0003 which seems better to me.

0004-0006 prepare for and implement percpu mempool.

0007 uses it in block cgroup to fix the deadlock problem.

This patchset is on top of block/for-3.3/core but applies on mainline
too.

If people agree with this approach, it would probably be easier to
route everything through block, I think.  Andrew, Jens, how do you
guys want to route these?

Oleg, if you can send patch with proper description and SOB, I'll
replace 0003 with yours.

The patchset is also available in the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git block-blkcg-pcpu-fix

and contains the following changes.

 block/blk-cgroup.c      |   37 +++++
 block/blk-cgroup.h      |    2 
 block/blk-throttle.c    |    2 
 block/cfq-iosched.c     |    2 
 include/linux/mempool.h |   80 ++++++++++++
 mm/mempool.c            |  310 +++++++++++++++++++++++++++++++++++++-----------
 6 files changed, 363 insertions(+), 70 deletions(-)

Thanks.

--
tejun
