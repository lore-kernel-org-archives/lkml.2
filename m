Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755383Ab1JaUJM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 16:09:12 -0400
Received: from oz.csail.mit.edu ([128.30.30.239]:47643 "EHLO mail.mgebm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752254Ab1JaUHe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 16:07:34 -0400
From: Eric B Munson <emunson@mgebm.net>
To: avi@redhat.com
Cc: mingo@redhat.com, x86@kernel.org, hpa@zytor.com, arnd@arndb.de,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-arch@vger.kernel.org, ryanh@linux.vnet.ibm.com,
        aliguori@us.ibm.com, Eric B Munson <emunson@mgebm.net>
Subject: [PATCH 5/6 V2] Add check for suspended vm in softlockup detector
Date: Mon, 31 Oct 2011 16:07:29 -0400
Message-Id: <1320091650-24682-6-git-send-email-emunson@mgebm.net>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1320091650-24682-1-git-send-email-emunson@mgebm.net>
References: <1320091650-24682-1-git-send-email-emunson@mgebm.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A suspended VM can cause spurious soft lockup warnings.  To avoid these, the
watchdog now checks if the kernel knows it was stopped by the host and skips
the warning if so.

Signed-off-by: Eric B Munson <emunson@mgebm.net>
---
 kernel/watchdog.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index d680381..ff86cae 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -25,6 +25,7 @@
 #include <linux/sysctl.h>
 
 #include <asm/irq_regs.h>
+#include <asm/pvclock.h>
 #include <linux/perf_event.h>
 
 int watchdog_enabled = 1;
@@ -292,6 +293,14 @@ static enum hrtimer_restart watchdog_timer_fn(struct hrtimer *hrtimer)
 	 */
 	duration = is_softlockup(touch_ts);
 	if (unlikely(duration)) {
+		/*
+		 * If a virtual machine is stopped by the host it can look to
+		 * the watchdog like a soft lockup, check to see if the host
+		 * stopped the vm before we issue the warning
+		 */
+		if (kvm_check_and_clear_host_stopped(smp_processor_id()))
+			return HRTIMER_RESTART;
+
 		/* only warn once */
 		if (__this_cpu_read(soft_watchdog_warn) == true)
 			return HRTIMER_RESTART;
-- 
1.7.5.4

