Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964969Ab0GSShp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 14:37:45 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:60964 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936512Ab0GSShQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 14:37:16 -0400
Date: Tue, 20 Jul 2010 04:37:06 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Michal Marek <mmarek@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>, linux-kbuild@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus <torvalds@linux-foundation.org>, Sam Ravnborg <sam@ravnborg.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Roman Zippel <zippel@linux-m68k.org>,
        Francis Galiegue <fgaliegue@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Andi Kleen <ak@linux.intel.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Nir Tzachar <nir.tzachar@gmail.com>,
        Vadim Bendebury <vbendeb@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
        Cheng Renquan <crquan@gmail.com>, Trevor Keith <tsrk@tsrk.net>,
        Josh Triplett <josh@joshtriplett.org>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: [RFC][PATCH] kconfig: implement select with values
Message-Id: <20100720043706.3813715a.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a fairly brute force approach to allowing a Kconfig "select"
to specify an excplicit value for the selected config sybmol.

The syntax of select is changed to:

	"select" <symbol> [<expr>] ["if" expr]

The approach taken is to add a list of <value, dependency expression>
pairs to the symbol and check them whenever the reverse depends (from
a current-style select) are checked.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 Documentation/kbuild/kconfig-language.txt |    7 +-
 scripts/kconfig/expr.h                    |    9 +
 scripts/kconfig/lkc.h                     |    1 +
 scripts/kconfig/menu.c                    |   70 +++++-
 scripts/kconfig/symbol.c                  |   88 +++++++-
 scripts/kconfig/zconf.tab.c_shipped       |  352 +++++++++++++++--------------
 scripts/kconfig/zconf.y                   |   17 ++-
 7 files changed, 356 insertions(+), 188 deletions(-)

This is a work in progress, though it is possible to set values.  I have
not done a great deal of testing.

I would like comments on the approach (and the actual code as the kconfig
code is pretty dense :-)).

This is built on top of the kbuild tree that is in linux-next
(git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild-2.6.git#for-next)
merged with Linus' tree of a few days ago (commit
2f7989efd4398d92b8adffce2e07dd043a0895fe "Merge
master.kernel.org:/home/rmk/linux-2.6-arm").

diff --git a/Documentation/kbuild/kconfig-language.txt b/Documentation/kbuild/kconfig-language.txt
index b472e4e..b1fb180 100644
--- a/Documentation/kbuild/kconfig-language.txt
+++ b/Documentation/kbuild/kconfig-language.txt
@@ -95,14 +95,15 @@ applicable everywhere (see syntax).
 	bool "foo"
 	default y
 
-- reverse dependencies: "select" <symbol> ["if" <expr>]
+- reverse dependencies: "select" <symbol> [<expr>] ["if" <expr>]
   While normal dependencies reduce the upper limit of a symbol (see
   below), reverse dependencies can be used to force a lower limit of
   another symbol. The value of the current menu symbol is used as the
   minimal value <symbol> can be set to. If <symbol> is selected multiple
   times, the limit is set to the largest selection.
-  Reverse dependencies can only be used with boolean or tristate
-  symbols.
+  Reverse dependencies without the optional <expr> can only be used with
+  boolean or tristate symbols. If the optional <expr> is supplied,
+  the <symbol> will be set to that value if possible.
   Note:
 	select should be used with care. select will force
 	a symbol to a value without visiting the dependencies.
diff --git a/scripts/kconfig/expr.h b/scripts/kconfig/expr.h
index 75a31e4..7217c6d 100644
--- a/scripts/kconfig/expr.h
+++ b/scripts/kconfig/expr.h
@@ -56,6 +56,13 @@ struct expr_value {
 	tristate tri;
 };
 
+struct expr_select_value {
+	struct expr *expr;
+	tristate tri;
+	struct expr *value;
+	struct expr_select_value *next;
+};
+
 struct symbol_value {
 	void *val;
 	tristate tri;
@@ -85,6 +92,7 @@ struct symbol {
 	struct property *prop;
 	struct expr_value dir_dep;
 	struct expr_value rev_dep;
+	struct expr_select_value *val_dep;
 };
 
 #define for_all_symbols(i, sym) for (i = 0; i < SYMBOL_HASHSIZE; i++) for (sym = symbol_hash[i]; sym; sym = sym->next) if (sym->type != S_OTHER)
@@ -146,6 +154,7 @@ struct property {
 	                            * P_PROMPT, P_DEFAULT, P_MENU, P_COMMENT */
 	struct file *file;         /* what file was this property defined */
 	int lineno;                /* what lineno was this property defined */
+	struct expr *value;	   /* the optional P_SELECT value */
 };
 
 #define for_all_properties(sym, st, tok) \
diff --git a/scripts/kconfig/lkc.h b/scripts/kconfig/lkc.h
index ce6549c..5176657 100644
--- a/scripts/kconfig/lkc.h
+++ b/scripts/kconfig/lkc.h
@@ -95,6 +95,7 @@ struct property *menu_add_prop(enum prop_type type, char *prompt, struct expr *e
 struct property *menu_add_prompt(enum prop_type type, char *prompt, struct expr *dep);
 void menu_add_expr(enum prop_type type, struct expr *expr, struct expr *dep);
 void menu_add_symbol(enum prop_type type, struct symbol *sym, struct expr *dep);
+void menu_add_select(struct symbol *sym, struct expr *value, struct expr *dep);
 void menu_add_option(int token, char *arg);
 void menu_finalize(struct menu *parent);
 void menu_set_type(int type);
diff --git a/scripts/kconfig/menu.c b/scripts/kconfig/menu.c
index 1179989..f1211f3 100644
--- a/scripts/kconfig/menu.c
+++ b/scripts/kconfig/menu.c
@@ -161,6 +161,14 @@ void menu_add_symbol(enum prop_type type, struct symbol *sym, struct expr *dep)
 	menu_add_prop(type, NULL, expr_alloc_symbol(sym), dep);
 }
 
+void menu_add_select(struct symbol *sym, struct expr *value, struct expr *dep)
+{
+	struct property *p;
+
+	p = menu_add_prop(P_SELECT, NULL, expr_alloc_symbol(sym), dep);
+	p->value = value;
+}
+
 void menu_add_option(int token, char *arg)
 {
 	struct property *prop;
@@ -207,13 +215,22 @@ static void sym_check_prop(struct symbol *sym)
 				prop_warn(prop,
 				    "config symbol '%s' uses select, but is "
 				    "not boolean or tristate", sym->name);
-			else if (sym2->type != S_UNKNOWN &&
+			else if (prop->value == NULL &&
+				 sym2->type != S_UNKNOWN &&
 			         sym2->type != S_BOOLEAN &&
 			         sym2->type != S_TRISTATE)
 				prop_warn(prop,
-				    "'%s' has wrong type. 'select' only "
-				    "accept arguments of boolean and "
-				    "tristate type", sym2->name);
+				    "'%s' has wrong type. 'select' without a "
+				    "value only accepts arguments of boolean "
+				    "and tristate type", sym2->name);
+			else if (prop->value != NULL &&
+				 (sym2->type == S_INT ||
+				  sym2->type == S_HEX ||
+				  sym2->type == S_STRING) &&
+				 prop->value->type != E_SYMBOL)
+				prop_warn(prop,
+				    "select value for config symbol '%s'"
+				    " must be a single symbol", sym2->name);
 			break;
 		case P_RANGE:
 			if (sym->type != S_INT && sym->type != S_HEX)
@@ -229,6 +246,25 @@ static void sym_check_prop(struct symbol *sym)
 	}
 }
 
+static void finalize_select(struct symbol *sym, struct property *prop,
+		struct expr *dep)
+{
+	struct symbol *es = prop_get_symbol(prop);
+	struct expr_select_value *esv;
+
+	if (prop->value) {
+		esv = malloc(sizeof *esv);
+		esv->expr = expr_alloc_and(expr_alloc_symbol(sym),
+				expr_copy(dep));
+		esv->value = prop->value;
+		esv->next = es->val_dep;
+		es->val_dep = esv;
+	} else {
+		es->rev_dep.expr = expr_alloc_or(es->rev_dep.expr,
+			expr_alloc_and(expr_alloc_symbol(sym), expr_copy(dep)));
+	}
+}
+
 void menu_finalize(struct menu *parent)
 {
 	struct menu *menu, *last_menu;
@@ -279,11 +315,8 @@ void menu_finalize(struct menu *parent)
 				if (menu->sym && menu->sym->type != S_TRISTATE)
 					dep = expr_trans_bool(dep);
 				prop->visible.expr = dep;
-				if (prop->type == P_SELECT) {
-					struct symbol *es = prop_get_symbol(prop);
-					es->rev_dep.expr = expr_alloc_or(es->rev_dep.expr,
-							expr_alloc_and(expr_alloc_symbol(menu->sym), expr_copy(dep)));
-				}
+				if (prop->type == P_SELECT)
+					finalize_select(menu->sym, prop, dep);
 			}
 		}
 		for (menu = parent->list; menu; menu = menu->next)
