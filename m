Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754502Ab2EHM0Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 08:26:25 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54661 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754106Ab2EHM0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 08:26:24 -0400
Date: Tue, 8 May 2012 05:26:08 -0700
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Message-ID: <tip-f37f435f33717dcf15fd4bb422da739da7fc2052@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <20120507175652.049316594@linutronix.de>
References: <20120507175652.049316594@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:smp/hotplug] smp: Implement kick_all_cpus_sync()
Git-Commit-ID: f37f435f33717dcf15fd4bb422da739da7fc2052
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 08 May 2012 05:26:13 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f37f435f33717dcf15fd4bb422da739da7fc2052
Gitweb:     http://git.kernel.org/tip/f37f435f33717dcf15fd4bb422da739da7fc2052
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Mon, 7 May 2012 17:59:48 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 8 May 2012 12:35:06 +0200

smp: Implement kick_all_cpus_sync()

Will replace the misnomed cpu_idle_wait() function which is copied a
gazillion times all over arch/*

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20120507175652.049316594@linutronix.de
---
 include/linux/smp.h |    4 ++++
 kernel/smp.c        |   23 +++++++++++++++++++++++
 2 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/include/linux/smp.h b/include/linux/smp.h
index 24360de..717fb74 100644
--- a/include/linux/smp.h
+++ b/include/linux/smp.h
@@ -81,6 +81,8 @@ void __smp_call_function_single(int cpuid, struct call_single_data *data,
 int smp_call_function_any(const struct cpumask *mask,
 			  smp_call_func_t func, void *info, int wait);
 
+void kick_all_cpus_sync(void);
+
 /*
  * Generic and arch helpers
  */
@@ -192,6 +194,8 @@ smp_call_function_any(const struct cpumask *mask, smp_call_func_t func,
 	return smp_call_function_single(0, func, info, wait);
 }
 
+static inline void kick_all_cpus_sync(void) {  }
+
 #endif /* !SMP */
 
 /*
diff --git a/kernel/smp.c b/kernel/smp.c
index a61294c..d0ae5b2 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -795,3 +795,26 @@ void on_each_cpu_cond(bool (*cond_func)(int cpu, void *info),
 	}
 }
 EXPORT_SYMBOL(on_each_cpu_cond);
+
+static void do_nothing(void *unused)
+{
+}
+
+/**
+ * kick_all_cpus_sync - Force all cpus out of idle
+ *
+ * Used to synchronize the update of pm_idle function pointer. It's
+ * called after the pointer is updated and returns after the dummy
+ * callback function has been executed on all cpus. The execution of
+ * the function can only happen on the remote cpus after they have
+ * left the idle function which had been called via pm_idle function
+ * pointer. So it's guaranteed that nothing uses the previous pointer
+ * anymore.
+ */
+void kick_all_cpus_sync(void)
+{
+	/* Make sure the change is visible before we kick the cpus */
+	smp_mb();
+	smp_call_function(do_nothing, NULL, 1);
+}
+EXPORT_SYMBOL_GPL(kick_all_cpus_sync);
