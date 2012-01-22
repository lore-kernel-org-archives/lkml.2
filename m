Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751761Ab2AVDIX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 22:08:23 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:47700 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751174Ab2AVDIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 22:08:22 -0500
MIME-Version: 1.0
Date: Sun, 22 Jan 2012 11:08:20 +0800
Message-ID: <CAJd=RBC8dCGgqXqP+yjW2+pVoSeFXwXfjx8DLHhMuY8goOadZw@mail.gmail.com>
Subject: [PATCH] mm: vmscan: ensure reclaiming pages on the lru lists of zone
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

It is possible that the memcg input into shrink_mem_cgroup_zone() in
each round is not NULL, and the loop terminates at NULL case. And there
is chance that pages on the lru lists of zone are not reclaimed.

Mem cgroup iteration is refactored a bit to ensure the NULL case is also
input into the function.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/mm/vmscan.c	Sat Jan 14 14:02:20 2012
+++ b/mm/vmscan.c	Sun Jan 22 10:09:32 2012
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
+		mz.mem_cgroup = memcg,

 		shrink_mem_cgroup_zone(priority, &mz, sc);
 		/*
@@ -2166,7 +2166,6 @@ static void shrink_zone(int priority, st
 			mem_cgroup_iter_break(root, memcg);
 			break;
 		}
-		memcg = mem_cgroup_iter(root, memcg, &reclaim);
 	} while (memcg);
 }
