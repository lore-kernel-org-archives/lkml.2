Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752754Ab1ARWjc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 17:39:32 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:52232 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752053Ab1ARWjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 17:39:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=s5gpCzX0dLKEO2Q5mLLK4eEviFOmvP35JpzRNLLOS71D/h9Wxb+3ESif6qe9YXRp6j
         JIjBBr58ttxebuhz19wQZn4JWFfipYxa38Wik240OnsKjcRPg8FlrgTc6M4wE6ERD6wh
         8NrbdvqUiWQL2hhXgq2THJyKU0T4DEowZzIkI=
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Don Zickus <dzickus@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        stable@kernel.org
Subject: [PATCH 2/3] watchdog: fix sysctl consistency
Date: Tue, 18 Jan 2011 23:37:45 +0100
Message-Id: <1295390266-9347-2-git-send-email-marcin.slusarz@gmail.com>
X-Mailer: git-send-email 1.7.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If it was not possible to enable watchdog for any cpu, switch watchdog_enabled
back to 0, because it's visible via kernel.watchdog sysctl.

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: stable@kernel.org
---
 kernel/watchdog.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index ba52aa3..9f24056 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -422,9 +422,6 @@ static int watchdog_enable(int cpu)
 		wake_up_process(p);
 	}
 
-	/* if any cpu succeeds, watchdog is considered enabled for the system */
-	watchdog_enabled = 1;
-
 	return 0;
 }
 
@@ -452,12 +449,16 @@ static void watchdog_disable(int cpu)
 static void watchdog_enable_all_cpus(void)
 {
 	int cpu;
-	int result = 0;
+
+	watchdog_enabled = 0;
 
 	for_each_online_cpu(cpu)
-		result += watchdog_enable(cpu);
+		if (!watchdog_enable(cpu))
+			/* if any cpu succeeds, watchdog is considered
+			   enabled for the system */
+			watchdog_enabled = 1;
 
-	if (result)
+	if (!watchdog_enabled)
 		printk(KERN_ERR "watchdog: failed to be enabled on some cpus\n");
 
 }
-- 
1.7.3.3

