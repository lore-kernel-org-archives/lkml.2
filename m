Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751183Ab0E2EGP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 May 2010 00:06:15 -0400
Received: from mail-pz0-f204.google.com ([209.85.222.204]:58189 "EHLO
	mail-pz0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858Ab0E2EGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 May 2010 00:06:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=BHc6gQidjRJ8t30kbyxrMBXmOD2MbqWbeofwtZaPYUt1Gr0EWPztihWCfgKcxNaRun
         fjQqnmgXU6cx4TyCV+GG4jvyBv9BluZJN6hOfgCewi/hg0wB+Q93uhT6N3bL1O+5Eyxx
         HP1rqh+MJGD1/WAmnENRvZSRoPFoQxYT0GN5I=
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH] kernel/: fix BUG_ON checks for cpu notifier callbacks direct call
Date: Sat, 29 May 2010 13:04:43 +0900
Message-Id: <1275105883-4710-1-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The commit 80b5184cc537718122e036afe7e62d202b70d077
("kernel/: convert cpu notifier to return encapsulate errno value")
changed the return value of cpu notifier callbacks.

Those callbacks don't return NOTIFY_BAD on failures anymore.
But there are a few callbacks which are called directly at init time and
checking the return value.

I forgot to change BUG_ON checking by the direct callers in the commit.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 kernel/softirq.c |    2 +-
 kernel/timer.c   |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/softirq.c b/kernel/softirq.c
index 825e112..07b4f1b 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -850,7 +850,7 @@ static __init int spawn_ksoftirqd(void)
 	void *cpu = (void *)(long)smp_processor_id();
 	int err = cpu_callback(&cpu_nfb, CPU_UP_PREPARE, cpu);
 
-	BUG_ON(err == NOTIFY_BAD);
+	BUG_ON(err != NOTIFY_OK);
 	cpu_callback(&cpu_nfb, CPU_ONLINE, cpu);
 	register_cpu_notifier(&cpu_nfb);
 	return 0;
diff --git a/kernel/timer.c b/kernel/timer.c
index 2454172..ee305c8 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -1717,7 +1717,7 @@ void __init init_timers(void)
 
 	init_timer_stats();
 
-	BUG_ON(err == NOTIFY_BAD);
+	BUG_ON(err != NOTIFY_OK);
 	register_cpu_notifier(&timers_nb);
 	open_softirq(TIMER_SOFTIRQ, run_timer_softirq);
 }
-- 
1.6.0.6

