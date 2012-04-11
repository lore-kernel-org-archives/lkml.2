Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965744Ab2DKXdl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 19:33:41 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45547 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965706Ab2DKX3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 19:29:04 -0400
Message-Id: <20120411231312.375051591@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Wed, 11 Apr 2012 16:13:36 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jan Beulich <jbeulich@novell.com>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: [ 29/42] modpost: Fix modposts license checking V3
In-Reply-To: <20120411231443.GA808@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alessio Igor Bogani <abogani@kernel.org>

commit 62a2635610dbc83c5e8d724e00941eee4d18c186 upstream.

The commit f02e8a6 sorts symbols placing each of them in its own elf section.
The sorting and merging into the canonical sections are done by the linker.
Unfortunately modpost to generate Module.symvers file parses vmlinux
(already linked) and all modules object files (which aren't linked yet).
These aren't sanitized by the linker yet. That breaks modpost that can't
detect license properly for modules. This patch makes modpost aware of
the new exported symbols structure.

Thanks to Arnaud Lacombe <lacombar@gmail.com> and Anders Kaseorg
<andersk@ksplice.com> for providing useful suggestions about code.

This work was supported by a hardware donation from the CE Linux Forum.

Reported-by: Jan Beulich <jbeulich@novell.com>
Signed-off-by: Alessio Igor Bogani <abogani@kernel.org>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 scripts/mod/modpost.c |   29 ++++++++++++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -254,6 +254,28 @@ static enum export export_no(const char
 	return export_unknown;
 }
 
+static const char *sec_name(struct elf_info *elf, int secindex);
+
+#define strstarts(str, prefix) (strncmp(str, prefix, strlen(prefix)) == 0)
+
+static enum export export_from_secname(struct elf_info *elf, unsigned int sec)
+{
+	const char *secname = sec_name(elf, sec);
+
+	if (strstarts(secname, "___ksymtab+"))
+		return export_plain;
+	else if (strstarts(secname, "___ksymtab_unused+"))
+		return export_unused;
+	else if (strstarts(secname, "___ksymtab_gpl+"))
+		return export_gpl;
+	else if (strstarts(secname, "___ksymtab_unused_gpl+"))
+		return export_unused_gpl;
+	else if (strstarts(secname, "___ksymtab_gpl_future+"))
+		return export_gpl_future;
+	else
+		return export_unknown;
+}
+
 static enum export export_from_sec(struct elf_info *elf, unsigned int sec)
 {
 	if (sec == elf->export_sec)
@@ -563,7 +585,12 @@ static void handle_modversions(struct mo
 			       Elf_Sym *sym, const char *symname)
 {
 	unsigned int crc;
-	enum export export = export_from_sec(info, get_secindex(info, sym));
+	enum export export;
+
+	if (!is_vmlinux(mod->name) && strncmp(symname, "__ksymtab", 9) == 0)
+		export = export_from_secname(info, get_secindex(info, sym));
+	else
+		export = export_from_sec(info, get_secindex(info, sym));
 
 	switch (sym->st_shndx) {
 	case SHN_COMMON:


