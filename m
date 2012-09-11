Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754080Ab2IKWYZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 18:24:25 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60776 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752001Ab2IKWYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 18:24:21 -0400
Date: Tue, 11 Sep 2012 15:24:16 -0700
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [GIT PULL] workqueue fixes for 3.6-rc5
Message-ID: <20120911222416.GI7677@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

Please consider pulling from the following branch to receive workqueue
fixes.  It's later than I'd like but well the timing just didn't work
out this time.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git for-3.6-fixes

There are three bug fixes.  One from before 3.6-rc1 and two from the
new CPU hotplug code.  Kudos to Lai for discovering all of them and
providing fixes.

* Atomicity bug when clearing a flag and setting another.  The two
  operation should have been atomic but wasn't.  This bug has existed
  for a long time but is unlikely to have actually happened.  Fix is
  safe.  Marked for -stable.

* If CPU hotplug cycles happen back-to-back before workers finish the
  previous cycle, the states could get out of sync and it could get
  stuck.  Fixed by waiting for workers to complete before finishing
  hotplug cycle.

* While CPU hotplug is in progress, idle workers could be depleted
  which can then lead to deadlock.  I think both happening together is
  highly unlikely but still better to fix it and the fix isn't too
  scary.

Lai Jiangshan (3):
      workqueue: UNBOUND -> REBIND morphing in rebind_workers() should be atomic
      workqueue: restore POOL_MANAGING_WORKERS
      workqueue: fix possible idle worker depletion across CPU hotplug

Tejun Heo (2):
      workqueue: move WORKER_REBIND clearing in rebind_workers() to the end of the function
      workqueue: fix possible deadlock in idle worker rebinding

 kernel/workqueue.c |  110 ++++++++++++++++++++++++++++++++++++++++++----------
 1 files changed, 89 insertions(+), 21 deletions(-)

Thanks.

--
tejun
