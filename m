Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756195Ab2BWWbA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 17:31:00 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:51487 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755942Ab2BWWa7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 17:30:59 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of htejun@gmail.com designates 10.68.130.7 as permitted sender) smtp.mail=htejun@gmail.com; dkim=pass header.i=htejun@gmail.com
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, vgoyal@redhat.com, akpm@linux-foundation.org,
        hughd@google.com
Cc: avi@redhat.com, nate@cpanel.net, cl@linux-foundation.org,
        linux-kernel@vger.kernel.org, dpshah@google.com, ctalbott@google.com,
        rni@google.com
Subject: [PATCHSET] mempool, percpu, blkcg: fix percpu stat allocation and remove stats_lock
Date: Thu, 23 Feb 2012 14:30:38 -0800
Message-Id: <1330036246-21633-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, guys.

This patchset is combination of the patchset "block, mempool, percpu:
implement percpu mempool and fix blkcg percpu alloc deadlock" [1] and
patches to remove blkg->stats_lock.

* percpu mempool and percpu stat allocation

Andrew, Hugh, other than the fourth patch updated for the current
blkcg branch, all the mempool changes are the same as before.  I tried
several different approaches to remove the percpu stats but failed to
do so without introducing something even sillier, so unless we're
gonna break userland visible stats, we need some form of NOIO percpu
allocation mechanism.

I don't think implementing private allocation queue in blkcg proper is
a good option.  Doing it from percpu counter has the advantage of not
losing any count while percpu allocation is in progress but it feels
weird like a spoon which can be used as a screw driver.  So, it still
seems to me that utilizing mempool code is the least of all evils.

The plan is to isolate these percpu stats into blk-throttle and
implement soft failure for stat allocation failure, so simple
buffering with opportunistic refilling should do.

If people agree with this, I think it would be best to route these
changes through block/core along with other blkcg updates.  If
somebody still disagrees, scream.

* removal of blkg->stats_lock

After the recent plug merge updates, all non-percpu stats are updated
under queue_lock, so use u64_stats_sync instead of spinlock.

 0001-mempool-factor-out-mempool_fill.patch
 0002-mempool-separate-out-__mempool_create.patch
 0003-mempool-percpu-implement-percpu-mempool.patch
 0004-block-fix-deadlock-through-percpu-allocation-in-blk-.patch
 0005-blkcg-don-t-use-percpu-for-merged-stats.patch
 0006-blkcg-simplify-stat-reset.patch
 0007-blkcg-restructure-blkio_get_stat.patch
 0008-blkcg-remove-blkio_group-stats_lock.patch

0001-0003 implement percpu mempool.

0004 make blk-cgroup use it to fix the GFP_KERNEL allocation from IO
path bug.

0005-0008 replace blkg->stats_lock with u64_stats_sync.

This patchset is on top of

  block/for-linus 621032ad6e "block: exit_io_context() should call eleva..."
+ [2] blkcg: accumulated blkcg updates

and available in the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git blkcg-stats

Thanks.

 block/blk-cgroup.c      |  399 ++++++++++++++++++++++--------------------------
 block/blk-cgroup.h      |   29 ++-
 include/linux/mempool.h |   80 +++++++++
 mm/mempool.c            |  208 +++++++++++++++++++++----
 4 files changed, 462 insertions(+), 254 deletions(-)

--
tejun

[1] http://thread.gmane.org/gmane.linux.kernel/1232735
[2] http://thread.gmane.org/gmane.linux.kernel/1256355
