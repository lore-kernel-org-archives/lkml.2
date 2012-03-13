Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030253Ab2CMA3L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:29:11 -0400
Received: from mail.windriver.com ([147.11.1.11]:48985 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965270Ab2CMAZC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:25:02 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, john stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 182/196] clocksource: Install completely before selecting
Date: Mon, 12 Mar 2012 20:21:35 -0400
Message-Id: <1331598109-31424-137-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
 <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: john stultz <johnstul@us.ibm.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit e05b2efb82596905ebfe88e8612ee81dec9b6592 upstream.

Christian Hoffmann reported that the command line clocksource override
with acpi_pm timer fails:

 Kernel command line: <SNIP> clocksource=acpi_pm
 hpet clockevent registered
 Switching to clocksource hpet
 Override clocksource acpi_pm is not HRT compatible.
 Cannot switch while in HRT/NOHZ mode.

The watchdog code is what enables CLOCK_SOURCE_VALID_FOR_HRES, but we
actually end up selecting the clocksource before we enqueue it into
the watchdog list, so that's why we see the warning and fail to switch
to acpi_pm timer as requested. That's particularly bad when we want to
debug timekeeping related problems in early boot.

Put the selection call last.

[PG: 34 doesn't have __clocksource_register_scale, so drop that 1/2]

Reported-by: Christian Hoffmann <email@christianhoffmann.info>
Signed-off-by: John Stultz <johnstul@us.ibm.com>
Link: http://lkml.kernel.org/r/%3C1304558210.2943.24.camel%40work-vm%3E
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 kernel/time/clocksource.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index 1f5dde6..db24c5c 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -638,8 +638,8 @@ int clocksource_register(struct clocksource *cs)
 
 	mutex_lock(&clocksource_mutex);
 	clocksource_enqueue(cs);
-	clocksource_select();
 	clocksource_enqueue_watchdog(cs);
+	clocksource_select();
 	mutex_unlock(&clocksource_mutex);
 	return 0;
 }
-- 
1.7.9.3

