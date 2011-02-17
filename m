Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757865Ab1BQTih (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 14:38:37 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:55364 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752166Ab1BQTif (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 14:38:35 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Roman Zippel <zippel@linux-m68k.org>,
        Grant Likely <grant.likely@secretlab.ca>, linux-kbuild@vger.kernel.org,
        Jason Hui <jason.hui@linaro.org>
Subject: [PATCH] [RFC] Allow configs from choice blocks to be selected.
Date: Thu, 17 Feb 2011 11:27:28 -0800
Message-Id: <1297970848-4371-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In looking at trying to replace defconfigs with kconfig fragments,
one limitation identified is that config items in choice blocks
cannot be selected by other config options.

One way to doge this would be to create non-visible meta options
that change the choice block's default, but that would require
additional meta-configs per-choice config, plus a conditional
default per meta-config. That just seemed too ugly.

So I looked into how to allow the choice default to be overrided
by a select statment, and the following patch is the result.

I'm very new to kconfig code, so I expect that my changes are
probably broken in some subtle way, but in my limited testing it
seems to work. The select only chagnes the default, which can be
overrided by the user via the menu. This allows kconfig fragments
to work for make defconfig, while not restricting user
customization.

Thoughts and feedback (or alternate approaches) would be appreciated.

thanks
-john

CC: Roman Zippel <zippel@linux-m68k.org>
CC: Grant Likely <grant.likely@secretlab.ca>
CC: linux-kbuild@vger.kernel.org
CC: Jason Hui <jason.hui@linaro.org>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 scripts/kconfig/symbol.c |   16 ++++++++++++++--
 1 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/scripts/kconfig/symbol.c b/scripts/kconfig/symbol.c
index a796c95..284b223 100644
--- a/scripts/kconfig/symbol.c
+++ b/scripts/kconfig/symbol.c
@@ -203,8 +203,6 @@ static void sym_calc_visibility(struct symbol *sym)
 		sym->visible = tri;
 		sym_set_changed(sym);
 	}
-	if (sym_is_choice_value(sym))
-		return;
 	/* defaulting to "yes" if no explicit "depends on" are given */
 	tri = yes;
 	if (sym->dir_dep.expr)
@@ -235,9 +233,23 @@ static void sym_calc_visibility(struct symbol *sym)
 struct symbol *sym_choice_default(struct symbol *sym)
 {
 	struct symbol *def_sym;
+	struct symbol *ret = NULL;
 	struct property *prop;
 	struct expr *e;
 
+	/* check to see if any are selected */
+	prop = sym_get_choice_prop(sym);
+	expr_list_for_each_sym(prop->expr, e, def_sym)
+		if (def_sym->rev_dep.tri != no) {
+			if (ret)
+				fprintf(stderr, "warning: conflicting selects "
+					"on choice block: %s\n", sym->name);
+			else
+				ret = def_sym;
+		}
+	if (ret)
+		return ret;
+
 	/* any of the defaults visible? */
 	for_all_defaults(sym, prop) {
 		prop->visible.tri = expr_calc_value(prop->visible.expr);
-- 
1.7.3.2.146.gca209

