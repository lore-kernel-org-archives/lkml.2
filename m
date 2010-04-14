Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699Ab0DNDm4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 23:42:56 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64585 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754577Ab0DNDmy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 23:42:54 -0400
Message-ID: <4BC53A14.1010806@cn.fujitsu.com>
Date: Wed, 14 Apr 2010 11:44:20 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, Michal Marek <mmarek@suse.cz>,
       linux-kbuild@vger.kernel.org, Tim Bird <tim.bird@am.sony.com>
Subject: [PATCH 2/6] kconfig: fix zconfdump()
References: <4BC539DD.5040003@cn.fujitsu.com>
In-Reply-To: <4BC539DD.5040003@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

zconfdump(), which is used for debugging, can't recognize P_SELECT,
P_RANGE and P_MENU (if associated with a symbol, aka "menuconfig"),
and output something like this:

config X86
  boolean
  default y
  unknown prop 6!
  unknown prop 6!
  unknown prop 6!
  ...

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 scripts/kconfig/zconf.tab.c_shipped |   21 +++++++++++++++++----
 scripts/kconfig/zconf.y             |   21 +++++++++++++++++----
 2 files changed, 34 insertions(+), 8 deletions(-)

diff --git a/scripts/kconfig/zconf.tab.c_shipped b/scripts/kconfig/zconf.tab.c_shipped
index 6e9dcd5..54d5ba1 100644
--- a/scripts/kconfig/zconf.tab.c_shipped
+++ b/scripts/kconfig/zconf.tab.c_shipped
@@ -2336,9 +2336,9 @@ static void print_symbol(FILE *out, struct menu *menu)
 	struct property *prop;
 
 	if (sym_is_choice(sym))
-		fprintf(out, "choice\n");
+		fprintf(out, "\nchoice\n");
 	else
-		fprintf(out, "config %s\n", sym->name);
+		fprintf(out, "\nconfig %s\n", sym->name);
 	switch (sym->type) {
 	case S_BOOLEAN:
 		fputs("  boolean\n", out);
@@ -2384,6 +2384,21 @@ static void print_symbol(FILE *out, struct menu *menu)
 		case P_CHOICE:
 			fputs("  #choice value\n", out);
 			break;
+		case P_SELECT:
+			fputs( "  select ", out);
+			expr_fprint(prop->expr, out);
+			fputc('\n', out);
+			break;
+		case P_RANGE:
+			fputs( "  range ", out);
+			expr_fprint(prop->expr, out);
+			fputc('\n', out);
+			break;
+		case P_MENU:
+			fputs( "  menu ", out);
+			print_quoted_string(out, prop->text);
+			fputc('\n', out);
+			break;
 		default:
 			fprintf(out, "  unknown prop %d!\n", prop->type);
 			break;
@@ -2395,7 +2410,6 @@ static void print_symbol(FILE *out, struct menu *menu)
 			menu->help[len] = 0;
 		fprintf(out, "  help\n%s\n", menu->help);
 	}
-	fputc('\n', out);
 }
 
 void zconfdump(FILE *out)
@@ -2428,7 +2442,6 @@ void zconfdump(FILE *out)
 				expr_fprint(prop->visible.expr, out);
 				fputc('\n', out);
 			}
-			fputs("\n", out);
 		}
 
 		if (menu->list)
diff --git a/scripts/kconfig/zconf.y b/scripts/kconfig/zconf.y
index 8c43491..98dae9f 100644
--- a/scripts/kconfig/zconf.y
+++ b/scripts/kconfig/zconf.y
@@ -591,9 +591,9 @@ static void print_symbol(FILE *out, struct menu *menu)
 	struct property *prop;
 
 	if (sym_is_choice(sym))
-		fprintf(out, "choice\n");
+		fprintf(out, "\nchoice\n");
 	else
-		fprintf(out, "config %s\n", sym->name);
+		fprintf(out, "\nconfig %s\n", sym->name);
 	switch (sym->type) {
 	case S_BOOLEAN:
 		fputs("  boolean\n", out);
@@ -639,6 +639,21 @@ static void print_symbol(FILE *out, struct menu *menu)
 		case P_CHOICE:
 			fputs("  #choice value\n", out);
 			break;
+		case P_SELECT:
+			fputs( "  select ", out);
+			expr_fprint(prop->expr, out);
+			fputc('\n', out);
+			break;
+		case P_RANGE:
+			fputs( "  range ", out);
+			expr_fprint(prop->expr, out);
+			fputc('\n', out);
+			break;
+		case P_MENU:
+			fputs( "  menu ", out);
+			print_quoted_string(out, prop->text);
+			fputc('\n', out);
+			break;
 		default:
 			fprintf(out, "  unknown prop %d!\n", prop->type);
 			break;
@@ -650,7 +665,6 @@ static void print_symbol(FILE *out, struct menu *menu)
 			menu->help[len] = 0;
 		fprintf(out, "  help\n%s\n", menu->help);
 	}
-	fputc('\n', out);
 }
 
 void zconfdump(FILE *out)
@@ -683,7 +697,6 @@ void zconfdump(FILE *out)
 				expr_fprint(prop->visible.expr, out);
 				fputc('\n', out);
 			}
-			fputs("\n", out);
 		}
 
 		if (menu->list)
-- 
1.6.3

