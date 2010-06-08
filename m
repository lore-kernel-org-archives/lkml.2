Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755602Ab0FHQ0M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 12:26:12 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:38341 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755506Ab0FHQ0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 12:26:07 -0400
Subject: [RFC PATCH 1/3] kbuild: Warn on selecting symbols with unmet direct
 dependencies
To: linux-kernel@vger.kernel.org
From: Catalin Marinas <catalin.marinas@arm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>, Arnd Bergmann <arnd@arndb.de>
Date: Tue, 08 Jun 2010 17:25:57 +0100
Message-ID: <20100608162556.21870.5952.stgit@e102109-lin.cambridge.arm.com>
In-Reply-To: <20100608162046.21870.5615.stgit@e102109-lin.cambridge.arm.com>
References: <20100608162046.21870.5615.stgit@e102109-lin.cambridge.arm.com>
User-Agent: StGit/0.15-83-g972d5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Jun 2010 16:25:57.0509 (UTC) FILETIME=[46520350:01CB0727]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "select" statement in Kconfig files allows the enabling of options
even if they have unmet direct dependencies (i.e. "depends on" expands
to "no"). Currently, the "depends on" clauses are used in calculating
the visibility but they do not affect the reverse dependencies in any
way.

The patch introduces additional tracking of the "depends on" statements
and prints a warning on selecting an option if its direct dependencies
are not met.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
---
 scripts/kconfig/expr.h   |    2 ++
 scripts/kconfig/menu.c   |    5 +++++
 scripts/kconfig/symbol.c |   18 ++++++++++++++++++
 3 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/scripts/kconfig/expr.h b/scripts/kconfig/expr.h
index 6408fef..c8be420 100644
--- a/scripts/kconfig/expr.h
+++ b/scripts/kconfig/expr.h
@@ -83,6 +83,7 @@ struct symbol {
 	tristate visible;
 	int flags;
 	struct property *prop;
+	struct expr_value dir_dep;
 	struct expr_value rev_dep;
 };
 
@@ -164,6 +165,7 @@ struct menu {
 	struct symbol *sym;
 	struct property *prompt;
 	struct expr *dep;
+	struct expr *dir_dep;
 	unsigned int flags;
 	char *help;
 	struct file *file;
diff --git a/scripts/kconfig/menu.c b/scripts/kconfig/menu.c
index 059a246..8519f21 100644
--- a/scripts/kconfig/menu.c
+++ b/scripts/kconfig/menu.c
@@ -105,6 +105,7 @@ static struct expr *menu_check_dep(struct expr *e)
 void menu_add_dep(struct expr *dep)
 {
 	current_entry->dep = expr_alloc_and(current_entry->dep, menu_check_dep(dep));
+	current_entry->dir_dep = current_entry->dep;
 }
 
 void menu_set_type(int type)
@@ -288,6 +289,10 @@ void menu_finalize(struct menu *parent)
 		for (menu = parent->list; menu; menu = menu->next)
 			menu_finalize(menu);
 	} else if (sym) {
+		/* ignore inherited dependencies for dir_dep */
+		sym->dir_dep.expr = expr_transform(expr_copy(parent->dir_dep));
+		sym->dir_dep.expr = expr_eliminate_dups(sym->dir_dep.expr);
+
 		basedep = parent->prompt ? parent->prompt->visible.expr : NULL;
 		basedep = expr_trans_compare(basedep, E_UNEQUAL, &symbol_no);
 		basedep = expr_eliminate_dups(expr_transform(basedep));
diff --git a/scripts/kconfig/symbol.c b/scripts/kconfig/symbol.c
index 6c8fbbb..7445cc0 100644
--- a/scripts/kconfig/symbol.c
+++ b/scripts/kconfig/symbol.c
@@ -205,6 +205,16 @@ static void sym_calc_visibility(struct symbol *sym)
 	}
 	if (sym_is_choice_value(sym))
 		return;
+	/* defaulting to "yes" if no explicit "depends on" are given */
+	tri = yes;
+	if (sym->dir_dep.expr)
+		tri = expr_calc_value(sym->dir_dep.expr);
+	if (tri == mod)
+		tri = yes;
+	if (sym->dir_dep.tri != tri) {
+		sym->dir_dep.tri = tri;
+		sym_set_changed(sym);
+	}
 	tri = no;
 	if (sym->rev_dep.expr)
 		tri = expr_calc_value(sym->rev_dep.expr);
@@ -321,6 +331,14 @@ void sym_calc_value(struct symbol *sym)
 				}
 			}
 		calc_newval:
+			if (sym->dir_dep.tri == no && sym->rev_dep.tri != no) {
+				fprintf(stderr, "warning: (");
+				expr_fprint(sym->rev_dep.expr, stderr);
+				fprintf(stderr, ") selects %s which has unmet direct dependencies (",
+					sym->name);
+				expr_fprint(sym->dir_dep.expr, stderr);
+				fprintf(stderr, ")\n");
+			}
 			newval.tri = EXPR_OR(newval.tri, sym->rev_dep.tri);
 		}
 		if (newval.tri == mod && sym_get_type(sym) == S_BOOLEAN)

