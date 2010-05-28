Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754803Ab0E1HDw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 03:03:52 -0400
Received: from vms173007pub.verizon.net ([206.46.173.7]:23566 "EHLO
	vms173007pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754530Ab0E1HDp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 03:03:45 -0400
From: Len Brown <lenb@kernel.org>
To: linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>,
       Shaohua Li <shaohua.li@intel.com>
Subject: [PATCH 6/8] acpi_pad: uses MONITOR/MWAIT,
 so it doesn't need to clear TS_POLLING
Date: Fri, 28 May 2010 02:01:59 -0400
Message-id: <a7d27c37533524e23bbdc9ba1d78e3241b7483ea.1275026041.git.len.brown@intel.com>
X-Mailer: git-send-email 1.7.1.231.gd0b16
In-reply-to: <1275026521-30835-1-git-send-email-lenb@kernel.org>
References: <1275026521-30835-1-git-send-email-lenb@kernel.org>
In-reply-to: <6b2c676bf32be91f43215d5874c07c1becaba013.1275026041.git.len.brown@intel.com>
References: <6b2c676bf32be91f43215d5874c07c1becaba013.1275026041.git.len.brown@intel.com>
X-Patchwork-Hint: ignore
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Len Brown <len.brown@intel.com>

api_pad exclusively uses MONITOR/MWAIT to sleep in idle,
so it does not need the wakeup IPI during idle sleep
that is provoked by clearing TS_POLLING.

Signed-off-by: Len Brown <len.brown@intel.com>
Cc: Shaohua Li <shaohua.li@intel.com>
---
 drivers/acpi/acpi_pad.c |    9 ---------
 1 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/drivers/acpi/acpi_pad.c b/drivers/acpi/acpi_pad.c
index 6212213..7edf053 100644
--- a/drivers/acpi/acpi_pad.c
+++ b/drivers/acpi/acpi_pad.c
@@ -168,13 +168,6 @@ static int power_saving_thread(void *data)
 
 		do_sleep = 0;
 
-		current_thread_info()->status &= ~TS_POLLING;
-		/*
-		 * TS_POLLING-cleared state must be visible before we test
-		 * NEED_RESCHED:
-		 */
-		smp_mb();
-
 		expire_time = jiffies + HZ * (100 - idle_pct) / 100;
 
 		while (!need_resched()) {
@@ -200,8 +193,6 @@ static int power_saving_thread(void *data)
 			}
 		}
 
-		current_thread_info()->status |= TS_POLLING;
-
 		/*
 		 * current sched_rt has threshold for rt task running time.
 		 * When a rt task uses 95% CPU time, the rt thread will be
-- 
1.6.0.6

