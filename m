Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752181Ab1AENAj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 08:00:39 -0500
Received: from mail.df.lth.se ([194.47.250.12]:49292 "EHLO df.lth.se"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751810Ab1AENAi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 08:00:38 -0500
X-Greylist: delayed 1994 seconds by postgrey-1.27 at vger.kernel.org; Wed, 05 Jan 2011 08:00:38 EST
From: Linus Walleij <linus.walleij@stericsson.com>
To: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        Dan Carpenter <error27@gmail.com>
Subject: [PATCH] param: add null statement to compiled-in module params
Date: Wed,  5 Jan 2011 13:27:04 +0100
Message-Id: <1294230424-4089-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add an unused struct declaration statement requiring a
terminating semicolon to the compile-in case to provoke an
error if __MODULE_INFO() is used without the terminating
semicolon. Previously MODULE_ALIAS("foo") (no semicolon)
compiled fine if MODULE was not selected.

Cc: Dan Carpenter <error27@gmail.com>
Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
More clever solutions appreciated, this thing works.
---
 include/linux/moduleparam.h |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/linux/moduleparam.h b/include/linux/moduleparam.h
index 112adf8..07b4195 100644
--- a/include/linux/moduleparam.h
+++ b/include/linux/moduleparam.h
@@ -16,15 +16,17 @@
 /* Chosen so that structs with an unsigned long line up. */
 #define MAX_PARAM_PREFIX_LEN (64 - sizeof(unsigned long))
 
-#ifdef MODULE
 #define ___module_cat(a,b) __mod_ ## a ## b
 #define __module_cat(a,b) ___module_cat(a,b)
+#ifdef MODULE
 #define __MODULE_INFO(tag, name, info)					  \
 static const char __module_cat(name,__LINE__)[]				  \
   __used __attribute__((section(".modinfo"), unused, aligned(1)))	  \
   = __stringify(tag) "=" info
 #else  /* !MODULE */
-#define __MODULE_INFO(tag, name, info)
+/* This struct is here for syntactic coherency, it is not used */
+#define __MODULE_INFO(tag, name, info)					  \
+  struct __module_cat(name,__LINE__) {}
 #endif
 #define __MODULE_PARM_TYPE(name, _type)					  \
   __MODULE_INFO(parmtype, name##type, #name ":" _type)
-- 
1.7.3.4

