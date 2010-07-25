Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752848Ab0GYVjW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jul 2010 17:39:22 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:54849 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752431Ab0GYVjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jul 2010 17:39:21 -0400
Date: Sun, 25 Jul 2010 23:39:19 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: lkml <linux-kernel@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Roman Zippel <zippel@linux-m68k.org>, Michal Marek <mmarek@suse.cz>,
        Uwe Kleine-Koig <u.kleine-koenig@pengutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 2/4] kconfig: print more info when we see a recursive
	dependency
Message-ID: <20100725213919.GB5834@merkur.ravnborg.org>
References: <20100725213808.GA5814@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100725213808.GA5814@merkur.ravnborg.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 874dbe17dd7b55238bdf995461488fc84196987c Mon Sep 17 00:00:00 2001
From: Roman Zippel <zippel@linux-m68k.org>
Date: Wed, 31 Dec 2008 03:55:00 +0100
Subject: [PATCH 2/4] kconfig: print more info when we see a recursive dependency

Consider following kconfig file:

config TEST1
	bool "test 1"
	depends on TEST2

config TEST2
	bool "test 2"
	depends on TEST1

Previously kconfig would report:

foo:6:error: found recursive dependency: TEST2 -> TEST1 -> TEST2

With the following patch kconfig reports:
foo:5:error: recursive dependency detected!
foo:5:  symbol TEST2 depends on TEST1
foo:1:  symbol TEST1 depends on TEST2

Note that we now report where the offending symbols are defined.
This can be a great help for complex situations involving
several files.

Patch is originally from Roman Zippel with a few adjustments by Sam.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 scripts/kconfig/symbol.c |  144 ++++++++++++++++++++++++++++++++++++++++-----
 1 files changed, 128 insertions(+), 16 deletions(-)

diff --git a/scripts/kconfig/symbol.c b/scripts/kconfig/symbol.c
index de36f3e..0ea9c46 100644
--- a/scripts/kconfig/symbol.c
+++ b/scripts/kconfig/symbol.c
@@ -765,6 +765,110 @@ struct symbol **sym_re_search(const char *pattern)
 	return sym_arr;
 }
 
+/*
+ * When we check for recursive dependencies we use a stack to save
+ * current state so we can print out relevant info to user.
+ * The entries are located on the call stack so no need to free memory.
+ * Note inser() remove() must always match to properly clear the stack.
+ */
+static struct dep_stack {
+	struct dep_stack *prev, *next;
+	struct symbol *sym;
+	struct property *prop;
+	struct expr *expr;
+} *check_top;
+
+static void dep_stack_insert(struct dep_stack *stack, struct symbol *sym)
+{
+	memset(stack, 0, sizeof(*stack));
+	if (check_top)
+		check_top->next = stack;
+	stack->prev = check_top;
+	stack->sym = sym;
+	check_top = stack;
+}
+
+static void dep_stack_remove(void)
+{
+	check_top = check_top->prev;
+	if (check_top)
+		check_top->next = NULL;
+}
+
+/*
+ * Called when we have detected a recursive dependency.
+ * check_top point to the top of the stact so we use
+ * the ->prev pointer to locate the bottom of the stack.
+ */
+static void sym_check_print_recursive(struct symbol *last_sym)
+{
+	struct dep_stack *stack;
+	struct symbol *sym, *next_sym;
+	struct menu *menu = NULL;
+	struct property *prop;
+	struct dep_stack cv_stack;
+
+	if (sym_is_choice_value(last_sym)) {
+		dep_stack_insert(&cv_stack, last_sym);
+		last_sym = prop_get_symbol(sym_get_choice_prop(last_sym));
+	}
+
+	for (stack = check_top; stack != NULL; stack = stack->prev)
+		if (stack->sym == last_sym)
+			break;
+	if (!stack) {
+		fprintf(stderr, "unexpected recursive dependency error\n");
+		return;
+	}
+
+	for (; stack; stack = stack->next) {
+		sym = stack->sym;
+		next_sym = stack->next ? stack->next->sym : last_sym;
+		prop = stack->prop;
+
+		/* for choice values find the menu entry (used below) */
+		if (sym_is_choice(sym) || sym_is_choice_value(sym)) {
+			for (prop = sym->prop; prop; prop = prop->next) {
+				menu = prop->menu;
+				if (prop->menu)
+					break;
+			}
+		}
+		if (stack->sym == last_sym)
+			fprintf(stderr, "%s:%d:error: recursive dependency detected!\n",
+				prop->file->name, prop->lineno);
+		if (stack->expr) {
+			fprintf(stderr, "%s:%d:\tsymbol %s %s value contains %s\n",
+				prop->file->name, prop->lineno,
+				sym->name ? sym->name : "<choice>",
+				prop_get_type_name(prop->type),
+				next_sym->name ? next_sym->name : "<choice>");
+		} else if (stack->prop) {
+			fprintf(stderr, "%s:%d:\tsymbol %s depends on %s\n",
+				prop->file->name, prop->lineno,
+				sym->name ? sym->name : "<choice>",
+				next_sym->name ? next_sym->name : "<choice>");
+		} else if (sym_is_choice(sym)) {
+			fprintf(stderr, "%s:%d:\tchoice %s contains symbol %s\n",
+				menu->file->name, menu->lineno,
+				sym->name ? sym->name : "<choice>",
+				next_sym->name ? next_sym->name : "<choice>");
+		} else if (sym_is_choice_value(sym)) {
+			fprintf(stderr, "%s:%d:\tsymbol %s is part of choice %s\n",
+				menu->file->name, menu->lineno,
+				sym->name ? sym->name : "<choice>",
+				next_sym->name ? next_sym->name : "<choice>");
+		} else {
+			fprintf(stderr, "%s:%d:\tsymbol %s is selected by %s\n",
+				prop->file->name, prop->lineno,
+				sym->name ? sym->name : "<choice>",
+				next_sym->name ? next_sym->name : "<choice>");
+		}
+	}
+
+	if (check_top == &cv_stack)
+		dep_stack_remove();
+}
 
 static struct symbol *sym_check_expr_deps(struct expr *e)
 {
@@ -792,7 +896,7 @@ static struct symbol *sym_check_expr_deps(struct expr *e)
 	default:
 		break;
 	}
