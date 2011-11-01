Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932757Ab1KAXwP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 19:52:15 -0400
Received: from smtp-out.google.com ([74.125.121.67]:38138 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932264Ab1KAXwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 19:52:11 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:
	references:in-reply-to:references:organization;
	b=I5K9UEgI+yJi9MJGi484BpQZE52OssBylSYHf62k19M1fBZaHACjBGxDehAecc9YI
	KXivPYzVJepg9bKD0LCXg==
From: David Decotigny <david.decotigny@google.com>
To: Randy Dunlap <rdunlap@xenotime.net>,
        Jason Wessel <jason.wessel@windriver.com>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Michal Schmidt <mschmidt@redhat.com>,
        Richard Kennedy <richard@rsk.demon.co.uk>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Dmitry Torokhov <dtor@vmware.com>, Kay Sievers <kay.sievers@vrfy.org>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Satoru Moriya <satoru.moriya@hds.com>,
        David Decotigny <decot@google.com>,
        David Decotigny <david.decotigny@google.com>
Subject: [PATCH v2 1/3] param: make destroy_params() private
Date: Tue,  1 Nov 2011 16:50:33 -0700
Message-Id: <515981316066d9d94e3152ef33ec509f0a49f080.1320191327.git.david.decotigny@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <cover.1320191327.git.david.decotigny@google.com>
References: <cover.1320191327.git.david.decotigny@google.com>
In-Reply-To: <cover.1320191327.git.david.decotigny@google.com>
References: <cover.1320191327.git.david.decotigny@google.com>
Organization: Google, Inc.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Decotigny <decot@google.com>

This moves params_destroy to module.c, the only place where it is
needed and called.

Tested:
  make defconfig all



Signed-off-by: David Decotigny <david.decotigny@google.com>
---
 include/linux/moduleparam.h |   10 ----------
 kernel/module.c             |    9 +++++++++
 kernel/params.c             |    8 --------
 3 files changed, 9 insertions(+), 18 deletions(-)

diff --git a/include/linux/moduleparam.h b/include/linux/moduleparam.h
index fffb10b..77d09f4 100644
--- a/include/linux/moduleparam.h
+++ b/include/linux/moduleparam.h
@@ -289,16 +289,6 @@ extern int parse_args(const char *name,
 		      unsigned num,
 		      int (*unknown)(char *param, char *val));
 
-/* Called by module remove. */
-#ifdef CONFIG_SYSFS
-extern void destroy_params(const struct kernel_param *params, unsigned num);
-#else
-static inline void destroy_params(const struct kernel_param *params,
-				  unsigned num)
-{
-}
-#endif /* !CONFIG_SYSFS */
-
 /* All the helper functions */
 /* The macros to do compile-time type checking stolen from Jakub
    Jelinek, who IIRC came up with this idea for the 2.4 module init code. */
diff --git a/kernel/module.c b/kernel/module.c
index 93342d9..529e965 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1723,6 +1723,15 @@ void __weak module_arch_cleanup(struct module *mod)
 {
 }
 
+static void destroy_params(const struct kernel_param *params, unsigned num)
+{
+	unsigned int i;
+
+	for (i = 0; i < num; i++)
+		if (params[i].ops->free)
+			params[i].ops->free(params[i].arg);
+}
+
 /* Free a module, remove from lists, etc. */
 static void free_module(struct module *mod)
 {
diff --git a/kernel/params.c b/kernel/params.c
index 8217889..75fd7bf 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -711,14 +711,6 @@ void module_param_sysfs_remove(struct module *mod)
 }
 #endif
 
-void destroy_params(const struct kernel_param *params, unsigned num)
-{
-	unsigned int i;
-
-	for (i = 0; i < num; i++)
-		if (params[i].ops->free)
-			params[i].ops->free(params[i].arg);
-}
 
 static struct module_kobject * __init locate_module_kobject(const char *name)
 {
-- 
1.7.3.1

