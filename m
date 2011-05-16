Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755872Ab1EPDmT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 23:42:19 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:64645 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642Ab1EPDmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 23:42:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=LyZs50IMXt/Jt6jOFtGwyBajRHd1ii9XrNjB9O8e6lCx+8JYHZhwbx6nHytouhKyD1
         0hqgeU1JNy1ZuabzC9Mgk4HVW92AM9DtewCaLxSNrV2bOt/DrO3wq3amPIUPQJq+2ovI
         9a3KNKDuQ8bRw257HrvtjLYiZ94zH57DzmQi8=
From: Arnaud Lacombe <lacombar@gmail.com>
To: linux-kbuild@vger.kernel.org
Cc: Michal Marek <mmarek@suse.cz>, linux-kernel@vger.kernel.org,
        Arnaud Lacombe <lacombar@gmail.com>
Subject: [PATCHv2] kconfig: introduce specialized printer
Date: Sun, 15 May 2011 23:42:09 -0400
Message-Id: <1305517329-7558-1-git-send-email-lacombar@gmail.com>
X-Mailer: git-send-email 1.7.3.4.574.g608b.dirty
In-Reply-To: <4D10D7DF.7040903@suse.cz>
References: <4D10D7DF.7040903@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make conf_write_symbol() grammar agnostic to be able to use it from different
code path. These path pass a printer callback which will print a symbol's name
and its value in different format.

conf_write_symbol()'s job become mostly only to prepare a string for the
printer. This avoid to have to pass specialized flag to generic
functions

Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
---
 scripts/kconfig/confdata.c  |  268 +++++++++++++++++++++++++++----------------
 scripts/kconfig/lkc.h       |    5 +
 scripts/kconfig/lkc_proto.h |    1 +
 scripts/kconfig/symbol.c    |   46 +++++++-
 4 files changed, 219 insertions(+), 101 deletions(-)

