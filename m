Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752485Ab1DUNXl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 09:23:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2178 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750981Ab1DUNXk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 09:23:40 -0400
From: Don Zickus <dzickus@redhat.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hillf Danton <dhillf@gmail.com>,
        Don Zickus <dzickus@redhat.com>
Subject: [PATCH] watchdog: Disable nmi perf event in the error path of enabling watchdog
Date: Thu, 21 Apr 2011 04:22:36 -0400
Message-Id: <1303374156-8885-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hillf Danton <dhillf@gmail.com>

In corner cases where softlockup watchdog is not setup successfully,
the relevant nmi perf event for hardlockup watchdog could be disabled,
then the status of the underlying hardware remains unchanged.

[ also if the kthread doesn't start, the hrtimer won't run and the
  hardlockup detector will falsely fire ]

Signed-off-by: Hillf Danton <dhillf@gmail.com>
Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 kernel/watchdog.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 140dce7..14733d4 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -430,9 +430,12 @@ static int watchdog_enable(int cpu)
 		p = kthread_create(watchdog, (void *)(unsigned long)cpu, "watchdog/%d", cpu);
 		if (IS_ERR(p)) {
 			printk(KERN_ERR "softlockup watchdog for %i failed\n", cpu);
-			if (!err)
+			if (!err) {
 				/* if hardlockup hasn't already set this */
 				err = PTR_ERR(p);
+				/* and disable the perf event */
+				watchdog_nmi_disable(cpu);
+			}
 			goto out;
 		}
 		kthread_bind(p, cpu);
-- 
1.7.4.2

