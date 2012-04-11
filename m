Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934068Ab2DKXbf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 19:31:35 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:53150 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965784Ab2DKX3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 19:29:36 -0400
Message-Id: <20120411231312.565020816@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Wed, 11 Apr 2012 16:13:37 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Frank Rowand <frank.rowand@am.sony.com>,
        Alessio Igor Bogani <abogani@kernel.org>
Subject: [ 30/42] modpost: Fix modpost license checking of vmlinux.o
In-Reply-To: <20120411231443.GA808@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frank Rowand <frank.rowand@am.sony.com>

commit 258f742635360175564e9470eb060ff4d4b984e7 upstream.

Commit f02e8a6596b7 ("module: Sort exported symbols") sorts symbols
placing each of them in its own elf section.  This sorting and merging
into the canonical sections are done by the linker.

Unfortunately modpost to generate Module.symvers file parses vmlinux.o
(which is not linked yet) and all modules object files (which aren't
linked yet).  These aren't sanitized by the linker yet.  That breaks
modpost that can't detect license properly for modules.

This patch makes modpost aware of the new exported symbols structure.

[ This above is a slightly corrected version of the explanation of the
  problem, copied from commit 62a2635610db ("modpost: Fix modpost's
  license checking V3").  That commit fixed the problem for module
  object files, but not for vmlinux.o.  This patch fixes modpost for
  vmlinux.o. ]

Signed-off-by: Frank Rowand <frank.rowand@am.sony.com>
Signed-off-by: Alessio Igor Bogani <abogani@kernel.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 scripts/mod/modpost.c |    7 +++++--
 scripts/mod/modpost.h |    1 +
 2 files changed, 6 insertions(+), 2 deletions(-)

--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -132,8 +132,10 @@ static struct module *new_module(char *m
 	/* strip trailing .o */
 	s = strrchr(p, '.');
 	if (s != NULL)
-		if (strcmp(s, ".o") == 0)
+		if (strcmp(s, ".o") == 0) {
 			*s = '\0';
+			mod->is_dot_o = 1;
+		}
 
 	/* add to list */
 	mod->name = p;
@@ -587,7 +589,8 @@ static void handle_modversions(struct mo
 	unsigned int crc;
 	enum export export;
 
-	if (!is_vmlinux(mod->name) && strncmp(symname, "__ksymtab", 9) == 0)
+	if ((!is_vmlinux(mod->name) || mod->is_dot_o) &&
+	    strncmp(symname, "__ksymtab", 9) == 0)
 		export = export_from_secname(info, get_secindex(info, sym));
 	else
 		export = export_from_sec(info, get_secindex(info, sym));
--- a/scripts/mod/modpost.h
+++ b/scripts/mod/modpost.h
@@ -113,6 +113,7 @@ struct module {
 	int has_cleanup;
 	struct buffer dev_table_buf;
 	char	     srcversion[25];
+	int is_dot_o;
 };
 
 struct elf_info {