@@ -389,9 +422,15 @@ void menu_finalize(struct menu *parent)
 	}
 
 	if (sym && !sym_is_optional(sym) && parent->prompt) {
+		struct expr_select_value *esv;
+
 		sym->rev_dep.expr = expr_alloc_or(sym->rev_dep.expr,
 				expr_alloc_and(parent->prompt->visible.expr,
 					expr_alloc_symbol(&symbol_mod)));
+		for (esv = sym->val_dep; esv; esv = esv->next)
+			esv->expr = expr_alloc_or(esv->expr,
+				expr_alloc_and(parent->prompt->visible.expr,
+					expr_alloc_symbol(&symbol_mod)));
 	}
 }
 
@@ -509,6 +548,7 @@ void get_symbol_str(struct gstr *r, struct symbol *sym)
 {
 	bool hit;
 	struct property *prop;
+	struct expr_select_value *esv;
 
 	if (sym && sym->name) {
 		str_printf(r, "Symbol: %s [=%s]\n", sym->name,
@@ -533,6 +573,11 @@ void get_symbol_str(struct gstr *r, struct symbol *sym)
 		} else
 			str_printf(r, " && ");
 		expr_gstr_print(prop->expr, r);
+		if (prop->value) {
+			str_printf(r, " (value=");
+			expr_gstr_print(prop->value, r);
+			str_printf(r, ")");
+		}
 	}
 	if (hit)
 		str_append(r, "\n");
@@ -541,6 +586,13 @@ void get_symbol_str(struct gstr *r, struct symbol *sym)
 		expr_gstr_print(sym->rev_dep.expr, r);
 		str_append(r, "\n");
 	}
+	for (esv = sym->val_dep; esv; esv = esv->next) {
+		str_append(r, "  Selected by: ");
+		expr_gstr_print(esv->expr, r);
+		str_append(r, " with value: ");
+		expr_gstr_print(esv->value, r);
+		str_append(r, "\n");
+	}
 	str_append(r, "\n\n");
 }
 
diff --git a/scripts/kconfig/symbol.c b/scripts/kconfig/symbol.c
index c127fa3..8fbfc15 100644
--- a/scripts/kconfig/symbol.c
+++ b/scripts/kconfig/symbol.c
@@ -190,6 +190,7 @@ static void sym_calc_visibility(struct symbol *sym)
 {
 	struct property *prop;
 	tristate tri;
+	struct expr_select_value *esv;
 
 	/* any prompt visible? */
 	tri = no;
@@ -224,6 +225,15 @@ static void sym_calc_visibility(struct symbol *sym)
 		sym->rev_dep.tri = tri;
 		sym_set_changed(sym);
 	}
+	for (esv = sym->val_dep; esv; esv = esv->next) {
+		tri = expr_calc_value(esv->expr);
+		if (tri == mod && sym_get_type(sym) == S_BOOLEAN)
+			tri = yes;
+		if (esv->tri != tri) {
+			esv->tri = tri;
+			sym_set_changed(sym);
+		}
+	}
 }
 
 static struct symbol *sym_calc_choice(struct symbol *sym)
@@ -268,6 +278,8 @@ void sym_calc_value(struct symbol *sym)
 	struct symbol_value newval, oldval;
 	struct property *prop;
 	struct expr *e;
+	struct expr_select_value *esv;
+	int got_sel_val;
 
 	if (!sym)
 		return;
@@ -321,6 +333,9 @@ void sym_calc_value(struct symbol *sym)
 			}
 			if (sym->rev_dep.tri != no)
 				sym->flags |= SYMBOL_WRITE;
+			for (esv = sym->val_dep; esv; esv = esv->next)
+				if (esv->tri != no)
+					sym->flags |= SYMBOL_WRITE;
 			if (!sym_is_choice(sym)) {
 				prop = sym_get_default_prop(sym);
 				if (prop) {
@@ -330,15 +345,34 @@ void sym_calc_value(struct symbol *sym)
 				}
 			}
 		calc_newval:
