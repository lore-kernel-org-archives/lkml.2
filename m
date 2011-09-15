Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935298Ab1IOW5F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 18:57:05 -0400
Received: from mga02.intel.com ([134.134.136.20]:33005 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935244Ab1IOW5D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 18:57:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="48919100"
From: Andi Kleen <andi@firstfloor.org>
To: a.p.zijlstra@chello.nl
Cc: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 3/4] perf_events: Support a lock_parent event flag
Date: Thu, 15 Sep 2011 15:56:51 -0700
Message-Id: <1316127412-1912-3-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1316127412-1912-1-git-send-email-andi@firstfloor.org>
References: <1316127412-1912-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Add a new lock_parent flag to the event attribute. When it is set
account spinlocks to the parent.  This is similar to how oprofile
behaves on x86. This just reuses the oprofile code for this.

The main advantage is that it allows to make more sense of locking
problems without requiring full callgraphs.

Right now only implemented on x86.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/perf_event.c |    3 +++
 include/linux/perf_event.h       |    3 ++-
 2 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 373a614..f2caa6e 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1933,6 +1933,9 @@ unsigned long perf_instruction_pointer(struct pt_regs *regs,
 	else
 		ip = instruction_pointer(regs);
 
+	if (event->attr.lock_parent)
+		ip = __profile_pc(ip, regs);
+
 	return ip;
 }
 
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index f8b93ec..51da085 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -219,8 +219,9 @@ struct perf_event_attr {
 				precise_ip     :  2, /* skid constraint       */
 				mmap_data      :  1, /* non-exec mmap data    */
 				sample_id_all  :  1, /* sample_type all events */
+				lock_parent    :  1, /* count locks in parent */
 
-				__reserved_1   : 45;
+				__reserved_1   : 44;
 
 	union {
 		__u32		wakeup_events;	  /* wakeup every n events */
-- 
1.7.4.4

