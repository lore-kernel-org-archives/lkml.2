Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755222Ab2CJOUx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2012 09:20:53 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:60096 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754830Ab2CJOUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2012 09:20:51 -0500
From: Cong Wang <xiyou.wangcong@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Rusty Russell <rusty@rustcorp.com.au>, David Airlie <airlied@linux.ie>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH 2/2] module: avoid exporting module_mutex
Date: Sat, 10 Mar 2012 22:20:03 +0800
Message-Id: <1331389203-3309-2-git-send-email-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1331389203-3309-1-git-send-email-xiyou.wangcong@gmail.com>
References: <1331389203-3309-1-git-send-email-xiyou.wangcong@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avoid exporting internal locks to modules, export two
functions lock_modules()/unlock_modules() for them instead.

Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
---
 drivers/gpu/drm/drm_fb_helper.c |    4 ++--
 include/linux/module.h          |    3 ++-
 kernel/kprobes.c                |    4 ++--
 kernel/module.c                 |   16 ++++++++++++++--
 4 files changed, 20 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/drm_fb_helper.c b/drivers/gpu/drm/drm_fb_helper.c
index aada26f..c184759 100644
--- a/drivers/gpu/drm/drm_fb_helper.c
+++ b/drivers/gpu/drm/drm_fb_helper.c
@@ -1451,9 +1451,9 @@ static int __init drm_fb_helper_modinit(void)
 	const char *name = "fbcon";
 	struct module *fbcon;
 
-	mutex_lock(&module_mutex);
+	lock_modules();
 	fbcon = find_module(name);
-	mutex_unlock(&module_mutex);
+	unlock_modules();
 
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
index e0b12f7..1165d5d 100644
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
-- 
1.7.7.6

