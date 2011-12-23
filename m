Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756237Ab1LWB6J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 20:58:09 -0500
Received: from mga09.intel.com ([134.134.136.24]:49571 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754004Ab1LWB6H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 20:58:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="89599943"
From: "Zhang, MingmingX" <mingmingx.zhang@intel.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "yanmin_zhang@linux.intel.com" <yanmin_zhang@linux.intel.com>,
        "Li, Shaohua" <shaohua.li@intel.com>,
        "Brown, Len" <len.brown@intel.com>
Subject: [patch] intel_idle: Delete meaningless local_irq_disable() call in
 intel_idle.c.
Thread-Topic: [patch] intel_idle: Delete meaningless local_irq_disable()
 call in intel_idle.c.
Thread-Index: AczBFjcRDOo6L3jXTgmGTWkdu/X0vg==
Date: Fri, 23 Dec 2011 01:57:29 +0000
Message-ID: <25CAFE86FAAED24C90F0AC30DBE9995381BD@SHSMSX101.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-cr-hashedpuzzle: Cegq EDlW EEaF ETyv FQ0w G+tj HnQD IWWb JOvz MFR0 Mvrz
 NCfj NzGP N6BF Ps2X
 Q5au;2;bABpAG4AdQB4AC0AawBlAHIAbgBlAGwAQAB2AGcAZQByAC4AawBlAHIAbgBlAGwALgBvAHIAZwA7AHkAYQBuAG0AaQBuAF8AegBoAGEAbgBnAEAAbABpAG4AdQB4AC4AaQBuAHQAZQBsAC4AYwBvAG0A;Sosha1_v1;7;{1C985E25-1B80-491E-A66C-4C1EDAA6711A};bQBpAG4AZwBtAGkAbgBnAHgALgB6AGgAYQBuAGcAQABpAG4AdABlAGwALgBjAG8AbQA=;Fri,
 23 Dec 2011 01:57:24
 GMT;WwBwAGEAdABjAGgAXQAgAGkAbgB0AGUAbABfAGkAZABsAGUAOgAgAEQAZQBsAGUAdABlACAAbQBlAGEAbgBpAG4AZwBsAGUAcwBzACAAbABvAGMAYQBsAF8AaQByAHEAXwBkAGkAcwBhAGIAbABlACgAKQAgAGMAYQBsAGwAIABpAG4AIABpAG4AdABlAGwAXwBpAGQAbABlAC4AYwAuAA==
x-cr-puzzleid: {1C985E25-1B80-491E-A66C-4C1EDAA6711A}
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: mzha38X <mingmingx.zhang@intel.com>

intel_idle.c is a bit misleading in a sense that local_irq_disable,it
actually does nothing. Real irq disable happens earlier in process_32.c:cpu_idle.
Basically, cpuidle_state->enter is called, cpu irq is disabled.
cpuidle_state->enter would turn on irq when exiting.

intel_idle doesn't follow this assumption. Although it doesn't
cause real issue, it misleads developers. Below patch deletes
the calling to local_irq_disable() at entry.

Signed-off-by: mzha38X <mingmingx.zhang@intel.com>
---
 drivers/idle/intel_idle.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
index 5d2f8e1..28f0394 100644
--- a/drivers/idle/intel_idle.c
+++ b/drivers/idle/intel_idle.c
@@ -247,8 +247,6 @@ static int intel_idle(struct cpuidle_device *dev,
 
 	cstate = (((eax) >> MWAIT_SUBSTATE_SIZE) & MWAIT_CSTATE_MASK) + 1;
 
-	local_irq_disable();
-
 	/*
 	 * leave_mm() to avoid costly and often unnecessary wakeups
 	 * for flushing the user TLB's associated with the active mm.
-- 
1.7.1
