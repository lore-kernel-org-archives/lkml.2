Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757149Ab0DOVKr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 17:10:47 -0400
Received: from mail-bw0-f225.google.com ([209.85.218.225]:55930 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756696Ab0DOVKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 17:10:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version;
        b=LJOd21+GAoRognPhDu4OmPqYTjgmIjdDIrbTrU8cEQMDbehZIDG8QNn6Zmb+5KwUlu
         XWirDDrSTMjAC4syQ33y7cGQbO8K28MQ++FHB/zuJgA4u/UUfOX2ztHBkWwuRnb2ClU5
         r+AkwfYGDhX/4mBI5W/hHo76gDyPNpUwhCyi8=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 1/2 v2] lockdep: Fix redundant_hardirqs_on incremented with irqs enabled
Date: Thu, 15 Apr 2010 23:10:42 +0200
Message-Id: <1271365843-17415-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a path restore the flags while irqs are already enabled, we
update the per cpu var redundant_hardirqs_on in a racy fashion
and debug_atomic_inc() warns about this situation.

In this particular case, loosing a few hits in a stat is not a big
deal, so increment it without protection.

v2: Don't bother with disabling irq, we can miss one count in
    rare situations

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: David Miller <davem@davemloft.net>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---
 kernel/lockdep.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 78325f8..1b58a1b 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -2298,7 +2298,12 @@ void trace_hardirqs_on_caller(unsigned long ip)
 		return;
 
 	if (unlikely(curr->hardirqs_enabled)) {
-		debug_atomic_inc(redundant_hardirqs_on);
+		/*
+		 * Neither irq nor preemption are disabled here
+		 * so this is racy by nature but loosing one hit
+		 * in a stat is not a big deal.
+		 */
+		this_cpu_inc(lockdep_stats.redundant_hardirqs_on);
 		return;
 	}
 	/* we'll do an OFF -> ON transition: */
-- 
1.6.2.3

