Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753867Ab2AQMYW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 07:24:22 -0500
Received: from vms173007pub.verizon.net ([206.46.173.7]:43948 "EHLO
	vms173007pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753646Ab2AQMW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 07:22:26 -0500
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Cc: Yanmin Zhang <yanmin_zhang@linux.intel.com>,
        Mingming Zhang <mingmingx.zhang@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Len Brown <len.brown@intel.com>
Subject: [PATCH 45/50] intel_idle: remove redundant local_irq_disable() call
Date: Tue, 17 Jan 2012 07:21:37 -0500
Message-id: <44bea1c45390ec0dc7ef5e1017c014498a580abb.1326802230.git.len.brown@intel.com>
X-Mailer: git-send-email 1.7.9.rc1
In-reply-to: <1326802902-21583-1-git-send-email-lenb@kernel.org>
References: <1326802902-21583-1-git-send-email-lenb@kernel.org>
In-reply-to: <553575f1ae048aa44682b46b3c51929a0b3ad337.1326802228.git.len.brown@intel.com>
References: <553575f1ae048aa44682b46b3c51929a0b3ad337.1326802228.git.len.brown@intel.com>
Reply-to: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yanmin Zhang <yanmin_zhang@linux.intel.com>

irq disabling happens earlier in process_32.c:cpu_idle.  Basically,
cpuidle_state->enter is called, cpu irq is disabled.  cpuidle_state->enter
would turn on irq when exiting.

intel_idle doesn't follow this assumption.  Although it doesn't cause real
issue, it misleads developers.  Remove the call to local_irq_disable() at
entry.

[akpm@linux-foundation.org: add comment]
Signed-off-by: Mingming Zhang <mingmingx.zhang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/idle/intel_idle.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
index 38da9f8..27e41cc 100644
--- a/drivers/idle/intel_idle.c
+++ b/drivers/idle/intel_idle.c
@@ -232,6 +232,7 @@ static int get_driver_data(int cstate)
  * @drv: cpuidle driver
  * @index: index of cpuidle state
  *
+ * Must be called under local_irq_disable().
  */
 static int intel_idle(struct cpuidle_device *dev,
 		struct cpuidle_driver *drv, int index)
@@ -247,8 +248,6 @@ static int intel_idle(struct cpuidle_device *dev,
 
 	cstate = (((eax) >> MWAIT_SUBSTATE_SIZE) & MWAIT_CSTATE_MASK) + 1;
 
-	local_irq_disable();
-
 	/*
 	 * leave_mm() to avoid costly and often unnecessary wakeups
 	 * for flushing the user TLB's associated with the active mm.
-- 
1.7.9.rc1

