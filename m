Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752805Ab0IVKId (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 06:08:33 -0400
Received: from one.firstfloor.org ([213.235.205.2]:34409 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752266Ab0IVKIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 06:08:32 -0400
From: Andi Kleen <andi@firstfloor.org>
To: jbaron@redhat.com
Cc: rostedt@goodmis.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
        mathieu.desnoyers@polymtl.ca, hpa@zytor.com, tglx@linutronix.de,
        roland@redhat.com, rth@redhat.com, mhiramat@redhat.com,
        fweisbec@gmail.com, avi@redhat.com, davem@davemloft.net,
        vgoyal@redhat.com, sam@ravnborg.org, tony@bakeyournoodle.com,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 1/2] Add for_each_module iterator function
Date: Wed, 22 Sep 2010 12:08:21 +0200
Message-Id: <1285150102-5506-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

This is a generic function to iterate over all modules.
To be used in the next patch.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 include/linux/module.h |    1 +
 kernel/module.c        |   10 ++++++++++
 2 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/include/linux/module.h b/include/linux/module.h
index 403ac26..809b6db 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -410,6 +410,7 @@ struct module *__module_address(unsigned long addr);
 bool is_module_address(unsigned long addr);
 bool is_module_percpu_address(unsigned long addr);
 bool is_module_text_address(unsigned long addr);
+void for_each_module(void (*op)(struct module *, void *arg), void *arg);
 
 static inline int within_module_core(unsigned long addr, struct module *mod)
 {
diff --git a/kernel/module.c b/kernel/module.c
index eba1341..b8fb3e6 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -384,6 +384,16 @@ struct module *find_module(const char *name)
 }
 EXPORT_SYMBOL_GPL(find_module);
 
+void for_each_module(void (*op)(struct module *, void *arg), void *arg)
+{
+	struct module *mod;
+
+	preempt_disable();
+	list_for_each_entry_rcu(mod, &modules, list)
+		op(mod, arg);
+	preempt_enable();
+}
+
 #ifdef CONFIG_SMP
 
 static inline void __percpu *mod_percpu(struct module *mod)
-- 
1.7.1

