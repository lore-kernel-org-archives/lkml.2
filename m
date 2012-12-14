Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932467Ab2LNWlg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 17:41:36 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:60971 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932122Ab2LNWle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 17:41:34 -0500
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com, axboe@kernel.dk, vgoyal@redhat.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, ctalbott@google.com, rni@google.com
Subject: [PATCHSET] block: implement blkcg hierarchy support in cfq
Date: Fri, 14 Dec 2012 14:41:13 -0800
Message-Id: <1355524885-22719-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

cfq-iosched is currently utterly broken in how it handles cgroup
hierarchy.  It ignores the hierarchy structure and just treats every
blkcgs equally.  This is simply broken.  This breakage makes blkcg
behave very differently from other properly-hierarchical controllers
and makes it impossible to give any uniform interpretation to the
hierarchy, which in turn makes it impossible to implement unified
hierarchy.

Given the relative simplicity of cfqg scheduling, implementing proper
hierarchy support isn't that difficult.  All that's necessary is
determining how much fraction each cfqg on the service tree has claim
to considering the hierarchy.  The calculation can be done by
maintaining the sum of active weights at each level and compounding
the ratios from the cfqg in question to root.  The overhead isn't
significant.  Tree traversals happen only when cfqgs are added or
removed from the service tree and they are from the cfqg being
modified to the root.

There are some design choices which are worth mentioning.

* Internal (non-leaf) cfqgs w/ tasks treat the tasks as a single unit
  competeting against the children cfqgs.  New config knobs -
  blkio.leaf_weight[_device] - are added to configure the weight of
  these tasks.  Another way to look at it is that each cfqg has a
  hidden leaf child node attached to it which hosts all tasks and
  leaf_weight controls the weight of that hidden node.

  Treating cfqqs and cfqgs as equals doesn't make much sense to me and
  is hairy - we need to establish ioprio to weight mapping and the
  weights fluctuate as processes fork and exit.  This becomes hairier
  when considering multiple controllers, Such mappings can't be
  established consistently across different controllers and the
  weights are given out differently - ie. blkcg give weights out to
  io_contexts while cpu to tasks, which may share io_contexts.  It's
  difficult to make sense of what's going on.

  The goal is to bring cpu, currently the only other controller which
  implements weight based resource allocation, to similar behavior.

* The existing stats aren't converted to hierarchical but new
  hierarchical ones are added.  There isn't a way to do that w/o
  introducing nasty silent surprises to the existing flat hierarchy
  users, so while being a bit clumsy, I can't see a better way.

* I based it on top of Vivek's cleanup patchset[1] but not the cfqq,
  cfqg scheduling unification patchset.  I don't think it's necessary
  or beneficial to mix the two and would really like to avoid messing
  with !blkcg scheduling logic.

The hierarchical scheduling itself is fairly simple.  The cfq part is
only ~260 lines with ~60 lines being comment, and the hierarchical
weight scaling is really straight-forward.

This patchset contains the following 12 patches.

 0001-blkcg-fix-minor-bug-in-blkg_alloc.patch
 0002-blkcg-reorganize-blkg_lookup_create-and-friends.patch
 0003-blkcg-cosmetic-updates-to-blkg_create.patch
 0004-blkcg-make-blkcg_gq-s-hierarchical.patch
 0005-cfq-iosched-add-leaf_weight.patch
 0006-cfq-iosched-implement-cfq_group-nr_active-and-level_.patch
 0007-cfq-iosched-implement-hierarchy-ready-cfq_group-char.patch
 0008-cfq-iosched-convert-cfq_group_slice-to-use-cfqg-vfra.patch
 0009-cfq-iosched-enable-full-blkcg-hierarchy-support.patch
 0010-blkcg-add-blkg_policy_data-plid.patch
 0011-blkcg-implement-blkg_prfill_-rw-stat_recursive.patch
 0012-cfq-iosched-add-hierarchical-cfq_group-statistics.patch

0001-0003 are prep patches.

0004 makes blkcg core always allocate non-leaf blkgs so that any given
blkg is guaranteed to have all its ancestor blkgs to the root.

0005-0006 prepare for hierarchical scheduling.

0007-0008 implement hierarchy-ready cfqg scheduling.

0009 enbles hierarchical scheduling.

0010-0012 implement hierarchical stats.

This patchset is on top of

  linus#master (d42b3a2906a10b732ea7d7f849d49be79d242ef0)
+ [1] "cfq-iosched: Some minor cleanups" patchset

and available in the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git blkcg-cfq-hierarchy

Thanks.

 block/blk-cgroup.c  |  263 ++++++++++++++++++++++++++++++++++++-----
 block/blk-cgroup.h  |   26 +++-
 block/cfq-iosched.c |  329 ++++++++++++++++++++++++++++++++++++++++++++++++----
 3 files changed, 560 insertions(+), 58 deletions(-)

--
tejun

[1] https://lkml.org/lkml/2012/10/3/502
