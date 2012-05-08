Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754708Ab2EHM1L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 08:27:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54693 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754396Ab2EHM1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 08:27:10 -0400
Date: Tue, 8 May 2012 05:26:57 -0700
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Message-ID: <tip-4a1625133d4faaefcec0dc175941f49b186918d9@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <20120507175652.119842173@linutronix.de>
References: <20120507175652.119842173@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:smp/hotplug] cpuidle: Use kick_all_cpus_sync()
Git-Commit-ID: 4a1625133d4faaefcec0dc175941f49b186918d9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 08 May 2012 05:27:03 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4a1625133d4faaefcec0dc175941f49b186918d9
Gitweb:     http://git.kernel.org/tip/4a1625133d4faaefcec0dc175941f49b186918d9
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Mon, 7 May 2012 17:59:48 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 8 May 2012 12:35:06 +0200

cpuidle: Use kick_all_cpus_sync()

kick_all_cpus_sync() is the core implementation of cpu_idle_wait()
which is copied all over the arch code.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20120507175652.119842173@linutronix.de
---
 drivers/cpuidle/cpuidle.c |   13 +------------
 1 files changed, 1 insertions(+), 12 deletions(-)

diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
index 2f0083a..d90519c 100644
--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -40,17 +40,6 @@ void disable_cpuidle(void)
 	off = 1;
 }
 
-#if defined(CONFIG_ARCH_HAS_CPU_IDLE_WAIT)
-static void cpuidle_kick_cpus(void)
-{
-	cpu_idle_wait();
-}
-#elif defined(CONFIG_SMP)
-# error "Arch needs cpu_idle_wait() equivalent here"
-#else /* !CONFIG_ARCH_HAS_CPU_IDLE_WAIT && !CONFIG_SMP */
-static void cpuidle_kick_cpus(void) {}
-#endif
-
 static int __cpuidle_register_device(struct cpuidle_device *dev);
 
 static inline int cpuidle_enter(struct cpuidle_device *dev,
@@ -186,7 +175,7 @@ void cpuidle_uninstall_idle_handler(void)
 {
 	if (enabled_devices) {
 		initialized = 0;
-		cpuidle_kick_cpus();
+		kick_all_cpus_sync();
 	}
 }
 
