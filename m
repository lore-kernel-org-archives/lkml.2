Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760178Ab2INW3u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 18:29:50 -0400
Received: from brettmacdonald.ca ([204.244.237.11]:52418 "HELO optimus.nome.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751372Ab2INW3r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 18:29:47 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Fri, 14 Sep 2012 18:29:47 EDT
Date: Sat, 15 Sep 2012 00:23:04 +0200
From: Markus Mayer <mmayer@broadcom.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Fix segfault in dtc when empty input file is given.
Message-ID: <20120914222304.GA2698@mmayer.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Operating-System: Linux 2.6.26-1-xen-amd64 x86_64
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Mayer <mmayer@broadcom.com>
Date: Thu, 13 Sep 2012 14:46:28 -0700
Subject: [PATCH] Fix segfault in dtc when empty input file is given.

Prior to this change, an empty input file would cause a segfault, because
yylloc had never been initialized. There was never any characters for the
lexer to match, so YY_USER_ACTION was never executed before the parse error
was detected.

When the parser printed the error message, it tried to include the name of
the file, but the structure holding the file name (yylloc.file, referenced
as pos->file) had never been initialized.

Without the fix:

$ ./dtc /dev/null
DTC: dts->dts  on file "/dev/null"
Segmentation fault (core dumped)

$ gdb dtc core
Program terminated with signal 11, Segmentation fault.
    at scripts/dtc/srcpos.c:194
194			fname = pos->file->name;
(gdb) bt
    at scripts/dtc/srcpos.c:194
    fmt=0x40d769 "%s", va=0x7fffbf027148) at scripts/dtc/srcpos.c:220
    at scripts/dtc/dtc-parser.tab.c:1920
    at scripts/dtc/treesource.c:38
    at scripts/dtc/dtc.c:203
(gdb) p *pos
$1 = {first_line = 0, first_column = 0, last_line = 0, last_column = 0,
  file = 0x0}

With the fix:

$ ./dtc /dev/null
DTC: dts->dts  on file "/dev/null"
Error: /dev/null:1.1 syntax error
FATAL ERROR: Unable to parse input tree

Signed-off-by: Markus Mayer <mmayer@broadcom.com>
---
 scripts/dtc/treesource.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/scripts/dtc/treesource.c b/scripts/dtc/treesource.c
index c09aafa..b461b88 100644
--- a/scripts/dtc/treesource.c
+++ b/scripts/dtc/treesource.c
@@ -29,11 +29,15 @@ int treesource_error;
 
 struct boot_info *dt_from_source(const char *fname)
 {
+	extern YYLTYPE yylloc;
+
 	the_boot_info = NULL;
 	treesource_error = 0;
 
 	srcfile_push(fname);
 	yyin = current_srcfile->f;
+	/* Initialize yylloc->file to avoid segfault on empty input */
+	srcpos_update(&yylloc, NULL, 0);
 
 	if (yyparse() != 0)
 		die("Unable to parse input tree\n");
-- 
1.7.5.4

