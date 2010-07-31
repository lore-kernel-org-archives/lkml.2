Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757038Ab0GaVdG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jul 2010 17:33:06 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:33008 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756858Ab0GaVby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jul 2010 17:31:54 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: Michal Marek <mmarek@suse.cz>, lkml <linux-kernel@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH] kconfig: code refactoring in confdata.c
Date: Sat, 31 Jul 2010 23:31:49 +0200
Message-Id: <1280611910-8155-8-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <20100731212907.GA7554@merkur.ravnborg.org>
References: <20100731212907.GA7554@merkur.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a a few local functions to avoid some code duplication
No functional changes.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 scripts/kconfig/confdata.c |  137 ++++++++++++++++++++++---------------------
 1 files changed, 70 insertions(+), 67 deletions(-)

diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
index 210a49e..d4fd55e 100644
--- a/scripts/kconfig/confdata.c
+++ b/scripts/kconfig/confdata.c
@@ -396,15 +396,73 @@ int conf_read(const char *name)
 	return 0;
 }
 
+/* Write a S_STRING */
+static void conf_write_string(bool headerfile, const char *name,
+                              const char *str, FILE *out)
+{
+	int l;
+	if (headerfile)
+		fprintf(out, "#define CONFIG_%s \"", name);
+	else
+		fprintf(out, "CONFIG_%s=\"", name);
+
+	while (1) {
+		l = strcspn(str, "\"\\");
+		if (l) {
+			fwrite(str, l, 1, out);
+			str += l;
+		}
+		if (!*str)
+			break;
+		fprintf(out, "\\%c", *str++);
+	}
+	fputs("\"\n", out);
+}
+
+static void conf_write_symbol(struct symbol *sym, enum symbol_type type,
+                              FILE *out, bool write_no)
+{
+	const char *str;
+
+	switch (type) {
+	case S_BOOLEAN:
+	case S_TRISTATE:
+		switch (sym_get_tristate_value(sym)) {
+		case no:
+			if (write_no)
+				fprintf(out, "# CONFIG_%s is not set\n", sym->name);
+			break;
+		case mod:
+			fprintf(out, "CONFIG_%s=m\n", sym->name);
+			break;
+		case yes:
+			fprintf(out, "CONFIG_%s=y\n", sym->name);
+			break;
+		}
+		break;
+	case S_STRING:
+		conf_write_string(false, sym->name, sym_get_string_value(sym), out);
+		break;
+	case S_HEX:
+	case S_INT:
+		str = sym_get_string_value(sym);
+		fprintf(out, "CONFIG_%s=%s\n", sym->name, str);
+		break;
+	case S_OTHER:
+	case S_UNKNOWN:
+		break;
+	}
+}
+
 int conf_write(const char *name)
 {
 	FILE *out;
 	struct symbol *sym;
 	struct menu *menu;
 	const char *basename;
-	char dirname[128], tmpname[128], newname[128];
-	int type, l;
 	const char *str;
+	char dirname[128], tmpname[128], newname[128];
+	enum symbol_type type;
 	time_t now;
 	int use_timestamp = 1;
 	char *env;
@@ -484,50 +542,11 @@ int conf_write(const char *name)
 				if (modules_sym->curr.tri == no)
 					type = S_BOOLEAN;
 			}
-			switch (type) {
-			case S_BOOLEAN:
-			case S_TRISTATE:
-				switch (sym_get_tristate_value(sym)) {
-				case no:
-					fprintf(out, "# CONFIG_%s is not set\n", sym->name);
-					break;
-				case mod:
-					fprintf(out, "CONFIG_%s=m\n", sym->name);
-					break;
-				case yes:
-					fprintf(out, "CONFIG_%s=y\n", sym->name);
-					break;
-				}
-				break;
-			case S_STRING:
-				str = sym_get_string_value(sym);
-				fprintf(out, "CONFIG_%s=\"", sym->name);
-				while (1) {
-					l = strcspn(str, "\"\\");
-					if (l) {
-						fwrite(str, l, 1, out);
-						str += l;
-					}
-					if (!*str)
-						break;
-					fprintf(out, "\\%c", *str++);
-				}
-				fputs("\"\n", out);
-				break;
-			case S_HEX:
-				str = sym_get_string_value(sym);
-				if (str[0] != '0' || (str[1] != 'x' && str[1] != 'X')) {
-					fprintf(out, "CONFIG_%s=%s\n", sym->name, str);
-					break;
-				}
-			case S_INT:
-				str = sym_get_string_value(sym);
-				fprintf(out, "CONFIG_%s=%s\n", sym->name, str);
-				break;
-			}
+			/* Write config symbol to file */
+			conf_write_symbol(sym, type, out, true);
 		}
 
-	next:
+next:
 		if (menu->list) {
 			menu = menu->list;
 			continue;
@@ -679,7 +698,7 @@ int conf_write_autoconf(void)
 	const char *name;
 	FILE *out, *tristate, *out_h;
 	time_t now;
-	int i, l;
+	int i;
 
 	sym_clear_all_valid();
 
@@ -729,6 +748,11 @@ int conf_write_autoconf(void)
 		sym_calc_value(sym);
 		if (!(sym->flags & SYMBOL_WRITE) || !sym->name)
 			continue;
+
+		/* write symbol to config file */
+		conf_write_symbol(sym, sym->type, out, false);
+
+		/* update autoconf and tristate files */
 		switch (sym->type) {
 		case S_BOOLEAN:
 		case S_TRISTATE:
@@ -736,12 +760,10 @@ int conf_write_autoconf(void)
 			case no:
 				break;
 			case mod:
-				fprintf(out, "CONFIG_%s=m\n", sym->name);
 				fprintf(tristate, "CONFIG_%s=M\n", sym->name);
 				fprintf(out_h, "#define CONFIG_%s_MODULE 1\n", sym->name);
 				break;
 			case yes:
-				fprintf(out, "CONFIG_%s=y\n", sym->name);
 				if (sym->type == S_TRISTATE)
 					fprintf(tristate, "CONFIG_%s=Y\n",
 							sym->name);
@@ -750,35 +772,16 @@ int conf_write_autoconf(void)
 			}
 			break;
 		case S_STRING:
-			str = sym_get_string_value(sym);
-			fprintf(out, "CONFIG_%s=\"", sym->name);
-			fprintf(out_h, "#define CONFIG_%s \"", sym->name);
-			while (1) {
-				l = strcspn(str, "\"\\");
-				if (l) {
-					fwrite(str, l, 1, out);
-					fwrite(str, l, 1, out_h);
-					str += l;
-				}
-				if (!*str)
-					break;
-				fprintf(out, "\\%c", *str);
-				fprintf(out_h, "\\%c", *str);
-				str++;
-			}
-			fputs("\"\n", out);
-			fputs("\"\n", out_h);
+			conf_write_string(true, sym->name, sym_get_string_value(sym), out_h);
 			break;
 		case S_HEX:
 			str = sym_get_string_value(sym);
 			if (str[0] != '0' || (str[1] != 'x' && str[1] != 'X')) {
-				fprintf(out, "CONFIG_%s=%s\n", sym->name, str);
 				fprintf(out_h, "#define CONFIG_%s 0x%s\n", sym->name, str);
 				break;
 			}
 		case S_INT:
 			str = sym_get_string_value(sym);
-			fprintf(out, "CONFIG_%s=%s\n", sym->name, str);
 			fprintf(out_h, "#define CONFIG_%s %s\n", sym->name, str);
 			break;
 		default:
-- 
1.6.0.6

