Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932618Ab2B1Jcy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 04:32:54 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:35632 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932308Ab2B1Jcv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 04:32:51 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of dmitry.antipov@linaro.org designates 10.204.151.3 as permitted sender) smtp.mail=dmitry.antipov@linaro.org
MIME-Version: 1.0
From: Dmitry Antipov <dmitry.antipov@linaro.org>
To: Rusty Russell <rusty.russell@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        Dmitry Antipov <dmitry.antipov@linaro.org>
Subject: [PATCH 2/2] module: use ZERO_OR_NULL_PTR allocation pointer checking
Date: Tue, 28 Feb 2012 13:34:00 +0400
Message-Id: <1330421640-5137-2-git-send-email-dmitry.antipov@linaro.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1330421640-5137-1-git-send-email-dmitry.antipov@linaro.org>
References: <1330421640-5137-1-git-send-email-dmitry.antipov@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use ZERO_OR_NULL_PTR allocation pointer checking where allocation
function may return ZERO_SIZE_PTR.
---
 kernel/module.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index 2c93276..ae438db 100644
--- a/kernel/module.c
+++ b/kernel/module.c
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
+	if (unlikely(ZERO_OR_NULL_PTR(ptr))) {
 		module_free(mod, mod->module_core);
 		return -ENOMEM;
 	}
-- 
1.7.7.6

