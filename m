Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753049Ab1GNGvQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 02:51:16 -0400
Received: from mail1.elettra.trieste.it ([140.105.4.201]:30547 "EHLO
	elettra.trieste.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751084Ab1GNGvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 02:51:14 -0400
From: Alessio Igor Bogani <abogani@kernel.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Jan Beulich <jbeulich@novell.com>, Kbuild <linux-kbuild@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Tim Bird <tim.bird@am.sony.com>,
        Anders Kaseorg <andersk@ksplice.com>,
        Arnaud Lacombe <lacombar@gmail.com>,
        Alessio Igor Bogani <abogani@kernel.org>
Subject: [PATCH] modpost: Fix modpost's license checking V3
Date: Thu, 14 Jul 2011 08:51:16 +0200
Message-Id: <1310626276-4541-1-git-send-email-abogani@kernel.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <CACqU3MUXAOMGQ1nzUrtYPEQAC3U-nuq3YurtNJJLS1hft4ROGA@mail.gmail.com>
References: <CACqU3MUXAOMGQ1nzUrtYPEQAC3U-nuq3YurtNJJLS1hft4ROGA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
 scripts/mod/modpost.c |   29 ++++++++++++++++++++++++++++-
 1 files changed, 28 insertions(+), 1 deletions(-)

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 413c536..a509ff8 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -254,6 +254,28 @@ static enum export export_no(const char *s)
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
@@ -563,7 +585,12 @@ static void handle_modversions(struct module *mod, struct elf_info *info,
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
-- 
1.7.4.1

