Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757890Ab1E3Wjx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 18:39:53 -0400
Received: from casper.infradead.org ([85.118.1.10]:36080 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751698Ab1E3Wjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 18:39:52 -0400
Subject: [PATCH] Enable 'make CONFIG_FOO=y oldconfig'
From: David Woodhouse <dwmw2@infradead.org>
To: "Ted Ts'o" <tytso@mit.edu>
Cc: Ingo Molnar <mingo@elte.hu>, x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Date: Mon, 30 May 2011 23:39:43 +0100
In-Reply-To: <alpine.LFD.2.02.1105302103220.3164@localhost6.localdomain6>
References: <1306707270.2029.377.camel@i7.infradead.org>
	 <20110530072300.GA9802@elte.hu>
	 <1306745835.2029.389.camel@i7.infradead.org>
	 <20110530104231.GF17821@elte.hu> <20110530104656.GA19532@elte.hu>
	 <E934876C-FABB-41F8-8C5E-469AA42DBE91@mit.edu>
	 <20110530105809.GA20133@elte.hu>
	 <1A4DB87D-9B32-44C0-B7C9-47A003CABD96@mit.edu>
	 <alpine.LFD.2.02.1105301955210.3164@localhost6.localdomain6>
	 <20110530195545.GG2890@dhcp-172-31-194-241.cam.corp.google.com>
	 <alpine.LFD.2.02.1105302103220.3164@localhost6.localdomain6>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.1 (3.0.1-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1306795186.2029.459.camel@i7.infradead.org>
Mime-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows you to set (and clear) config options on the make command
line, for all config targets. For example:

   make CONFIG_64BIT=n randconfig
   make CONFIG_64BIT=n allmodconfig
   make CONFIG_64BIT=y CONFIG_SATA_MV=y oldconfig 

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>

diff --git a/scripts/kconfig/conf.c b/scripts/kconfig/conf.c
index 006ad81..2b91e3b 100644
--- a/scripts/kconfig/conf.c
+++ b/scripts/kconfig/conf.c
@@ -456,7 +456,7 @@ static struct option long_opts[] = {
 	{NULL, 0, NULL, 0}
 };
 
-int main(int ac, char **av)
+int main(int ac, char **av, char **ep)
 {
 	int opt;
 	const char *name;
@@ -563,6 +563,11 @@ int main(int ac, char **av)
 		break;
 	}
 
+	for ( ; *ep;  ep++) {
+		if (!strncmp(*ep, CONFIG_, strlen(CONFIG_)))
+			conf_set_symbol_from_env(*ep);
+	}
+
 	if (sync_kconfig) {
 		if (conf_get_changed()) {
 			name = getenv("KCONFIG_NOSILENTUPDATE");
diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
index 61c35bf..e8ff902 100644
--- a/scripts/kconfig/confdata.c
+++ b/scripts/kconfig/confdata.c
@@ -338,6 +338,47 @@ setsym:
 	return 0;
 }
 
+void conf_set_symbol_from_env(char *str)
+{
+	char *p = strchr(str, '=');
+	struct symbol *sym;
+	int def = S_DEF_USER;
+	int def_flags = SYMBOL_DEF << def;
+
+	if (!p)
+		return;
+
+	*p = 0;
+	sym = sym_find(str + strlen(CONFIG_));
+	*p++ = '=';
+
+	if (!sym)
+		return;
+
+	if (!sym_set_string_value(sym, p))
+		return;
+	conf_message("CONFIG_%s set to %s from environment", sym->name, p);
+	if (sym && sym_is_choice_value(sym)) {
+		struct symbol *cs = prop_get_symbol(sym_get_choice_prop(sym));
+		switch (sym->def[def].tri) {
+		case no:
+			break;
+		case mod:
+			if (cs->def[def].tri == yes) {
+				conf_warning("%s creates inconsistent choice state", sym->name);
+				cs->flags &= ~def_flags;
+			}
+			break;
+		case yes:
+			if (cs->def[def].tri != no)
+				conf_warning("override: %s changes choice state", sym->name);
+			cs->def[def].val = sym;
+			break;
+		}
+		cs->def[def].tri = EXPR_OR(cs->def[def].tri, sym->def[def].tri);
+	}
+}
+
 int conf_read(const char *name)
 {
 	struct symbol *sym, *choice_sym;
diff --git a/scripts/kconfig/lkc.h b/scripts/kconfig/lkc.h
index febf0c9..bf6fade 100644
--- a/scripts/kconfig/lkc.h
+++ b/scripts/kconfig/lkc.h
@@ -91,6 +91,7 @@ char *conf_get_default_confname(void);
 void sym_set_change_count(int count);
 void sym_add_change_count(int count);
 void conf_set_all_new_symbols(enum conf_def_mode mode);
+void conf_set_symbol_from_env(char *);
 
 /* confdata.c and expr.c */
 static inline void xfwrite(const void *str, size_t len, size_t count, FILE *out)


-- 
dwmw2

