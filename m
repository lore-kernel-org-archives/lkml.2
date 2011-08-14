Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754167Ab1HNRCk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 13:02:40 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:57874 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753651Ab1HNRCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 13:02:34 -0400
From: Arnaud Lacombe <lacombar@gmail.com>
To: Rabin Vincent <rabin@rab.in>
Cc: Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, Arnaud Lacombe <lacombar@gmail.com>
Subject: Re: IS_ENABLED() and non-available symbols
Date: Sun, 14 Aug 2011 13:02:26 -0400
Message-Id: <1313341346-15605-1-git-send-email-lacombar@gmail.com>
X-Mailer: git-send-email 1.7.6.153.g78432
In-Reply-To: <CACqU3MU2pjcqgYDjn=S2asdLamU0mity+kLizH_mbTtJU5Fh2A@mail.gmail.com>
References: <CACqU3MU2pjcqgYDjn=S2asdLamU0mity+kLizH_mbTtJU5Fh2A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, Aug 14, 2011 at 12:55 PM, Arnaud Lacombe <lacombar@gmail.com> wrote:
> The solution is trivial, but I am not sure we want to go that way: we
> need to generated a __enabled_ entry for symbols for _all_ symbols in
> the configuration, even internal one
>
That should do the job...

 -= NOT FOR MERGE =-

Not-Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>

---
 scripts/kconfig/confdata.c |   42 +++++++++++++++++++++++++++++++-----------
 1 files changed, 31 insertions(+), 11 deletions(-)

diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
index 59b667c..e976ccb 100644
--- a/scripts/kconfig/confdata.c
+++ b/scripts/kconfig/confdata.c
@@ -503,17 +503,6 @@ header_print_symbol(FILE *fp, struct symbol *sym, const char *value, void *arg)
 			fprintf(fp, "#define %s%s%s 1\n",
 			    CONFIG_, sym->name, suffix);
 		}
-		/*
-		 * Generate the __enabled_CONFIG_* and
-		 * __enabled_CONFIG_*_MODULE macros for use by the
-		 * IS_{ENABLED,BUILTIN,MODULE} macros. The _MODULE variant is
-		 * generated even for booleans so that the IS_ENABLED() macro
-		 * works.
-		 */
-		fprintf(fp, "#define __enabled_" CONFIG_ "%s %d\n",
-				sym->name, (*value == 'y'));
-		fprintf(fp, "#define __enabled_" CONFIG_ "%s_MODULE %d\n",
-				sym->name, (*value == 'm'));
 		break;
 	}
 	case S_HEX: {
@@ -565,6 +554,35 @@ static struct conf_printer header_printer_cb =
 };
 
 /*
+ * Generate the __enabled_CONFIG_* and __enabled_CONFIG_*_MODULE macros for
+ * use by the IS_{ENABLED,BUILTIN,MODULE} macros. The _MODULE variant is
+ * generated even for booleans so that the IS_ENABLED() macro works.
+ */
+static void
+header_print__enabled_symbol(FILE *fp, struct symbol *sym, const char *value, void *arg)
+{
+
+	switch (sym->type) {
+	case S_BOOLEAN:
+	case S_TRISTATE: {
+		fprintf(fp, "#define __enabled_" CONFIG_ "%s %d\n",
+		    sym->name, (*value == 'y'));
+		fprintf(fp, "#define __enabled_" CONFIG_ "%s_MODULE %d\n",
+		    sym->name, (*value == 'm'));
+		break;
+	}
+	default:
+		break;
+	}
+}
+
+static struct conf_printer header__enabled_printer_cb =
+{
+	.print_symbol = header_print__enabled_symbol,
+	.print_comment = header_print_comment,
+};
+
+/*
  * Tristate printer
  *
  * This printer is used when generating the `include/config/tristate.conf' file.
@@ -945,6 +963,8 @@ int conf_write_autoconf(void)
 	conf_write_heading(out_h, &header_printer_cb, NULL);
 
 	for_all_symbols(i, sym) {
+		conf_write_symbol(out_h, sym, &header__enabled_printer_cb, NULL);
+
 		sym_calc_value(sym);
 		if (!(sym->flags & SYMBOL_WRITE) || !sym->name)
 			continue;
-- 
1.7.6.153.g78432

