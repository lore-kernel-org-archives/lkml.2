Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751613Ab0HUJtM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Aug 2010 05:49:12 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:59221 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902Ab0HUJtK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Aug 2010 05:49:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=NMC8AQpuj95jeG9EDbaKe296Jk0Jb/P+de3hIRgla6ZPV7XrZjNPxV+IHnzFN/qSjM
         q7t3yQsZg6mE+TAX6Bm6fIHSkoclag/N0MS77+jT7REXUfulc90y9wwdz6Ex6PiiOrIj
         jLdovYNH11Le3W1lQK7nZhMNNLpsAUSs46UuA=
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH] stop_machine: convert cpu notifier to return encapsulate errno value
Date: Sat, 21 Aug 2010 18:42:48 +0900
Message-Id: <1282383768-11320-1-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By the commit e6bde73b07edeb703d4c89c1daabc09c303de11f
("cpu-hotplug: return better errno on cpu hotplug failure"),
the cpu notifier can return encapsulate errno value.

This converts the cpu notifier to return encapsulate errno value
for stop_machine.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 kernel/stop_machine.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/stop_machine.c b/kernel/stop_machine.c
index 4372ccb..9f95199 100644
--- a/kernel/stop_machine.c
+++ b/kernel/stop_machine.c
@@ -303,7 +303,7 @@ static int __cpuinit cpu_stop_cpu_callback(struct notifier_block *nfb,
 		p = kthread_create(cpu_stopper_thread, stopper, "migration/%d",
 				   cpu);
 		if (IS_ERR(p))
-			return NOTIFY_BAD;
+			return notifier_from_errno(PTR_ERR(p));
 		sched_setscheduler_nocheck(p, SCHED_FIFO, &param);
 		get_task_struct(p);
 		stopper->thread = p;
@@ -370,7 +370,7 @@ static int __init cpu_stop_init(void)
 	/* start one for the boot cpu */
 	err = cpu_stop_cpu_callback(&cpu_stop_cpu_notifier, CPU_UP_PREPARE,
 				    bcpu);
-	BUG_ON(err == NOTIFY_BAD);
+	BUG_ON(err != NOTIFY_OK);
 	cpu_stop_cpu_callback(&cpu_stop_cpu_notifier, CPU_ONLINE, bcpu);
 	register_cpu_notifier(&cpu_stop_cpu_notifier);
 
-- 
1.6.0.6

