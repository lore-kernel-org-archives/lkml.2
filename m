Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755136Ab1GIXOD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jul 2011 19:14:03 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:39580 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755067Ab1GIXOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jul 2011 19:14:00 -0400
From: Alessio Igor Bogani <abogani@kernel.org>
To: Rusty Russell <rusty@rustcorp.com.au>, Jan Beulich <JBeulich@novell.com>
Cc: Kbuild <linux-kbuild@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Tim Bird <tim.bird@am.sony.com>, Anders Kaseorg <andersk@ksplice.com>,
        Alessio Igor Bogani <abogani@kernel.org>
Subject: [PATCH] modpost: Fix modpost's license checking
Date: Sun, 10 Jul 2011 01:13:30 +0200
Message-Id: <1310253210-1221-1-git-send-email-abogani@kernel.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <CAPk1OjH4Otd-+q3tD6KYx9ZBT=zenYBvpQMm8LthPd1D1c+AKg@mail.gmail.com>
References: <CAPk1OjH4Otd-+q3tD6KYx9ZBT=zenYBvpQMm8LthPd1D1c+AKg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The commit f02e8a6 sorts symbols placing each of them in its own elf section.
The sorting and merging into the canonical sections are done by the linker.
Unfortunately modpost to generate Module.symvers file parses vmlinux
(already linked) and all modules object files (which aren't linked yet).
These aren't sanitized by the linker yet. That breaks modpost that can't
detect license properly for modules.

This patch makes modpost aware of  the new exported symbols structure.

This work was supported by a hardware donation from the CE Linux Forum.

Signed-off-by: Alessio Igor Bogani <abogani@kernel.org>
---
 scripts/mod/modpost.c |   27 ++++++++++++++++++++++++++-
 1 files changed, 26 insertions(+), 1 deletions(-)

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 413c536..f41283c 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -254,6 +254,26 @@ static enum export export_no(const char *s)
 	return export_unknown;
 }
 
+static const char *sec_name(struct elf_info *elf, int secindex);
+
+static enum export export_from_secname(struct elf_info *elf, unsigned int sec)
+{
+	const char *secname = sec_name(elf, sec);
+
+	if (strncmp(secname, "___ksymtab+", 11) == 0)
+		return export_plain;
+	else if (strncmp(secname, "___ksymtab_unused+", 18) == 0)
+		return export_unused;
+	else if (strncmp(secname, "___ksymtab_gpl+", 15) == 0)
+		return export_gpl;
+	else if (strncmp(secname, "___ksymtab_unused_gpl+", 22) == 0)
+		return export_unused_gpl;
+	else if (strncmp(secname, "___ksymtab_gpl_future+", 22) == 0)
+		return export_gpl_future;
+	else
+		return export_unknown;
+}
+
 static enum export export_from_sec(struct elf_info *elf, unsigned int sec)
 {
 	if (sec == elf->export_sec)
@@ -563,7 +583,12 @@ static void handle_modversions(struct module *mod, struct elf_info *info,
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

