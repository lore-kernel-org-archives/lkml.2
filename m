Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755921Ab2A0HTY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 02:19:24 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:54524 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754332Ab2A0HTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 02:19:23 -0500
From: Dmitry Antipov <dmitry.antipov@linaro.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        patches@linaro.org, Dmitry Antipov <dmitry.antipov@linaro.org>
Subject: [PATCH] module: avoid call vmalloc if init size is zero
Date: Fri, 27 Jan 2012 11:19:16 +0400
Message-Id: <1327648756-22255-1-git-send-email-dmitry.antipov@linaro.org>
X-Mailer: git-send-email 1.7.7.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For the architectures with it's own module_alloc(), if module init
size is zero, avoiding module_alloc_update_bounds() and memset()
no-op calls also eliminates warn_alloc_failed() zero-size warning
in __vmalloc_node_range().

Signed-off-by: Dmitry Antipov <dmitry.antipov@linaro.org>
---
 kernel/module.c |   31 +++++++++++++++++--------------
 1 files changed, 17 insertions(+), 14 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index 2c93276..bbe1c5b 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2644,20 +2644,23 @@ static int move_module(struct module *mod, struct load_info *info)
 	memset(ptr, 0, mod->core_size);
 	mod->module_core = ptr;
 
-	ptr = module_alloc_update_bounds(mod->init_size);
-	/*
-	 * The pointer to this block is stored in the module structure
-	 * which is inside the block. This block doesn't need to be
-	 * scanned as it contains data and code that will be freed
-	 * after the module is initialized.
-	 */
-	kmemleak_ignore(ptr);
-	if (!ptr && mod->init_size) {
-		module_free(mod, mod->module_core);
-		return -ENOMEM;
-	}
-	memset(ptr, 0, mod->init_size);
-	mod->module_init = ptr;
+	if (mod->init_size) {
+		ptr = module_alloc_update_bounds(mod->init_size);
+		/*
+		 * The pointer to this block is stored in the module structure
+		 * which is inside the block. This block doesn't need to be
+		 * scanned as it contains data and code that will be freed
+		 * after the module is initialized.
+		 */
+		kmemleak_ignore(ptr);
+		if (!ptr) {
+			module_free(mod, mod->module_core);
+			return -ENOMEM;
+		}
+		memset(ptr, 0, mod->init_size);
+		mod->module_init = ptr;
+	} else
+		mod->module_init = NULL;
 
 	/* Transfer each section which specifies SHF_ALLOC */
 	pr_debug("final section addresses:\n");
-- 
1.7.7.5

