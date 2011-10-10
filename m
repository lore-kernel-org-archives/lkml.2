Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753914Ab1JJMcm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 08:32:42 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:46219 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752939Ab1JJMck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 08:32:40 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH v2 1/3] Introduce helper functions
To: rjw@sisk.pl
Cc: srivatsa.bhat@linux.vnet.ibm.com, bp@amd64.org, pavel@ucw.cz,
        len.brown@intel.com, tj@kernel.org, mingo@elte.hu,
        a.p.zijlstra@chello.nl, akpm@linux-foundation.org,
        suresh.b.siddha@intel.com, lucas.demarchi@profusion.mobi,
        rusty@rustcorp.com.au, rdunlap@xenotime.net, vatsa@linux.vnet.ibm.com,
        ashok.raj@intel.com, tigran@aivazian.fsnet.co.uk, tglx@linutronix.de,
        hpa@zytor.com, linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Date: Mon, 10 Oct 2011 18:02:32 +0530
Message-ID: <20111010123139.15067.12906.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20111010123102.15067.23128.stgit@srivatsabhat.in.ibm.com>
References: <20111010123102.15067.23128.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce helper functions used to prevent cpu hotplug (online operation) from
running in parallel with suspend or hibernate.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 include/linux/suspend.h |   21 +++++++++++++++++++--
 1 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/include/linux/suspend.h b/include/linux/suspend.h
index 6bbcef2..89a5d27 100644
--- a/include/linux/suspend.h
+++ b/include/linux/suspend.h
@@ -276,7 +276,24 @@ static inline bool system_entering_hibernation(void) { return false; }
 #define PM_RESTORE_PREPARE	0x0005 /* Going to restore a saved image */
 #define PM_POST_RESTORE		0x0006 /* Restore failed */
 
+extern struct mutex pm_mutex;
+
 #ifdef CONFIG_PM_SLEEP
+
+/*
+ * Allow operations like CPU online to exclude suspend and hibernation
+ */
+static inline int trylock_pm_sleep(void)
+{
+	return mutex_trylock(&pm_mutex);
+}
+
+static inline void unlock_pm_sleep(void)
+{
+	mutex_unlock(&pm_mutex);
+}
+
 void save_processor_state(void);
 void restore_processor_state(void);
 
@@ -298,6 +315,8 @@ extern bool pm_get_wakeup_count(unsigned int *count);
 extern bool pm_save_wakeup_count(unsigned int count);
 #else /* !CONFIG_PM_SLEEP */
 
+static inline int trylock_pm_sleep(void) { return 1; }
+static inline void unlock_pm_sleep(void) {}
 static inline int register_pm_notifier(struct notifier_block *nb)
 {
 	return 0;
@@ -313,8 +332,6 @@ static inline int unregister_pm_notifier(struct notifier_block *nb)
 static inline bool pm_wakeup_pending(void) { return false; }
 #endif /* !CONFIG_PM_SLEEP */
 
-extern struct mutex pm_mutex;
-
 #ifndef CONFIG_HIBERNATE_CALLBACKS
 static inline void lock_system_sleep(void) {}
 static inline void unlock_system_sleep(void) {}