-			if (sym->dir_dep.tri == no && sym->rev_dep.tri != no) {
-				fprintf(stderr, "warning: (");
-				expr_fprint(sym->rev_dep.expr, stderr);
-				fprintf(stderr, ") selects %s which has unmet direct dependencies (",
-					sym->name);
-				expr_fprint(sym->dir_dep.expr, stderr);
-				fprintf(stderr, ")\n");
+			if (sym->dir_dep.tri == no) {
+				if (sym->rev_dep.tri != no) {
+					fprintf(stderr, "warning: (");
+					expr_fprint(sym->rev_dep.expr, stderr);
+					fprintf(stderr, ") selects %s which has unmet direct dependencies (",
+						sym->name);
+					expr_fprint(sym->dir_dep.expr, stderr);
+					fprintf(stderr, ")\n");
+				}
+				for (esv = sym->val_dep; esv; esv = esv->next) {
+					if ((esv->tri != no) &&
+					    (expr_calc_value(esv->value) != no)) {
+						fprintf(stderr, "warning: (");
+						expr_fprint(esv->expr, stderr);
+						fprintf(stderr, ") selects %s (with value ",
+							sym->name);
+						expr_fprint(esv->value, stderr);
+						fprintf(stderr, ") which has unmet direct dependencies (");
+						expr_fprint(sym->dir_dep.expr, stderr);
+						fprintf(stderr, ")\n");
+					}
+				}
 			}
 			newval.tri = EXPR_OR(newval.tri, sym->rev_dep.tri);
+			for (esv = sym->val_dep; esv; esv = esv->next)
+				if (esv->tri != no)
+					newval.tri = EXPR_OR(newval.tri,
+						expr_calc_value(esv->value));
 		}
 		if (newval.tri == mod && sym_get_type(sym) == S_BOOLEAN)
 			newval.tri = yes;
@@ -353,6 +387,23 @@ void sym_calc_value(struct symbol *sym)
 				break;
 			}
 		}
+		got_sel_val = 0;
+		for (esv = sym->val_dep; esv; esv = esv->next) {
+			if (esv->tri != no) {
+				struct symbol *ss = esv->value->left.sym;
+
+				if (got_sel_val) {
+					/* warn of more than one value selected */
+				} else {
+					sym->flags |= SYMBOL_WRITE;
+					sym_calc_value(ss);
+					newval.val = ss->curr.val;
+					got_sel_val = 1;
+				}
+			}
+		}
+		if (got_sel_val)
+			break;
 		prop = sym_get_default_prop(sym);
 		if (prop) {
 			struct symbol *ds = prop_get_symbol(prop);
@@ -432,6 +483,8 @@ void sym_set_all_changed(void)
 bool sym_tristate_within_range(struct symbol *sym, tristate val)
 {
 	int type = sym_get_type(sym);
+	struct expr_select_value *esv;
+	tristate tri;
 
 	if (sym->visible == no)
 		return false;
@@ -441,11 +494,14 @@ bool sym_tristate_within_range(struct symbol *sym, tristate val)
 
 	if (type == S_BOOLEAN && val == mod)
 		return false;
-	if (sym->visible <= sym->rev_dep.tri)
+	tri = sym->rev_dep.tri;
+	for (esv = sym->val_dep; esv; esv = esv->next)
+		tri = EXPR_OR(tri, esv->tri);
+	if (sym->visible <= tri)
 		return false;
 	if (sym_is_choice_value(sym) && sym->visible == yes)
 		return val == yes;
-	return val >= sym->rev_dep.tri && val <= sym->visible;
+	return val >= tri && val <= sym->visible;
 }
 
 bool sym_set_tristate_value(struct symbol *sym, tristate val)
@@ -666,7 +722,13 @@ const char *sym_get_string_value(struct symbol *sym)
 
 bool sym_is_changable(struct symbol *sym)
 {
-	return sym->visible > sym->rev_dep.tri;
+	tristate tri = sym->rev_dep.tri;
+	struct expr_select_value *esv;
+
+	for (esv = sym->val_dep; esv; esv = esv->next)
+		tri = EXPR_OR(tri, esv->tri);
+
+	return sym->visible > tri;
 }
 
 static unsigned strhash(const char *s)
@@ -819,10 +881,16 @@ static struct symbol *sym_check_sym_deps(struct symbol *sym)
 {
 	struct symbol *sym2;
 	struct property *prop;
+	struct expr_select_value *esv;
 
 	sym2 = sym_check_expr_deps(sym->rev_dep.expr);
 	if (sym2)
 		return sym2;
+	for (esv = sym->val_dep; esv; esv = esv->next) {
+		sym2 = sym_check_expr_deps(esv->expr);
+		if (sym2)
+			return sym2;
+	}
 
 	for (prop = sym->prop; prop; prop = prop->next) {
 		if (prop->type == P_CHOICE || prop->type == P_SELECT)
diff --git a/scripts/kconfig/zconf.tab.c_shipped b/scripts/kconfig/zconf.tab.c_shipped
index 32a9eef..307bf23 100644
--- a/scripts/kconfig/zconf.tab.c_shipped
+++ b/scripts/kconfig/zconf.tab.c_shipped
@@ -419,16 +419,16 @@ union yyalloc
 /* YYFINAL -- State number of the termination state.  */
 #define YYFINAL  3
 /* YYLAST -- Last index in YYTABLE.  */
-#define YYLAST   259
+#define YYLAST   268
 
 /* YYNTOKENS -- Number of terminals.  */
 #define YYNTOKENS  35
 /* YYNNTS -- Number of nonterminals.  */
 #define YYNNTS  46
 /* YYNRULES -- Number of rules.  */
-#define YYNRULES  110
+#define YYNRULES  111
 /* YYNRULES -- Number of states.  */
-#define YYNSTATES  180
+#define YYNSTATES  183
 
 /* YYTRANSLATE(YYLEX) -- Bison symbol number corresponding to YYLEX.  */
 #define YYUNDEFTOK  2
@@ -480,14 +480,14 @@ static const yytype_uint16 yyprhs[] =
       28,    33,    37,    39,    41,    43,    45,    47,    49,    51,
       53,    55,    57,    59,    61,    63,    67,    70,    74,    77,
       81,    84,    85,    88,    91,    94,    97,   100,   103,   107,
-     112,   117,   122,   128,   132,   133,   137,   138,   141,   145,
-     148,   150,   154,   155,   158,   161,   164,   167,   170,   175,
-     179,   182,   187,   188,   191,   195,   197,   201,   202,   205,
-     208,   211,   215,   218,   220,   224,   225,   228,   231,   234,
-     238,   242,   245,   248,   251,   252,   255,   258,   261,   266,
-     267,   270,   272,   274,   277,   280,   283,   285,   288,   289,
-     292,   294,   298,   302,   306,   309,   313,   317,   319,   321,
-     322
+     112,   117,   122,   128,   134,   138,   139,   143,   144,   147,
+     151,   154,   156,   160,   161,   164,   167,   170,   173,   176,
+     181,   185,   188,   193,   194,   197,   201,   203,   207,   208,
+     211,   214,   217,   221,   224,   226,   230,   231,   234,   237,
+     240,   244,   248,   251,   254,   257,   258,   261,   264,   267,
+     272,   273,   276,   278,   280,   283,   286,   289,   291,   294,
+     295,   298,   300,   304,   308,   312,   315,   319,   323,   325,
+     327,   328
 };
 
 /* YYRHS -- A `-1'-separated list of the rules' RHS.  */
@@ -505,27 +505,27 @@ static const yytype_int8 yyrhs[] =
       -1,    45,    72,    -1,    45,    70,    -1,    45,    40,    -1,
       45,    30,    -1,    19,    73,    30,    -1,    18,    74,    77,
       30,    -1,    20,    78,    77,    30,    -1,    21,    25,    77,
-      30,    -1,    22,    79,    79,    77,    30,    -1,    23,    48,
-      30,    -1,    -1,    48,    25,    49,    -1,    -1,    33,    74,
-      -1,     7,    80,    30,    -1,    50,    54,    -1,    75,    -1,
-      51,    56,    52,    -1,    -1,    54,    55,    -1,    54,    72,
-      -1,    54,    70,    -1,    54,    30,    -1,    54,    40,    -1,
-      18,    74,    77,    30,    -1,    19,    73,    30,    -1,    17,
-      30,    -1,    20,    25,    77,    30,    -1,    -1,    56,    39,
-      -1,    14,    78,    76,    -1,    75,    -1,    57,    60,    58,
-      -1,    -1,    60,    39,    -1,    60,    64,    -1,    60,    53,
-      -1,     4,    74,    30,    -1,    61,    71,    -1,    75,    -1,
-      62,    65,    63,    -1,    -1,    65,    39,    -1,    65,    64,
-      -1,    65,    53,    -1,     6,    74,    30,    -1,     9,    74,
-      30,    -1,    67,    71,    -1,    12,    30,    -1,    69,    13,
-      -1,    -1,    71,    72,    -1,    71,    30,    -1,    71,    40,
-      -1,    16,    24,    78,    30,    -1,    -1,    74,    77,    -1,
-      25,    -1,    26,    -1,     5,    30,    -1,     8,    30,    -1,
-      15,    30,    -1,    30,    -1,    76,    30,    -1,    -1,    14,
-      78,    -1,    79,    -1,    79,    33,    79,    -1,    79,    27,
-      79,    -1,    29,    78,    28,    -1,    34,    78,    -1,    78,
-      31,    78,    -1,    78,    32,    78,    -1,    25,    -1,    26,
-      -1,    -1,    25,    -1
+      30,    -1,    21,    25,    78,    77,    30,    -1,    22,    79,
+      79,    77,    30,    -1,    23,    48,    30,    -1,    -1,    48,
+      25,    49,    -1,    -1,    33,    74,    -1,     7,    80,    30,
+      -1,    50,    54,    -1,    75,    -1,    51,    56,    52,    -1,
+      -1,    54,    55,    -1,    54,    72,    -1,    54,    70,    -1,
+      54,    30,    -1,    54,    40,    -1,    18,    74,    77,    30,
+      -1,    19,    73,    30,    -1,    17,    30,    -1,    20,    25,
+      77,    30,    -1,    -1,    56,    39,    -1,    14,    78,    76,
+      -1,    75,    -1,    57,    60,    58,    -1,    -1,    60,    39,
+      -1,    60,    64,    -1,    60,    53,    -1,     4,    74,    30,
+      -1,    61,    71,    -1,    75,    -1,    62,    65,    63,    -1,
+      -1,    65,    39,    -1,    65,    64,    -1,    65,    53,    -1,
+       6,    74,    30,    -1,     9,    74,    30,    -1,    67,    71,
+      -1,    12,    30,    -1,    69,    13,    -1,    -1,    71,    72,
+      -1,    71,    30,    -1,    71,    40,    -1,    16,    24,    78,
+      30,    -1,    -1,    74,    77,    -1,    25,    -1,    26,    -1,
+       5,    30,    -1,     8,    30,    -1,    15,    30,    -1,    30,
+      -1,    76,    30,    -1,    -1,    14,    78,    -1,    79,    -1,
+      79,    33,    79,    -1,    79,    27,    79,    -1,    29,    78,
+      28,    -1,    34,    78,    -1,    78,    31,    78,    -1,    78,
+      32,    78,    -1,    25,    -1,    26,    -1,    -1,    25,    -1
 };
 
 /* YYRLINE[YYN] -- source line where rule number YYN was defined.  */
@@ -535,14 +535,14 @@ static const yytype_uint16 yyrline[] =
      117,   121,   125,   125,   125,   125,   125,   125,   125,   129,
      130,   131,   132,   133,   134,   138,   139,   145,   153,   159,
      167,   177,   179,   180,   181,   182,   183,   184,   187,   195,
-     201,   211,   217,   223,   226,   228,   239,   240,   245,   254,
-     259,   267,   270,   272,   273,   274,   275,   276,   279,   285,
-     296,   302,   312,   314,   319,   327,   335,   338,   340,   341,
-     342,   347,   354,   359,   367,   370,   372,   373,   374,   377,
-     385,   392,   399,   405,   412,   414,   415,   416,   419,   427,
-     429,   434,   435,   438,   439,   440,   444,   445,   448,   449,
-     452,   453,   454,   455,   456,   457,   458,   461,   462,   465,
-     466
+     201,   211,   217,   223,   229,   232,   234,   245,   246,   251,
+     260,   265,   273,   276,   278,   279,   280,   281,   282,   285,
+     291,   302,   308,   318,   320,   325,   333,   341,   344,   346,
+     347,   348,   353,   360,   365,   373,   376,   378,   379,   380,
+     383,   391,   398,   405,   411,   418,   420,   421,   422,   425,
+     433,   435,   440,   441,   444,   445,   446,   450,   451,   454,
+     455,   458,   459,   460,   461,   462,   463,   464,   467,   468,
+     471,   472
 };
 #endif
 
