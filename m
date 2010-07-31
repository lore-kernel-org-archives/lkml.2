Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757112Ab0GaVhJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jul 2010 17:37:09 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:40619 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757103Ab0GaVfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jul 2010 17:35:38 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: Michal Marek <mmarek@suse.cz>, lkml <linux-kernel@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 7/9] kconfig: refactor code in symbol.c
Date: Sat, 31 Jul 2010 23:35:32 +0200
Message-Id: <1280612134-8220-7-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <20100731213429.GA8200@merkur.ravnborg.org>
References: <20100731213429.GA8200@merkur.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move logic to determine default for a choice to
a separate function.
No functional changes.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 scripts/kconfig/lkc.h    |    1 +
 scripts/kconfig/symbol.c |   46 +++++++++++++++++++++++++++++++++-------------
 2 files changed, 34 insertions(+), 13 deletions(-)

diff --git a/scripts/kconfig/lkc.h b/scripts/kconfig/lkc.h
index ce6549c..755b819 100644
--- a/scripts/kconfig/lkc.h
+++ b/scripts/kconfig/lkc.h
@@ -126,6 +126,7 @@ void sym_init(void);
 void sym_clear_all_valid(void);
 void sym_set_all_changed(void);
 void sym_set_changed(struct symbol *sym);
+struct symbol *sym_choice_default(struct symbol *sym);
 struct symbol *sym_check_deps(struct symbol *sym);
 struct property *prop_alloc(enum prop_type type, struct symbol *sym);
 struct symbol *prop_get_symbol(struct property *prop);
diff --git a/scripts/kconfig/symbol.c b/scripts/kconfig/symbol.c
index bc1e158..0a013ab 100644
--- a/scripts/kconfig/symbol.c
+++ b/scripts/kconfig/symbol.c
@@ -226,22 +226,18 @@ static void sym_calc_visibility(struct symbol *sym)
 	}
 }
 
-static struct symbol *sym_calc_choice(struct symbol *sym)
+/*
+ * Find the default symbol for a choice.
+ * First try the default values for the choice symbol
+ * Next locate the first visible choice value
+ * Return NULL if none was found
+ */
+struct symbol *sym_choice_default(struct symbol *sym)
 {
 	struct symbol *def_sym;
 	struct property *prop;
 	struct expr *e;
 
-	/* first calculate all choice values' visibilities */
-	prop = sym_get_choice_prop(sym);
-	expr_list_for_each_sym(prop->expr, e, def_sym)
-		sym_calc_visibility(def_sym);
-
-	/* is the user choice visible? */
-	def_sym = sym->def[S_DEF_USER].val;
-	if (def_sym && def_sym->visible != no)
-		return def_sym;
-
 	/* any of the defaults visible? */
 	for_all_defaults(sym, prop) {
 		prop->visible.tri = expr_calc_value(prop->visible.expr);
@@ -258,11 +254,35 @@ static struct symbol *sym_calc_choice(struct symbol *sym)
 		if (def_sym->visible != no)
 			return def_sym;
 
-	/* no choice? reset tristate value */
-	sym->curr.tri = no;
+	/* failed to locate any defaults */
 	return NULL;
 }
 
+static struct symbol *sym_calc_choice(struct symbol *sym)
+{
+	struct symbol *def_sym;
+	struct property *prop;
+	struct expr *e;
+
+	/* first calculate all choice values' visibilities */
+	prop = sym_get_choice_prop(sym);
+	expr_list_for_each_sym(prop->expr, e, def_sym)
+		sym_calc_visibility(def_sym);
+
+	/* is the user choice visible? */
+	def_sym = sym->def[S_DEF_USER].val;
+	if (def_sym && def_sym->visible != no)
+		return def_sym;
+
+	def_sym = sym_choice_default(sym);
+
+	if (def_sym == NULL)
+		/* no choice? reset tristate value */
+		sym->curr.tri = no;
+
+	return def_sym;
+}
+
 void sym_calc_value(struct symbol *sym)
 {
 	struct symbol_value newval, oldval;
-- 
1.6.0.6

