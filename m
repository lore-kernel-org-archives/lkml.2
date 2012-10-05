Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753324Ab2JENCL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 09:02:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34643 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401Ab2JENCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 09:02:09 -0400
Date: Fri, 5 Oct 2012 06:01:47 -0700
From: tip-bot for Tang Chen <tangchen@cn.fujitsu.com>
Message-ID: <tip-5f7865f3e44db4c73fdc454fb2af40806212a7ca@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        wency@cn.fujitsu.com, a.p.zijlstra@chello.nl, tangchen@cn.fujitsu.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        wency@cn.fujitsu.com, a.p.zijlstra@chello.nl, tangchen@cn.fujitsu.com,
        tglx@linutronix.de
In-Reply-To: <1348578751-16904-2-git-send-email-tangchen@cn.fujitsu.com>
References: <1348578751-16904-2-git-send-email-tangchen@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Ensure 'sched_domains_numa_levels'
  is safe to use in other functions
Git-Commit-ID: 5f7865f3e44db4c73fdc454fb2af40806212a7ca
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 05 Oct 2012 06:01:54 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5f7865f3e44db4c73fdc454fb2af40806212a7ca
Gitweb:     http://git.kernel.org/tip/5f7865f3e44db4c73fdc454fb2af40806212a7ca
Author:     Tang Chen <tangchen@cn.fujitsu.com>
AuthorDate: Tue, 25 Sep 2012 21:12:30 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 5 Oct 2012 13:54:46 +0200

sched: Ensure 'sched_domains_numa_levels' is safe to use in other functions

We should temporarily reset 'sched_domains_numa_levels' to 0 after
it is reset to 'level' in sched_init_numa(). If it fails to allocate
memory for array sched_domains_numa_masks[][], the array will contain
less then 'level' members. This could be dangerous when we use it to
iterate array sched_domains_numa_masks[][] in other functions.

This patch set sched_domains_numa_levels to 0 before initializing
array sched_domains_numa_masks[][], and reset it to 'level' when
sched_domains_numa_masks[][] is fully initialized.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1348578751-16904-2-git-send-email-tangchen@cn.fujitsu.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index c177472..f895fdd 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6122,6 +6122,17 @@ static void sched_init_numa(void)
 	 * numbers.
 	 */
 
+	/*
+	 * Here, we should temporarily reset sched_domains_numa_levels to 0.
+	 * If it fails to allocate memory for array sched_domains_numa_masks[][],
+	 * the array will contain less then 'level' members. This could be
+	 * dangerous when we use it to iterate array sched_domains_numa_masks[][]
+	 * in other functions.
+	 *
+	 * We reset it to 'level' at the end of this function.
+	 */
+	sched_domains_numa_levels = 0;
+
 	sched_domains_numa_masks = kzalloc(sizeof(void *) * level, GFP_KERNEL);
 	if (!sched_domains_numa_masks)
 		return;
@@ -6176,6 +6187,8 @@ static void sched_init_numa(void)
 	}
 
 	sched_domain_topology = tl;
+
+	sched_domains_numa_levels = level;
 }
 #else
 static inline void sched_init_numa(void)
