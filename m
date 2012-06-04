Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756047Ab2FDEbV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 00:31:21 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:38985 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753257Ab2FDEbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 00:31:19 -0400
Date: Mon, 4 Jun 2012 13:31:12 +0900
From: Tejun Heo <tj@kernel.org>
To: Jens Axboe <jaxboe@fusionio.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] block: blkcg_policy_cfq shouldn't be used if
 !CONFIG_CFQ_GROUP_IOSCHED
Message-ID: <20120604043112.GB21357@google.com>
References: <20120601112954.GC3535@osiris.boeblingen.de.ibm.com>
 <20120604043040.GA21357@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120604043040.GA21357@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cfq may be built w/ or w/o blkcg support depending on
CONFIG_CFQ_CGROUP_IOSCHED.  If blkcg support is disabled, most of
related code is ifdef'd out but some part is left dangling -
blkcg_policy_cfq is left zero-filled and blkcg_policy_[un]register()
calls are made on it.

Feeding zero filled policy to blkcg_policy_register() is incorrect and
triggers the following WARN_ON() if CONFIG_BLK_CGROUP &&
!CONFIG_CFQ_GROUP_IOSCHED.

 ------------[ cut here ]------------
 WARNING: at block/blk-cgroup.c:867
 Modules linked in:
 Modules linked in:
 CPU: 3 Not tainted 3.4.0-09547-gfb21aff #1
 Process swapper/0 (pid: 1, task: 000000003ff80000, ksp: 000000003ff7f8b8)
 Krnl PSW : 0704100180000000 00000000003d76ca (blkcg_policy_register+0xca/0xe0)
	    R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:0 CC:1 PM:0 EA:3
 Krnl GPRS: 0000000000000000 00000000014b85ec 00000000014b85b0 0000000000000000
	    000000000096fb60 0000000000000000 00000000009a8e78 0000000000000048
	    000000000099c070 0000000000b6f000 0000000000000000 000000000099c0b8
	    00000000014b85b0 0000000000667580 000000003ff7fd98 000000003ff7fd70
 Krnl Code: 00000000003d76be: a7280001           lhi     %r2,1
	    00000000003d76c2: a7f4ffdf           brc     15,3d7680
	   #00000000003d76c6: a7f40001           brc     15,3d76c8
	   >00000000003d76ca: a7c8ffea           lhi     %r12,-22
	    00000000003d76ce: a7f4ffce           brc     15,3d766a
	    00000000003d76d2: a7f40001           brc     15,3d76d4
	    00000000003d76d6: a7c80000           lhi     %r12,0
	    00000000003d76da: a7f4ffc2           brc     15,3d765e
 Call Trace:
 ([<0000000000b6f000>] initcall_debug+0x0/0x4)
  [<0000000000989e8a>] cfq_init+0x62/0xd4
  [<00000000001000ba>] do_one_initcall+0x3a/0x170
  [<000000000096fb60>] kernel_init+0x214/0x2bc
  [<0000000000623202>] kernel_thread_starter+0x6/0xc
  [<00000000006231fc>] kernel_thread_starter+0x0/0xc
 no locks held by swapper/0/1.
 Last Breaking-Event-Address:
  [<00000000003d76c6>] blkcg_policy_register+0xc6/0xe0
 ---[ end trace b8ef4903fcbf9dd3 ]---

This patch fixes the problem by ensuring all blkcg support code is
inside CONFIG_CFQ_GROUP_IOSCHED.

* blkcg_policy_cfq declaration and blkg_to_cfqg() definition are moved
  inside the first CONFIG_CFQ_GROUP_IOSCHED block.  __maybe_unused is
  dropped from blkcg_policy_cfq decl.

* blkcg_deactivate_poilcy() invocation is moved inside ifdef.  This
  also makes the activation logic match cfq_init_queue().

* All blkcg_policy_[un]register() invocations are moved inside ifdef.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Heiko Carstens <heiko.carstens@de.ibm.com>
LKML-Reference: <20120601112954.GC3535@osiris.boeblingen.de.ibm.com>
---
 block/cfq-iosched.c |   29 +++++++++++++++++------------
 1 file changed, 17 insertions(+), 12 deletions(-)

--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -17,8 +17,6 @@
 #include "blk.h"
 #include "blk-cgroup.h"
 
-static struct blkcg_policy blkcg_policy_cfq __maybe_unused;
-
 /*
  * tunables
  */
@@ -418,11 +416,6 @@ static inline struct cfq_group *pd_to_cf
 	return pd ? container_of(pd, struct cfq_group, pd) : NULL;
 }
 
-static inline struct cfq_group *blkg_to_cfqg(struct blkcg_gq *blkg)
-{
-	return pd_to_cfqg(blkg_to_pd(blkg, &blkcg_policy_cfq));
-}
-
 static inline struct blkcg_gq *cfqg_to_blkg(struct cfq_group *cfqg)
 {
 	return pd_to_blkg(&cfqg->pd);
@@ -572,6 +565,13 @@ static inline void cfqg_stats_update_avg
 
 #ifdef CONFIG_CFQ_GROUP_IOSCHED
 
+static struct blkcg_policy blkcg_policy_cfq;
+
+static inline struct cfq_group *blkg_to_cfqg(struct blkcg_gq *blkg)
+{
+	return pd_to_cfqg(blkg_to_pd(blkg, &blkcg_policy_cfq));
+}
+
 static inline void cfqg_get(struct cfq_group *cfqg)
 {
 	return blkg_get(cfqg_to_blkg(cfqg));
@@ -3951,10 +3951,11 @@ static void cfq_exit_queue(struct elevat
 
 	cfq_shutdown_timer_wq(cfqd);
 
-#ifndef CONFIG_CFQ_GROUP_IOSCHED
+#ifdef CONFIG_CFQ_GROUP_IOSCHED
+	blkcg_deactivate_policy(q, &blkcg_policy_cfq);
+#else
 	kfree(cfqd->root_group);
 #endif
-	blkcg_deactivate_policy(q, &blkcg_policy_cfq);
 	kfree(cfqd);
 }
 
@@ -4194,13 +4195,13 @@ static int __init cfq_init(void)
 #ifdef CONFIG_CFQ_GROUP_IOSCHED
 	if (!cfq_group_idle)
 		cfq_group_idle = 1;
-#else
-		cfq_group_idle = 0;
-#endif
 
 	ret = blkcg_policy_register(&blkcg_policy_cfq);
 	if (ret)
 		return ret;
+#else
+	cfq_group_idle = 0;
+#endif
 
 	ret = -ENOMEM;
 	cfq_pool = KMEM_CACHE(cfq_queue, 0);
@@ -4216,13 +4217,17 @@ static int __init cfq_init(void)
 err_free_pool:
 	kmem_cache_destroy(cfq_pool);
 err_pol_unreg:
+#ifdef CONFIG_CFQ_GROUP_IOSCHED
 	blkcg_policy_unregister(&blkcg_policy_cfq);
+#endif
 	return ret;
 }
 
 static void __exit cfq_exit(void)
 {
+#ifdef CONFIG_CFQ_GROUP_IOSCHED
 	blkcg_policy_unregister(&blkcg_policy_cfq);
+#endif
 	elv_unregister(&iosched_cfq);
 	kmem_cache_destroy(cfq_pool);
 }
