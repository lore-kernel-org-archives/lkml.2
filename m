Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965028Ab2DKXw4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 19:52:56 -0400
Received: from mail.windriver.com ([147.11.1.11]:39419 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934064Ab2DKXvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 19:51:55 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, davem@davemloft.net,
        tony@bakeyournoodle.com, mmarek@suse.cz, lacombar@gmail.com,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH 5/5] kconfig: limit IS_ENABLED & similar to CPP usage
Date: Wed, 11 Apr 2012 19:50:57 -0400
Message-Id: <1334188257-3449-6-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.1
In-Reply-To: <1334188257-3449-1-git-send-email-paul.gortmaker@windriver.com>
References: <1334188257-3449-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using IS_ENABLED() within C (vs. within CPP #if statements) requires
us to actually define every possible bool/tristate Kconfig option
twice (__enabled_* and __enabled_*_MODULE variants).

Commit 953742c8fe8ac45be453fee959d7be40cd89f920

  "kconfig: fix __enabled_ macros definition for invisible
   and un-selected symbols"

caused the autoconf.h file to grow by a large factor, since it
now defined tens of thousands(!) of __enabled_CONFIG* items.

With the few C users that crept in over the last couple of releases
gone, we can now limit these items to be just for CPP usage.  And
in doing so, just emit lines where the options are really enabled
as modules or built in.

In doing so, the defconfig x86_64 autoconf.h size drops significantly:

	before:	15934 of 16943 total are __enabled_CONFIG* lines
	after:	943 of 1952 total are __enabled_CONFIG* lines

The numbers for x86_64 allnoconfig are even more drastic:

	before:	15934 of 16200 total are __enabled_CONFIG* lines
	after:	224 of 490 total are __enabled_CONFIG* lines

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 include/linux/kconfig.h    |    8 ++++----
 scripts/kconfig/confdata.c |   14 +++++++-------
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/include/linux/kconfig.h b/include/linux/kconfig.h
index 067eda0..5fa3f1b 100644
--- a/include/linux/kconfig.h
+++ b/include/linux/kconfig.h
@@ -4,7 +4,7 @@
 #include <generated/autoconf.h>
 
 /*
- * Helper macros to use CONFIG_ options in C expressions. Note that
+ * Helper macros to use CONFIG_ options in CPP #if expressions. Note that
  * these only work with boolean and tristate options.
  */
 
@@ -14,19 +14,19 @@
  *
  */
 #define IS_ENABLED(option) \
-	(__enabled_ ## option || __enabled_ ## option ## _MODULE)
+	(defined(__enabled_ ## option) || defined(__enabled_ ## option ## _MODULE))
 
 /*
  * IS_BUILTIN(CONFIG_FOO) evaluates to 1 if CONFIG_FOO is set to 'y', 0
  * otherwise. For boolean options, this is equivalent to
  * IS_ENABLED(CONFIG_FOO).
  */
-#define IS_BUILTIN(option) __enabled_ ## option
+#define IS_BUILTIN(option) defined(__enabled_ ## option)
 
 /*
  * IS_MODULE(CONFIG_FOO) evaluates to 1 if CONFIG_FOO is set to 'm', 0
  * otherwise.
  */
-#define IS_MODULE(option) __enabled_ ## option ## _MODULE
+#define IS_MODULE(option) defined(__enabled_ ## option ## _MODULE)
 
 #endif /* __LINUX_KCONFIG_H */
diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
index 9d06744..3651ee7 100644
--- a/scripts/kconfig/confdata.c
+++ b/scripts/kconfig/confdata.c
@@ -492,14 +492,14 @@ header_print_symbol(FILE *fp, struct symbol *sym, const char *value, void *arg)
 		/*
 		 * Generate the __enabled_CONFIG_* and
 		 * __enabled_CONFIG_*_MODULE macros for use by the
-		 * IS_{ENABLED,BUILTIN,MODULE} macros. The _MODULE variant is
-		 * generated even for booleans so that the IS_ENABLED() macro
-		 * works.
+		 * IS_{ENABLED,BUILTIN,MODULE} cpp helpers.
 		 */
-		fprintf(fp, "#define __enabled_" CONFIG_ "%s %d\n",
-				sym->name, (*value == 'y'));
-		fprintf(fp, "#define __enabled_" CONFIG_ "%s_MODULE %d\n",
-				sym->name, (*value == 'm'));
+		if (*value == 'y')
+			fprintf(fp, "#define __enabled_" CONFIG_ "%s\n",
+				sym->name);
+		if (*value == 'm')
+			fprintf(fp, "#define __enabled_" CONFIG_ "%s_MODULE\n",
+				sym->name);
 		break;
 	}
 	case S_HEX: {
-- 
1.7.9.1

