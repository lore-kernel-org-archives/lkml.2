Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754719Ab2GIXfm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 19:35:42 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63850 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752285Ab2GIXfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 19:35:40 -0400
From: Michel Lespinasse <walken@google.com>
To: aarcange@redhat.com, dwmw2@infradead.org, riel@redhat.com,
        peterz@infradead.org, daniel.santos@pobox.com, axboe@kernel.dk,
        ebiederm@xmission.com
Cc: linux-mm@kvack.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: [PATCH 00/13] rbtree updates
Date: Mon,  9 Jul 2012 16:35:10 -0700
Message-Id: <1341876923-12469-1-git-send-email-walken@google.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I recently started looking at the rbtree code (with an eye towards
improving the augmented rbtree support, but I haven't gotten there
yet). I noticed a lot of possible speed improvements, which I am now
proposing in this patch set.

Patches 1-4 are preparatory: remove internal functions from rbtree.h
so that users won't be tempted to use them instead of the documented
APIs, clean up some incorrect usages I've noticed (in particular, with
the recently added fs/proc/proc_sysctl.c rbtree usage), reference the
documentation so that people have one less excuse to miss it, etc.

Patch 5 is a small module I wrote to check the rbtree performance.
It creates 100 nodes with random keys and repeatedly inserts and erases
them from an rbtree. Additionally, it has code to check for rbtree
invariants after each insert or erase operation.

Patches 6-13 is where the rbtree optimizations are done, and they touch
only that one file, lib/rbtree.c . I am getting good results out of these -
in my small benchmark doing rbtree insertion (including search) and erase,
I'm seeing a 30% runtime reduction on Sandybridge E5, which is more than
I initially thought would be possible. (the results aren't as impressive
on my two other test hosts though, AMD barcelona and Intel Westmere, where
I am seeing 14% runtime reduction only). The code size - both source
(ommiting comments) and compiled - is also shorter after these changes.
However, I do admit that the updated code is more arduous to read - one
big reason for that is the removal of the tree rotation helpers, which
added some overhead but also made it easier to reason about things locally.
Overall, I believe this is an acceptable compromise, given that this code
doesn't get modified very often, and that I have good tests for it.

For those people who want to really understand the code, I can only
recommend keeping around a copy of the cormen/leiserson/rivest book, as
the original algorithm seems to be inspired by it and having the rbtrees
drawn up really helps.

This patchset is against v3.4 - I had actually done most of the development
against v3.3 but the rbtree code doesn't change very often so I didn't have
to update it much, save for dealing with the recent rbtree additions in
fs/proc/proc_sysctl.c

My proposal would be to use this as a base to add on the augmented rbtree
support enhancements, which I'd like to do next. Then this could all go in
-mm tree so that various augmented rbtree uses that have been discussed
(such as finding gaps between vmas) can use this.

Michel Lespinasse (13):
  rbtree: reference Documentation/rbtree.txt for usage instructions
  rbtree: empty nodes have no color
  rbtree: fix incorrect rbtree node insertion in fs/proc/proc_sysctl.c
  rbtree: move some implementation details from rbtree.h to rbtree.c
  rbtree: performance and correctness test
  rbtree: break out of rb_insert_color loop after tree rotation
  rbtree: adjust root color in rb_insert_color() only when necessary
  rbtree: optimize tree rotations in rb_insert_color()
  rbtree: optimize color flips and parent fetching in rb_insert_color()
  rbtree: adjust node color in __rb_erase_color() only when necessary
  rbtree: optimize case selection logic in __rb_erase_color()
  rbtree: optimize tree rotations in __rb_erase_color()
  rbtree: optimize color flips in __rb_erase_color()

 fs/proc/proc_sysctl.c      |    5 +-
 include/linux/rbtree.h     |   98 +------------
 include/linux/timerqueue.h |    2 +-
 lib/rbtree.c               |  349 +++++++++++++++++++++++++-------------------
 tests/rbtree_test.c        |  135 +++++++++++++++++
 5 files changed, 340 insertions(+), 249 deletions(-)
 create mode 100644 tests/rbtree_test.c

-- 
1.7.7.3

