Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755721Ab2ISODN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 10:03:13 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50410 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753587Ab2ISODL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 10:03:11 -0400
Date: Wed, 19 Sep 2012 16:03:08 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Tejun Heo <tj@kernel.org>
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, Li Zefan <lizefan@huawei.com>,
        Glauber Costa <glommer@parallels.com>,
        Peter Zijlstra <peterz@infradead.org>, Paul Turner <pjt@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Thomas Graf <tgraf@suug.ch>,
        "Serge E. Hallyn" <serue@us.ibm.com>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Neil Horman <nhorman@tuxdriver.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Dave Jones <davej@redhat.com>, Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 2.6.32] memcg: warn on deeper hierarchies with
 use_hierarchy==0
Message-ID: <20120919140308.GB5398@dhcp22.suse.cz>
References: <20120913205827.GO7677@google.com>
 <20120914150306.GQ28039@dhcp22.suse.cz>
 <20120919140203.GA5398@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120919140203.GA5398@dhcp22.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>From 34be56e3e7e4f9c31381ce35247e0a0b7f972874 Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko@suse.cz>
Date: Tue, 4 Sep 2012 15:55:03 +0200
Subject: [PATCH] memcg: warn on deeper hierarchies with use_hierarchy==0

The memory controller supports both hierarchical and non-hierarchical
behavior which is controlled by use_hierarchy knob (0 by default).
The primary motivation for this distinction was an ineffectiveness
of hierarchical accounting. This has improved a lot since it was
introduced.

This schizophrenia makes the code and integration with other controllers
more complicated (e.g. mounting it with fully hierarchical one could
have an unexpected side effects) for no good reason so it would be good
to make the memory controller behave only hierarchically.

It seems that there is no good reasons for deep cgroup hierarchies which
are not truly hierarchical so we could set the default to 1. This might,
however, lead to unexpected regressions when somebody relies on the
current default behavior. For example, consider the following setup:
		 Root[cpuset,memory]
		  |
		  A (use_hierarchy=0)
		 / \
		B  C

All three A, B, C have some tasks and their memory limits. The hierarchy
is created only because of the cpuset and its configuration.
Say the default is changed. Then a memory pressure in C could influence
both A and B which wouldn't happen before. The problem might be really
hard to notice (unexpected slowdown).
This configuration could be fixed up easily by reorganization, though:
		 Root
		  |
		  A' (use_hierarchy=1, limit=unlimited, no tasks)
		 /|\
		A B C

The problem is that we don't know whether somebody has an use case which
cannot be transformed like that. Therefore this patch starts the slow
transition to hierarchical only memory controller by warning users who
are using flat hierarchies. The warning triggers only if a subgroup of
non-root group is created with use_hierarchy==0.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
---
 mm/memcontrol.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index f99f599..b61c34b 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3106,6 +3106,11 @@ mem_cgroup_create(struct cgroup_subsys *ss, struct cgroup *cont)
 	} else {
 		parent = mem_cgroup_from_cont(cont->parent);
 		mem->use_hierarchy = parent->use_hierarchy;
+		WARN_ONCE(!mem->use_hierarchy && parent != root_mem_cgroup,
+				"Creating hierarchies with use_hierarchy==0 "
+				"(flat hierarchy) is considered deprecated. "
+				"If you believe that your setup is correct, "
+				"we kindly ask you to contact linux-mm@kvack.org and let us know");
 	}
 
 	if (parent && parent->use_hierarchy) {
-- 
1.7.10.4

