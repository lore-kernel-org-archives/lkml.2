Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754620Ab1HCOZS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 10:25:18 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:34333 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754003Ab1HCOZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 10:25:08 -0400
From: Eric B Munson <emunson@mgebm.net>
To: kvm@vger.kernel.org
Cc: kvm-ia64@vger.kernel.org, kvm-ppc@vger.kernel.org, avi@redhat.com,
        riel@redhat.com, glommer@redhat.com, linux-kernel@vger.kernel.org,
        aliguori@us.ibm.com, raharper@us.ibm.com,
        Eric B Munson <emunson@mgebm.net>
Subject: [RFC PATCH 3/3] Add check for suspended vm in softlockup detector
Date: Wed,  3 Aug 2011 10:25:01 -0400
Message-Id: <1312381501-27746-4-git-send-email-emunson@mgebm.net>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1312381501-27746-1-git-send-email-emunson@mgebm.net>
References: <1312381501-27746-1-git-send-email-emunson@mgebm.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A suspended VM can cause spurious soft lockup warnings.  To avoid these, the
watchdog now checks if the kernel knows it was stopped by the host and skips
the warning if so.

Signed-off-by: Eric B Munson <emunson@mgebm.net>
---
 kernel/watchdog.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 36491cd..9cd03b3 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -25,6 +25,7 @@
 #include <linux/sysctl.h>
 
 #include <asm/irq_regs.h>
+#include <asm/pvclock.h>
 #include <linux/perf_event.h>
 
 int watchdog_enabled = 1;
@@ -292,6 +293,16 @@ static enum hrtimer_restart watchdog_timer_fn(struct hrtimer *hrtimer)
 	 */
 	duration = is_softlockup(touch_ts);
 	if (unlikely(duration)) {
+		/*
+		 * If a virtual machine is stopped by the host it can look to
+		 * the watchdog like a soft lockup, check to see if the host
+		 * stopped the vm before we issue the warning
+		 */
+		if (kvm_check_host_stopped()) {
+			kvm_clear_host_stopped();
+			return HRTIMER_RESTART;
+		}
+
 		/* only warn once */
 		if (__this_cpu_read(soft_watchdog_warn) == true)
 			return HRTIMER_RESTART;
-- 
1.7.4.1

