Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756717Ab1ISVsw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 17:48:52 -0400
Received: from mga03.intel.com ([143.182.124.21]:36717 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756409Ab1ISVsv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 17:48:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,407,1312182000"; 
   d="scan'208";a="50600778"
From: Andi Kleen <andi@firstfloor.org>
To: tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, eric.dumazet@gmail.com,
        akpm@linux-foundation.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 2/2] posix-timers: limit the number of posix timers per process v2
Date: Mon, 19 Sep 2011 14:48:45 -0700
Message-Id: <1316468925-16754-2-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1316468925-16754-1-git-send-email-andi@firstfloor.org>
References: <1316468925-16754-1-git-send-email-andi@firstfloor.org>
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

Uses a rlimit to limit the number of timers.

The 1024 default is completely arbitrary, but seems reasonable
for now.

v2: Use a rlimit instead of sysctl
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 fs/proc/base.c                 |    1 +
 include/asm-generic/resource.h |    4 +++-
 include/linux/limits.h         |    1 +
 kernel/posix-timers.c          |    6 ++++++
 4 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 5eb0206..229ec4e 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -511,6 +511,7 @@ static const struct limit_names lnames[RLIM_NLIMITS] = {
 	[RLIMIT_NICE] = {"Max nice priority", NULL},
 	[RLIMIT_RTPRIO] = {"Max realtime priority", NULL},
 	[RLIMIT_RTTIME] = {"Max realtime timeout", "us"},
+	[RLIMIT_POSIX_TIMERS] = {"Max number of POSIX timers", "timers"},
 };
 
 /* Display limits for a process */
diff --git a/include/asm-generic/resource.h b/include/asm-generic/resource.h
index 61fa862..9fde1b5 100644
--- a/include/asm-generic/resource.h
+++ b/include/asm-generic/resource.h
@@ -45,7 +45,8 @@
 					   0-39 for nice level 19 .. -20 */
 #define RLIMIT_RTPRIO		14	/* maximum realtime priority */
 #define RLIMIT_RTTIME		15	/* timeout for RT tasks in us */
-#define RLIM_NLIMITS		16
+#define RLIMIT_POSIX_TIMERS	16	/* max number of posix timers/process */
+#define RLIM_NLIMITS		17
 
 /*
  * SuS says limits have to be unsigned.
@@ -87,6 +88,7 @@
 	[RLIMIT_NICE]		= { 0, 0 },				\
 	[RLIMIT_RTPRIO]		= { 0, 0 },				\
 	[RLIMIT_RTTIME]		= {  RLIM_INFINITY,  RLIM_INFINITY },	\
+	[RLIMIT_POSIX_TIMERS]	= { POSIX_TIMERS_LIM, POSIX_TIMERS_LIM }, \
 }
 
 #endif	/* __KERNEL__ */
diff --git a/include/linux/limits.h b/include/linux/limits.h
index 2d0f941..634a445 100644
--- a/include/linux/limits.h
+++ b/include/linux/limits.h
@@ -14,6 +14,7 @@
 #define XATTR_NAME_MAX   255	/* # chars in an extended attribute name */
 #define XATTR_SIZE_MAX 65536	/* size of an extended attribute value (64k) */
 #define XATTR_LIST_MAX 65536	/* size of extended attribute namelist (64k) */
+#define POSIX_TIMERS_LIM 1024   /* Number of posix timers process (default) */
 
 #define RTSIG_MAX	  32
 
diff --git a/kernel/posix-timers.c b/kernel/posix-timers.c
index f832021..9eb0a68 100644
--- a/kernel/posix-timers.c
+++ b/kernel/posix-timers.c
@@ -567,6 +567,12 @@ SYSCALL_DEFINE3(timer_create, const clockid_t, which_clock,
 
 	it_id_set = IT_ID_SET;
 	new_timer->it_id = (timer_t) new_timer_id;
+
+	if (new_timer_id >= rlimit(RLIMIT_POSIX_TIMERS)) {
+		error = -EPERM;
+		goto out;
+	}
+
 	new_timer->it_clock = which_clock;
 	new_timer->it_overrun = -1;
 
-- 
1.7.4.4