@@ -590,14 +590,14 @@ static const yytype_uint8 yyr1[] =
       37,    37,    38,    38,    38,    38,    38,    38,    38,    39,
       39,    39,    39,    39,    39,    40,    40,    41,    42,    43,
       44,    45,    45,    45,    45,    45,    45,    45,    46,    46,
-      46,    46,    46,    47,    48,    48,    49,    49,    50,    51,
-      52,    53,    54,    54,    54,    54,    54,    54,    55,    55,
-      55,    55,    56,    56,    57,    58,    59,    60,    60,    60,
-      60,    61,    62,    63,    64,    65,    65,    65,    65,    66,
-      67,    68,    69,    70,    71,    71,    71,    71,    72,    73,
-      73,    74,    74,    75,    75,    75,    76,    76,    77,    77,
-      78,    78,    78,    78,    78,    78,    78,    79,    79,    80,
-      80
+      46,    46,    46,    46,    47,    48,    48,    49,    49,    50,
+      51,    52,    53,    54,    54,    54,    54,    54,    54,    55,
+      55,    55,    55,    56,    56,    57,    58,    59,    60,    60,
+      60,    60,    61,    62,    63,    64,    65,    65,    65,    65,
+      66,    67,    68,    69,    70,    71,    71,    71,    71,    72,
+      73,    73,    74,    74,    75,    75,    75,    76,    76,    77,
+      77,    78,    78,    78,    78,    78,    78,    78,    79,    79,
+      80,    80
 };
 
 /* YYR2[YYN] -- Number of symbols composing right hand side of rule YYN.  */
