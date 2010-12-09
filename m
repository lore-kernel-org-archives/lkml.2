Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756153Ab0LIX2O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 18:28:14 -0500
Received: from hera.kernel.org ([140.211.167.34]:40772 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752665Ab0LIX2M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 18:28:12 -0500
Date: Thu, 9 Dec 2010 23:27:47 GMT
From: tip-bot for Don Zickus <dzickus@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        tglx@linutronix.de, gorcunov@gmail.com, mingo@elte.hu,
        dzickus@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, gorcunov@gmail.com, dzickus@redhat.com,
        mingo@elte.hu
In-Reply-To: <1291068437-5331-2-git-send-email-dzickus@redhat.com>
References: <1291068437-5331-2-git-send-email-dzickus@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] lockup detector: Compile fixes from removing the old x86 nmi watchdog
Message-ID: <tip-96a84c20d635fb1e98ab92f9fc517c4441f5c424@git.kernel.org>
Git-Commit-ID: 96a84c20d635fb1e98ab92f9fc517c4441f5c424
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 09 Dec 2010 23:27:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  96a84c20d635fb1e98ab92f9fc517c4441f5c424
Gitweb:     http://git.kernel.org/tip/96a84c20d635fb1e98ab92f9fc517c4441f5c424
Author:     Don Zickus <dzickus@redhat.com>
AuthorDate: Mon, 29 Nov 2010 17:07:16 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 10 Dec 2010 00:01:06 +0100

lockup detector: Compile fixes from removing the old x86 nmi watchdog

My patch that removed the old x86 nmi watchdog broke other
arches.  This change reverts a piece of that patch and puts the
change in the correct spot.

Signed-off-by: Don Zickus <dzickus@redhat.com>
Reviewed-by: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: fweisbec@gmail.com
Cc: yinghai@kernel.org
LKML-Reference: <1291068437-5331-2-git-send-email-dzickus@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/apic/hw_nmi.c |    8 +++++++-
 include/linux/nmi.h           |    4 +++-
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/apic/hw_nmi.c b/arch/x86/kernel/apic/hw_nmi.c
index 057f1eb..2e94eb4 100644
--- a/arch/x86/kernel/apic/hw_nmi.c
+++ b/arch/x86/kernel/apic/hw_nmi.c
@@ -24,8 +24,14 @@ u64 hw_nmi_get_sample_period(void)
 }
 #endif
 
+#ifndef CONFIG_HARDLOCKUP_DETECTOR
+void touch_nmi_watchdog(void)
+{
+	touch_softlockup_watchdog();
+}
+EXPORT_SYMBOL(touch_nmi_watchdog);
+#endif
 #ifdef arch_trigger_all_cpu_backtrace
-
 /* For reliability, we're prepared to waste bits here. */
 static DECLARE_BITMAP(backtrace_mask, NR_CPUS) __read_mostly;
 
diff --git a/include/linux/nmi.h b/include/linux/nmi.h
index 1c451e6..17ccf44 100644
--- a/include/linux/nmi.h
+++ b/include/linux/nmi.h
@@ -16,7 +16,8 @@
  */
 #ifdef ARCH_HAS_NMI_WATCHDOG
 #include <asm/nmi.h>
-#endif
+extern void touch_nmi_watchdog(void);
+#else
 #ifndef CONFIG_HARDLOCKUP_DETECTOR
 static inline void touch_nmi_watchdog(void)
 {
@@ -25,6 +26,7 @@ static inline void touch_nmi_watchdog(void)
 #else
 extern void touch_nmi_watchdog(void);
 #endif
+#endif
 
 /*
  * Create trigger_all_cpu_backtrace() out of the arch-provided
