Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753712Ab2KMPbT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 10:31:19 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60663 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751576Ab2KMPbS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 10:31:18 -0500
From: Michal Hocko <mhocko@suse.cz>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Ying Han <yinghan@google.com>,
        Tejun Heo <htejun@gmail.com>, Glauber Costa <glommer@parallels.com>
Subject: [RFC] rework mem_cgroup iterator
Date: Tue, 13 Nov 2012 16:30:34 +0100
Message-Id: <1352820639-13521-1-git-send-email-mhocko@suse.cz>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
this patch set tries to make mem_cgroup_iter saner in the way how it
walks hierarchies. css->id based traversal is far from being ideal as it
is not deterministic because it depends on the creation ordering.

Diffstat looks promising but it is fair the say that the biggest cleanup is
just css_get_next removal. The memcg code has grown a bit but I think it is
worth the resulting outcome (the sanity ;)).

The first patch fixes a potential misbehaving which I haven't seen but the
fix is needed for the later patches anyway. We could take it alone as well
but I do not have any bug report to base the fix on.

The second patch replaces css_get_next by cgroup iterators which are
scheduled for 3.8 in Tejun's tree and I depend on the following two patches:
fe1e904c cgroup: implement generic child / descendant walk macros
7e187c6c cgroup: use rculist ops for cgroup->children

The third patch is an attempt for simplification of the mem_cgroup_iter. It
basically removes all css usages to make the code easier. The next patch
removes the big while(!memcg) loop around the iterating logic. It could have
been folded into #3 but I rather have the rework separate from the code
moving noise.

The last patch just removes css_get_next as there is no user for it any
longer.

I am also thinking that leaf-to-root iteration makes more sense but this
patch is not included in the series yet because I have to think some
more about the justification.

So far I didn't get to testing but I am posting this early if everybody is
OK with this change.

Any thoughts?

Cumulative diffstat:
 include/linux/cgroup.h |    7 ---
 kernel/cgroup.c        |   49 ---------------------
 mm/memcontrol.c        |  110 +++++++++++++++++++++++++++++++++---------------
 3 files changed, 75 insertions(+), 91 deletions(-)

Michal Hocko (5):
      memcg: synchronize per-zone iterator access by a spinlock
      memcg: rework mem_cgroup_iter to use cgroup iterators
      memcg: simplify mem_cgroup_iter
      memcg: clean up mem_cgroup_iter
      cgroup: remove css_get_next

