Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758925Ab1BPLek (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 06:34:40 -0500
Received: from hera.kernel.org ([140.211.167.34]:54083 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756134Ab1BPLeh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 06:34:37 -0500
Date: Wed, 16 Feb 2011 11:33:58 GMT
From: tip-bot for Cyrill Gorcunov <gorcunov@openvz.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        gorcunov@openvz.org, a.p.zijlstra@chello.nl, airlied@gmail.com,
        linux@horizon.com, ming.m.lin@intel.com, mroos@linux.ee,
        tglx@linutronix.de, mingo@elte.hu, dzickus@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        gorcunov@openvz.org, a.p.zijlstra@chello.nl, airlied@gmail.com,
        linux@horizon.com, ming.m.lin@intel.com, mroos@linux.ee,
        tglx@linutronix.de, dzickus@redhat.com, mingo@elte.hu
In-Reply-To: <AANLkTinfuTfCck_FfaOHrDqQZZehtRzkBum4SpFoO=KJ@mail.gmail.com>
References: <AANLkTinfuTfCck_FfaOHrDqQZZehtRzkBum4SpFoO=KJ@mail.gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf, x86: P4 PMU: Fix spurious NMI messages
Message-ID: <tip-7d44ec193d95416d1342cdd86392a1eeb7461186@git.kernel.org>
Git-Commit-ID: 7d44ec193d95416d1342cdd86392a1eeb7461186
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 16 Feb 2011 11:34:00 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7d44ec193d95416d1342cdd86392a1eeb7461186
Gitweb:     http://git.kernel.org/tip/7d44ec193d95416d1342cdd86392a1eeb7461186
Author:     Cyrill Gorcunov <gorcunov@openvz.org>
AuthorDate: Wed, 16 Feb 2011 14:08:02 +0300
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 16 Feb 2011 12:26:12 +0100

perf, x86: P4 PMU: Fix spurious NMI messages

Several people have reported spurious unknown NMI
messages on some P4 CPUs.

This patch fixes it by checking for an overflow (negative
counter values) directly, instead of relying on the
P4_CCCR_OVF bit.

Reported-by: George Spelvin <linux@horizon.com>
Reported-by: Meelis Roos <mroos@linux.ee>
Reported-by: Don Zickus <dzickus@redhat.com>
Reported-by: Dave Airlie <airlied@gmail.com>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Lin Ming <ming.m.lin@intel.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <AANLkTinfuTfCck_FfaOHrDqQZZehtRzkBum4SpFoO=KJ@mail.gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/perf_event_p4.h |    1 +
 arch/x86/kernel/cpu/perf_event_p4.c  |   11 ++++++++---
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/perf_event_p4.h b/arch/x86/include/asm/perf_event_p4.h
index e2f6a99..cc29086 100644
--- a/arch/x86/include/asm/perf_event_p4.h
+++ b/arch/x86/include/asm/perf_event_p4.h
@@ -22,6 +22,7 @@
 
 #define ARCH_P4_CNTRVAL_BITS	(40)
 #define ARCH_P4_CNTRVAL_MASK	((1ULL << ARCH_P4_CNTRVAL_BITS) - 1)
+#define ARCH_P4_UNFLAGGED_BIT	((1ULL) << (ARCH_P4_CNTRVAL_BITS - 1))
 
 #define P4_ESCR_EVENT_MASK	0x7e000000U
 #define P4_ESCR_EVENT_SHIFT	25
diff --git a/arch/x86/kernel/cpu/perf_event_p4.c b/arch/x86/kernel/cpu/perf_event_p4.c
index f7a0993..ff751a9 100644
--- a/arch/x86/kernel/cpu/perf_event_p4.c
+++ b/arch/x86/kernel/cpu/perf_event_p4.c
@@ -770,9 +770,14 @@ static inline int p4_pmu_clear_cccr_ovf(struct hw_perf_event *hwc)
 		return 1;
 	}
 
-	/* it might be unflagged overflow */
-	rdmsrl(hwc->event_base + hwc->idx, v);
-	if (!(v & ARCH_P4_CNTRVAL_MASK))
+	/*
+	 * In some circumstances the overflow might issue an NMI but did
+	 * not set P4_CCCR_OVF bit. Because a counter holds a negative value
+	 * we simply check for high bit being set, if it's cleared it means
+	 * the counter has reached zero value and continued counting before
+	 * real NMI signal was received:
+	 */
+	if (!(v & ARCH_P4_UNFLAGGED_BIT))
 		return 1;
 
 	return 0;
