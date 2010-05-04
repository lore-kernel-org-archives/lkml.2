Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759777Ab0EDDpq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 23:45:46 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:57604 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755583Ab0EDDpl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 23:45:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=XQ4a3V19vkxLIkKQH2F62DQSDYlBnnAqG6jyCV/7VfAb66YOkrpkoUcws1suWEQdUb
         qLkWkoplFRAANhdGe8DEDDOTtTFl5NZbSTqFE6Ss3uNbpRX+JH21GSzMizO4s0/MoUhs
         dEeFZNbxYvFwo3RsQEtPfxtXXuNjDnvzrwApc=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 1/3] lockdep: Provide off case for redundant_hardirqs_on increment
Date: Tue,  4 May 2010 05:45:34 +0200
Message-Id: <1272944736-25141-2-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <1272944736-25141-1-git-send-regression-fweisbec@gmail.com>
References: <1272944736-25141-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We forgot to provide a !CONFIG_DEBUG_LOCKDEP case for the
redundant_hardirqs_on stat handling.

Manage that in the headers with a new __debug_atomic_inc() helper.

Fixes:

	kernel/lockdep.c:2306: error: 'lockdep_stats' undeclared (first use in this function)
	kernel/lockdep.c:2306: error: (Each undeclared identifier is reported only once
	kernel/lockdep.c:2306: error: for each function it appears in.)

Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
---
 kernel/lockdep.c           |    2 +-
 kernel/lockdep_internals.h |    4 ++++
 2 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 1b58a1b..9cf7985 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -2303,7 +2303,7 @@ void trace_hardirqs_on_caller(unsigned long ip)
 		 * so this is racy by nature but loosing one hit
 		 * in a stat is not a big deal.
 		 */
-		this_cpu_inc(lockdep_stats.redundant_hardirqs_on);
+		__debug_atomic_inc(redundant_hardirqs_on);
 		return;
 	}
 	/* we'll do an OFF -> ON transition: */
diff --git a/kernel/lockdep_internals.h b/kernel/lockdep_internals.h
index 2b17476..7de27a8 100644
--- a/kernel/lockdep_internals.h
+++ b/kernel/lockdep_internals.h
@@ -139,6 +139,9 @@ struct lockdep_stats {
 
 DECLARE_PER_CPU(struct lockdep_stats, lockdep_stats);
 
+#define __debug_atomic_inc(ptr)					\
+	this_cpu_inc(lockdep_stats.ptr);
+
 #define debug_atomic_inc(ptr)			{		\
 	WARN_ON_ONCE(!irqs_disabled());				\
 	this_cpu_inc(lockdep_stats.ptr);			\
@@ -160,6 +163,7 @@ DECLARE_PER_CPU(struct lockdep_stats, lockdep_stats);
 	__total;							\
 })
 #else
+# define __debug_atomic_inc(ptr)	do { } while (0)
 # define debug_atomic_inc(ptr)		do { } while (0)
 # define debug_atomic_dec(ptr)		do { } while (0)
 # define debug_atomic_read(ptr)		0
-- 
1.6.2.3

