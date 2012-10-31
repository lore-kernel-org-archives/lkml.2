Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935531Ab2JaM3t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 08:29:49 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:33408 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935465Ab2JaM3o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 08:29:44 -0400
From: Glauber Costa <glommer@parallels.com>
To: <cgroups@vger.kernel.org>
Cc: Tejun Heo <tj@kernel.org>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 0/2] cgroup hook after successful create
Date: Wed, 31 Oct 2012 16:29:12 +0400
Message-Id: <1351686554-22592-1-git-send-email-glommer@parallels.com>
X-Mailer: git-send-email 1.7.11.7
CC: Tejun Heo <tj@kernel.org>
CC: Michal Hocko <mhocko@suse.cz>
CC: Li Zefan <lizefan@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

cgroups that use css_id only have this number assigned after ->create()
returns.  This means it is not possible to use this number for anything during
cgroup initialization.

There are situations in which it may come handy: in the kmemcg-slab patchset,
for instance, each memcg that has a limit on kernel memory will use its css_id
as an index in an array of per-memcg kmem_caches. This array increases in size
(in bulks, of course) as the maximum possible index grows, so we need to be
aware of that early.

This could be achieved with a hook called after ->create(). Such a hook exists:
this is ->post_clone(). However, this is called only for cgroups that set the
clone_children flag. I believe a more general hook is useful, and the following
two patches generalize post_clone() into a hook that is always called after
create.

As I mentioned, I intend to do memory allocations from that hook so it can fail
(in patch 2, for simplicity).

I consider a general hook acceptable and useful, and is the simplest solution to
the problem I face. Let me know what you guys think of it.

Glauber Costa (2):
  generalize post_clone into post_create
  allow post_create to fail

 Documentation/cgroups/cgroups.txt | 13 +++++++------
 include/linux/cgroup.h            |  7 ++++++-
 kernel/cgroup.c                   | 12 +++++-------
 kernel/cpuset.c                   | 19 +++++++++++--------
 4 files changed, 29 insertions(+), 22 deletions(-)

-- 
1.7.11.7

