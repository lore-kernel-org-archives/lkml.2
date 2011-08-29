Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755548Ab1H2XjZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 19:39:25 -0400
Received: from mga02.intel.com ([134.134.136.20]:50757 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755401Ab1H2XjY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 19:39:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="43427269"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, eric.dumazet@gmail.com,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 2/4] posix-timers: limit the number of posix timers per process
Date: Mon, 29 Aug 2011 16:39:15 -0700
Message-Id: <1314661157-22173-2-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1314661157-22173-1-git-send-email-andi@firstfloor.org>
References: <1314661157-22173-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Now this is the main reason I wrote the whole patchkit: previously
there was no limit on the maximum number of POSIX timers a process
could allocate.  This limits the amount of unswappable kernel memory
a process can pin down this way.

With the POSIX timer ids being per process we can do this limit
per process now without allowing one process DoSing another.

I implemented it as a sysctl, not a rlimit for now, because
there was no clear use case for rlimit.

The 1024 default is completely arbitrary, but seems reasonable
for now.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 Documentation/sysctl/kernel.txt |    7 +++++++
 kernel/posix-timers.c           |    8 ++++++++
 kernel/sysctl.c                 |    9 +++++++++
 3 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kernel.txt
index 704e474..1f69cae 100644
--- a/Documentation/sysctl/kernel.txt
+++ b/Documentation/sysctl/kernel.txt
@@ -35,6 +35,7 @@ show up in /proc/sys/kernel:
 - kptr_restrict
 - kstack_depth_to_print       [ X86 only ]
 - l2cr                        [ PPC only ]
+- max_posix_timer
 - modprobe                    ==> Documentation/debugging-modules.txt
 - modules_disabled
 - msgmax
@@ -299,6 +300,12 @@ This flag controls the L2 cache of G3 processor boards. If
 
 ==============================================================
 
+max_posix_timers
+
+The maximum number of POSIX timer ids per process.
+
+==============================================================
+
 modules_disabled:
 
 A toggle value indicating if modules are allowed to be loaded
diff --git a/kernel/posix-timers.c b/kernel/posix-timers.c
index 4193cf7..ef6721c 100644
--- a/kernel/posix-timers.c
+++ b/kernel/posix-timers.c
@@ -71,6 +71,8 @@
  */
 static struct kmem_cache *posix_timers_cache;
 
+int sysctl_max_posix_timers __read_mostly = 1024;
+
 /*
  * we assume that the new SIGEV_THREAD_ID shares no bits with the other
  * SIGEV values.  Here we put out an error if this assumption fails.
@@ -572,6 +574,12 @@ SYSCALL_DEFINE3(timer_create, const clockid_t, which_clock,
 
 	it_id_set = IT_ID_SET;
 	new_timer->it_id = (timer_t) new_timer_id;
+
+	if (new_timer_id >= sysctl_max_posix_timers) {
+		error = -EMFILE;  /* better error? */
+		goto out;
+	}
+
 	new_timer->it_clock = which_clock;
 	new_timer->it_overrun = -1;
 
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 11d65b5..8fcf8b5 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -108,6 +108,7 @@ extern int sysctl_nr_trim_pages;
 #ifdef CONFIG_BLOCK
 extern int blk_iopoll_enabled;
 #endif
+extern int sysctl_max_posix_timers;
 
 /* Constants used for minimum and  maximum */
 #ifdef CONFIG_LOCKUP_DETECTOR
@@ -984,6 +985,14 @@ static struct ctl_table kern_table[] = {
 		.proc_handler	= proc_dointvec,
 	},
 #endif
+	{
+		.procname	= "max_posix_timers",
+		.data		= &sysctl_max_posix_timers,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
+
 	{ }
 };
 
-- 
1.7.4.4

