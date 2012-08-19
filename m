Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754936Ab2HSC7W (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 22:59:22 -0400
Received: from mga14.intel.com ([143.182.124.37]:59858 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753360Ab2HSC5f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 22:57:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,792,1336374000"; 
   d="scan'208";a="135817672"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, mmarek@suse.cz, linux-kbuild@vger.kernel.org,
        JBeulich@suse.com, akpm@linux-foundation.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 61/74] Kbuild, lto: Drop .number postfixes in modpost
Date: Sat, 18 Aug 2012 19:56:57 -0700
Message-Id: <1345345030-22211-62-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1345345030-22211-1-git-send-email-andi@firstfloor.org>
References: <1345345030-22211-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

LTO turns all global symbols effectively into statics. This
has the side effect that they all have a .NUMBER postfix to make
them unique. In modpost drop this postfix because it confuses
it.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 scripts/mod/modpost.c |   15 ++++++++++++++-
 scripts/mod/modpost.h |    2 +-
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index c797e95..ccd34ff 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -1696,6 +1696,19 @@ static void check_sec_ref(struct module *mod, const char *modname,
 	}
 }
 
+static char *remove_dot(char *s)
+{
+	char *end;
+	int n = strcspn(s, ".");
+
+	if (n > 0 && s[n] != 0) {
+		strtoul(s + n + 1, &end, 10);
+		if  (end > s + n + 1 && (*end == '.' || *end == 0))
+			s[n] = 0;
+	}
+	return s;
+}
+
 static void read_symbols(char *modname)
 {
 	const char *symname;
@@ -1734,7 +1747,7 @@ static void read_symbols(char *modname)
 	}
 
 	for (sym = info.symtab_start; sym < info.symtab_stop; sym++) {
-		symname = info.strtab + sym->st_name;
+		symname = remove_dot(info.strtab + sym->st_name);
 
 		handle_modversions(mod, &info, sym, symname);
 		handle_moddevtable(mod, &info, sym, symname);
diff --git a/scripts/mod/modpost.h b/scripts/mod/modpost.h
index 51207e4..168b43d 100644
--- a/scripts/mod/modpost.h
+++ b/scripts/mod/modpost.h
@@ -127,7 +127,7 @@ struct elf_info {
 	Elf_Section  export_gpl_sec;
 	Elf_Section  export_unused_gpl_sec;
 	Elf_Section  export_gpl_future_sec;
-	const char   *strtab;
+	char         *strtab;
 	char	     *modinfo;
 	unsigned int modinfo_len;
 
-- 
1.7.7.6

