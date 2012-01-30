Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110Ab2A3Ink (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 03:43:40 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:53618 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752725Ab2A3Inj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 03:43:39 -0500
From: Dmitry Antipov <dmitry.antipov@linaro.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        patches@linaro.org, Dmitry Antipov <dmitry.antipov@linaro.org>
Subject: [PATCH 3/3] module: use ZERO_OR_NULL_PTR allocation pointer checking
Date: Mon, 30 Jan 2012 12:44:40 +0400
Message-Id: <1327913080-8850-1-git-send-email-dmitry.antipov@linaro.org>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use ZERO_OR_NULL_PTR allocation pointer checking where allocation
function may return ZERO_SIZE_PTR.

Signed-off-by: Dmitry Antipov <dmitry.antipov@linaro.org>
---
 kernel/module.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index 2c93276..5183f91 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -438,7 +438,7 @@ static int percpu_modalloc(struct module *mod,
 	}
 
 	mod->percpu = __alloc_reserved_percpu(size, align);
-	if (!mod->percpu) {
+	if (unlikely(ZERO_OR_NULL_PTR(mod->percpu))) {
 		printk(KERN_WARNING
 		       "%s: Could not allocate %lu bytes percpu data\n",
 		       mod->name, size);
@@ -572,7 +572,7 @@ EXPORT_TRACEPOINT_SYMBOL(module_get);
 static int module_unload_init(struct module *mod)
 {
 	mod->refptr = alloc_percpu(struct module_ref);
-	if (!mod->refptr)
+	if (unlikely(ZERO_OR_NULL_PTR(mod->refptr)))
 		return -ENOMEM;
 
 	INIT_LIST_HEAD(&mod->source_list);
@@ -2322,14 +2322,14 @@ static void dynamic_debug_remove(struct _ddebug *debug)
 
 void * __weak module_alloc(unsigned long size)
 {
-	return size == 0 ? NULL : vmalloc_exec(size);
+	return vmalloc_exec(size);
 }
 
 static void *module_alloc_update_bounds(unsigned long size)
 {
 	void *ret = module_alloc(size);
 
-	if (ret) {
+	if (likely(!ZERO_OR_NULL_PTR(ret))) {
 		mutex_lock(&module_mutex);
 		/* Update module bounds. */
 		if ((unsigned long)ret < module_addr_min)
@@ -2638,7 +2638,7 @@ static int move_module(struct module *mod, struct load_info *info)
 	 * leak.
 	 */
 	kmemleak_not_leak(ptr);
-	if (!ptr)
+	if (unlikely(ZERO_OR_NULL_PTR(ptr)))
 		return -ENOMEM;
 
 	memset(ptr, 0, mod->core_size);
@@ -2652,7 +2652,7 @@ static int move_module(struct module *mod, struct load_info *info)
 	 * after the module is initialized.
 	 */
 	kmemleak_ignore(ptr);
-	if (!ptr && mod->init_size) {
+	if (unlikely(ZERO_OR_NULL_PTR(ptr)) && mod->init_size) {
 		module_free(mod, mod->module_core);
 		return -ENOMEM;
 	}
-- 
1.7.7.6

