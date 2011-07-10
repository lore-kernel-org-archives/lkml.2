Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755294Ab1GJCsR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jul 2011 22:48:17 -0400
Received: from mx1.HRZ.Uni-Dortmund.DE ([129.217.128.51]:53961 "EHLO
	unimail.tu-dortmund.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755237Ab1GJCsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jul 2011 22:48:15 -0400
X-Greylist: delayed 2603 seconds by postgrey-1.27 at vger.kernel.org; Sat, 09 Jul 2011 22:48:15 EDT
Message-ID: <4E1908BF.4010700@udo.edu>
Date: Sun, 10 Jul 2011 04:04:47 +0200
From: Andrej Gelenberg <andrej.gelenberg@udo.edu>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110709 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Subject: [PATCH] nconfig: prevent segfault on empty menu
Content-Type: multipart/mixed;
 boundary="------------060504070000080006070802"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060504070000080006070802
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hello,

i found and fixed an NULL-dereference bug in nconf tool.

How to reproduce:
1. $ make nconfig
2. disable "Kernel hacking -> Debug Filesystem"
3. go to "General setup -> GCOV-based kernel profiling" and hit F2
it should segfault

Fix: i have added some checks for "struct menu*" to be NULL before it
get dereferenced

Regards,
Andrej Gelenberg

--------------060504070000080006070802
Content-Type: text/plain;
 name="0001-nconfig-prevent-segfault-on-empty-menu.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0001-nconfig-prevent-segfault-on-empty-menu.patch"

>From 82be343a388a02477ffb0d464e1f2810c61a1fda Mon Sep 17 00:00:00 2001
From: Andrej Gelenberg <andrej.gelenberg@udo.edu>
Date: Sun, 10 Jul 2011 03:44:50 +0200
Subject: [PATCH] nconfig: prevent segfault on empty menu

how to reproduce:
1. $ make nconfig
2. disable "Kernel hacking -> Debug Filesystem"
3. go to "General setup -> GCOV-based kernel profiling" and hit F2
it should segfault

Fix: i have added some checks for "struct menu*" to be NULL bevor it get dereferenced

Signed-off-by: Andrej Gelenberg <andrej.gelenberg@udo.edu>
---
 scripts/kconfig/menu.c |   18 ++++++++++--------
 1 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/scripts/kconfig/menu.c b/scripts/kconfig/menu.c
index 5fdf10d..6a09cc4 100644
--- a/scripts/kconfig/menu.c
+++ b/scripts/kconfig/menu.c
@@ -425,7 +425,7 @@ void menu_finalize(struct menu *parent)
 
 bool menu_has_prompt(struct menu *menu)
 {
-	if (!menu->prompt)
+	if ((!menu) || (!menu->prompt))
 		return false;
 	return true;
 }
@@ -436,7 +436,7 @@ bool menu_is_visible(struct menu *menu)
 	struct symbol *sym;
 	tristate visible;
 
-	if (!menu->prompt)
+	if ((!menu) || !menu->prompt)
 		return false;
 
 	if (menu->visibility) {
@@ -470,10 +470,12 @@ bool menu_is_visible(struct menu *menu)
 
 const char *menu_get_prompt(struct menu *menu)
 {
-	if (menu->prompt)
-		return menu->prompt->text;
-	else if (menu->sym)
-		return menu->sym->name;
+	if (menu) {
+		if (menu->prompt)
+			return menu->prompt->text;
+		else if (menu->sym)
+			return menu->sym->name;
+	}
 	return NULL;
 }
 
@@ -496,12 +498,12 @@ struct menu *menu_get_parent_menu(struct menu *menu)
 
 bool menu_has_help(struct menu *menu)
 {
-	return menu->help != NULL;
+	return menu && (menu->help != NULL);
 }
 
 const char *menu_get_help(struct menu *menu)
 {
-	if (menu->help)
+	if (menu && menu->help)
 		return menu->help;
 	else
 		return "";
-- 
1.7.6


--------------060504070000080006070802--
