Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932691Ab1LEUTr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 15:19:47 -0500
Received: from oz.csail.mit.edu ([128.30.30.239]:34708 "EHLO mail.mgebm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932588Ab1LEUTK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 15:19:10 -0500
From: Eric B Munson <emunson@mgebm.net>
To: avi@redhat.com
Cc: Eric B Munson <emunson@mgebm.net>, mingo@redhat.com, hpa@zytor.com,
        arnd@arndb.de, ryanh@linux.vnet.ibm.com, aliguori@us.ibm.com,
        mtosatti@redhat.com, jeremy.fitzhardinge@citrix.com,
        levinsasha928@gmail.com, Jan Kiszka <jan.kiszka@siemens.com>,
        kvm@vger.kernel.org, linux-arch@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/5 V5] Add check for suspended vm in softlockup detector
Date: Mon,  5 Dec 2011 15:19:04 -0500
Message-Id: <1323116344-17911-6-git-send-email-emunson@mgebm.net>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1323116344-17911-1-git-send-email-emunson@mgebm.net>
References: <1323116344-17911-1-git-send-email-emunson@mgebm.net>
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
Cc: arnd@arndb.de
Cc: ryanh@linux.vnet.ibm.com
Cc: aliguori@us.ibm.com
Cc: mtosatti@redhat.com
Cc: jeremy.fitzhardinge@citrix.com
Cc: levinsasha928@gmail.com
Cc: Jan Kiszka <jan.kiszka@siemens.com>
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
index 1d7bca7..7c62919 100644
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
+		kvm_check_and_clear_guest_paused(smp_processor_id());
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
+		if (kvm_check_and_clear_guest_paused(smp_processor_id()))
+			return HRTIMER_RESTART;
+
 		/* only warn once */
 		if (__this_cpu_read(soft_watchdog_warn) == true)
 			return HRTIMER_RESTART;
-- 
1.7.5.4

