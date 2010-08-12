Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758893Ab0HLHL4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 03:11:56 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:38587 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752281Ab0HLHLy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 03:11:54 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: Michal Marek <mmarek@suse.cz>, lkml <linux-kernel@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 1/2] kconfig: fix savedefconfig for tristate choices
Date: Thu, 12 Aug 2010 09:11:51 +0200
Message-Id: <1281597112-31019-1-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <20100812071023.GA11148@merkur.ravnborg.org>
References: <20100812071023.GA11148@merkur.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

savedefconfig failed to save choice symbols equal to 'y'
for tristate choices.
This resulted in this value being lost.

In particular is fixes an issue where

	make ARCH=avr32 atngw100_defconfig
	make ARCH=avr32 savedefconfig
	cp defconfig arch/avr32/configs/atngw100_defconfig
	make ARCH=avr32 atngw100_defconfig
	diff -u .config .config.old

failed to produce an identical .config.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 scripts/kconfig/confdata.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
index f81f263..e5d66e4 100644
--- a/scripts/kconfig/confdata.c
+++ b/scripts/kconfig/confdata.c
@@ -497,7 +497,7 @@ int conf_write_defconfig(const char *filename)
 			/*
 			 * If symbol is a choice value and equals to the
 			 * default for a choice - skip.
-			 * But only if value equal to "y".
+			 * But only if value is bool and equal to "y" .
 			 */
 			if (sym_is_choice_value(sym)) {
 				struct symbol *cs;
@@ -506,9 +506,8 @@ int conf_write_defconfig(const char *filename)
 				cs = prop_get_symbol(sym_get_choice_prop(sym));
 				ds = sym_choice_default(cs);
 				if (sym == ds) {
-					if ((sym->type == S_BOOLEAN ||
-					sym->type == S_TRISTATE) &&
-					sym_get_tristate_value(sym) == yes)
+					if ((sym->type == S_BOOLEAN) &&
+					    sym_get_tristate_value(sym) == yes)
 						goto next_menu;
 				}
 			}
-- 
1.6.0.6

