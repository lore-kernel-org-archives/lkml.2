Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754361Ab2KCIi7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2012 04:38:59 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:36901 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753873Ab2KCIix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2012 04:38:53 -0400
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com, mhocko@suse.cz, rjw@sisk.pl
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        fweisbec@gmail.com
Subject: [PATCHSET cgroup/for-3.8] cgroup_freezer: implement proper hierarchy support
Date: Sat,  3 Nov 2012 01:38:26 -0700
Message-Id: <1351931915-1701-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patchset implement proper hierarchy support for cgroup_freezer as
discussed in "[RFC] cgroup TODOs"[1].

The patchset first implements generic cgroup iteration macros -
cgroup_for_each_children(), cgroup_for_each_descendant_{pre|post}().
Combined with the newly introduced ->post_create() callback, this
allows controllers to implement reliable iteration over descendants
without messing with cgroup internal locking.  Controllers can perform
reliable walking using simple hierarchy-wide locking or finer-grained
parent-children locking.

Using the iteration macros and ->post_create(), cgroup_freezer is
updated to propagate state updates to and collect FROZEN completions
from the descendants.  This removes .broken_hierarchy marking from
cgroup_freezer.

cgroup_freezer hierarchy support is implemented using finer-grained
locking not necessarily because it's necessary but more because I
wanted an example controller doing that.

This patchset contains the following nine patches.

 0001-cgroup-add-cgroup_subsys-post_create.patch
 0002-cgroup-Use-rculist-ops-for-cgroup-children.patch
 0003-cgroup-implement-generic-child-descendant-walk-macro.patch
 0004-cgroup_freezer-trivial-cleanups.patch
 0005-cgroup_freezer-prepare-freezer_change_state-for-full.patch
 0006-cgroup_freezer-make-freezer-state-mask-of-flags.patch
 0007-cgroup_freezer-introduce-CGROUP_FREEZING_-SELF-PAREN.patch
 0008-cgroup_freezer-add-post_create-and-pre_destroy-and-t.patch
 0009-cgroup_freezer-implement-proper-hierarchy-support.patch

0001-0003 implement cgroup descendant iterators.

0004-0008 prepare cgroup_freezer for hierarchy support.  0009
implements it.

This patchset is on top of

 v3.6 (a0d271cbfe)
+ [2] the first three patches of
      "memcg/cgroup: do not fail fail on pre_destroy callbacks" patchset
+ [3] "cgroup: simplify cgroup removal path" v2 patchset

with cgroup/for-3.8 pulled into it.  The branch is rather floaty at
the moment so it would be the easiest to pull the following branch for
review.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-cgroup_freezer-hierarchy

Thanks.

 kernel/cgroup.c         |  106 +++++++++++++-
 kernel/cgroup_freezer.c |  359 +++++++++++++++++++++++++++++++++++-------------
 3 files changed, 445 insertions(+), 104 deletions(-)

--
tejun

[1] http://thread.gmane.org/gmane.linux.kernel.containers/23698
[2] http://thread.gmane.org/gmane.linux.kernel.cgroups/4757
[3] http://thread.gmane.org/gmane.linux.kernel.cgroups/4861
