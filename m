Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755155Ab2GWXvm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 19:51:42 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58214 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755019Ab2GWXvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 19:51:40 -0400
From: Kent Overstreet <koverstreet@google.com>
To: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com
Cc: Kent Overstreet <koverstreet@google.com>, tj@kernel.org, vgoyal@redhat.com,
        joe@perches.com
Subject: [Bcache v15 00/16]
Date: Mon, 23 Jul 2012 16:50:43 -0700
Message-Id: <1343087459-17645-1-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bcache: a cache for arbitrary block devices using an SSD.

Short overview:
Bcache does both writethrough and writeback caching. It presents itself as a
new block device, a bit like say md. You can cache an arbitrary number of
block devices with a single cache device, and attach and detach things at
runtime - it's quite flexible.

It's very fast. It uses a b+ tree for the index, along with a journal to
coalesce index updates, and a bunch of other cool tricks like auxiliary binary
search trees with software floating point keys for searching within btree
nodes.

CURRENT STATUS:

Bcache is solid, production ready code. I think there's still a bug or two
related to bcache + dm, but nothing I've been able to reproduce. I'm running it
on this machine in writeback mode for awhile now - subjectively, it's just as
good as running on an SSD. It's been running on various servers in production,
I have no clue how many.

This patch series is based on my block_stuff branch, available at
git://evilpiepirate.org/~kent/linux-bcache.org
http://evilpiepirate.org/git/linux-bcache.git/log/?h=block_stuff

and that branch is in turn based on v3.5.

CHANGES SINCE v14:

Almost 500 lines of new code documentation, most of it high level design docs.
Start at the top of bcache.h - most of the header files now start with some
high level documentation, and alloc.c since it doesn't have its own header.

Suggestions on what else to document would be most welcome. I think the high
level design documentation is in pretty good shape (except perhaps for non
btree metadata stuff), but I've started on function level documentation. So, if
there's a function and you can't figure out wtf it does, please let me know.

Incorporated Joe Perches' feedback.

CHANGES SINCE v13:

I lost the cover letter I was writing just as I was about to send out v14, and
in a fit of frustration sent it out with just the shortlog. Anyways, v14 had
all a ton of review feedback incorporated; if there's anything anyone pointed
out that hasn't been fixed or responded to I probably missed it.

Incorporated feedback from Tejun, Vivek, and Joe Perches'. Though it's quite
possible I missed some bits.

I also refactored a lot of the trickiest code; the refcounting and flow control
in request.c (around request_write) in particular is massively improved, and I
changed the way bio splits are refcounted, which is now much more consistent.
The btree in memory cache code was also significantly improved.

I rebased onto my patches for the generic block layer that make
generic_make_request() take arbitrary sized bios, which cleaned up a lot of
bcache code and let me delete like 400 lines of code from bcache.

Merged in the moving garbage collector. It needs more work (needs generational
garbage collection, rate limiting) but it does currently work. It's for flash
only volumes, and ultimately for making bcache a full blown FTL.

TODO/KNOWN ISSUES (Incomplete):

 * More documentation

 * My patch for adding human readable units to vsnprintf() isn't going to work
   because of gcc printf typechecking. Probably going to end up reverting that.
   The current code works fine, gcc just complains a lot.

 * I need to get better at responding to emails.