@@ -607,14 +607,14 @@ static const yytype_uint8 yyr2[] =
        4,     3,     1,     1,     1,     1,     1,     1,     1,     1,
        1,     1,     1,     1,     1,     3,     2,     3,     2,     3,
        2,     0,     2,     2,     2,     2,     2,     2,     3,     4,
-       4,     4,     5,     3,     0,     3,     0,     2,     3,     2,
-       1,     3,     0,     2,     2,     2,     2,     2,     4,     3,
-       2,     4,     0,     2,     3,     1,     3,     0,     2,     2,
-       2,     3,     2,     1,     3,     0,     2,     2,     2,     3,
-       3,     2,     2,     2,     0,     2,     2,     2,     4,     0,
-       2,     1,     1,     2,     2,     2,     1,     2,     0,     2,
-       1,     3,     3,     3,     2,     3,     3,     1,     1,     0,
-       1
+       4,     4,     5,     5,     3,     0,     3,     0,     2,     3,
+       2,     1,     3,     0,     2,     2,     2,     2,     2,     4,
+       3,     2,     4,     0,     2,     3,     1,     3,     0,     2,
+       2,     2,     3,     2,     1,     3,     0,     2,     2,     2,
+       3,     3,     2,     2,     2,     0,     2,     2,     2,     4,
+       0,     2,     1,     1,     2,     2,     2,     1,     2,     0,
+       2,     1,     3,     3,     3,     2,     3,     3,     1,     1,
+       0,     1
 };
 
 /* YYDEFACT[STATE-NAME] -- Default rule to reduce with in state
@@ -622,31 +622,32 @@ static const yytype_uint8 yyr2[] =
    means the default is an error.  */
 static const yytype_uint8 yydefact[] =
 {
-       3,     0,     0,     1,     0,     0,     0,     0,     0,   109,
+       3,     0,     0,     1,     0,     0,     0,     0,     0,   110,
        0,     0,     0,     0,     0,     0,    12,    16,    13,    14,
       18,    15,    17,     0,    19,     0,     4,    31,    22,    31,
-      23,    52,    62,     5,    67,    20,    84,    75,     6,    24,
-      84,    21,     8,    11,    91,    92,     0,     0,    93,     0,
-     110,     0,    94,     0,     0,     0,   107,   108,     0,     0,
-       0,   100,    95,     0,     0,     0,     0,     0,     0,     0,
-       0,     0,     0,    96,     7,    71,    79,    48,    80,    27,
-      29,     0,   104,     0,     0,    64,     0,     0,     9,    10,
-       0,     0,     0,     0,    89,     0,     0,     0,    44,     0,
-      37,    36,    32,    33,     0,    35,    34,     0,     0,    89,
-       0,    56,    57,    53,    55,    54,    63,    51,    50,    68,
-      70,    66,    69,    65,    86,    87,    85,    76,    78,    74,
-      77,    73,    97,   103,   105,   106,   102,   101,    26,    82,
-       0,    98,     0,    98,    98,    98,     0,     0,     0,    83,
-      60,    98,     0,    98,     0,     0,     0,    38,    90,     0,
-       0,    98,    46,    43,    25,     0,    59,     0,    88,    99,
-      39,    40,    41,     0,     0,    45,    58,    61,    42,    47
+      23,    53,    63,     5,    68,    20,    85,    76,     6,    24,
+      85,    21,     8,    11,    92,    93,     0,     0,    94,     0,
+     111,     0,    95,     0,     0,     0,   108,   109,     0,     0,
+       0,   101,    96,     0,     0,     0,     0,     0,     0,     0,
+       0,     0,     0,    97,     7,    72,    80,    49,    81,    27,
+      29,     0,   105,     0,     0,    65,     0,     0,     9,    10,
+       0,     0,     0,     0,    90,     0,     0,     0,    45,     0,
+      37,    36,    32,    33,     0,    35,    34,     0,     0,    90,
+       0,    57,    58,    54,    56,    55,    64,    52,    51,    69,
+      71,    67,    70,    66,    87,    88,    86,    77,    79,    75,
+      78,    74,    98,   104,   106,   107,   103,   102,    26,    83,
+       0,    99,     0,    99,    99,    99,     0,     0,     0,    84,
+      61,    99,     0,    99,     0,     0,     0,    38,    91,     0,
+       0,    99,    99,    47,    44,    25,     0,    60,     0,    89,
+     100,    39,    40,    41,     0,     0,     0,    46,    59,    62,
+      42,    43,    48
 };
 
 /* YYDEFGOTO[NTERM-NUM].  */
 static const yytype_int16 yydefgoto[] =
 {
       -1,     1,     2,    25,    26,   101,    27,    28,    29,    30,
-      65,   102,   103,   147,   175,    31,    32,   117,    33,    67,
+      65,   102,   103,   147,   177,    31,    32,   117,    33,    67,
      113,    68,    34,   121,    35,    69,    36,    37,   129,    38,
       71,    39,    40,    41,   104,   105,    70,   106,   142,   143,
       42,    74,   156,    60,    61,    51
@@ -661,65 +662,67 @@ static const yytype_int16 yypact[] =
       33,    -1,    27,    40,    -3,    38,   -80,   -80,   -80,   -80,
      -80,   -80,   -80,    71,   -80,    77,   -80,   -80,   -80,   -80,
      -80,   -80,   -80,   -80,   -80,   -80,   -80,   -80,   -80,   -80,
-     -80,   -80,   -80,   -80,   -80,   -80,    57,    61,   -80,    63,
-     -80,    76,   -80,    87,   101,   133,   -80,   -80,    -3,    -3,
-     195,    -6,   -80,   136,   149,    39,   104,    65,   150,     5,
-     194,     5,   167,   -80,   176,   -80,   -80,   -80,   -80,   -80,
-     -80,    68,   -80,    -3,    -3,   176,    72,    72,   -80,   -80,
-     177,   187,    78,    -1,    -1,    -3,   196,    72,   -80,   222,
-     -80,   -80,   -80,   -80,   221,   -80,   -80,   205,    -1,    -1,
-     211,   -80,   -80,   -80,   -80,   -80,   -80,   -80,   -80,   -80,
+     -80,   -80,   -80,   -80,   -80,   -80,    57,    63,   -80,    76,
+     -80,    87,   -80,   101,   115,   128,   -80,   -80,    -3,    -3,
+     209,    -6,   -80,   137,   162,    39,   104,    65,   208,     5,
+     196,     5,   169,   -80,   166,   -80,   -80,   -80,   -80,   -80,
+     -80,    68,   -80,    -3,    -3,   166,    72,    72,   -80,   -80,
+     168,   178,    78,    -1,    -1,    -3,   184,    72,   -80,   219,
+     -80,   -80,   -80,   -80,   211,   -80,   -80,   195,    -1,    -1,
+     205,   -80,   -80,   -80,   -80,   -80,   -80,   -80,   -80,   -80,
      -80,   -80,   -80,   -80,   -80,   -80,   -80,   -80,   -80,   -80,
-     -80,   -80,   -80,   -80,   206,   -80,   -80,   -80,   -80,   -80,
-      -3,   223,   209,   223,   197,   223,    72,     7,   210,   -80,
-     -80,   223,   212,   223,   201,    -3,   213,   -80,   -80,   214,
-     215,   223,   208,   -80,   -80,   216,   -80,   217,   -80,   113,
-     -80,   -80,   -80,   218,    -1,   -80,   -80,   -80,   -80,   -80
+     -80,   -80,   -80,   -80,   199,   -80,   -80,   -80,   -80,   -80,
+      -3,   220,   206,   220,   201,   130,    72,     7,   217,   -80,
+     -80,   220,   218,   220,   212,    -3,   221,   -80,   -80,   222,
+     223,   201,   220,   216,   -80,   -80,   224,   -80,   225,   -80,
+     150,   -80,   -80,   -80,   226,   227,    -1,   -80,   -80,   -80,
+     -80,   -80,   -80
 };
 
 /* YYPGOTO[NTERM-NUM].  */
 static const yytype_int16 yypgoto[] =
 {
-     -80,   -80,   -80,   -80,   122,   -34,   -80,   -80,   -80,   -80,
-     220,   -80,   -80,   -80,   -80,   -80,   -80,   -80,    59,   -80,
-     -80,   -80,   -80,   -80,   -80,   -80,   -80,   -80,   -80,   125,
-     -80,   -80,   -80,   -80,   -80,   183,   219,    22,   142,    -5,
-     147,   192,    69,   -54,   -79,   -80
+     -80,   -80,   -80,   -80,    92,   -34,   -80,   -80,   -80,   -80,
+     229,   -80,   -80,   -80,   -80,   -80,   -80,   -80,    59,   -80,
+     -80,   -80,   -80,   -80,   -80,   -80,   -80,   -80,   -80,   124,
+     -80,   -80,   -80,   -80,   -80,   183,   228,    22,   151,    -5,
+      97,   202,    84,   -54,   -79,   -80
 };
 
 /* YYTABLE[YYPACT[STATE-NUM]].  What to do in state STATE-NUM.  If
    positive, shift that token.  If negative, reduce the rule which
    number is the opposite.  If zero, do what YYDEFACT says.
    If YYTABLE_NINF, syntax error.  */
