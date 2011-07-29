Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755319Ab1G2NwD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 09:52:03 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37244 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754349Ab1G2NwB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 09:52:01 -0400
From: Michal Marek <mmarek@suse.cz>
To: linux-kbuild@vger.kernel.org
Cc: xiyou.wangcong@gmail.com, rdunlap@xenotime.net, lacombar@gmail.com,
        sam@ravnborg.org, linux-kernel@vger.kernel.org, plagnioj@jcrosoft.com
Subject: [PATCH] kconfig: Introduce IS_ENABLED(), IS_BUILTIN() and IS_MODULE()
Date: Fri, 29 Jul 2011 15:51:37 +0200
Message-Id: <1311947497-4958-1-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1311634718-32588-1-git-send-email-mmarek@suse.cz>
References: <1311634718-32588-1-git-send-email-mmarek@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace the config_is_*() macros with a variant that allows for grepping
for usage of CONFIG_* options in the code. Usage:

  if (IS_ENABLED(CONFIG_NUMA))

or

  #if IS_ENABLED(CONFIG_NUMA)

The IS_ENABLED() macro evaluates to 1 if the argument is set (to either 'y'
or 'm'), IS_BUILTIN() tests if the option is 'y' and IS_MODULE() test if
the option is 'm'. Only boolean and tristate options are supported.

Signed-off-by: Michal Marek <mmarek@suse.cz>
---

Everybody happy with the above naming?

Michal

---
 Makefile                   |    2 +-
 include/linux/kconfig.h    |   32 ++++++++++++++++++++
 scripts/kconfig/confdata.c |   71 ++++++++-----------------------------------
 3 files changed, 47 insertions(+), 58 deletions(-)
 create mode 100644 include/linux/kconfig.h

diff --git a/Makefile b/Makefile
index afb8e0d..bd7629b 100644
--- a/Makefile
+++ b/Makefile
@@ -360,7 +360,7 @@ CFLAGS_GCOV	= -fprofile-arcs -ftest-coverage
 LINUXINCLUDE    := -I$(srctree)/arch/$(hdr-arch)/include \
                    -Iarch/$(hdr-arch)/include/generated -Iinclude \
                    $(if $(KBUILD_SRC), -I$(srctree)/include) \
-                   -include include/generated/autoconf.h
+                   -include $(srctree)/include/linux/kconfig.h
 
 KBUILD_CPPFLAGS := -D__KERNEL__
 
diff --git a/include/linux/kconfig.h b/include/linux/kconfig.h
new file mode 100644
index 0000000..067eda0
--- /dev/null
+++ b/include/linux/kconfig.h
@@ -0,0 +1,32 @@
+#ifndef __LINUX_KCONFIG_H
+#define __LINUX_KCONFIG_H
+
+#include <generated/autoconf.h>
+
+/*
+ * Helper macros to use CONFIG_ options in C expressions. Note that
+ * these only work with boolean and tristate options.
+ */
+
+/*
+ * IS_ENABLED(CONFIG_FOO) evaluates to 1 if CONFIG_FOO is set to 'y' or 'm',
+ * 0 otherwise.
+ *
+ */
+#define IS_ENABLED(option) \
+	(__enabled_ ## option || __enabled_ ## option ## _MODULE)
+
+/*
+ * IS_BUILTIN(CONFIG_FOO) evaluates to 1 if CONFIG_FOO is set to 'y', 0
+ * otherwise. For boolean options, this is equivalent to
+ * IS_ENABLED(CONFIG_FOO).
+ */
+#define IS_BUILTIN(option) __enabled_ ## option
+
+/*
+ * IS_MODULE(CONFIG_FOO) evaluates to 1 if CONFIG_FOO is set to 'm', 0
+ * otherwise.
+ */
+#define IS_MODULE(option) __enabled_ ## option ## _MODULE
+
+#endif /* __LINUX_KCONFIG_H */
diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
index df629ec..59b667c 100644
--- a/scripts/kconfig/confdata.c
+++ b/scripts/kconfig/confdata.c
@@ -495,15 +495,25 @@ header_print_symbol(FILE *fp, struct symbol *sym, const char *value, void *arg)
 
 		switch (*value) {
 		case 'n':
-			return;
+			break;
 		case 'm':
 			suffix = "_MODULE";
 			/* fall through */
 		default:
-			value = "1";
+			fprintf(fp, "#define %s%s%s 1\n",
+			    CONFIG_, sym->name, suffix);
 		}
-		fprintf(fp, "#define %s%s%s %s\n",
-		    CONFIG_, sym->name, suffix, value);
+		/*
+		 * Generate the __enabled_CONFIG_* and
+		 * __enabled_CONFIG_*_MODULE macros for use by the
+		 * IS_{ENABLED,BUILTIN,MODULE} macros. The _MODULE variant is
+		 * generated even for booleans so that the IS_ENABLED() macro
+		 * works.
+		 */
+		fprintf(fp, "#define __enabled_" CONFIG_ "%s %d\n",
+				sym->name, (*value == 'y'));
+		fprintf(fp, "#define __enabled_" CONFIG_ "%s_MODULE %d\n",
+				sym->name, (*value == 'm'));
 		break;
 	}
 	case S_HEX: {
@@ -555,58 +565,6 @@ static struct conf_printer header_printer_cb =
 };
 
 /*
- * Function-style header printer
- *
- * This printer is used to generate the config_is_xxx() function-style macros
- * in `include/generated/autoconf.h' 
- */
-static void
-header_function_print_symbol(FILE *fp, struct symbol *sym, const char *value, void *arg)
-{
-	int val = 0;
-	char c;
-	char *tmp, *d;
-
-	switch (sym->type) {
-	case S_BOOLEAN:
-	case S_TRISTATE:
-		break;
-	default:
-		return;
-	}
-	if (*value == 'm')
-		val = 2;
-	else if (*value == 'y')
-		val = 1;
-
-	d = strdup(CONFIG_);
-	tmp = d;
-	while ((c = *d)) {
-		*d = tolower(c);
-		d++;
-	}
-
-	fprintf(fp, "#define %sis_", tmp);
-	free(tmp);
-
-	d = strdup(sym->name);
-	tmp = d;
-	while ((c = *d)) {
-		*d = tolower(c);
-		d++;
-	}
-	fprintf(fp, "%s%s() %d\n", tmp, (val > 1) ? "_module" : "",
-		      val ? 1 : 0);
-	free(tmp);
-}
-
-static struct conf_printer header_function_printer_cb =
-{
-	.print_symbol = header_function_print_symbol,
-};
-
-
-/*
  * Tristate printer
  *
  * This printer is used when generating the `include/config/tristate.conf' file.
@@ -997,7 +955,6 @@ int conf_write_autoconf(void)
 		conf_write_symbol(tristate, sym, &tristate_printer_cb, (void *)1);
 
 		conf_write_symbol(out_h, sym, &header_printer_cb, NULL);
-		conf_write_symbol(out_h, sym, &header_function_printer_cb, NULL);
 	}
 	fclose(out);
 	fclose(tristate);
-- 
1.7.6

