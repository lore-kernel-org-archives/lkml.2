Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932544Ab0FQIOZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 04:14:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:60436 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932094Ab0FQIOX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 04:14:23 -0400
Message-ID: <4C19D94C.6090807@kernel.org>
Date: Thu, 17 Jun 2010 10:14:04 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: "Pavel V. Panteleev" <pp_84@mail.ru>, linux-mm@kvak.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] percpu in linux-2.6.35-rc3
References: <E1OOr6Q-0005Zi-00.pp_84-mail-ru@f57.mail.ru> <20100616145639.GE17599@basil.fritz.box>
In-Reply-To: <20100616145639.GE17599@basil.fritz.box>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 17 Jun 2010 08:14:07 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi, thanks for forwarding.

Pavel, I wrote up the patch description, added SOBs and committed it to
percpu#for-linus.  Will push it to mainline later.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu.git for-linus

Thanks.

>From a92d3ff9e5dbd958d8008a3e7a573e988e370ca3 Mon Sep 17 00:00:00 2001
From: Pavel V. Panteleev <pp_84@mail.ru>
Date: Thu, 17 Jun 2010 10:07:25 +0200
Subject: [PATCH] percpu: fix trivial bugs in pcpu_build_alloc_info()

Fix the following two trivial bugs in pcpu_build_alloc_info()

* we should memset group_cnt to 0 by size of group_cnt, not size of
  group_map (both are of the same size, so the bug isn't dangerous)

* we can delete useless variable group_cnt_max.

Signed-off-by: Pavel V. Panteleev <pp_84@mail.ru>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
 mm/percpu.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index 39f7dfd..46485e1 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -1086,7 +1086,7 @@ struct pcpu_alloc_info * __init pcpu_build_alloc_info(
 	static int group_map[NR_CPUS] __initdata;
 	static int group_cnt[NR_CPUS] __initdata;
 	const size_t static_size = __per_cpu_end - __per_cpu_start;
-	int group_cnt_max = 0, nr_groups = 1, nr_units = 0;
+	int nr_groups = 1, nr_units = 0;
 	size_t size_sum, min_unit_size, alloc_size;
 	int upa, max_upa, uninitialized_var(best_upa);	/* units_per_alloc */
 	int last_allocs, group, unit;
@@ -1096,7 +1096,7 @@ struct pcpu_alloc_info * __init pcpu_build_alloc_info(

 	/* this function may be called multiple times */
 	memset(group_map, 0, sizeof(group_map));
-	memset(group_cnt, 0, sizeof(group_map));
+	memset(group_cnt, 0, sizeof(group_cnt));

 	/*
 	 * Determine min_unit_size, alloc_size and max_upa such that
@@ -1130,7 +1130,6 @@ struct pcpu_alloc_info * __init pcpu_build_alloc_info(
 		}
 		group_map[cpu] = group;
 		group_cnt[group]++;
-		group_cnt_max = max(group_cnt_max, group_cnt[group]);
 	}

 	/*
-- 
1.6.4.2

