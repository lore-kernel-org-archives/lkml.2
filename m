Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932327Ab1KBNru (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 09:47:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58967 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932264Ab1KBNrs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 09:47:48 -0400
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Prarit Bhargava <prarit@redhat.com>, tglx@linutronix.de,
        johnstul@us.ibm.com
Subject: [PATCH] [PATCH]: Reset clocksource watchdog after sysrq-t
Date: Wed,  2 Nov 2011 09:46:25 -0400
Message-Id: <1320241585-28056-1-git-send-email-prarit@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When doing a sysrq-t other processes are starved out because the task_list
lock is held.  On a large enough system this means that the clocksource
watchdog does not fire for a long time and when system operation resumes the
watchdog erroneously marks the current clocksource as unstable.

Reset the clocksource watchdog after show_state_filter() has dumped the
task states.

Cc: tglx@linutronix.de
Cc: johnstul@us.ibm.com
---
 kernel/sched.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index d87c6e5..b09c053 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -71,6 +71,7 @@
 #include <linux/ctype.h>
 #include <linux/ftrace.h>
 #include <linux/slab.h>
+#include <linux/clocksource.h>
 
 #include <asm/tlb.h>
 #include <asm/irq_regs.h>
@@ -6034,6 +6035,7 @@ void show_state_filter(unsigned long state_filter)
 	} while_each_thread(g, p);
 
 	touch_all_softlockup_watchdogs();
+	clocksource_touch_watchdog();
 
 #ifdef CONFIG_SCHED_DEBUG
 	sysrq_sched_debug_show();
-- 
1.7.1

