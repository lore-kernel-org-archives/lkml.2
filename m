Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757872Ab2CHSyK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 13:54:10 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:48276 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757493Ab2CHSyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 13:54:07 -0500
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, vgoyal@redhat.com
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, dpshah@google.com,
        ctalbott@google.com, rni@google.com
Subject: [PATCHSET] blkcg: fix percpu stat allocation and remove stats_lock, take#2
Date: Thu,  8 Mar 2012 10:53:55 -0800
Message-Id: <1331232840-16044-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, guys.

This patchset is another retry at fixing percpu stat allocation and
removing stats_lock.  From the last try[L], percpu mempool stuff is
replaced with in-blkcg delayed allocation using work item.  Other than
that, the rest of the patchset remain the same.

Vivek, I made some minor adjustments to your percpu alloc patch.
Also, your patch fixes the suspicious RCU deref warning, which was
caused by blkg_alloc() needing sleepable context from the first place.
I added a note for that in the commit message.

  0001-blkcg-alloc-per-cpu-stats-from-worker-thread-in-a-de.patch
  0002-blkcg-don-t-use-percpu-for-merged-stats.patch
  0003-blkcg-simplify-stat-reset.patch
  0004-blkcg-restructure-blkio_get_stat.patch
  0005-blkcg-remove-blkio_group-stats_lock.patch

0001 fix blkcg per cpu stat allocation by implementing delayed
allocation in blkcg proper using a work item.

0002-0005 replace blkg->stats_lock with u64_stats_sync.

This patchset is on top of the current block/for-3.4/core - 671058fb2a
"block: make blk-throttle preserve the issuing task on delayed bios".

and available in the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git blkcg-stats

Thanks.

 block/blk-cgroup.c |  466 ++++++++++++++++++++++++++---------------------------
 block/blk-cgroup.h |   31 ++-
 2 files changed, 257 insertions(+), 240 deletions(-)

--
tejun

[L] http://thread.gmane.org/gmane.linux.kernel/1257428