History:
v2: Address Michal's comment in msg-id <4D10D7DF.7040903@suse.cz>:
 - add brief comment before each printer
 - introduce a `skip_unset' variable in kconfig printer
 - merge inner switch in an if() statement
 - annotate fallthrough
 - fix tristate printer behavior

v1: cf. https://patchwork.kernel.org/patch/380631/

diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
index 2bafd9a..46e92e9 100644
--- a/scripts/kconfig/confdata.c
+++ b/scripts/kconfig/confdata.c
@@ -417,64 +417,176 @@ int conf_read(const char *name)
 	return 0;
 }
 
-/* Write a S_STRING */
-static void conf_write_string(bool headerfile, const char *name,
-                              const char *str, FILE *out)
+/*
+ * Kconfig configuration printer
+ *
+ * This printer is used when generating the resulting configuration after
+ * kconfig invocation and `defconfig' files. Unset symbol might be omitted by
+ * passing a non-NULL argument to the printer.
+ *
+ */
+static void
+kconfig_print_symbol(FILE *fp, struct symbol *sym, const char *value, void *arg)
 {
-	int l;
-	if (headerfile)
-		fprintf(out, "#define %s%s \"", CONFIG_, name);
-	else
-		fprintf(out, "%s%s=\"", CONFIG_, name);
-
-	while (1) {
-		l = strcspn(str, "\"\\");
+
+	switch (sym->type) {
+	case S_BOOLEAN:
+	case S_TRISTATE:
+		if (*value == 'n') {
+			bool skip_unset = (arg != NULL);
+
+			if (!skip_unset)
+				fprintf(fp, "# %s%s is not set\n",
+				    CONFIG_, sym->name);
+			return;
+		}
+		break;
+	default:
+		break;
+	}
+
+	fprintf(fp, "%s%s=%s\n", CONFIG_, sym->name, value);
+}
+
+static void
+kconfig_print_comment(FILE *fp, const char *value, void *arg)
+{
+	const char *p = value;
+	size_t l;
+
+	for (;;) {
+		l = strcspn(p, "\n");
+		fprintf(fp, "#");
 		if (l) {
-			xfwrite(str, l, 1, out);
-			str += l;
+			fprintf(fp, " ");
+			fwrite(p, l, 1, fp);
+			p += l;
 		}
-		if (!*str)
+		fprintf(fp, "\n");
+		if (*p++ == '\0')
 			break;
-		fprintf(out, "\\%c", *str++);
 	}
-	fputs("\"\n", out);
 }
 
-static void conf_write_symbol(struct symbol *sym, FILE *out, bool write_no)
+static struct conf_printer kconfig_printer_cb =
 {
-	const char *str;
+	.print_symbol = kconfig_print_symbol,
+	.print_comment = kconfig_print_comment,
+};
+
+/*
+ * Header printer
+ *
+ * This printer is used when generating the `include/generated/autoconf.h' file.
+ */
+static void
+header_print_symbol(FILE *fp, struct symbol *sym, const char *value, void *arg)
+{
+	const char *suffix = "";
 
 	switch (sym->type) {
 	case S_BOOLEAN:
 	case S_TRISTATE:
-		switch (sym_get_tristate_value(sym)) {
-		case no:
-			if (write_no)
-				fprintf(out, "# %s%s is not set\n",
-				    CONFIG_, sym->name);
-			break;
-		case mod:
-			fprintf(out, "%s%s=m\n", CONFIG_, sym->name);
-			break;
-		case yes:
-			fprintf(out, "%s%s=y\n", CONFIG_, sym->name);
-			break;
+		switch (*value) {
+		case 'n':
+			return;
+		case 'm':
+			suffix = "_MODULE";
+			/* FALLTHROUGH */
+		default:
+			value = "1";
 		}
 		break;
-	case S_STRING:
-		conf_write_string(false, sym->name, sym_get_string_value(sym), out);
-		break;
-	case S_HEX:
-	case S_INT:
-		str = sym_get_string_value(sym);
-		fprintf(out, "%s%s=%s\n", CONFIG_, sym->name, str);
+	default:
 		break;
+	}
+
+	fprintf(fp, "#define %s%s%s %s\n",
+	    CONFIG_, sym->name, suffix, value);
+}
+
+static void
+header_print_comment(FILE *fp, const char *value, void *arg)
+{
+	const char *p = value;
+	size_t l;
+
+	fprintf(fp, "/*\n");
+	for (;;) {
+		l = strcspn(p, "\n");
+		fprintf(fp, " *");
+		if (l) {
+			fprintf(fp, " ");
+			fwrite(p, l, 1, fp);
+			p += l;
+		}
+		fprintf(fp, "\n");
+		if (*p++ == '\0')
+			break;
+	}
+	fprintf(fp, " */\n");
+}
+
+static struct conf_printer header_printer_cb =
+{
+	.print_symbol = header_print_symbol,
+	.print_comment = header_print_comment,
+};
+
+/*
+ * Tristate printer
+ *
+ * This printer is used when generating the `include/config/tristate.conf' file.
+ */
+static void
+tristate_print_symbol(FILE *fp, struct symbol *sym, const char *value, void *arg)
+{
+
+	if (sym->type == S_TRISTATE && *value != 'n')
+		fprintf(fp, "%s%s=%c\n", CONFIG_, sym->name, (char)toupper(*value));
+}
+
+static struct conf_printer tristate_printer_cb =
+{
+	.print_symbol = tristate_print_symbol,
+	.print_comment = kconfig_print_comment,
+};
+
+static void conf_write_symbol(FILE *fp, struct symbol *sym,
+			      struct conf_printer *printer, void *printer_arg)
+{
+	const char *str;
+
+	switch (sym->type) {
 	case S_OTHER:
 	case S_UNKNOWN:
 		break;
+	case S_STRING:
+		str = sym_get_string_value(sym);
+		str = sym_escape_string_value(str);
+		printer->print_symbol(fp, sym, str, printer_arg);
+		free((void *)str);
+		break;
+	default:
+		str = sym_get_string_value(sym);
+		printer->print_symbol(fp, sym, str, printer_arg);
 	}
 }
 
+static void
+conf_write_heading(FILE *fp, struct conf_printer *printer, void *printer_arg)
+{
+	char buf[256];
+
+	snprintf(buf, sizeof(buf),
+	    "\n"
+	    "Automatically generated file; DO NOT EDIT.\n"
+	    "%s\n",
+	    rootmenu.prompt->text);
+
+	printer->print_comment(fp, buf, printer_arg);
+}
+
 /*
  * Write out a minimal config.
  * All values that has default values are skipped as this is redundant.
@@ -531,7 +643,7 @@ int conf_write_defconfig(const char *filename)
 						goto next_menu;
 				}
 			}
-			conf_write_symbol(sym, out, true);
+			conf_write_symbol(out, sym, &kconfig_printer_cb, NULL);
 		}
 next_menu:
 		if (menu->list != NULL) {
@@ -596,11 +708,7 @@ int conf_write(const char *name)
 	if (!out)
 		return 1;
 
-	fprintf(out, _("#\n"
-		       "# Automatically generated make config: don't edit\n"
-		       "# %s\n"
-		       "#\n"),
-		     rootmenu.prompt->text);
+	conf_write_heading(out, &kconfig_printer_cb, NULL);
 
 	if (!conf_get_changed())
 		sym_clear_all_valid();
@@ -621,8 +729,8 @@ int conf_write(const char *name)
 			if (!(sym->flags & SYMBOL_WRITE))
 				goto next;
 			sym->flags &= ~SYMBOL_WRITE;
-			/* Write config symbol to file */
-			conf_write_symbol(sym, out, true);
+
+			conf_write_symbol(out, sym, &kconfig_printer_cb, NULL);
 		}
 
 next:
@@ -771,7 +879,6 @@ out:
 int conf_write_autoconf(void)
 {
 	struct symbol *sym;
-	const char *str;
 	const char *name;
 	FILE *out, *tristate, *out_h;
 	int i;
@@ -800,68 +907,23 @@ int conf_write_autoconf(void)
 		return 1;
 	}
 
-	fprintf(out, "#\n"
-		     "# Automatically generated make config: don't edit\n"
-		     "# %s\n"
-		     "#\n",
-		     rootmenu.prompt->text);
-	fprintf(tristate, "#\n"
-			  "# Automatically generated - do not edit\n"
-			  "\n");
-	fprintf(out_h, "/*\n"
-		       " * Automatically generated C config: don't edit\n"
-		       " * %s\n"
-		       " */\n",
-		       rootmenu.prompt->text);
+	conf_write_heading(out, &kconfig_printer_cb, NULL);
+
+	conf_write_heading(tristate, &tristate_printer_cb, NULL);
+
+	conf_write_heading(out_h, &header_printer_cb, NULL);
 
 	for_all_symbols(i, sym) {
 		sym_calc_value(sym);
 		if (!(sym->flags & SYMBOL_WRITE) || !sym->name)
 			continue;
 
-		/* write symbol to config file */
-		conf_write_symbol(sym, out, false);
+		/* write symbol to auto.conf, tristate and header files */
+		conf_write_symbol(out, sym, &kconfig_printer_cb, (void *)1);
 
-		/* update autoconf and tristate files */
-		switch (sym->type) {
-		case S_BOOLEAN:
-		case S_TRISTATE:
-			switch (sym_get_tristate_value(sym)) {
-			case no:
-				break;
-			case mod:
-				fprintf(tristate, "%s%s=M\n",
-				    CONFIG_, sym->name);
-				fprintf(out_h, "#define %s%s_MODULE 1\n",
-				    CONFIG_, sym->name);
-				break;
-			case yes:
-				if (sym->type == S_TRISTATE)
-					fprintf(tristate,"%s%s=Y\n",
-					    CONFIG_, sym->name);
-				fprintf(out_h, "#define %s%s 1\n",
-				    CONFIG_, sym->name);
-				break;
-			}
-			break;
-		case S_STRING:
-			conf_write_string(true, sym->name, sym_get_string_value(sym), out_h);
-			break;
-		case S_HEX:
-			str = sym_get_string_value(sym);
-			if (str[0] != '0' || (str[1] != 'x' && str[1] != 'X')) {
-				fprintf(out_h, "#define %s%s 0x%s\n",
-				    CONFIG_, sym->name, str);
-				break;
-			}
-		case S_INT:
-			str = sym_get_string_value(sym);
-			fprintf(out_h, "#define %s%s %s\n",
-			    CONFIG_, sym->name, str);
-			break;
-		default:
-			break;
-		}
+		conf_write_symbol(tristate, sym, &tristate_printer_cb, (void *)1);
+
+		conf_write_symbol(out_h, sym, &header_printer_cb, NULL);
 	}
 	fclose(out);
 	fclose(tristate);
diff --git a/scripts/kconfig/lkc.h b/scripts/kconfig/lkc.h
index febf0c9..7b0db22 100644
--- a/scripts/kconfig/lkc.h
+++ b/scripts/kconfig/lkc.h
@@ -92,6 +92,11 @@ void sym_set_change_count(int count);
 void sym_add_change_count(int count);
 void conf_set_all_new_symbols(enum conf_def_mode mode);
 
+struct conf_printer {
+	void (*print_symbol)(FILE *, struct symbol *, const char *, void *);
+	void (*print_comment)(FILE *, const char *, void *);
+};
+
 /* confdata.c and expr.c */
 static inline void xfwrite(const void *str, size_t len, size_t count, FILE *out)
 {
diff --git a/scripts/kconfig/lkc_proto.h b/scripts/kconfig/lkc_proto.h
index 17342fe..47fe9c3 100644
--- a/scripts/kconfig/lkc_proto.h
+++ b/scripts/kconfig/lkc_proto.h
@@ -31,6 +31,7 @@ P(symbol_hash,struct symbol *,[SYMBOL_HASHSIZE]);
 P(sym_lookup,struct symbol *,(const char *name, int flags));
 P(sym_find,struct symbol *,(const char *name));
 P(sym_expand_string_value,const char *,(const char *in));
+P(sym_escape_string_value, const char *,(const char *in));
 P(sym_re_search,struct symbol **,(const char *pattern));
 P(sym_type_name,const char *,(enum symbol_type type));
 P(sym_calc_value,void,(struct symbol *sym));
diff --git a/scripts/kconfig/symbol.c b/scripts/kconfig/symbol.c
index a796c95..11417a2 100644
--- a/scripts/kconfig/symbol.c
+++ b/scripts/kconfig/symbol.c
@@ -751,7 +751,8 @@ const char *sym_get_string_value(struct symbol *sym)
 		case no:
 			return "n";
 		case mod:
-			return "m";
+			sym_calc_value(modules_sym);
+			return (modules_sym->curr.tri == no) ? "n" : "m";
 		case yes:
 			return "y";
 		}
@@ -893,6 +894,49 @@ const char *sym_expand_string_value(const char *in)
 	return res;
 }
 
+const char *sym_escape_string_value(const char *in)
+{
+	const char *p;
+	size_t reslen;
+	char *res;
+	size_t l;
+
+	reslen = strlen(in) + strlen("\"\"") + 1;
+
+	p = in;
+	for (;;) {
+		l = strcspn(p, "\"\\");
+		p += l;
+
+		if (p[0] == '\0')
+			break;
+
+		reslen++;
+		p++;
+	}
+
+	res = malloc(reslen);
+	res[0] = '\0';
+
+	strcat(res, "\"");
+
+	p = in;
+	for (;;) {
+		l = strcspn(p, "\"\\");
+		strncat(res, p, l);
+		p += l;
+
+		if (p[0] == '\0')
+			break;
+
+		strcat(res, "\\");
+		strncat(res, p++, 1);
+	}
+
+	strcat(res, "\"");
+	return res;
+}
+
 struct symbol **sym_re_search(const char *pattern)
 {
 	struct symbol *sym, **sym_arr = NULL;
-- 
1.7.3.4.574.g608b.dirty

