Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754577Ab2JRTvB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 15:51:01 -0400
Received: from smtp02.smtpout.orange.fr ([80.12.242.124]:48889 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753195Ab2JRTuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 15:50:21 -0400
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
To: linux-kbuild@vger.kernel.org
Cc: Michal Marek <mmarek@suse.cz>, linux-kernel@vger.kernel.org,
        "Yann E. MORIN" <yann.morin.1998@free.fr>
Subject: [PATCH 1/3] kconfig: remove CONFIG_ from string constants
Date: Thu, 18 Oct 2012 21:50:14 +0200
Message-Id: <1350589816-20447-2-git-send-email-yann.morin.1998@free.fr>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1350589816-20447-1-git-send-email-yann.morin.1998@free.fr>
References: <1350589816-20447-1-git-send-email-yann.morin.1998@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Having the CONFIG_ prefix in string constants gets in the way of
using a run-time-defined CONFIG_ prefix.

Fix that by using temp growable strings (gstr) in which we printf
the text.

Signed-off-by: "Yann E. MORIN" <yann.morin.1998@free.fr>
---
 scripts/kconfig/mconf.c |   10 ++++++++--
 scripts/kconfig/nconf.c |   11 +++++++++--
 2 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/scripts/kconfig/mconf.c b/scripts/kconfig/mconf.c
index 48f6744..5f29618 100644
--- a/scripts/kconfig/mconf.c
+++ b/scripts/kconfig/mconf.c
@@ -348,15 +348,19 @@ static void search_conf(void)
 {
 	struct symbol **sym_arr;
 	struct gstr res;
+	struct gstr title;
 	char *dialog_input;
 	int dres, vscroll = 0, hscroll = 0;
 	bool again;
 
+	title = str_new();
+	str_printf( &title, _("Enter %s (sub)string to search for "
+			      "(with or without \"%s\")"), CONFIG_, CONFIG_);
+
 again:
 	dialog_clear();
 	dres = dialog_inputbox(_("Search Configuration Parameter"),
-			      _("Enter " CONFIG_ " (sub)string to search for "
-				"(with or without \"" CONFIG_ "\")"),
+			      str_get(&title),
 			      10, 75, "");
 	switch (dres) {
 	case 0:
@@ -365,6 +369,7 @@ again:
 		show_helptext(_("Search Configuration"), search_help);
 		goto again;
 	default:
+		str_free(&title);
 		return;
 	}
 
@@ -398,6 +403,7 @@ again:
 		str_free(&res);
 	} while (again);
 	free(sym_arr);
+	str_free(&title);
 }
 
 static void build_conf(struct menu *menu)
diff --git a/scripts/kconfig/nconf.c b/scripts/kconfig/nconf.c
index 87d4b15..261f926 100644
--- a/scripts/kconfig/nconf.c
+++ b/scripts/kconfig/nconf.c
@@ -696,13 +696,18 @@ static void search_conf(void)
 {
 	struct symbol **sym_arr;
 	struct gstr res;
+	struct gstr title;
 	char *dialog_input;
 	int dres;
+
+	title = str_new();
+	str_printf( &title, _("Enter %s (sub)string to search for "
+			      "(with or without \"%s\")"), CONFIG_, CONFIG_);
+
 again:
 	dres = dialog_inputbox(main_window,
 			_("Search Configuration Parameter"),
-			_("Enter " CONFIG_ " (sub)string to search for "
-				"(with or without \"" CONFIG_ "\")"),
+			str_get(&title),
 			"", &dialog_input_result, &dialog_input_result_len);
 	switch (dres) {
 	case 0:
@@ -712,6 +717,7 @@ again:
 				_("Search Configuration"), search_help);
 		goto again;
 	default:
+		str_free(&title);
 		return;
 	}
 
@@ -726,6 +732,7 @@ again:
 	show_scroll_win(main_window,
 			_("Search Results"), str_get(&res));
 	str_free(&res);
+	str_free(&title);
 }
 
 
-- 
1.7.2.5

