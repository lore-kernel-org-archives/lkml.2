Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752114Ab2AVQrh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jan 2012 11:47:37 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:50718 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751961Ab2AVQrg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jan 2012 11:47:36 -0500
MIME-Version: 1.0
In-Reply-To: <CAJd=RBC8dCGgqXqP+yjW2+pVoSeFXwXfjx8DLHhMuY8goOadZw@mail.gmail.com>
References: <CAJd=RBC8dCGgqXqP+yjW2+pVoSeFXwXfjx8DLHhMuY8goOadZw@mail.gmail.com>
Date: Mon, 23 Jan 2012 00:47:34 +0800
Message-ID: <CAJd=RBBqp3bMGwFc14BJ7+=KsfO0gLnrnXwbRdLDYOJDdvbptA@mail.gmail.com>
Subject: Re: [PATCH] mm: vmscan: ensure reclaiming pages on the lru lists of zone
From: Hillf Danton <dhillf@gmail.com>
To: linux-mm@kvack.org
Cc: Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Ying Han <yinghan@google.com>, Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Hillf Danton <dhillf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all

For easy review, it is re-prepared based on 3.3-rc1.

Thanks
Hillf

===cut please===
From: Hillf Danton <dhillf@gmail.com>
Subject: [PATCH] mm: vmscan: ensure reclaiming pages on the lru lists of zone

While iterating over memory cgroup hierarchy, pages are reclaimed from each
mem cgroup, and reclaim terminates after a full round-trip. It is possible
that no pages on the lru lists of given zone are reclaimed, as termination
is checked after the reclaiming function.

Mem cgroup iteration is rearranged a bit to make sure that pages are reclaimed
from both mem cgroups and zone.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/mm/vmscan.c	Mon Jan 23 00:23:10 2012
+++ b/mm/vmscan.c	Mon Jan 23 00:26:44 2012
@@ -2142,14 +2142,14 @@ static void shrink_zone(int priority, st
 		.zone = zone,
 		.priority = priority,
 	};
-	struct mem_cgroup *memcg;
+	struct mem_cgroup_zone mz = {
+		.zone = zone,
+	};
+	struct mem_cgroup *memcg = NULL;

-	memcg = mem_cgroup_iter(root, NULL, &reclaim);
 	do {
-		struct mem_cgroup_zone mz = {
-			.mem_cgroup = memcg,
-			.zone = zone,
-		};
+		memcg = mem_cgroup_iter(root, memcg, &reclaim);
+		mz.mem_cgroup = memcg;

 		shrink_mem_cgroup_zone(priority, &mz, sc);
 		/*
@@ -2166,7 +2166,6 @@ static void shrink_zone(int priority, st
 			mem_cgroup_iter_break(root, memcg);
 			break;
 		}
-		memcg = mem_cgroup_iter(root, memcg, &reclaim);
 	} while (memcg);
 }
