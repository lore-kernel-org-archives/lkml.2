Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757564Ab2GNA6d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 20:58:33 -0400
Received: from mga09.intel.com ([134.134.136.24]:14058 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757297Ab2GNA6c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 20:58:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="165743237"
From: Andi Kleen <andi@firstfloor.org>
To: mingo@elte.hu
Cc: eranian@google.com, a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 1/2] Fix Sandy Bridge microcode check to actually work
Date: Fri, 13 Jul 2012 17:58:13 -0700
Message-Id: <1342227494-24830-2-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1342227494-24830-1-git-send-email-andi@firstfloor.org>
References: <1342227494-24830-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

- The old style microcode interface used by microcode_ctl didn't call
the perf callback.
- The pebs_broken bitfield needs to be unsigned, otherwise the one bit
signed bitfield gets sign extended and any microcode revision on a update
passes, and later updates are ignored.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/perf_event.h |    2 +-
 arch/x86/kernel/microcode_core.c |    3 +++
 2 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index a15df4b..1b12fac 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -374,7 +374,7 @@ struct x86_pmu {
 	/*
 	 * Intel DebugStore bits
 	 */
-	int		bts		:1,
+	unsigned	bts		:1,
 			bts_active	:1,
 			pebs		:1,
 			pebs_active	:1,
diff --git a/arch/x86/kernel/microcode_core.c b/arch/x86/kernel/microcode_core.c
index 4873e62..d4f4d31 100644
--- a/arch/x86/kernel/microcode_core.c
+++ b/arch/x86/kernel/microcode_core.c
@@ -228,6 +228,9 @@ static ssize_t microcode_write(struct file *file, const char __user *buf,
 	mutex_unlock(&microcode_mutex);
 	put_online_cpus();
 
+	if (ret >= 0)
+		perf_check_microcode();
+
 	return ret;
 }
 
-- 
1.7.7.6

