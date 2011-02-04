Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752832Ab1BDXQZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 18:16:25 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:33258 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752582Ab1BDXQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 18:16:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=dIQ2FRF9LhhURprCDEZ/Fq2907uQp76n0PQiJrmmOvke/3NbgGbtJyFaPnoSI1fhQa
         MB/VtZaHC5H6tGY9IZHZbEj/ojwwmm2RIXl81rhUgTArLdRLcGsLT48Uk69Yro1nfJi7
         /hPRpTpulgmNpNtqOUrQwm+RFoYUDMjdVEBBg=
Date: Sat, 5 Feb 2011 00:16:15 +0100
From: Ulf Magnusson <ulfalizer.lkml@gmail.com>
To: linux-kbuild@vger.kernel.org
Cc: zippel@linux-m68k.org, linux-kernel@vger.kernel.org
Subject: [PATCH] kconfig: undefined symbols can crash dependency loop
 detection
Message-ID: <20110204231611.GA9344@ulf>
Mail-Followup-To: Ulf Magnusson <ulfalizer.lkml@gmail.com>,
	linux-kbuild@vger.kernel.org, zippel@linux-m68k.org,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Kconfig

config FOO
	bool "FOO" if BAR
	select BAR

has a dependency loop involving an undefined symbol BAR. This causes a
segfault in sym_check_print_recursive() as it assumes all symbols have a
non-null 'prop', which is not the case for undefined symbols. This is a
proposed fix.

Signed-off-by: Ulf Magnusson <ulfalizer.lkml@gmail.com>
---
 scripts/kconfig/symbol.c |   32 ++++++++++++++++++++++++++++----
 1 files changed, 28 insertions(+), 4 deletions(-)

diff --git a/scripts/kconfig/symbol.c b/scripts/kconfig/symbol.c
index a796c95..81a217f 100644
--- a/scripts/kconfig/symbol.c
+++ b/scripts/kconfig/symbol.c
@@ -5,6 +5,7 @@
 
 #include <ctype.h>
 #include <stdlib.h>
+#include <stdio.h>
 #include <string.h>
 #include <regex.h>
 #include <sys/utsname.h>
@@ -972,6 +973,10 @@ static void sym_check_print_recursive(struct symbol *last_sym)
 	struct menu *menu = NULL;
 	struct property *prop;
 	struct dep_stack cv_stack;
+	const char *filename;
+	int lineno;
+	char undef_msg_buf[100];
+	int snprintf_size;
 
 	if (sym_is_choice_value(last_sym)) {
 		dep_stack_insert(&cv_stack, last_sym);
@@ -1001,18 +1006,37 @@ static void sym_check_print_recursive(struct symbol *last_sym)
 					break;
 			}
 		}
+
+		if (prop) {
+			filename = prop->file->name;
+			lineno = prop->lineno;
+		} else {
+			/* The dependency loop involves an undefined symbol.
+			 * Checking sym->name is probably unnecessary here, but
+			 * just to be on the safe side. */
+			snprintf_size = snprintf(undef_msg_buf,
+						 sizeof(undef_msg_buf),
+						 "<no file, %s is undefined>",
+						 sym->name ? sym->name :
+							     "<choice>");
+			if (snprintf_size > sizeof(undef_msg_buf))
+				undef_msg_buf[sizeof(undef_msg_buf) - 1] = '\0';
+			filename = undef_msg_buf;
+			lineno = 0;
+		}
+
 		if (stack->sym == last_sym)
 			fprintf(stderr, "%s:%d:error: recursive dependency detected!\n",
-				prop->file->name, prop->lineno);
+				filename, lineno);
 		if (stack->expr) {
 			fprintf(stderr, "%s:%d:\tsymbol %s %s value contains %s\n",
-				prop->file->name, prop->lineno,
+				filename, lineno,
 				sym->name ? sym->name : "<choice>",
 				prop_get_type_name(prop->type),
 				next_sym->name ? next_sym->name : "<choice>");
 		} else if (stack->prop) {
 			fprintf(stderr, "%s:%d:\tsymbol %s depends on %s\n",
-				prop->file->name, prop->lineno,
+				filename, lineno,
 				sym->name ? sym->name : "<choice>",
 				next_sym->name ? next_sym->name : "<choice>");
 		} else if (sym_is_choice(sym)) {
@@ -1027,7 +1051,7 @@ static void sym_check_print_recursive(struct symbol *last_sym)
 				next_sym->name ? next_sym->name : "<choice>");
 		} else {
 			fprintf(stderr, "%s:%d:\tsymbol %s is selected by %s\n",
-				prop->file->name, prop->lineno,
+				filename, lineno,
 				sym->name ? sym->name : "<choice>",
 				next_sym->name ? next_sym->name : "<choice>");
 		}
-- 
1.7.0.4

