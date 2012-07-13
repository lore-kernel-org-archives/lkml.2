Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030859Ab2GMS2W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 14:28:22 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:45850 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756042Ab2GMS2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 14:28:18 -0400
From: cody@linux.vnet.ibm.com
To: Michal Marek <mmarek@suse.cz>
Cc: Cody Schafer <cody@linux.vnet.ibm.com>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] kconfig: allow long lines in config file
Date: Fri, 13 Jul 2012 11:27:12 -0700
Message-Id: <1342204033-24484-1-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <50001D87.1020708@suse.cz>
References: <50001D87.1020708@suse.cz>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12071318-4242-0000-0000-0000025126C2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cody Schafer <cody@linux.vnet.ibm.com>

For some config options (CONFIG_EXTRA_FIRMWARE, for example), the length
of a config file line can exceed the 1024 byte buffer.

Switch from fgets to compat_getline to fix. compat_getline is an
internally implimented getline work-alike for portability purposes.

Signed-off-by: Cody Schafer <cody@linux.vnet.ibm.com>
---
 scripts/kconfig/confdata.c |   61 ++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 59 insertions(+), 2 deletions(-)

diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
index 52577f0..13ddf11 100644
--- a/scripts/kconfig/confdata.c
+++ b/scripts/kconfig/confdata.c
@@ -182,10 +182,66 @@ static int conf_set_sym_val(struct symbol *sym, int def, int def_flags, char *p)
 	return 0;
 }
 
+#define LINE_GROWTH 16
+static int add_byte(int c, char **lineptr, size_t slen, size_t *n)
+{
+	char *nline;
+	size_t new_size = slen + 1;
+	if (new_size > *n) {
+		new_size += LINE_GROWTH - 1;
+		new_size *= 2;
+		nline = realloc(*lineptr, new_size);
+		if (!nline)
+			return -1;
+
+		*lineptr = nline;
+		*n = new_size;
+	}
+
+	(*lineptr)[slen] = c;
+
+	return 0;
+}
+
+static ssize_t compat_getline(char **lineptr, size_t *n, FILE *stream)
+{
+	char *line = *lineptr;
+	size_t slen = 0;
+
+	for (;;) {
+		int c = getc(stream);
+
+		switch (c) {
+		case '\n':
+			if (add_byte(c, &line, slen, n) < 0)
+				goto e_out;
+			slen++;
+			/* fall through */
+		case EOF:
+			if (add_byte('\0', &line, slen, n) < 0)
+				goto e_out;
+			*lineptr = line;
+			if (slen == 0)
+				return -1;
+			return slen;
+		default:
+			if (add_byte(c, &line, slen, n) < 0)
+				goto e_out;
+			slen++;
+		}
+	}
+
+e_out:
+	line[slen-1] = '\0';
+	*lineptr = line;
+	return -1;
+}
+
 int conf_read_simple(const char *name, int def)
 {
 	FILE *in = NULL;
-	char line[1024];
+	char   *line = NULL;
+	size_t  line_asize = 0;
 	char *p, *p2;
 	struct symbol *sym;
 	int i, def_flags;
@@ -247,7 +303,7 @@ load:
 		}
 	}
 
-	while (fgets(line, sizeof(line), in)) {
+	while (compat_getline(&line, &line_asize, in) != -1) {
 		conf_lineno++;
 		sym = NULL;
 		if (line[0] == '#') {
@@ -335,6 +391,7 @@ setsym:
 			cs->def[def].tri = EXPR_OR(cs->def[def].tri, sym->def[def].tri);
 		}
 	}
+	free(line);
 	fclose(in);
 
 	if (modules_sym)
-- 
1.7.9.5