-#define YYTABLE_NINF -82
+#define YYTABLE_NINF -83
 static const yytype_int16 yytable[] =
 {
       46,    47,     3,    49,    81,    82,    53,   136,   137,     6,
        7,     8,     9,    10,    11,    12,    13,    43,   146,    14,
       15,    86,    56,    57,    44,    45,    58,    87,    48,   134,
-     135,    59,   162,   112,    50,    24,   125,   163,   125,   -28,
+     135,    59,   163,   112,    50,    24,   125,   164,   125,   -28,
       90,   144,   -28,   -28,   -28,   -28,   -28,   -28,   -28,   -28,
      -28,    91,    54,   -28,   -28,    92,   -28,    93,    94,    95,
-      96,    97,    98,    52,    99,    55,    90,   161,    62,   100,
-     -49,   -49,    63,   -49,   -49,   -49,   -49,    91,    64,   -49,
-     -49,    92,   107,   108,   109,   110,   154,    73,   141,   115,
-      99,    75,   126,    76,   126,   111,   133,    56,    57,    83,
-      84,   169,   140,   151,   -30,    90,    77,   -30,   -30,   -30,
-     -30,   -30,   -30,   -30,   -30,   -30,    91,    78,   -30,   -30,
+      96,    97,    98,    52,    99,    55,    90,   162,    62,   100,
+     -50,   -50,    63,   -50,   -50,   -50,   -50,    91,    64,   -50,
+     -50,    92,   107,   108,   109,   110,   154,    73,   141,   115,
+      99,   161,   126,    75,   126,   111,   133,    56,    57,    83,
+      84,   170,   140,   151,   -30,    90,    76,   -30,   -30,   -30,
+     -30,   -30,   -30,   -30,   -30,   -30,    91,    77,   -30,   -30,
       92,   -30,    93,    94,    95,    96,    97,    98,   120,    99,
-     128,    79,    -2,     4,   100,     5,     6,     7,     8,     9,
-      10,    11,    12,    13,    83,    84,    14,    15,    16,    17,
-      18,    19,    20,    21,    22,     7,     8,    23,    10,    11,
-      12,    13,    24,    80,    14,    15,    88,   -81,    90,   179,
-     -81,   -81,   -81,   -81,   -81,   -81,   -81,   -81,   -81,    89,
-      24,   -81,   -81,    92,   -81,   -81,   -81,   -81,   -81,   -81,
-     116,   119,    99,   127,   122,    90,   130,   124,   -72,   -72,
-     -72,   -72,   -72,   -72,   -72,   -72,   132,   138,   -72,   -72,
-      92,   155,   158,   159,   160,   118,   123,   139,   131,    99,
-     165,   145,   167,   148,   124,    73,    83,    84,    83,    84,
-     173,   168,    83,    84,   149,   150,   153,   155,    84,   157,
-     164,   174,   166,   170,   171,   172,   176,   177,   178,    66,
-     114,   152,    85,     0,     0,     0,     0,     0,     0,    72
+     128,    78,    -2,     4,   100,     5,     6,     7,     8,     9,
+      10,    11,    12,    13,   155,    79,    14,    15,    16,    17,
+      18,    19,    20,    21,    22,    56,    57,    23,    80,    58,
+     116,   119,    24,   127,    59,   118,   123,    88,   131,   -82,
+      90,   182,   -82,   -82,   -82,   -82,   -82,   -82,   -82,   -82,
+     -82,    83,    84,   -82,   -82,    92,   -82,   -82,   -82,   -82,
+     -82,   -82,    89,   122,    99,   130,   132,    90,   138,   124,
+     -73,   -73,   -73,   -73,   -73,   -73,   -73,   -73,   139,   145,
+     -73,   -73,    92,     7,     8,   155,    10,    11,    12,    13,
+     148,    99,    14,    15,   149,   150,   124,   158,   159,   160,
+     153,    84,    83,    84,   155,   166,   157,   168,    24,    73,
+      83,    84,   169,    83,    84,   174,   175,   165,   167,   176,
+     114,   171,   172,   173,   178,   179,   180,   181,    66,     0,
+     152,     0,    85,     0,     0,     0,     0,     0,    72
 };
 
 static const yytype_int16 yycheck[] =
@@ -733,23 +736,24 @@ static const yytype_int16 yycheck[] =
       21,    22,    23,    30,    25,    25,     1,   146,    30,    30,
        5,     6,     1,     8,     9,    10,    11,    12,     1,    14,
       15,    16,    17,    18,    19,    20,   140,    30,    93,    67,
-      25,    30,    70,    30,    72,    30,    28,    25,    26,    31,
+      25,   145,    70,    30,    72,    30,    28,    25,    26,    31,
       32,   155,    24,   108,     0,     1,    30,     3,     4,     5,
        6,     7,     8,     9,    10,    11,    12,    30,    14,    15,
       16,    17,    18,    19,    20,    21,    22,    23,    69,    25,
       71,    30,     0,     1,    30,     3,     4,     5,     6,     7,
