Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753744Ab2ASBLh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 20:11:37 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52870 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751748Ab2ASBLf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 20:11:35 -0500
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, vgoyal@redhat.com
Cc: ctalbott@google.com, rni@google.com, linux-kernel@vger.kernel.org
Subject: [PATCHSET] blkcg: kill policy node and blkg->dev
Date: Wed, 18 Jan 2012 17:11:18 -0800
Message-Id: <1326935490-11827-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, guys.

This is the first of three (maybe four) patchset series trying to
cleanup block cgroup API.

<rant>
The current state of blkcg API is extremely sad.  From the first
glance, it looks as though it's built with some modular design in mind
with policy registration and all but the whole thing is one giant
unholy spaghetti mess which renders the phrase "layer violation"
meaningless as it's unclear whether it exists at all from the
beginning.

I've been looking at the code for three weeks now.  I've done a lot of
code cleanups all around the kernel and seen a lot of scary/messy
stuff, but blkcg takes the worst spot without any shred of doubt.  We
really shouldn't have code like this in the kernel.
</rant>

Alright, I just needed to get that out of my system.  We all do a lot
of horrible things.  I know I've been and still am, so let's just
concentrate on getting it better from here on.

blk-cgroup, blk-throttle and cfq-iosched are pretty tightly tangled
and untangling requires seemingly unrelated changes and addition of
some transitional stuff.  Some are in this patchset but they'll be
more prominent in the second patchset.  With that said, this patchset
concentrates on removing blkio_policy_node and blkio_group->dev.

blkio_policy_node carries configuration per cgroup-request_queue
association separately from the matching blkio_group.  The goal seems
to be allowing configuration of missing devices and retaining
configuration across hot unplug/plug cycles.  Such behavior is very
different from existing conventions, misleading and unnecessary.  This
patchset moves configuration to blkio_group and removes
blkio_policy_node.

blkg->dev removal is much simpler.  blkg->dev is used to print out
device number when printing out per-device configurations or
statistics.  The device name can be easily determined by following the
associated request_queue from blkg instead.

This patchset contains the following 12 patches.

  0001-blkcg-obtaining-blkg-should-be-enclosed-inside-rcu_r.patch
  0002-cfq-don-t-register-propio-policy-if-CONFIG_CFQ_GROUP.patch
  0003-elevator-clear-auxiliary-data-earlier-during-elevato.patch
  0004-elevator-make-elevator_init_fn-return-0-errno.patch
  0005-blkcg-update-blkg-get-functions-take-blkio_cgroup-as.patch
  0006-blkcg-use-q-and-plid-instead-of-opaque-void-for-blki.patch
  0007-blkcg-add-blkio_policy-array-and-allow-one-policy-pe.patch
  0008-blkcg-use-the-usual-get-blkg-path-for-root-blkio_gro.patch
  0009-blkcg-factor-out-blkio_group-creation.patch
  0010-blkcg-don-t-allow-or-retain-configuration-of-missing.patch
  0011-blkcg-kill-blkio_policy_node.patch
  0012-blkcg-kill-the-mind-bending-blkg-dev.patch

0001 is rcu locking fix.  Applying to mainline as fix is probably a
good idea.

0002 is misc cfq prep.

0003-0004 update elevator.  Elevator switch behavior is changed once
more to simplify elevator init/exit paths.

0005-0009 prepare blkcg for further changes.  Two policy operations
and new one policy per policy ID restriction are added.  All will be
removed as cleanup progresses further.

0010-0011 move blkcg configuration into blkg and drop policy node.

0012 drops blkg->dev.

This patchset is on top of linus#master (4ba3069fea "Merge branch
'for-next' of git://../nab/target-pending") and available in the
following git branch.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git blkcg-kill-pn

Thanks.

 block/blk-cgroup.c       |  635 +++++++++++++++--------------------------------
 block/blk-cgroup.h       |   91 ++----
 block/blk-core.c         |    6 
 block/blk-throttle.c     |  259 +++++--------------
 block/cfq-iosched.c      |  237 +++++------------
 block/cfq.h              |    7 
 block/deadline-iosched.c |    8 
 block/elevator.c         |   90 +++---
 block/noop-iosched.c     |    8 
 include/linux/elevator.h |    2 
 10 files changed, 436 insertions(+), 907 deletions(-)

--
tejun
