Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752868Ab0GYLaS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jul 2010 07:30:18 -0400
Received: from smtp.nokia.com ([192.100.122.230]:18909 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752765Ab0GYLaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jul 2010 07:30:04 -0400
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCHv6 00/15] kill unnecessary bdi wakeups + cleanups
Date: Sun, 25 Jul 2010 14:29:10 +0300
Message-Id: <1280057365-10297-1-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.1.1
X-OriginalArrivalTime: 25 Jul 2010 11:29:25.0822 (UTC) FILETIME=[A31045E0:01CB2BEC]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

here is v6 of the patch series which clean-ups bdi threads and substantially
lessens amount of unnecessary kernel wake-ups, which is very important on
battery-powered devices.

This patch-set is also available at:
git://git.infradead.org/users/dedekind/misc-2.6.git flushers_v6

Changes since v5
Only patch N12 was really changed.

1. Use 'spin_lock_bh' for the 'bdi->wb_lock' (changed patch N12)
1. Cosmetic change in patch N10: fix checkpatch.pl warning abot using spaces
   before tabs.
2. Cosmetic change in patch N11: remove extra new line at the end of
   '__mark_inode_dirty()'

Changes since v4
Most patches are intact. Only patches N9, N10, N12 and N14 were changed. And
patch N15 was added. Also, now I tested the patch-set much better.

1. Fix a bug found while testing: in the forker thread, when we create a bdi
   task and then assign it to 'bdi->wb.task', we need to take the
   'bdi->work_lock'. Otherwise we can lose a wake-up. Changed this in patch
   N10.
2. Add patch 15 which fixes a warning and cleans up 'bdi_register()'.
3. Use "switch" in the main forker thread loop. Patch N9 was changed and now it
   also introduces the "switch".
4. Stick with Christoph's version of tracepoint names and positions -> changed
   patch N14.
5. Add a couple of "Reviewed-by" tags.
6. Addressed the issue pointed to by Christoph and added
  'del_timer_sync()' in patch 12

Changes since v3:
Tested more internally and found problems in bdi shutdown path. Namely, I forgot
to move the code which wakes up processes waiting on BDI_pending bit to the
forker thread. I also spotted few other things. Only patch N10 was changed.

1. Removed "Reviewed-by: Christoph Hellwig <hch@lst.de>" tag from patch 10
   "writeback: move bdi threads exiting logic to the forker thread" in this
   patch-set, because it was changed substantialy, and needs new review.
2. Move 'clear_bit()' and 'wake_up_bit()' bit to bdi forker
3. Add 'smp_wmb()' and 'smp_rmb()' in bdi forker and 'bdi_wb_shutdown()'
4. In 'bdi_wb_shutdown()' first remove the bdi from 'bdi_list', and then wait
   on the 'BDI_pending' bit, not vise-versa.

Changes since v2:
Basically, added patches 12, 13, 14. Other patches are almost identical to v2,
but I fixed few warnings about mixing tabs and spaces were fixed there. Also,
tweaked them as described in item 6 below.
1. Delay bdi thread wake-up as suggested by Nick Piggin, see patch N12
2. Do not invoke init_timer unnecessarily - spotted and fixed an imperfection,
   see patch N13
3. Introduce tracepoints to the code path which wakes up bdi threads for
   periodic write-back, suggested by Dave Chinner, see patch N14
4. Fix few checkpatch.pl warnings
5. Add more "Reviewed-by" tags
6. Amend patches so that we would check the optimistic case first
   (http://lkml.org/lkml/2010/7/22/112)

Changes since v1
Basically, address all requests from Christoph except of 2.
1.  Drop "[PATCH 01/16] writeback: do not self-wakeup"
2.  Add all "Reviewed-by"
3.  Rebase to the latest "linux-2.6-block / for-2.6.36"
4.  Re-order patches so that the independent ones would go first and could
    be picked independently
5.  Do not remove comment about "temporary measure" in the forker thread.
6.  Drop "[PATCH 01/13] writeback: remove redundant list initialization"
    because one of later patches will kill whole function, so this small
    patch is pointless
7.  Merge "[PATCH 03/13] writeback: clean-up the warning about non-registered
    bdi" with the patch which adds bdi threads wake-ups to
    '__mark_inode_dirty()'.
9.  Do not remove bdis from the bdi_list
8.  Drop "[PATCH 09/13] writeback: add to bdi_list in the forker thread"
    because we do not remove bdis from the bdi_list anymore
10. Use less local variables which are not strictly needed

The following Christoph's requests were *not* addressed:

1. Restructure the loop in bdi forker, because we have to drop spinlock
   before forking a thread, see my answer here:
   http://lkml.org/lkml/2010/7/20/92
2. Get rid of 'BDI_pending' and use a per-bdi mutex. We cannot easily
   use a per-bdi mutex, because we would have to take it while holding
   the 'bdi_lock' spinlock. We could turn 'bdi_lock' into a mutex, though,
   and avoid dropping it before the task is created. This would eliminate
   the need in the 'BDI_pending' flag. I can do this change, if needed.


THE PROBLEM
~~~~~~~~~~~

Each block device has corresponding "flusher" thread, which is usually seen as
"flusher-x:y" in your 'ps' output. Flusher threads are responsible for
background write-back and are used in various kernel code paths like memory
reclamation as well as the periodic background write-out.

The flusher threads wake up every 5 seconds and check whether they have to
write anything back or not. In idle systems with good dynamic power-management
this means that they force the system to wake up from deep sleep, find out that
there is nothing to do, and waste power. This hurts small battery-powered
devices, e.g., linux-based phones.

Idle bdi thread wake-ups do not last forever: the threads kill themselves if
nothing useful has been done for 5 minutes.

However, there is the bdi forker thread, seen as 'bdi-default' in your 'ps'
output. This thread also wakes up every 5 seconds and checks whether it has to
fork a bdi flusher thread, in case there is dirty data on the bdi, but bdi
thread was killed. This thread never kills itself, and disturbs the system all
the time. Again, this is bad for battery-powered devices.

THE SOLUTION
~~~~~~~~~~~~

This patch-set makes bdi threads and the forker thread wake-up only if there is
job to do, otherwise they just sleep. The main idea is to wake-up the needed
thread when adding dirty data to the bdi.

To implement this:

1. I address various race conditions in the current bdi code.
2. I move the killing logic from bdi threads to the forker thread, so that we
   would have one central place where we make decisions about killing inactive
   bdi threads. The reason I do this is because otherwise it is difficult to
   kill inactive threads - they never wake-up, so would never kill themselves.
   There are other technical reasons, too.
3. I add a small piece of code to '__mark_inode_dirt()' which wakes up the bdi
   thread when dirty inodes arrive.
4. There are also clean-up patches and nicification patches which I found to be
   good for better code readability.
5. Some patches are just preparations which make the following real patches
   simpler and easier to review.
6. Some patches are just simplifications of current code.

With this patch-set bdi threads wake up considerably less.

v1 can be found here:
http://thread.gmane.org/gmane.linux.file-systems/43306
v2 can be found here:
http://thread.gmane.org/gmane.linux.kernel/1012439
v3 can be found here:
http://thread.gmane.org/gmane.linux.kernel/1013009
v4 can be found here:
http://thread.gmane.org/gmane.linux.kernel/1013682
v5 can be found here:
http://thread.gmane.org/gmane.linux.kernel/1013987

Artem.
