Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757198Ab0GaVfl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jul 2010 17:35:41 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:40608 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757018Ab0GaVfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jul 2010 17:35:36 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: Michal Marek <mmarek@suse.cz>, lkml <linux-kernel@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Roman Zippel <zippel@linux-m68k.org>
Subject: [PATCH 4/9] kconfig: save location of config symbols
Date: Sat, 31 Jul 2010 23:35:29 +0200
Message-Id: <1280612134-8220-4-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <20100731213429.GA8200@merkur.ravnborg.org>
References: <20100731213429.GA8200@merkur.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we add a new config symbol save the file/line
so we later can refer to their location.

The information is saved as a property to a config symbol
because we may have multiple definitions of the same symbol.

This has the side-effect that a symbol always has
at least one property.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Roman Zippel <zippel@linux-m68k.org>
---
 scripts/kconfig/expr.h   |    1 +
 scripts/kconfig/menu.c   |    2 ++
 scripts/kconfig/symbol.c |    2 ++
 3 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/scripts/kconfig/expr.h b/scripts/kconfig/expr.h
index 75a31e4..6ee2e4f 100644
--- a/scripts/kconfig/expr.h
+++ b/scripts/kconfig/expr.h
@@ -132,6 +132,7 @@ enum prop_type {
 	P_SELECT,   /* select BAR */
 	P_RANGE,    /* range 7..100 (for a symbol) */
 	P_ENV,      /* value from environment variable */
+	P_SYMBOL,   /* where a symbol is defined */
 };
 
 struct property {
diff --git a/scripts/kconfig/menu.c b/scripts/kconfig/menu.c
index 1179989..4fb5902 100644
--- a/scripts/kconfig/menu.c
+++ b/scripts/kconfig/menu.c
@@ -58,6 +58,8 @@ void menu_add_entry(struct symbol *sym)
 	*last_entry_ptr = menu;
 	last_entry_ptr = &menu->next;
 	current_entry = menu;
+	if (sym)
+		menu_add_symbol(P_SYMBOL, sym, NULL);
 }
 
 void menu_end_entry(void)
diff --git a/scripts/kconfig/symbol.c b/scripts/kconfig/symbol.c
index c127fa3..9f180ab 100644
--- a/scripts/kconfig/symbol.c
+++ b/scripts/kconfig/symbol.c
@@ -961,6 +961,8 @@ const char *prop_get_type_name(enum prop_type type)
 		return "select";
 	case P_RANGE:
 		return "range";
+	case P_SYMBOL:
+		return "symbol";
 	case P_UNKNOWN:
 		break;
 	}
-- 
1.6.0.6

