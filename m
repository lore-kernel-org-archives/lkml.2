Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755519Ab2GJXsw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 19:48:52 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:45115 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755264Ab2GJXsu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 19:48:50 -0400
From: cody@linux.vnet.ibm.com
To: Michal Marek <mmarek@suse.cz>
Cc: Cody Schafer <cody@linux.vnet.ibm.com>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] kconfig: allow long lines in config file
Date: Tue, 10 Jul 2012 16:47:58 -0700
Message-Id: <1341964078-22594-1-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.9.5
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12071023-7408-0000-0000-000006A7D906
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cody Schafer <cody@linux.vnet.ibm.com>

For some config options (CONFIG_EXTRA_FIRMWARE, for example), the length
of a config file line can exceed the 1024 byte buffer.

Switch from fgets to getline to fix.

Signed-off-by: Cody Schafer <cody@linux.vnet.ibm.com>
---
 scripts/kconfig/confdata.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
index 52577f0..175037f 100644
--- a/scripts/kconfig/confdata.c
+++ b/scripts/kconfig/confdata.c
@@ -185,7 +185,8 @@ static int conf_set_sym_val(struct symbol *sym, int def, int def_flags, char *p)
 int conf_read_simple(const char *name, int def)
 {
 	FILE *in = NULL;
-	char line[1024];
+	char   *line = NULL;
+	size_t  line_asize = 0;
 	char *p, *p2;
 	struct symbol *sym;
 	int i, def_flags;
@@ -247,7 +248,7 @@ load:
 		}
 	}
 
-	while (fgets(line, sizeof(line), in)) {
+	while (getline(&line, &line_asize, in) != -1) {
 		conf_lineno++;
 		sym = NULL;
 		if (line[0] == '#') {
@@ -335,6 +336,7 @@ setsym:
 			cs->def[def].tri = EXPR_OR(cs->def[def].tri, sym->def[def].tri);
 		}
 	}
+	free(line);
 	fclose(in);
 
 	if (modules_sym)
-- 
1.7.9.5