-       8,     9,    10,    11,    31,    32,    14,    15,    16,    17,
-      18,    19,    20,    21,    22,     5,     6,    25,     8,     9,
-      10,    11,    30,    30,    14,    15,    30,     0,     1,   174,
-       3,     4,     5,     6,     7,     8,     9,    10,    11,    30,
-      30,    14,    15,    16,    17,    18,    19,    20,    21,    22,
-      68,    69,    25,    71,    69,     1,    71,    30,     4,     5,
-       6,     7,     8,     9,    10,    11,    30,    30,    14,    15,
-      16,    14,   143,   144,   145,    68,    69,    30,    71,    25,
-     151,    25,   153,     1,    30,    30,    31,    32,    31,    32,
-     161,    30,    31,    32,    13,    30,    25,    14,    32,    30,
-      30,    33,    30,    30,    30,    30,    30,    30,    30,    29,
-      67,   109,    60,    -1,    -1,    -1,    -1,    -1,    -1,    40
+       8,     9,    10,    11,    14,    30,    14,    15,    16,    17,
+      18,    19,    20,    21,    22,    25,    26,    25,    30,    29,
+      68,    69,    30,    71,    34,    68,    69,    30,    71,     0,
+       1,   176,     3,     4,     5,     6,     7,     8,     9,    10,
+      11,    31,    32,    14,    15,    16,    17,    18,    19,    20,
+      21,    22,    30,    69,    25,    71,    30,     1,    30,    30,
+       4,     5,     6,     7,     8,     9,    10,    11,    30,    25,
+      14,    15,    16,     5,     6,    14,     8,     9,    10,    11,
+       1,    25,    14,    15,    13,    30,    30,   143,   144,   145,
+      25,    32,    31,    32,    14,   151,    30,   153,    30,    30,
+      31,    32,    30,    31,    32,   161,   162,    30,    30,    33,
+      67,    30,    30,    30,    30,    30,    30,    30,    29,    -1,
+     109,    -1,    60,    -1,    -1,    -1,    -1,    -1,    40
 };
 
 /* YYSTOS[STATE-NUM] -- The (internal number of the) accessing
@@ -772,8 +776,9 @@ static const yytype_uint8 yystos[] =
       64,    75,    30,    28,    78,    78,    79,    79,    30,    30,
       24,    74,    73,    74,    78,    25,    79,    48,     1,    13,
       30,    74,    73,    25,    78,    14,    77,    30,    77,    77,
-      77,    79,    25,    30,    30,    77,    30,    77,    30,    78,
-      30,    30,    30,    77,    33,    49,    30,    30,    30,    74
+      77,    78,    79,    25,    30,    30,    77,    30,    77,    30,
+      78,    30,    30,    30,    77,    77,    33,    49,    30,    30,
+      30,    30,    74
 };
 
 #define yyerrok		(yyerrstatus = 0)
@@ -1719,7 +1724,7 @@ yyreduce:
   case 41:
 
     {
-	menu_add_symbol(P_SELECT, sym_lookup((yyvsp[(2) - (4)].string), 0), (yyvsp[(3) - (4)].expr));
+	menu_add_select(sym_lookup((yyvsp[(2) - (4)].string), 0), NULL, (yyvsp[(3) - (4)].expr));
 	printd(DEBUG_PARSE, "%s:%d:select\n", zconf_curname(), zconf_lineno());
 ;}
     break;
@@ -1727,12 +1732,20 @@ yyreduce:
   case 42:
 
     {
+	menu_add_select(sym_lookup((yyvsp[(2) - (5)].string), 0), (yyvsp[(3) - (5)].expr), (yyvsp[(4) - (5)].expr));
+	printd(DEBUG_PARSE, "%s:%d:select with value\n", zconf_curname(), zconf_lineno());
+;}
+    break;
+
+  case 43:
+
+    {
 	menu_add_expr(P_RANGE, expr_alloc_comp(E_RANGE,(yyvsp[(2) - (5)].symbol), (yyvsp[(3) - (5)].symbol)), (yyvsp[(4) - (5)].expr));
 	printd(DEBUG_PARSE, "%s:%d:range\n", zconf_curname(), zconf_lineno());
 ;}
     break;
 
-  case 45:
+  case 46:
 
     {
 	struct kconf_id *id = kconf_id_lookup((yyvsp[(2) - (3)].string), strlen((yyvsp[(2) - (3)].string)));
@@ -1744,17 +1757,17 @@ yyreduce:
 ;}
     break;
 
-  case 46:
+  case 47:
 
     { (yyval.string) = NULL; ;}
     break;
 
-  case 47:
+  case 48:
 
     { (yyval.string) = (yyvsp[(2) - (2)].string); ;}
     break;
 
-  case 48:
+  case 49:
 
     {
 	struct symbol *sym = sym_lookup((yyvsp[(2) - (3)].string), SYMBOL_CHOICE);
@@ -1765,14 +1778,14 @@ yyreduce:
 ;}
     break;
 
-  case 49:
+  case 50:
 
     {
 	(yyval.menu) = menu_add_menu();
 ;}
     break;
 
-  case 50:
+  case 51:
 
     {
 	if (zconf_endtoken((yyvsp[(1) - (1)].id), T_CHOICE, T_ENDCHOICE)) {
@@ -1782,7 +1795,7 @@ yyreduce:
 ;}
     break;
 
-  case 58:
+  case 59:
 
     {
 	menu_add_prompt(P_PROMPT, (yyvsp[(2) - (4)].string), (yyvsp[(3) - (4)].expr));
@@ -1790,7 +1803,7 @@ yyreduce:
 ;}
     break;
 
-  case 59:
+  case 60:
 
     {
 	if ((yyvsp[(1) - (3)].id)->stype == S_BOOLEAN || (yyvsp[(1) - (3)].id)->stype == S_TRISTATE) {
@@ -1803,7 +1816,7 @@ yyreduce:
 ;}
     break;
 
-  case 60:
+  case 61:
 
     {
 	current_entry->sym->flags |= SYMBOL_OPTIONAL;
@@ -1811,7 +1824,7 @@ yyreduce:
 ;}
     break;
 
-  case 61:
+  case 62:
 
     {
 	if ((yyvsp[(1) - (4)].id)->stype == S_UNKNOWN) {
@@ -1823,7 +1836,7 @@ yyreduce:
 ;}
     break;
 
-  case 64:
+  case 65:
 
     {
 	printd(DEBUG_PARSE, "%s:%d:if\n", zconf_curname(), zconf_lineno());
@@ -1833,7 +1846,7 @@ yyreduce:
 ;}
     break;
 
-  case 65:
+  case 66:
 
     {
 	if (zconf_endtoken((yyvsp[(1) - (1)].id), T_IF, T_ENDIF)) {
@@ -1843,7 +1856,7 @@ yyreduce:
 ;}
     break;
 
-  case 71:
+  case 72:
 
     {
 	menu_add_entry(NULL);
@@ -1852,14 +1865,14 @@ yyreduce:
 ;}
     break;
 
-  case 72:
+  case 73:
 
     {
 	(yyval.menu) = menu_add_menu();
 ;}
     break;
 
-  case 73:
+  case 74:
 
     {
 	if (zconf_endtoken((yyvsp[(1) - (1)].id), T_MENU, T_ENDMENU)) {
@@ -1869,7 +1882,7 @@ yyreduce:
 ;}
     break;
 
-  case 79:
+  case 80:
 
     {
 	printd(DEBUG_PARSE, "%s:%d:source %s\n", zconf_curname(), zconf_lineno(), (yyvsp[(2) - (3)].string));
@@ -1877,7 +1890,7 @@ yyreduce:
 ;}
     break;
 
-  case 80:
+  case 81:
 
     {
 	menu_add_entry(NULL);
@@ -1886,14 +1899,14 @@ yyreduce:
 ;}
     break;
 
-  case 81:
+  case 82:
 
     {
 	menu_end_entry();
 ;}
     break;
 
-  case 82:
+  case 83:
 
     {
 	printd(DEBUG_PARSE, "%s:%d:help\n", zconf_curname(), zconf_lineno());
@@ -1901,14 +1914,14 @@ yyreduce:
 ;}
     break;
 
-  case 83:
+  case 84:
 
     {
 	current_entry->help = (yyvsp[(2) - (2)].string);
 ;}
     break;
 
-  case 88:
+  case 89:
 
     {
 	menu_add_dep((yyvsp[(3) - (4)].expr));
@@ -1916,84 +1929,84 @@ yyreduce:
 ;}
     break;
 
-  case 90:
+  case 91:
 
     {
 	menu_add_prompt(P_PROMPT, (yyvsp[(1) - (2)].string), (yyvsp[(2) - (2)].expr));
 ;}
     break;
 
-  case 93:
+  case 94:
 
     { (yyval.id) = (yyvsp[(1) - (2)].id); ;}
     break;
 
-  case 94:
+  case 95:
 
     { (yyval.id) = (yyvsp[(1) - (2)].id); ;}
     break;
 
-  case 95:
+  case 96:
 
     { (yyval.id) = (yyvsp[(1) - (2)].id); ;}
     break;
 
-  case 98:
+  case 99:
 
     { (yyval.expr) = NULL; ;}
     break;
 
-  case 99:
+  case 100:
 
     { (yyval.expr) = (yyvsp[(2) - (2)].expr); ;}
     break;
 
-  case 100:
+  case 101:
 
     { (yyval.expr) = expr_alloc_symbol((yyvsp[(1) - (1)].symbol)); ;}
     break;
 
-  case 101:
+  case 102:
 
     { (yyval.expr) = expr_alloc_comp(E_EQUAL, (yyvsp[(1) - (3)].symbol), (yyvsp[(3) - (3)].symbol)); ;}
     break;
 
-  case 102:
+  case 103:
 
     { (yyval.expr) = expr_alloc_comp(E_UNEQUAL, (yyvsp[(1) - (3)].symbol), (yyvsp[(3) - (3)].symbol)); ;}
     break;
 
-  case 103:
+  case 104:
 
     { (yyval.expr) = (yyvsp[(2) - (3)].expr); ;}
     break;
 
-  case 104:
+  case 105:
 
     { (yyval.expr) = expr_alloc_one(E_NOT, (yyvsp[(2) - (2)].expr)); ;}
     break;
 
-  case 105:
+  case 106:
 
     { (yyval.expr) = expr_alloc_two(E_OR, (yyvsp[(1) - (3)].expr), (yyvsp[(3) - (3)].expr)); ;}
     break;
 
-  case 106:
+  case 107:
 
     { (yyval.expr) = expr_alloc_two(E_AND, (yyvsp[(1) - (3)].expr), (yyvsp[(3) - (3)].expr)); ;}
     break;
 
-  case 107:
+  case 108:
 
     { (yyval.symbol) = sym_lookup((yyvsp[(1) - (1)].string), 0); free((yyvsp[(1) - (1)].string)); ;}
     break;
 
-  case 108:
+  case 109:
 
     { (yyval.symbol) = sym_lookup((yyvsp[(1) - (1)].string), SYMBOL_CONST); free((yyvsp[(1) - (1)].string)); ;}
     break;
 
-  case 109:
+  case 110:
 
     { (yyval.string) = NULL; ;}
     break;
@@ -2387,6 +2400,15 @@ static void print_symbol(FILE *out, struct menu *menu)
 		case P_SELECT:
 			fputs( "  select ", out);
 			expr_fprint(prop->expr, out);
+			if (prop->value) {
+				fputs(" (value=", out);
+				expr_fprint(prop->value, out);
+				fputc(')', out);
+			}
+			if (!expr_is_yes(prop->visible.expr)) {
+				fputs(" if ", out);
+				expr_fprint(prop->visible.expr, out);
+			}
 			fputc('\n', out);
 			break;
 		case P_RANGE:
diff --git a/scripts/kconfig/zconf.y b/scripts/kconfig/zconf.y
index 23dfd3b..5f2a413 100644
--- a/scripts/kconfig/zconf.y
+++ b/scripts/kconfig/zconf.y
@@ -210,10 +210,16 @@ config_option: T_DEFAULT expr if_expr T_EOL
 
 config_option: T_SELECT T_WORD if_expr T_EOL
 {
-	menu_add_symbol(P_SELECT, sym_lookup($2, 0), $3);
+	menu_add_select(sym_lookup($2, 0), NULL, $3);
 	printd(DEBUG_PARSE, "%s:%d:select\n", zconf_curname(), zconf_lineno());
 };
 
+config_option: T_SELECT T_WORD expr if_expr T_EOL
+{
+	menu_add_select(sym_lookup($2, 0), $3, $4);
+	printd(DEBUG_PARSE, "%s:%d:select with value\n", zconf_curname(), zconf_lineno());
+};
+
 config_option: T_RANGE symbol symbol if_expr T_EOL
 {
 	menu_add_expr(P_RANGE, expr_alloc_comp(E_RANGE,$2, $3), $4);
@@ -642,6 +648,15 @@ static void print_symbol(FILE *out, struct menu *menu)
 		case P_SELECT:
 			fputs( "  select ", out);
 			expr_fprint(prop->expr, out);
+			if (prop->value) {
+				fputs(" (value=", out);
+				expr_fprint(prop->value, out);
+				fputc(')', out);
+			}
+			if (!expr_is_yes(prop->visible.expr)) {
+				fputs(" if ", out);
+				expr_fprint(prop->visible.expr, out);
+			}
 			fputc('\n', out);
 			break;
 		case P_RANGE:
-- 
1.7.1


-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
