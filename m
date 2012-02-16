Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755718Ab2BPUTY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 15:19:24 -0500
Received: from oz.csail.mit.edu ([128.30.30.239]:46043 "EHLO mail.mgebm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755630Ab2BPUTQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 15:19:16 -0500
From: Eric B Munson <emunson@mgebm.net>
To: avi@redhat.com
Cc: Eric B Munson <emunson@mgebm.net>, mingo@redhat.com, hpa@zytor.com,
        ryanh@linux.vnet.ibm.com, aliguori@us.ibm.com, mtosatti@redhat.com,
        kvm@vger.kernel.org, linux-arch@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/4 V14] Add check for suspended vm in softlockup detector
Date: Thu, 16 Feb 2012 15:19:01 -0500
Message-Id: <1329423541-11677-5-git-send-email-emunson@mgebm.net>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1329423541-11677-1-git-send-email-emunson@mgebm.net>
References: <1329423541-11677-1-git-send-email-emunson@mgebm.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A suspended VM can cause spurious soft lockup warnings.  To avoid these, the
watchdog now checks if the kernel knows it was stopped by the host and skips
the warning if so.  When the watchdog is reset successfully, clear the guest
paused flag.

Signed-off-by: Eric B Munson <emunson@mgebm.net>
Cc: mingo@redhat.com
Cc: hpa@zytor.com
Cc: ryanh@linux.vnet.ibm.com
Cc: aliguori@us.ibm.com
Cc: mtosatti@redhat.com
Cc: kvm@vger.kernel.org
Cc: linux-arch@vger.kernel.org
Cc: x86@kernel.org
Cc: linux-kernel@vger.kernel.org
---
Changes from V3:
 Clear the PAUSED flag when the watchdog is reset

 kernel/watchdog.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index d117262..f6ffdc2 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -25,6 +25,7 @@
 #include <linux/sysctl.h>
 
 #include <asm/irq_regs.h>
+#include <linux/kvm_para.h>
 #include <linux/perf_event.h>
 
 int watchdog_enabled = 1;
@@ -280,6 +281,9 @@ static enum hrtimer_restart watchdog_timer_fn(struct hrtimer *hrtimer)
 			__this_cpu_write(softlockup_touch_sync, false);
 			sched_clock_tick();
 		}
+
+		/* Clear the guest paused flag on watchdog reset */
+		kvm_check_and_clear_guest_paused();
 		__touch_watchdog();
 		return HRTIMER_RESTART;
 	}
@@ -292,6 +296,14 @@ static enum hrtimer_restart watchdog_timer_fn(struct hrtimer *hrtimer)
 	 */
 	duration = is_softlockup(touch_ts);
 	if (unlikely(duration)) {
+		/*
+		 * If a virtual machine is stopped by the host it can look to
+		 * the watchdog like a soft lockup, check to see if the host
+		 * stopped the vm before we issue the warning
+		 */
+		if (kvm_check_and_clear_guest_paused())
+			return HRTIMER_RESTART;
+
 		/* only warn once */
 		if (__this_cpu_read(soft_watchdog_warn) == true)
 			return HRTIMER_RESTART;
-- 
1.7.5.4