-	printf("Oops! How to check %d?\n", e->type);
+	fprintf(stderr, "Oops! How to check %d?\n", e->type);
 	return NULL;
 }
 
@@ -801,24 +905,33 @@ static struct symbol *sym_check_sym_deps(struct symbol *sym)
 {
 	struct symbol *sym2;
 	struct property *prop;
+	struct dep_stack stack;
+
+	dep_stack_insert(&stack, sym);
 
 	sym2 = sym_check_expr_deps(sym->rev_dep.expr);
 	if (sym2)
-		return sym2;
+		goto out;
 
 	for (prop = sym->prop; prop; prop = prop->next) {
 		if (prop->type == P_CHOICE || prop->type == P_SELECT)
 			continue;
+		stack.prop = prop;
 		sym2 = sym_check_expr_deps(prop->visible.expr);
 		if (sym2)
 			break;
 		if (prop->type != P_DEFAULT || sym_is_choice(sym))
 			continue;
+		stack.expr = prop->expr;
 		sym2 = sym_check_expr_deps(prop->expr);
 		if (sym2)
 			break;
+		stack.expr = NULL;
 	}
 
+out:
+	dep_stack_remove();
+
 	return sym2;
 }
 
@@ -827,6 +940,9 @@ static struct symbol *sym_check_choice_deps(struct symbol *choice)
 	struct symbol *sym, *sym2;
 	struct property *prop;
 	struct expr *e;
+	struct dep_stack stack;
+
+	dep_stack_insert(&stack, choice);
 
 	prop = sym_get_choice_prop(choice);
 	expr_list_for_each_sym(prop->expr, e, sym)
@@ -840,10 +956,8 @@ static struct symbol *sym_check_choice_deps(struct symbol *choice)
 
 	expr_list_for_each_sym(prop->expr, e, sym) {
 		sym2 = sym_check_sym_deps(sym);
-		if (sym2) {
-			fprintf(stderr, " -> %s", sym->name);
+		if (sym2)
 			break;
-		}
 	}
 out:
 	expr_list_for_each_sym(prop->expr, e, sym)
@@ -853,6 +967,8 @@ out:
 	    prop_get_symbol(sym_get_choice_prop(sym2)) == choice)
 		sym2 = choice;
 
+	dep_stack_remove();
+
 	return sym2;
 }
 
@@ -862,18 +978,20 @@ struct symbol *sym_check_deps(struct symbol *sym)
 	struct property *prop;
 
 	if (sym->flags & SYMBOL_CHECK) {
-		fprintf(stderr, "%s:%d:error: found recursive dependency: %s",
-		        sym->prop->file->name, sym->prop->lineno,
-			sym->name ? sym->name : "<choice>");
+		sym_check_print_recursive(sym);
 		return sym;
 	}
 	if (sym->flags & SYMBOL_CHECKED)
 		return NULL;
 
 	if (sym_is_choice_value(sym)) {
+		struct dep_stack stack;
+
 		/* for choice groups start the check with main choice symbol */
+		dep_stack_insert(&stack, sym);
 		prop = sym_get_choice_prop(sym);
 		sym2 = sym_check_deps(prop_get_symbol(prop));
+		dep_stack_remove();
 	} else if (sym_is_choice(sym)) {
 		sym2 = sym_check_choice_deps(sym);
 	} else {
@@ -882,14 +1000,8 @@ struct symbol *sym_check_deps(struct symbol *sym)
 		sym->flags &= ~SYMBOL_CHECK;
 	}
 
-	if (sym2) {
-		fprintf(stderr, " -> %s", sym->name ? sym->name : "<choice>");
-		if (sym2 == sym) {
-			fprintf(stderr, "\n");
-			zconfnerrs++;
-			sym2 = NULL;
-		}
-	}
+	if (sym2 && sym2 == sym)
+		sym2 = NULL;
 
 	return sym2;
 }
-- 
1.6.0.6

