Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756292Ab2IYNK5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 09:10:57 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:32061 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756130Ab2IYNKz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 09:10:55 -0400
X-IronPort-AV: E=Sophos;i="4.80,482,1344182400"; 
   d="scan'208";a="5914411"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: peterz@infradead.org, srivatsa.bhat@linux.vnet.ibm.com, mingo@kernel.org,
        tglx@linutronix.de, linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-numa@vger.kernel.org
Cc: Tang Chen <tangchen@cn.fujitsu.com>, Wen Congyang <wency@cn.fujitsu.com>
Subject: [PATCH v2 1/2] Ensure sched_domains_numa_levels safe in other functions.
Date: Tue, 25 Sep 2012 21:12:30 +0800
Message-Id: <1348578751-16904-2-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1348578751-16904-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1348578751-16904-1-git-send-email-tangchen@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/25 21:11:04,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/25 21:11:05,
	Serialize complete at 2012/09/25 21:11:05
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should temporarily reset sched_domains_numa_levels to 0 after
it is reset to 'level' in sched_init_numa(). If it fails to allocate
memory for array sched_domains_numa_masks[][], the array will contain
less then 'level' members. This could be dangerous when we use it to
iterate array sched_domains_numa_masks[][] in other functions.

This patch set sched_domains_numa_levels to 0 before initializing
array sched_domains_numa_masks[][], and reset it to 'level' when
sched_domains_numa_masks[][] is fully initialized.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
---
 kernel/sched/core.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 649c9f8..3aa306a 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6660,6 +6660,17 @@ static void sched_init_numa(void)
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
@@ -6714,6 +6725,8 @@ static void sched_init_numa(void)
 	}
 
 	sched_domain_topology = tl;
+
+	sched_domains_numa_levels = level;
 }
 #else
 static inline void sched_init_numa(void)
-- 
1.7.10.1

