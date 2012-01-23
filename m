Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623Ab2AWW30 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 17:29:26 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:47325 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754087Ab2AWW3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 17:29:24 -0500
From: Arnaud Lacombe <lacombar@gmail.com>
To: linux-kbuild@vger.kernel.org
Cc: Arnaud Lacombe <lacombar@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Michal Marek <mmarek@suse.cz>,
        Uwe Kleine-Konig <u.kleine-koenig@pengutronix.de>
Subject: [PATCH] kconfig: fix new choices being skipped upon config update
Date: Mon, 23 Jan 2012 17:29:05 -0500
Message-Id: <1327357745-9095-1-git-send-email-lacombar@gmail.com>
X-Mailer: git-send-email 1.7.9.rc1.23.g51649
In-Reply-To: <20120120164036.GO4066@pengutronix.de>
References: <20120120164036.GO4066@pengutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Running `oldconfig' after any of the following configuration change:

either trivial addition, such as:

config A
	bool "A"

choice
	prompt "Choice ?"
	depends on A

	config CHOICE_B
		bool "Choice B"

	config CHOICE_C
		bool "Choice C"
endchoice

or more tricky change:

OLD KCONFIG                      |  NEW KCONFIG
                                 |
                                 |  config A
                                 |          bool "A"
                                 |
choice                           |  choice
        prompt "Choice ?"        |          prompt "Choice ?"
                                 |
        config CHOICE_C          |          config CHOICE_C
                bool "Choice C"  |                  bool "Choice C"
                                 |
        config CHOICE_D          |          config CHOICE_D
                bool "Choice D"  |                  bool "Choice D"
endchoice                        |
                                 |          config CHOICE_E
                                 |                  bool "Choice E"
                                 |                  depends on A
                                 |  endchoice

will not cause the choice to be considered as NEW, and thus not be asked. The
cause of this behavior is that choice's novelty are computed statically right
after the saved configuration has been read. At this point, the new dependency's
value is still unknown and asserted to be `no'. Moreover, no update to this
decision is made afterward.

Correct this by dynamically evaluating a choice's novelty, and removing the
static evaluation.

Cc: linux-kbuild@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>,
Cc: Michal Marek <mmarek@suse.cz>
Cc: Uwe Kleine-Konig <u.kleine-koenig@pengutronix.de>
Reported-by: Uwe Kleine-Konig <u.kleine-koenig@pengutronix.de>
Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
---
 scripts/kconfig/confdata.c |   26 ++++++--------------------
 scripts/kconfig/symbol.c   |    9 ++++++++-
 2 files changed, 14 insertions(+), 21 deletions(-)

diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
index 5a58965..47aed3f 100644
--- a/scripts/kconfig/confdata.c
+++ b/scripts/kconfig/confdata.c
@@ -344,10 +344,8 @@ int conf_read_simple(const char *name, int def)
 
 int conf_read(const char *name)
 {
-	struct symbol *sym, *choice_sym;
-	struct property *prop;
-	struct expr *e;
-	int i, flags;
+	struct symbol *sym;
+	int i;
 
 	sym_set_change_count(0);
 
@@ -357,7 +355,7 @@ int conf_read(const char *name)
 	for_all_symbols(i, sym) {
 		sym_calc_value(sym);
 		if (sym_is_choice(sym) || (sym->flags & SYMBOL_AUTO))
-			goto sym_ok;
+			continue;
 		if (sym_has_value(sym) && (sym->flags & SYMBOL_WRITE)) {
 			/* check that calculated value agrees with saved value */
 			switch (sym->type) {
@@ -366,30 +364,18 @@ int conf_read(const char *name)
 				if (sym->def[S_DEF_USER].tri != sym_get_tristate_value(sym))
 					break;
 				if (!sym_is_choice(sym))
-					goto sym_ok;
+					continue;
 				/* fall through */
 			default:
 				if (!strcmp(sym->curr.val, sym->def[S_DEF_USER].val))
-					goto sym_ok;
+					continue;
 				break;
 			}
 		} else if (!sym_has_value(sym) && !(sym->flags & SYMBOL_WRITE))
 			/* no previous value and not saved */
-			goto sym_ok;
+			continue;
 		conf_unsaved++;
 		/* maybe print value in verbose mode... */
-	sym_ok:
-		if (!sym_is_choice(sym))
-			continue;
-		/* The choice symbol only has a set value (and thus is not new)
-		 * if all its visible childs have values.
-		 */
-		prop = sym_get_choice_prop(sym);
-		flags = sym->flags;
-		expr_list_for_each_sym(prop->expr, e, choice_sym)
-			if (choice_sym->visible != no)
-				flags &= choice_sym->flags;
-		sym->flags &= flags | ~SYMBOL_DEF_USER;
 	}
 
 	for_all_symbols(i, sym) {
diff --git a/scripts/kconfig/symbol.c b/scripts/kconfig/symbol.c
index 071f00c..22a3c40 100644
--- a/scripts/kconfig/symbol.c
+++ b/scripts/kconfig/symbol.c
@@ -262,11 +262,18 @@ static struct symbol *sym_calc_choice(struct symbol *sym)
 	struct symbol *def_sym;
 	struct property *prop;
 	struct expr *e;
+	int flags;
 
 	/* first calculate all choice values' visibilities */
+	flags = sym->flags;
 	prop = sym_get_choice_prop(sym);
-	expr_list_for_each_sym(prop->expr, e, def_sym)
+	expr_list_for_each_sym(prop->expr, e, def_sym) {
 		sym_calc_visibility(def_sym);
+		if (def_sym->visible != no)
+			flags &= def_sym->flags;
+	}
+
+	sym->flags &= flags | ~SYMBOL_DEF_USER;
 
 	/* is the user choice visible? */
 	def_sym = sym->def[S_DEF_USER].val;
-- 
1.7.9.rc1.23.g51649

