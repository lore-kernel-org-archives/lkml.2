Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161318Ab2COTrr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 15:47:47 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:58528 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965418Ab2COTrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 15:47:43 -0400
From: Sasha Levin <levinsasha928@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, akpm@linux-foundation.org, tglx@linutronix.de,
        hpa@zytor.com, Sasha Levin <levinsasha928@gmail.com>
Subject: [PATCH] hung task: NMI when hung and going to panic
Date: Thu, 15 Mar 2012 17:47:20 -0400
Message-Id: <1331848040-1676-1-git-send-email-levinsasha928@gmail.com>
X-Mailer: git-send-email 1.7.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NMI all CPUs when detected a hung task and the hung task code is configured
to panic.

This lets us get stack trace of all CPUs which makes life easier trying to
debug a deadlock, and the NMI doesn't change anything since the next step is
a kernel panic.

Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
---
 kernel/hung_task.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/kernel/hung_task.c b/kernel/hung_task.c
index c21449f..6df6149 100644
--- a/kernel/hung_task.c
+++ b/kernel/hung_task.c
@@ -108,8 +108,10 @@ static void check_hung_task(struct task_struct *t, unsigned long timeout)
 
 	touch_nmi_watchdog();
 
-	if (sysctl_hung_task_panic)
+	if (sysctl_hung_task_panic) {
+		trigger_all_cpu_backtrace();
 		panic("hung_task: blocked tasks");
+	}
 }
 
 /*
-- 
1.7.8.4

