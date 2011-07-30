Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752347Ab1G3XNz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 19:13:55 -0400
Received: from casper.infradead.org ([85.118.1.10]:33616 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370Ab1G3XNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 19:13:49 -0400
Subject: [PATCH 1/2] kconfig: Factor out conf_validate_choice_val() function
 from conf_read_simple()
From: David Woodhouse <dwmw2@infradead.org>
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Date: Sun, 31 Jul 2011 00:13:45 +0100
In-Reply-To: <1312067499.22074.59.camel@i7.infradead.org>
References: <1312067499.22074.59.camel@i7.infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 (3.0.2-3.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1312067626.22074.60.camel@i7.infradead.org>
Mime-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We're going to want to do this from elsewhere, shortly...

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
---
 scripts/kconfig/confdata.c |   42 +++++++++++++++++++++++-------------------
 1 files changed, 23 insertions(+), 19 deletions(-)

diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
index 2bafd9a..a518ab3 100644
--- a/scripts/kconfig/confdata.c
+++ b/scripts/kconfig/confdata.c
@@ -179,6 +179,27 @@ static int conf_set_sym_val(struct symbol *sym, int def, int def_flags, char *p)
 	return 0;
 }
 
+static void conf_validate_choice_val(struct symbol *sym, int def, int def_flags)
+{
+	struct symbol *cs = prop_get_symbol(sym_get_choice_prop(sym));
+	switch (sym->def[def].tri) {
+	case no:
+		break;
+	case mod:
+		if (cs->def[def].tri == yes) {
+			conf_warning("%s creates inconsistent choice state", sym->name);
+			cs->flags &= ~def_flags;
+		}
+		break;
+	case yes:
+		if (cs->def[def].tri != no)
+			conf_warning("override: %s changes choice state", sym->name);
+		cs->def[def].val = sym;
+		break;
+	}
+	cs->def[def].tri = EXPR_OR(cs->def[def].tri, sym->def[def].tri);
+}
+
 int conf_read_simple(const char *name, int def)
 {
 	FILE *in = NULL;
@@ -311,25 +332,8 @@ load:
 			continue;
 		}
 setsym:
-		if (sym && sym_is_choice_value(sym)) {
-			struct symbol *cs = prop_get_symbol(sym_get_choice_prop(sym));
-			switch (sym->def[def].tri) {
-			case no:
-				break;
-			case mod:
-				if (cs->def[def].tri == yes) {
-					conf_warning("%s creates inconsistent choice state", sym->name);
-					cs->flags &= ~def_flags;
-				}
-				break;
-			case yes:
-				if (cs->def[def].tri != no)
-					conf_warning("override: %s changes choice state", sym->name);
-				cs->def[def].val = sym;
-				break;
-			}
-			cs->def[def].tri = EXPR_OR(cs->def[def].tri, sym->def[def].tri);
-		}
+		if (sym && sym_is_choice_value(sym))
+			conf_validate_choice_val(sym, def, def_flags);
 	}
 	fclose(in);
 
-- 
1.7.6