Kent Overstreet (16):
  Revert "rw_semaphore: remove up/down_read_non_owner"
  Fix ratelimit macro to compile in c99 mode
  Export get_random_int()
  Export blk_fill_rwbs()
  Export __lockdep_no_validate__
  Add human-readable units modifier to vsnprintf()
  Closures
  bcache: Generic utility code
  bcache: Documentation, and changes to generic code
  bcache: Superblock/initialization/sysfs code
  bcache: Core btree code
  bcache: Bset code (lookups within a btree node)
  bcache: Journalling
  bcache: Request, io and allocation code
  bcache: Writeback, copying garbage collection
  bcache: Debug and tracing code

 Documentation/ABI/testing/sysfs-block-bcache |  156 ++
 Documentation/bcache.txt                     |  255 +++
 drivers/char/random.c                        |    1 +
 drivers/md/Kconfig                           |    2 +
 drivers/md/Makefile                          |    1 +
 drivers/md/bcache/Kconfig                    |   41 +
 drivers/md/bcache/Makefile                   |   14 +
 drivers/md/bcache/alloc.c                    |  615 +++++++
 drivers/md/bcache/bcache.h                   | 1142 ++++++++++++
 drivers/md/bcache/bset.c                     | 1165 ++++++++++++
 drivers/md/bcache/bset.h                     |  372 ++++
 drivers/md/bcache/btree.c                    | 2508 ++++++++++++++++++++++++++
 drivers/md/bcache/btree.h                    |  423 +++++
 drivers/md/bcache/debug.c                    |  576 ++++++
 drivers/md/bcache/debug.h                    |   54 +
 drivers/md/bcache/io.c                       |  136 ++
 drivers/md/bcache/journal.c                  |  703 ++++++++
 drivers/md/bcache/journal.h                  |  159 ++
 drivers/md/bcache/movinggc.c                 |  245 +++
 drivers/md/bcache/request.c                  | 1366 ++++++++++++++
 drivers/md/bcache/request.h                  |   61 +
 drivers/md/bcache/stats.c                    |  245 +++
 drivers/md/bcache/stats.h                    |   58 +
 drivers/md/bcache/super.c                    | 1992 ++++++++++++++++++++
 drivers/md/bcache/sysfs.c                    |  812 +++++++++
 drivers/md/bcache/sysfs.h                    |   91 +
 drivers/md/bcache/trace.c                    |   26 +
 drivers/md/bcache/util.c                     |  392 ++++
 drivers/md/bcache/util.h                     |  606 +++++++
 drivers/md/bcache/writeback.c                |  405 +++++
 include/linux/cgroup_subsys.h                |    6 +
 include/linux/closure.h                      |   88 +-
 include/linux/ratelimit.h                    |    2 +-
 include/linux/rwsem.h                        |   10 +
 include/linux/sched.h                        |    4 +
 include/trace/events/bcache.h                |  271 +++
 kernel/fork.c                                |    4 +
 kernel/lockdep.c                             |    1 +
 kernel/rwsem.c                               |   16 +
 kernel/trace/blktrace.c                      |    1 +
 lib/closure.c                                |   26 +-
 lib/vsprintf.c                               |   24 +-
 42 files changed, 15022 insertions(+), 53 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-block-bcache
 create mode 100644 Documentation/bcache.txt
 create mode 100644 drivers/md/bcache/Kconfig
 create mode 100644 drivers/md/bcache/Makefile
 create mode 100644 drivers/md/bcache/alloc.c
 create mode 100644 drivers/md/bcache/bcache.h
 create mode 100644 drivers/md/bcache/bset.c
 create mode 100644 drivers/md/bcache/bset.h
 create mode 100644 drivers/md/bcache/btree.c
 create mode 100644 drivers/md/bcache/btree.h
 create mode 100644 drivers/md/bcache/debug.c
 create mode 100644 drivers/md/bcache/debug.h
 create mode 100644 drivers/md/bcache/io.c
 create mode 100644 drivers/md/bcache/journal.c
 create mode 100644 drivers/md/bcache/journal.h
 create mode 100644 drivers/md/bcache/movinggc.c
 create mode 100644 drivers/md/bcache/request.c
 create mode 100644 drivers/md/bcache/request.h
 create mode 100644 drivers/md/bcache/stats.c
 create mode 100644 drivers/md/bcache/stats.h
 create mode 100644 drivers/md/bcache/super.c
 create mode 100644 drivers/md/bcache/sysfs.c
 create mode 100644 drivers/md/bcache/sysfs.h
 create mode 100644 drivers/md/bcache/trace.c
 create mode 100644 drivers/md/bcache/util.c
 create mode 100644 drivers/md/bcache/util.h
 create mode 100644 drivers/md/bcache/writeback.c
 create mode 100644 include/trace/events/bcache.h

-- 
1.7.7.3

