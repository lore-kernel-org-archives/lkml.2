Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754376Ab0IPLYa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 07:24:30 -0400
Received: from hera.kernel.org ([140.211.167.34]:40134 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753785Ab0IPLYZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 07:24:25 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, oleg@redhat.com
Cc: dmitry.torokhov@gmail.com
Subject: [PATCHSET] workqueue: implement alloc_ordered_workqueue() and flush[_delayed]_work_sync()
Date: Thu, 16 Sep 2010 13:24:03 +0200
Message-Id: <1284636247-4734-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 16 Sep 2010 11:24:11 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patchset implements new workqueue API fucntions -
alloc_ordered_workqueue() and flush[_delayed]_work_sync().

The former is rather straight-forward replacement for
alloc_singlethread/frozen_workqueue().

The latter two are similar to cancel[_delayed]_work_sync() but wait
for the work to finish execution rather than cancelling them.  These
syncing flushes make sure that works which were queued on multiple
workqueues or a reentrant workqueues have finished execution on all
CPUs.  One usage of these new flushes is replacing
flush_scheduled_works() with finer scoped flushes.

This patchset contains the following four patches.

 0001-workqueue-implement-alloc_ordered_workqueue.patch
 0002-workqueue-cleanup-flush-cancel-functions.patch
 0003-workqueue-factor-out-start_flush_work.patch
 0004-workqueue-implement-flush-_delayed-_work_sync.patch

0001 adds alloc_ordered_workqueue().  0002-0003 prepare for syncing
flushes.  0004 implements them.

Dmitry, as I wrote before, I think serio should be able to simply use
schedule_work() combined with flush_work_sync() implemented by this
patchset.  Would this work for you?

The patches are available in the following git tree.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git review-flush_sync

and contains the following changes.

 include/linux/workqueue.h |   38 +++++-
 kernel/workqueue.c        |  265 +++++++++++++++++++++++++++++-----------------
 2 files changed, 201 insertions(+), 102 deletions(-)

Thanks.

--
tejun
