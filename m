Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755798Ab1EQPfq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 11:35:46 -0400
Received: from cantor.suse.de ([195.135.220.2]:44571 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754383Ab1EQPfp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 11:35:45 -0400
From: Michal Marek <mmarek@suse.cz>
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Subject: [PATCH] kconfig: Only generate config_is_xxx for bool and tristate options
Date: Tue, 17 May 2011 17:35:32 +0200
Message-Id: <1305646532-29114-1-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For strings and integers, the config_is_xxx macros are useless and
sometimes misleading:

  #define CONFIG_INITRAMFS_SOURCE ""
  #define config_is_initramfs_source() 1

Cc: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 scripts/kconfig/confdata.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
index db06af0..d40195d 100644
--- a/scripts/kconfig/confdata.c
+++ b/scripts/kconfig/confdata.c
@@ -808,7 +808,6 @@ int conf_write_autoconf(void)
 	const char *name;
 	FILE *out, *tristate, *out_h;
 	int i;
-	int fct_val;
 
 	sym_clear_all_valid();
 
@@ -849,7 +848,7 @@ int conf_write_autoconf(void)
 		       rootmenu.prompt->text);
 
 	for_all_symbols(i, sym) {
-		fct_val = 1;
+		int fct_val = 0;
 		sym_calc_value(sym);
 		if (!(sym->flags & SYMBOL_WRITE) || !sym->name)
 			continue;
@@ -863,7 +862,6 @@ int conf_write_autoconf(void)
 		case S_TRISTATE:
 			switch (sym_get_tristate_value(sym)) {
 			case no:
-				fct_val = 0;
 				break;
 			case mod:
 				fprintf(tristate, "%s%s=M\n",
@@ -878,8 +876,10 @@ int conf_write_autoconf(void)
 					    CONFIG_, sym->name);
 				fprintf(out_h, "#define %s%s 1\n",
 				    CONFIG_, sym->name);
+				fct_val = 1;
 				break;
 			}
+			conf_write_function_autoconf(out_h, CONFIG_, sym->name, fct_val);
 			break;
 		case S_STRING:
 			conf_write_string(true, sym->name, sym_get_string_value(sym), out_h);
@@ -897,10 +897,8 @@ int conf_write_autoconf(void)
 			    CONFIG_, sym->name, str);
 			break;
 		default:
-			fct_val = 0;
 			break;
 		}
-		conf_write_function_autoconf(out_h, CONFIG_, sym->name, fct_val);
 	}
 	fclose(out);
 	fclose(tristate);
-- 
1.7.4.1

