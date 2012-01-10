Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756677Ab2AJS2h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 13:28:37 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:33972 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756657Ab2AJS2g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 13:28:36 -0500
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, mingo@redhat.com, rostedt@goodmis.org, fweisbec@gmail.com,
        teravest@google.com, slavapestov@google.com, ctalbott@google.com,
        dhsharp@google.com
Cc: linux-kernel@vger.kernel.org, winget@google.com, namhyung@gmail.com
Subject: [RFC PATCHSET take#2] ioblame: IO tracer with origin tracking
Date: Tue, 10 Jan 2012 10:28:17 -0800
Message-Id: <1326220106-5765-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, guys.

Even with blktrace and tracepoints, getting insight into the IOs going
on a system is very challenging.  A lot of IO operations happen long
after the action which triggered the IO finished and the overall
asynchronous nature of IO operations make it difficult to trace back
the origin of a given IO.

ioblame is an attempt at providing better visibility into overall IO
behavior.  ioblame hooks into various tracepoints and tries to
determine who caused any given IO how and charges the IO accordingly.

On each IO completion, ioblame knows who to charge the IO (task), how
the IO got triggered (stack trace at the point of triggering, be it
page, inode dirtying or direct IO issue) and various information about
the IO itself (offset, size, how long it took and so on).  ioblame
exports this information via ioblame:ioblame_io tracepoint.

For more details, please read Documentation/trace/ioblame.txt.

Changes from the last take[L] are,

* Per Namhyung's suggestion, in-kernel statistics gathering stripped
  out.  All information is now exported through a tracepoint per each
  IO.  This makes a lot of stuff unnecessary and over 1500 lines of
  code have been removed.

* block_bio_complete tracepoint patch will result in duplicate
  BLK_TA_COMPLETE notifications.  Namhyung is working on proper
  solution.  For now, SOB is removed from the patch.

* Trace filter is no longer used and patches dropped from the series.

* Rebased on top of v3.2.

This patchset contains the following 9 patches.

  0001-block-abstract-disk-iteration-into-disk_iter.patch
  0002-block-block_bio_complete-tracepoint-was-missing.patch
  0003-block-add-req-to-bio_-front-back-_merge-tracepoints.patch
  0004-writeback-move-struct-wb_writeback_work-to-writeback.patch
  0005-writeback-add-more-tracepoints.patch
  0006-block-add-block_touch_buffer-tracepoint.patch
  0007-vfs-add-fcheck-tracepoint.patch
  0008-stacktrace-implement-save_stack_trace_quick.patch
  0009-block-trace-implement-ioblame-IO-tracer-with-origin-.patch

0001-0004 update block layer in preparation.

0005-0007 add more tracepoints along the IO stack.

0008 adds nimbler backtrace dump function as ioblame dumps stacktrace
extremely frequently.

0009 implements ioblame.

This is still in early stage and I haven't done much performance
analysis yet.  Tentative testing shows it adds ~20% CPU overhead when
used on memory backed loopback device.

The patches are on top of v3.2 and available in the following git
branch.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git review-ioblame

diffstat follows.

 Documentation/trace/ioblame.txt   |  476 +++++++
 arch/x86/include/asm/stacktrace.h |    2 
 arch/x86/kernel/stacktrace.c      |   40 
 block/blk-core.c                  |    5 
 block/genhd.c                     |   98 +
 fs/bio.c                          |    3 
 fs/fs-writeback.c                 |   34 
 fs/super.c                        |    2 
 include/linux/blk_types.h         |    4 
 include/linux/buffer_head.h       |    7 
 include/linux/fdtable.h           |    3 
 include/linux/fs.h                |    3 
 include/linux/genhd.h             |   13 
 include/linux/ioblame.h           |   72 +
 include/linux/stacktrace.h        |    6 
 include/linux/writeback.h         |   18 
 include/trace/events/block.h      |   70 -
 include/trace/events/vfs.h        |   40 
 include/trace/events/writeback.h  |  113 +
 kernel/stacktrace.c               |    6 
 kernel/trace/Kconfig              |   12 
 kernel/trace/Makefile             |    1 
 kernel/trace/blktrace.c           |    2 
 kernel/trace/ioblame.c            | 2279 ++++++++++++++++++++++++++++++++++++++
 mm/page-writeback.c               |    2 
 25 files changed, 3244 insertions(+), 67 deletions(-)

Thanks.

--
tejun

[L] http://thread.gmane.org/gmane.linux.kernel/1235937
