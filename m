Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761956Ab2COOvF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 10:51:05 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:55023 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030518Ab2COOur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 10:50:47 -0400
From: Cong Wang <xiyou.wangcong@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Dennis1.Chen@amd.com,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Rusty Russell <rusty@rustcorp.com.au>, David Airlie <airlied@linux.ie>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH 7/7] module: avoid exporting module_mutex
Date: Thu, 15 Mar 2012 22:49:01 +0800
Message-Id: <1331822941-19938-7-git-send-email-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1331822941-19938-1-git-send-email-xiyou.wangcong@gmail.com>
References: <1331822941-19938-1-git-send-email-xiyou.wangcong@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drm_fb_helper_modinit() calls find_module() which only
needs rcu_read_lock_sched().

The rest seems still have to hold module_mutex to prevent
module insertion/deletion. Instead of exporting module_mutex
for them, export two functions lock_modules()/unlock_modules()
and hide module_mutex.

Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
---
 drivers/gpu/drm/drm_fb_helper.c |    4 ++--
 include/linux/module.h          |    3 ++-
 kernel/kprobes.c                |    4 ++--
 kernel/module.c                 |   24 ++++++++++++++++++------
 4 files changed, 24 insertions(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/drm_fb_helper.c b/drivers/gpu/drm/drm_fb_helper.c
index aada26f..a3aee0e 100644
--- a/drivers/gpu/drm/drm_fb_helper.c
+++ b/drivers/gpu/drm/drm_fb_helper.c
@@ -1451,9 +1451,9 @@ static int __init drm_fb_helper_modinit(void)
 	const char *name = "fbcon";
 	struct module *fbcon;
 
-	mutex_lock(&module_mutex);
+	rcu_read_lock_sched();
 	fbcon = find_module(name);
-	mutex_unlock(&module_mutex);
+	rcu_read_unlock_sched();
 
 	if (!fbcon)
 		request_module_nowait(name);
diff --git a/include/linux/module.h b/include/linux/module.h
index 4598bf0..5cf6428 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -374,7 +374,8 @@ struct module
 #define MODULE_ARCH_INIT {}
 #endif
 
-extern struct mutex module_mutex;
+extern void lock_modules(void);
+extern void unlock_modules(void);
 
 /* FIXME: It'd be nice to isolate modules during init, too, so they
    aren't used before they (may) fail.  But presently too much code
diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index c62b854..0670fb1 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -562,7 +562,7 @@ static __kprobes void kprobe_optimizer(struct work_struct *work)
 	LIST_HEAD(free_list);
 
 	/* Lock modules while optimizing kprobes */
-	mutex_lock(&module_mutex);
+	lock_modules();
 	mutex_lock(&kprobe_mutex);
 
 	/*
@@ -587,7 +587,7 @@ static __kprobes void kprobe_optimizer(struct work_struct *work)
 	do_free_cleaned_kprobes(&free_list);
 
 	mutex_unlock(&kprobe_mutex);
-	mutex_unlock(&module_mutex);
+	unlock_modules();
 
 	/* Step 5: Kick optimizer again if needed */
 	if (!list_empty(&optimizing_list) || !list_empty(&unoptimizing_list))
diff --git a/kernel/module.c b/kernel/module.c
index 2e7a5c5..b60f882 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -95,8 +95,20 @@
  * 2) module_use links,
  * 3) module_addr_min/module_addr_max.
  * (delete uses stop_machine/add uses RCU list operations). */
-DEFINE_MUTEX(module_mutex);
-EXPORT_SYMBOL_GPL(module_mutex);
+static DEFINE_MUTEX(module_mutex);
+
+void lock_modules(void)
+{
+	mutex_lock(&module_mutex);
+}
+EXPORT_SYMBOL(lock_modules);
+
+void unlock_modules(void)
+{
+	mutex_unlock(&module_mutex);
+}
+EXPORT_SYMBOL(unlock_modules);
+
 static LIST_HEAD(modules);
 #ifdef CONFIG_KGDB_KDB
 struct list_head *kdb_modules = &modules; /* kdb needs the list of modules */
@@ -1715,7 +1727,7 @@ void set_all_modules_text_rw(void)
 {
 	struct module *mod;
 
-	mutex_lock(&module_mutex);
+	lock_modules();
 	list_for_each_entry_rcu(mod, &modules, list) {
 		if ((mod->module_core) && (mod->core_text_size)) {
 			set_page_attributes(mod->module_core,
@@ -1728,7 +1740,7 @@ void set_all_modules_text_rw(void)
 						set_memory_rw);
 		}
 	}
-	mutex_unlock(&module_mutex);
+	unlock_modules();
 }
 
 /* Iterate through all modules and set each module's text as RO */
@@ -1736,7 +1748,7 @@ void set_all_modules_text_ro(void)
 {
 	struct module *mod;
 
-	mutex_lock(&module_mutex);
+	lock_modules();
 	list_for_each_entry_rcu(mod, &modules, list) {
 		if ((mod->module_core) && (mod->core_text_size)) {
 			set_page_attributes(mod->module_core,
@@ -1749,7 +1761,7 @@ void set_all_modules_text_ro(void)
 						set_memory_ro);
 		}
 	}
-	mutex_unlock(&module_mutex);
+	unlock_modules();
 }
 #else
 static inline void set_section_ro_nx(void *base, unsigned long text_size, unsigned long ro_size, unsigned long total_size) { }
-- 
1.7.7.6

