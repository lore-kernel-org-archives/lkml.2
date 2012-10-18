Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755848Ab2JRLE3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 07:04:29 -0400
Received: from mga03.intel.com ([143.182.124.21]:42979 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932624Ab2JRLDa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 07:03:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,606,1344236400"; 
   d="scan'208";a="157620849"
From: dragos.tatulea@intel.com
To: ccross@android.com, keescook@chromium.org, tony.luck@intel.com,
        cbouatmailru@gmail.com, linux-kernel@vger.kernel.org
Cc: adrian.hunter@intel.com, octavian.purdila@intel.com
Subject: [PATCH v3 6/9] pstore: do not run timer while pstore is not mounted
Date: Thu, 18 Oct 2012 14:06:04 +0300
Message-Id: <1350558367-31801-7-git-send-email-dragos.tatulea@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1350558367-31801-1-git-send-email-dragos.tatulea@intel.com>
References: <1350558367-31801-1-git-send-email-dragos.tatulea@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

A timer is used to periodically check for new dumps.
The timer is not needed unless pstore is mounted,
so disable it otherwise.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 fs/pstore/inode.c    |    3 +++
 fs/pstore/internal.h |    2 ++
 fs/pstore/platform.c |   36 +++++++++++++++++++++++++++++-------
 3 files changed, 34 insertions(+), 7 deletions(-)

diff --git a/fs/pstore/inode.c b/fs/pstore/inode.c
index 4800c09..5e20a8d 100644
--- a/fs/pstore/inode.c
+++ b/fs/pstore/inode.c
@@ -397,6 +397,8 @@ static int pstore_fill_super(struct super_block *sb, void *data, int silent)
 
 	pstore_get_records(0);
 
+	pstore_add_timer();
+
 	return 0;
 }
 
@@ -408,6 +410,7 @@ static struct dentry *pstore_mount(struct file_system_type *fs_type,
 
 static void pstore_kill_sb(struct super_block *sb)
 {
+	pstore_del_timer();
 	kill_litter_super(sb);
 	pstore_sb = NULL;
 }
diff --git a/fs/pstore/internal.h b/fs/pstore/internal.h
index 4847f58..c7b8197 100644
--- a/fs/pstore/internal.h
+++ b/fs/pstore/internal.h
@@ -54,4 +54,6 @@ extern int	pstore_mkfile(enum pstore_type_id, char *psname, u64 id,
 			      struct timespec time, struct pstore_info *psi);
 extern int	pstore_is_mounted(void);
 
+extern void pstore_add_timer(void);
+extern void pstore_del_timer(void);
 #endif
diff --git a/fs/pstore/platform.c b/fs/pstore/platform.c
index 63ff377..3a4c38f 100644
--- a/fs/pstore/platform.c
+++ b/fs/pstore/platform.c
@@ -54,6 +54,8 @@ static int pstore_new_entry;
 
 static void pstore_timefunc(unsigned long);
 static DEFINE_TIMER(pstore_timer, pstore_timefunc, 0, 0);
+static DEFINE_SPINLOCK(pstore_timer_lock);
+static int pstore_timer_on;
 
 static void pstore_dowork(struct work_struct *);
 static DECLARE_WORK(pstore_work, pstore_dowork);
@@ -351,12 +353,6 @@ int pstore_register(struct pstore_info *psi)
 	pstore_register_console();
 	pstore_register_ftrace();
 
-	if (pstore_update_ms >= 0) {
-		pstore_timer.expires = jiffies +
-			msecs_to_jiffies(pstore_update_ms);
-		add_timer(&pstore_timer);
-	}
-
 	pstore_debugfs_init();
 
 	return 0;
@@ -411,12 +407,38 @@ static void pstore_dowork(struct work_struct *work)
 
 static void pstore_timefunc(unsigned long dummy)
 {
+	unsigned long flags;
+
 	if (pstore_new_entry) {
 		pstore_new_entry = 0;
 		schedule_work(&pstore_work);
 	}
 
-	mod_timer(&pstore_timer, jiffies + msecs_to_jiffies(pstore_update_ms));
+	spin_lock_irqsave(&pstore_timer_lock, flags);
+	if (pstore_timer_on)
+		mod_timer(&pstore_timer,
+				jiffies + msecs_to_jiffies(pstore_update_ms));
+	spin_unlock_irqrestore(&pstore_timer_lock, flags);
+}
+
+void pstore_add_timer(void)
+{
+	pstore_timer_on = 1;
+	if (pstore_update_ms >= 0) {
+		pstore_timer.expires = jiffies +
+			msecs_to_jiffies(pstore_update_ms);
+		add_timer(&pstore_timer);
+	}
+}
+
+void pstore_del_timer(void)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&pstore_timer_lock, flags);
+	pstore_timer_on = 0;
+	spin_unlock_irqrestore(&pstore_timer_lock, flags);
+	del_timer_sync(&pstore_timer);
 }
 
 /* pstore_write must only be called from PSTORE_DUMP notifier callbacks */
-- 
1.7.9.5

