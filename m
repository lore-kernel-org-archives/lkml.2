Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758995Ab0HLHMA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 03:12:00 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:38591 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752298Ab0HLHLy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 03:11:54 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: Michal Marek <mmarek@suse.cz>, lkml <linux-kernel@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 2/2] kconfig: fix tristate choice with minimal config
Date: Thu, 12 Aug 2010 09:11:52 +0200
Message-Id: <1281597112-31019-2-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <20100812071023.GA11148@merkur.ravnborg.org>
References: <20100812071023.GA11148@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a minimal config did not specify the value
of all choice values, the resulting configuration
could have wrong values.

Consider following example:
config M
        def_bool y
        option modules
choice
        prompt "choice list"
config A
        tristate "a"
config B
	tristate "b"
endchoice

With a defconfig like this:
CONFIG_M=y
CONFIG_A=y

The resulting configuration would have

    CONFIG_A=m

which was unexpected.

The problem was not not all choice values were set and thus
kconfig calculated a wrong value.

The fix is to set all choice values when we
read a defconfig files.

conf_set_all_new_symbols() is refactored such that
random choice values are now handled by a dedicated function.
And new choice values are set by set_all_choice_values().

This was not the minimal fix, but the fix that resulted
in the most readable code.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Reported-by: Arve Hjønnevåg <arve@android.com>
Tested-by: Arve Hjønnevåg <arve@android.com>
---
 scripts/kconfig/confdata.c |  102 +++++++++++++++++++++++++++++---------------
 1 files changed, 67 insertions(+), 35 deletions(-)

diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
index e5d66e4..ac13f0f 100644
--- a/scripts/kconfig/confdata.c
+++ b/scripts/kconfig/confdata.c
@@ -918,13 +918,73 @@ void conf_set_changed_callback(void (*fn)(void))
 	conf_changed_callback = fn;
 }
 
+static void randomize_choice_values(struct symbol *csym)
+{
+	struct property *prop;
+	struct symbol *sym;
+	struct expr *e;
+	int cnt, def;
 
-void conf_set_all_new_symbols(enum conf_def_mode mode)
+	/*
+	 * If choice is mod then we may have more items slected
+	 * and if no then no-one.
+	 * In both cases stop.
+	 */
+	if (csym->curr.tri != yes)
+		return;
+
+	prop = sym_get_choice_prop(csym);
+
+	/* count entries in choice block */
+	cnt = 0;
+	expr_list_for_each_sym(prop->expr, e, sym)
+		cnt++;
+
+	/*
+	 * find a random value and set it to yes,
+	 * set the rest to no so we have only one set
+	 */
+	def = (rand() % cnt);
+
+	cnt = 0;
+	expr_list_for_each_sym(prop->expr, e, sym) {
+		if (def == cnt++) {
+			sym->def[S_DEF_USER].tri = yes;
+			csym->def[S_DEF_USER].val = sym;
+		}
+		else {
+			sym->def[S_DEF_USER].tri = no;
+		}
+	}
+	csym->flags |= SYMBOL_DEF_USER;
+	/* clear VALID to get value calculated */
+	csym->flags &= ~(SYMBOL_VALID);
+}
+
+static void set_all_choice_values(struct symbol *csym)
 {
-	struct symbol *sym, *csym;
 	struct property *prop;
+	struct symbol *sym;
 	struct expr *e;
-	int i, cnt, def;
+
+	prop = sym_get_choice_prop(csym);
+
+	/*
+	 * Set all non-assinged choice values to no
+	 */
+	expr_list_for_each_sym(prop->expr, e, sym) {
+		if (!sym_has_value(sym))
+			sym->def[S_DEF_USER].tri = no;
+	}
+	csym->flags |= SYMBOL_DEF_USER;
+	/* clear VALID to get value calculated */
+	csym->flags &= ~(SYMBOL_VALID);
+}
+
+void conf_set_all_new_symbols(enum conf_def_mode mode)
+{
+	struct symbol *sym, *csym;
+	int i, cnt;
 
 	for_all_symbols(i, sym) {
 		if (sym_has_value(sym))
@@ -960,8 +1020,6 @@ void conf_set_all_new_symbols(enum conf_def_mode mode)
 
 	sym_clear_all_valid();
 
-	if (mode != def_random)
-		return;
 	/*
 	 * We have different type of choice blocks.
 	 * If curr.tri equal to mod then we can select several
@@ -976,35 +1034,9 @@ void conf_set_all_new_symbols(enum conf_def_mode mode)
 			continue;
 
 		sym_calc_value(csym);
-
-		if (csym->curr.tri != yes)
-			continue;
-
-		prop = sym_get_choice_prop(csym);
-
-		/* count entries in choice block */
-		cnt = 0;
-		expr_list_for_each_sym(prop->expr, e, sym)
-			cnt++;
-
-		/*
-		 * find a random value and set it to yes,
-		 * set the rest to no so we have only one set
-		 */
-		def = (rand() % cnt);
-
-		cnt = 0;
-		expr_list_for_each_sym(prop->expr, e, sym) {
-			if (def == cnt++) {
-				sym->def[S_DEF_USER].tri = yes;
-				csym->def[S_DEF_USER].val = sym;
-			}
-			else {
-				sym->def[S_DEF_USER].tri = no;
-			}
-		}
-		csym->flags |= SYMBOL_DEF_USER;
-		/* clear VALID to get value calculated */
-		csym->flags &= ~(SYMBOL_VALID);
+		if (mode == def_random)
+			randomize_choice_values(csym);
+		else
+			set_all_choice_values(csym);
 	}
 }
-- 
1.6.0.6

