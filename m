Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758105Ab1FJUOb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 16:14:31 -0400
Received: from mga02.intel.com ([134.134.136.20]:21809 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758061Ab1FJUO0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 16:14:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,348,1304319600"; 
   d="scan'208";a="12148033"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: eric.dumazet@gmail.com, tglx@linutronix.de,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 3/3] posix-timers: limit the number of posix timers per process
Date: Fri, 10 Jun 2011 13:13:08 -0700
Message-Id: <1307736788-25457-3-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1307736788-25457-1-git-send-email-andi@firstfloor.org>
References: <1307736788-25457-1-git-send-email-andi@firstfloor.org>
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
index 5e7cb39..311c4b3 100644
--- a/Documentation/sysctl/kernel.txt
+++ b/Documentation/sysctl/kernel.txt
@@ -68,6 +68,7 @@ show up in /proc/sys/kernel:
 - threads-max
 - unknown_nmi_panic
 - version
+- max_posix_timers
 
 ==============================================================
 
@@ -555,3 +556,9 @@ A small number of systems do generate NMI's for bizarre random reasons such as
 power management so the default is off. That sysctl works like the existing
 panic controls already in that directory.
 
+===============================================================
+
+max_posix_timers
+
+The maximum number of POSIX timer ids per process.
+
diff --git a/kernel/posix-timers.c b/kernel/posix-timers.c
index 7351e51..2d5b1f0 100644
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
@@ -567,6 +569,12 @@ SYSCALL_DEFINE3(timer_create, const clockid_t, which_clock,
 
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
index f175d98..d24eec6 100644
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

