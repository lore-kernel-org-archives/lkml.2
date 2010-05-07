Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753113Ab0EGFzF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 01:55:05 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62850 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752596Ab0EGFzA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 01:55:00 -0400
Message-ID: <4BE3ABA2.6070106@cn.fujitsu.com>
Date: Fri, 07 May 2010 13:56:50 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Michal Marek <mmarek@suse.cz>
CC: Randy Dunlap <randy.dunlap@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kbuild@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 2/8] kconfig: print the range of integer/hex symbol in
 help text
References: <4BE3AB91.80606@cn.fujitsu.com>
In-Reply-To: <4BE3AB91.80606@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Without this patch, one has to refer to the Kconfig file to find
out the range of an integer/hex symbol.

  │ Symbol: NR_CPUS [=4]
  │ Type  : integer
  │ Range : [2 8]
  │ Prompt: Maximum number of CPUs
  │   Defined at arch/x86/Kconfig:761
  │   Depends on: SMP [=y] && !MAXSMP [=n]
  │   Location:
  │     -> Processor type and features

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 scripts/kconfig/expr.c |    2 +-
 scripts/kconfig/menu.c |    8 ++++++++
 2 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/scripts/kconfig/expr.c b/scripts/kconfig/expr.c
index edd3f39..e5e13f5 100644
--- a/scripts/kconfig/expr.c
+++ b/scripts/kconfig/expr.c
@@ -1098,7 +1098,7 @@ void expr_fprint(struct expr *e, FILE *out)
 static void expr_print_gstr_helper(void *data, struct symbol *sym, const char *str)
 {
 	str_append((struct gstr*)data, str);
-	if (sym)
+	if (sym && sym->type != S_UNKNOWN)
 		str_printf((struct gstr*)data, " [=%s]", sym_get_string_value(sym));
 }
 
diff --git a/scripts/kconfig/menu.c b/scripts/kconfig/menu.c
index b5d15fa..c547692 100644
--- a/scripts/kconfig/menu.c
+++ b/scripts/kconfig/menu.c
@@ -505,6 +505,14 @@ void get_symbol_str(struct gstr *r, struct symbol *sym)
 		str_printf(r, "Symbol: %s [=%s]\n", sym->name,
 			   sym_get_string_value(sym));
 		str_printf(r, "Type  : %s\n", sym_type_name(sym->type));
+		if (sym->type == S_INT || sym->type == S_HEX) {
+			prop = sym_get_range_prop(sym);
+			if (prop) {
+				str_printf(r, "Range : ");
+				expr_gstr_print(prop->expr, r);
+				str_append(r, "\n");
+			}
+		}
 	}
 	for_all_prompts(sym, prop)
 		get_prompt_str(r, prop);
-- 
1.6.3

