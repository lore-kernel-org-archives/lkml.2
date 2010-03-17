Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753773Ab0CQImu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 04:42:50 -0400
Received: from hera.kernel.org ([140.211.167.34]:59036 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753679Ab0CQImS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 04:42:18 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, sivanich@sgi.com,
       heiko.carstens@de.ibm.com, torvalds@linux-foundation.org, mingo@elte.hu,
       dipankar@in.ibm.com, josh@freedesktop.org, paulmck@linux.vnet.ibm.com,
       oleg@redhat.com, akpm@linux-foundation.org, peterz@infradead.org,
       arjan@infradead.org
Subject: [PATCHSET sched/core] cpuhog: implement and use cpuhog, take#2
Date: Wed, 17 Mar 2010 17:40:47 +0900
Message-Id: <1268815251-31407-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 17 Mar 2010 08:41:10 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This is the second take of cpuhog patchset which implements a
simplistic cpu monopolization mechanism and reimplements
stop_machine() and replaces migration_thread with it.

This allows stop_machine() to be simpler and much more efficient on
very large machines without using more resources while also making the
rather messy overloaded migration_thread usages cleaner.

This should solve the slow boot problem[1] caused by repeated
stop_machine workqueue creation/destruction reported by Dimitri
Sivanich.

Changes from the last take[L] are

* cpuhog callbacks are no longer allowed to sleep.  preemption is
  disabled around them.

* Patches are rebased on top of sched/core.

This patchset contains the following four patches.

 0001-cpuhog-implement-cpuhog.patch
 0002-stop_machine-reimplement-using-cpuhog.patch
 0003-scheduler-replace-migration_thread-with-cpuhog.patch
 0004-scheduler-kill-paranoia-check-in-synchronize_sched_e.patch

Tested cpu on/offlining, shutdown, all migration usage paths including
RCU torture test at 0003 and 004 and everything seems to work fine
here.

Peter suggested reusing stop_cpu/machine() names instead of
introducing new hog_* names.  While renaming definitely is an option,
I think it's better to keep the distinction between
stop_{cpu|machine}() and this maximum priority scheduler based
monopolization mechanism.

hog_[one_]cpu[s]() schedule highest priority task to monopolize the
upper half of cpu[s] but doesn't affect contextless part of the cpu
(hard/soft irq, bh, tasklet...) nor does it coordinate with each other
to make sure all the cpus are synchronized while executing the
callbacks.  In that sense, it is the lowest bottom of upper half but
not quite stopping the cpu or the machine and I think the distinction
is meaningful to make.  Now that the callbacks are not allowed to
sleep, they really 'hog' the target cpus too.

I wanted to avoid verbs associated with the traditional workqueue -
schedule and queue, while emphasizing that this is something that you
don't want to abuse - so the verb hog.  monopolize_cpu() was the
second choice but hog is shorter and can be used as a noun as-is, so I
chose hog.  If you like/dislike the name, please let me know.

If Rusty and RCU people agree (where are you? :-), I think it would be
the easiest to route the whole thing through sched tree so I rebased
it on top of sched/core.  Again, if you disagree, please let me know.

The tree is available in the following git tree.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git cpuhog

diffstat follows.

 Documentation/RCU/torture.txt |   10 -
 arch/s390/kernel/time.c       |    1 
 drivers/xen/manage.c          |   14 -
 include/linux/cpuhog.h        |   24 ++
 include/linux/rcutiny.h       |    2 
 include/linux/rcutree.h       |    1 
 include/linux/stop_machine.h  |   20 --
 kernel/Makefile               |    2 
 kernel/cpu.c                  |    8 
 kernel/cpuhog.c               |  368 ++++++++++++++++++++++++++++++++++++++++++
 kernel/module.c               |   14 -
 kernel/rcutorture.c           |    2 
 kernel/sched.c                |  282 +++++---------------------------
 kernel/sched_fair.c           |   39 ++--
 kernel/stop_machine.c         |  162 ++++--------------
 15 files changed, 511 insertions(+), 438 deletions(-)

Thanks.

--
tejun

[1] http://thread.gmane.org/gmane.linux.kernel/957726
[L] http://thread.gmane.org/gmane.linux.kernel/958743
