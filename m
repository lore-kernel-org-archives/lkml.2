Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757418Ab2CSWLK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 18:11:10 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:64547 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757010Ab2CSWLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 18:11:07 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, vgoyal@redhat.com
Cc: linux-kernel@vger.kernel.org, ctalbott@google.com, rni@google.com
Subject: [PATCHSET] block: remove ioc_*_changed()
Date: Mon, 19 Mar 2012 15:10:55 -0700
Message-Id: <1332195059-2750-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, guys.

The changed notification used by cfq is rather odd.  cfq caches the
associated cfqqs per cic and uses the changed notification to expire
those lookup caches.

The explicit notification mechanism might make sense if determining
whether the current cache is up-to-date is difficult or expensive;
however, that isn't the case here.  Determining whether ioprio or
cgroup has changed is straight-forward and inexpensive.

This patchset updates cfq to so that it remembers the current ioprio
and blkcg in the cic and determines whether cfqq's need to be reset
without using the changed notification and drops the changed
notification code.

 0001-blkcg-add-blkcg-id.patch
 0002-cfq-pass-around-cfq_io_cq-instead-of-io_context.patch
 0003-cfq-don-t-use-icq_get_changed.patch
 0004-block-remove-ioc_-_changed.patch

0001 adds unique u64 id to each blkcg so that policies can tell
whether the associated blkcg has changed.

0002 makes cfq pass around cic internally instead of ioc.  This is a
cleanup in itself and necessary for the next patch.

0003 updates cfq to not use changed notification.

0004 removes code implementing changed notification.

This patchset is on top of

  block/for-3.4/core 671058fb2a2aac4e70f01b316b06bc59b98bd138
+ [1] blkcg: fix percpu stat allocation and remove stats_lock, take#2

and available in the following git branch

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git blk-ioc-remove-changed

Thanks.

 block/blk-cgroup.c        |   22 +----------
 block/blk-cgroup.h        |    3 +
 block/blk-ioc.c           |   68 ----------------------------------
 block/cfq-iosched.c       |   92 ++++++++++++++++++++++++++--------------------
 fs/ioprio.c               |    2 -
 include/linux/iocontext.h |    7 ---
 include/linux/ioprio.h    |   22 ++---------
 7 files changed, 64 insertions(+), 152 deletions(-)

--
tejun

[1] http://thread.gmane.org/gmane.linux.kernel/1263989
