Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965004Ab2DKXwH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 19:52:07 -0400
Received: from mail.windriver.com ([147.11.1.11]:39416 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934056Ab2DKXvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 19:51:54 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, davem@davemloft.net,
        tony@bakeyournoodle.com, mmarek@suse.cz, lacombar@gmail.com,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH 4/5] Revert "kconfig: fix __enabled_ macros definition for invisible and un-selected symbols"
Date: Wed, 11 Apr 2012 19:50:56 -0400
Message-Id: <1334188257-3449-5-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.1
In-Reply-To: <1334188257-3449-1-git-send-email-paul.gortmaker@windriver.com>
References: <1334188257-3449-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit 953742c8fe8ac45be453fee959d7be40cd89f920.

Dumping two lines into autoconf.h for all existing Kconfig
options results in a giant file (~16k lines) we have to process
each time.  Instead, lets work to just ensure things we care
about have definitions and we'll only have about 1k lines.

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 scripts/kconfig/confdata.c |   49 +++++++++++--------------------------------
 1 files changed, 13 insertions(+), 36 deletions(-)

diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
index 0586085..9d06744 100644
--- a/scripts/kconfig/confdata.c
+++ b/scripts/kconfig/confdata.c
@@ -489,6 +489,17 @@ header_print_symbol(FILE *fp, struct symbol *sym, const char *value, void *arg)
 			fprintf(fp, "#define %s%s%s 1\n",
 			    CONFIG_, sym->name, suffix);
 		}
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
@@ -540,35 +551,6 @@ static struct conf_printer header_printer_cb =
 };
 
 /*
- * Generate the __enabled_CONFIG_* and __enabled_CONFIG_*_MODULE macros for
- * use by the IS_{ENABLED,BUILTIN,MODULE} macros. The _MODULE variant is
- * generated even for booleans so that the IS_ENABLED() macro works.
- */
-static void
-header_print__enabled_symbol(FILE *fp, struct symbol *sym, const char *value, void *arg)
-{
-
-	switch (sym->type) {
-	case S_BOOLEAN:
-	case S_TRISTATE: {
-		fprintf(fp, "#define __enabled_" CONFIG_ "%s %d\n",
-		    sym->name, (*value == 'y'));
-		fprintf(fp, "#define __enabled_" CONFIG_ "%s_MODULE %d\n",
-		    sym->name, (*value == 'm'));
-		break;
-	}
-	default:
-		break;
-	}
-}
-
-static struct conf_printer header__enabled_printer_cb =
-{
-	.print_symbol = header_print__enabled_symbol,
-	.print_comment = header_print_comment,
-};
-
-/*
  * Tristate printer
  *
  * This printer is used when generating the `include/config/tristate.conf' file.
@@ -949,16 +931,11 @@ int conf_write_autoconf(void)
 	conf_write_heading(out_h, &header_printer_cb, NULL);
 
 	for_all_symbols(i, sym) {
-		if (!sym->name)
-			continue;
-
 		sym_calc_value(sym);
-
-		conf_write_symbol(out_h, sym, &header__enabled_printer_cb, NULL);
-
-		if (!(sym->flags & SYMBOL_WRITE))
+		if (!(sym->flags & SYMBOL_WRITE) || !sym->name)
 			continue;
 
+		/* write symbol to auto.conf, tristate and header files */
 		conf_write_symbol(out, sym, &kconfig_printer_cb, (void *)1);
 
 		conf_write_symbol(tristate, sym, &tristate_printer_cb, (void *)1);
-- 
1.7.9.1

