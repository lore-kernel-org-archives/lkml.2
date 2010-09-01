Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754145Ab0IAC55 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 22:57:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17722 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753670Ab0IAC5x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 22:57:53 -0400
From: Don Zickus <dzickus@redhat.com>
To: mingo@elte.hu
Cc: peterz@infradead.org, robert.richter@amd.com, gorcunov@gmail.com,
        fweisbec@gmail.com, linux-kernel@vger.kernel.org, ying.huang@intel.com,
        ming.m.lin@intel.com, yinghai@kernel.org, andi@firstfloor.org,
        Don Zickus <dzickus@redhat.com>
Subject: [PATCH 3/4] [x86] perf: rename nmi variable to avoid clash with entry point
Date: Tue, 31 Aug 2010 22:56:45 -0400
Message-Id: <1283309806-21913-4-git-send-email-dzickus@redhat.com>
In-Reply-To: <1283309806-21913-1-git-send-email-dzickus@redhat.com>
References: <1283309806-21913-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is already an entry point named .nmi in entry.S and that seems to clash
with the per_cpu variable nmi defined in commit f3a860d8.  Renaming this
variable avoids the namespace collision.

Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 arch/x86/kernel/cpu/perf_event.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index dd2fceb..2a05ea4 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1205,7 +1205,7 @@ struct pmu_nmi_state {
 	int		handled;
 };
 
-static DEFINE_PER_CPU(struct pmu_nmi_state, nmi);
+static DEFINE_PER_CPU_PAGE_ALIGNED(struct pmu_nmi_state, pmu_nmi);
 
 static int __kprobes
 perf_event_nmi_handler(struct notifier_block *self,
@@ -1224,7 +1224,7 @@ perf_event_nmi_handler(struct notifier_block *self,
 		break;
 	case DIE_NMIUNKNOWN:
 		this_nmi = percpu_read(irq_stat.__nmi_count);
-		if (this_nmi != __get_cpu_var(nmi).marked)
+		if (this_nmi != __get_cpu_var(pmu_nmi).marked)
 			/* let the kernel handle the unknown nmi */
 			return NOTIFY_DONE;
 		/*
@@ -1248,8 +1248,8 @@ perf_event_nmi_handler(struct notifier_block *self,
 	this_nmi = percpu_read(irq_stat.__nmi_count);
 	if ((handled > 1) ||
 		/* the next nmi could be a back-to-back nmi */
-	    ((__get_cpu_var(nmi).marked == this_nmi) &&
-	     (__get_cpu_var(nmi).handled > 1))) {
+	    ((__get_cpu_var(pmu_nmi).marked == this_nmi) &&
+	     (__get_cpu_var(pmu_nmi).handled > 1))) {
 		/*
 		 * We could have two subsequent back-to-back nmis: The
 		 * first handles more than one counter, the 2nd
@@ -1260,8 +1260,8 @@ perf_event_nmi_handler(struct notifier_block *self,
 		 * handling more than one counter. We will mark the
 		 * next (3rd) and then drop it if unhandled.
 		 */
-		__get_cpu_var(nmi).marked	= this_nmi + 1;
-		__get_cpu_var(nmi).handled	= handled;
+		__get_cpu_var(pmu_nmi).marked	= this_nmi + 1;
+		__get_cpu_var(pmu_nmi).handled	= handled;
 	}
 
 	return NOTIFY_STOP;
-- 
1.7.2.2

