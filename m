Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754479Ab2DADic (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 23:38:32 -0400
Received: from g6t0184.atlanta.hp.com ([15.193.32.61]:33249 "EHLO
	g6t0184.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754388Ab2DADi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 23:38:29 -0400
From: Toshi Kani <toshi.kani@hp.com>
To: len.brown@intel.com
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Toshi Kani <toshi.kani@hp.com>,
        Boris Ostrovsky <boris.ostrovsky@amd.com>
Subject: [PATCH] cpuidle: Fix panic in CPU off-lining with no idle driver
Date: Sat, 31 Mar 2012 21:37:02 -0600
Message-Id: <1333251422-13479-1-git-send-email-toshi.kani@hp.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a NULL pointer dereference panic in cpuidle_play_dead() during
CPU off-lining when no cpuidle driver is registered.  A cpuidle
driver may be registered at boot-time based on CPU type.  This patch
allows an off-lined CPU to enter HLT-based idle in this condition.

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
Cc: Boris Ostrovsky <boris.ostrovsky@amd.com>
---
 drivers/cpuidle/cpuidle.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
index 87411ce..2f0083a 100644
--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -74,7 +74,7 @@ static cpuidle_enter_t cpuidle_enter_ops;
 /**
  * cpuidle_play_dead - cpu off-lining
  *
- * Only returns in case of an error
+ * Returns in case of an error or no driver
  */
 int cpuidle_play_dead(void)
 {
@@ -83,6 +83,9 @@ int cpuidle_play_dead(void)
 	int i, dead_state = -1;
 	int power_usage = -1;
 
+	if (!drv)
+		return -ENODEV;
+
 	/* Find lowest-power state that supports long-term idle */
 	for (i = CPUIDLE_DRIVER_STATE_START; i < drv->state_count; i++) {
 		struct cpuidle_state *s = &drv->states[i];
-- 
1.7.7.6

