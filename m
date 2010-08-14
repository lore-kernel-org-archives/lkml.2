Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756222Ab0HNV3E (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Aug 2010 17:29:04 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:37373 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755411Ab0HNV3C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Aug 2010 17:29:02 -0400
Date: Sat, 14 Aug 2010 23:29:00 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Michal Marek <mmarek@suse.cz>, linux-kbuild <linux-kbuild@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] kconfig: fix savedefconfig with choice marked optional
Message-ID: <20100814212900.GA29962@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From db5b47421d4e9c2f3a35bc3aaa4a1423b767e00a Mon Sep 17 00:00:00 2001
From: Sam Ravnborg <sam@ravnborg.org>
Date: Sat, 14 Aug 2010 23:22:16 +0200
Subject: [PATCH] kconfig: fix savedefconfig with choice marked optional

savedefconfig failed to save the correct minimal config
when it encountered a choice marked optional.

Consider following minimal configuration:
$cat Kconfig
choice
	prompt "choice"
	optional

config A
	bool "a"

config B
	bool "b"

endchoice

$cat .config | grep -v ^#
CONFIG_A=y

$conf --savedefconfig=defconfig Kconfig

would before this fix result in an empty file, because
kconfig would assume that CONFIG_A=y is a default value.
But because the choice is optional the default is that
both A and B are =n.

Fix so we handle optional choices correct.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 scripts/kconfig/confdata.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
index c39327e..515253f 100644
--- a/scripts/kconfig/confdata.c
+++ b/scripts/kconfig/confdata.c
@@ -497,7 +497,9 @@ int conf_write_defconfig(const char *filename)
 			/*
 			 * If symbol is a choice value and equals to the
 			 * default for a choice - skip.
-			 * But only if value is bool and equal to "y" .
+			 * But only if value is bool and equal to "y" and
+			 * choice is not "optional".
+			 * (If choice is "optional" then all values can be "n")
 			 */
 			if (sym_is_choice_value(sym)) {
 				struct symbol *cs;
@@ -505,7 +507,7 @@ int conf_write_defconfig(const char *filename)
 
 				cs = prop_get_symbol(sym_get_choice_prop(sym));
 				ds = sym_choice_default(cs);
-				if (sym == ds) {
+				if (!sym_is_optional(cs) && sym == ds) {
 					if ((sym->type == S_BOOLEAN) &&
 					    sym_get_tristate_value(sym) == yes)
 						goto next_menu;
-- 
1.6.0.6

