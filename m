Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757197Ab0DOVKu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 17:10:50 -0400
Received: from mail-bw0-f225.google.com ([209.85.218.225]:42647 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757084Ab0DOVKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 17:10:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=A5x3LRO4a/7lB1NyHe5UH0W5haI9TamEBkHsnid8xeiiNC9Zhgl18NR8tBa/vhAV/q
         rFDhFCHzZLarAAGLRsg6gxQMXQJf2Eo0QzCkDvlEzQM7n8O1rGczRgGa6Bwg+M0kYerb
         LDixDtOWh/WlYH3X+56hvmavsevihWPoC6dLU=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 2/2] lockdep: Simplify debug atomic ops
Date: Thu, 15 Apr 2010 23:10:43 +0200
Message-Id: <1271365843-17415-2-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <1271365843-17415-1-git-send-regression-fweisbec@gmail.com>
References: <1271365843-17415-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simplify debug_atomic_inc/dec by using this_cpu_inc/dec() instead
of doing it through an indirect get_cpu_var() and a manual
incrementation.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
---
 kernel/lockdep_internals.h |   10 ++--------
 1 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/kernel/lockdep_internals.h b/kernel/lockdep_internals.h
index 8d7d4b6..2b17476 100644
--- a/kernel/lockdep_internals.h
+++ b/kernel/lockdep_internals.h
@@ -140,19 +140,13 @@ struct lockdep_stats {
 DECLARE_PER_CPU(struct lockdep_stats, lockdep_stats);
 
 #define debug_atomic_inc(ptr)			{		\
-	struct lockdep_stats *__cpu_lockdep_stats;		\
-								\
 	WARN_ON_ONCE(!irqs_disabled());				\
-	__cpu_lockdep_stats = &__get_cpu_var(lockdep_stats);	\
-	__cpu_lockdep_stats->ptr++;				\
+	this_cpu_inc(lockdep_stats.ptr);			\
 }
 
 #define debug_atomic_dec(ptr)			{		\
-	struct lockdep_stats *__cpu_lockdep_stats;		\
-								\
 	WARN_ON_ONCE(!irqs_disabled());				\
-	__cpu_lockdep_stats = &__get_cpu_var(lockdep_stats);	\
-	__cpu_lockdep_stats->ptr--;				\
+	this_cpu_inc(lockdep_stats.ptr);			\
 }
 
 #define debug_atomic_read(ptr)		({				\
-- 
1.6.2.3

