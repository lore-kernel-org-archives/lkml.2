Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367Ab0GUJcF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 05:32:05 -0400
Received: from smtp.nokia.com ([192.100.122.233]:25433 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727Ab0GUJcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 05:32:01 -0400
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCHv2 00/16] kill unnecessary bdi wakeups + cleanups
Date: Wed, 21 Jul 2010 12:31:35 +0300
Message-Id: <1279704706-1267-1-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.1.1
X-OriginalArrivalTime: 21 Jul 2010 09:31:46.0768 (UTC) FILETIME=[89E31D00:01CB28B7]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

here is v2 of the patch series which clean-ups bdi threads and substantially
lessens amount of unnecessary kernel wake-ups, which is very important on
battery-powered devices.

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

Artem.
