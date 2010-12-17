Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754Ab0LQNRH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 08:17:07 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:51275 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754645Ab0LQNRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 08:17:05 -0500
X-AuditID: b753bd60-a3afaba000000f8d-8d-4d0b62cdbf3c
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH -tip 4/4] [BUGFIX]perf probe: Fix to support libdwfl older
	than 0.148
To: Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, 2nddept-manager@sdl.hitachi.co.jp,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
Date: Fri, 17 Dec 2010 22:12:18 +0900
Message-ID: <20101217131218.24123.62424.stgit@ltc236.sdl.hitachi.co.jp>
In-Reply-To: <20101217131149.24123.96128.stgit@ltc236.sdl.hitachi.co.jp>
References: <20101217131149.24123.96128.stgit@ltc236.sdl.hitachi.co.jp>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the libdwfl before 0.148 fails to analyze live
kernel debuginfo, 'perf probe --list' compiled with those
old libdwfl sometime crashes.

To avoid that bug, perf probe does not use libdwfl's live
kernel analysis routine when it is compiled with older libdwfl.

Side effect: perf with older libdwfl doesn't support
listing probe in modules with source code line. Those
could be shown by symbol+offset.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org
---

 tools/perf/util/probe-finder.c |   85 ++++++++++++++++++++++++++--------------
 1 files changed, 55 insertions(+), 30 deletions(-)

diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index 90b6292..ab83b6a 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -117,28 +117,6 @@ static void line_list__free(struct list_head *head)
 }
 
 /* Dwarf FL wrappers */
-
-static int __linux_kernel_find_elf(Dwfl_Module *mod,
-				   void **userdata,
-				   const char *module_name,
-				   Dwarf_Addr base,
-				   char **file_name, Elf **elfp)
-{
-	int fd;
-	const char *path = kernel_get_module_path(module_name);
-
-	if (path) {
-		fd = open(path, O_RDONLY);
-		if (fd >= 0) {
-			*file_name = strdup(path);
-			return fd;
-		}
-	}
-	/* If failed, try to call standard method */
-	return dwfl_linux_kernel_find_elf(mod, userdata, module_name, base,
-					  file_name, elfp);
-}
-
 static char *debuginfo_path;	/* Currently dummy */
 
 static const Dwfl_Callbacks offline_callbacks = {
@@ -151,14 +129,6 @@ static const Dwfl_Callbacks offline_callbacks = {
 	.find_elf = dwfl_build_id_find_elf,
 };
 
-static const Dwfl_Callbacks kernel_callbacks = {
-	.find_debuginfo = dwfl_standard_find_debuginfo,
-	.debuginfo_path = &debuginfo_path,
-
-	.find_elf = __linux_kernel_find_elf,
-	.section_address = dwfl_linux_kernel_module_section_address,
-};
-
 /* Get a Dwarf from offline image */
 static Dwarf *dwfl_init_offline_dwarf(int fd, Dwfl **dwflp, Dwarf_Addr *bias)
 {
@@ -185,6 +155,38 @@ error:
 	return dbg;
 }
 
+#if _ELFUTILS_PREREQ(0, 148)
+/* This method is buggy if elfutils is older than 0.148 */
+static int __linux_kernel_find_elf(Dwfl_Module *mod,
+				   void **userdata,
+				   const char *module_name,
+				   Dwarf_Addr base,
+				   char **file_name, Elf **elfp)
+{
+	int fd;
+	const char *path = kernel_get_module_path(module_name);
+
+	pr_debug2("Use file %s for %s\n", path, module_name);
+	if (path) {
+		fd = open(path, O_RDONLY);
+		if (fd >= 0) {
+			*file_name = strdup(path);
+			return fd;
+		}
+	}
+	/* If failed, try to call standard method */
+	return dwfl_linux_kernel_find_elf(mod, userdata, module_name, base,
+					  file_name, elfp);
+}
+
+static const Dwfl_Callbacks kernel_callbacks = {
+	.find_debuginfo = dwfl_standard_find_debuginfo,
+	.debuginfo_path = &debuginfo_path,
+
+	.find_elf = __linux_kernel_find_elf,
+	.section_address = dwfl_linux_kernel_module_section_address,
+};
+
 /* Get a Dwarf from live kernel image */
 static Dwarf *dwfl_init_live_kernel_dwarf(Dwarf_Addr addr, Dwfl **dwflp,
 					  Dwarf_Addr *bias)
@@ -205,11 +207,34 @@ static Dwarf *dwfl_init_live_kernel_dwarf(Dwarf_Addr addr, Dwfl **dwflp,
 	dbg = dwfl_addrdwarf(*dwflp, addr, bias);
 	/* Here, check whether we could get a real dwarf */
 	if (!dbg) {
+		pr_debug("Failed to find kernel dwarf at %lx\n",
+			 (unsigned long)addr);
 		dwfl_end(*dwflp);
 		*dwflp = NULL;
 	}
 	return dbg;
 }
+#else
+/* With older elfutils, this just support kernel module... */
+static Dwarf *dwfl_init_live_kernel_dwarf(Dwarf_Addr addr __used, Dwfl **dwflp,
+					  Dwarf_Addr *bias)
+{
+	int fd;
+	const char *path = kernel_get_module_path("kernel");
+
+	if (!path) {
+		pr_err("Failed to find vmlinux path\n");
+		return NULL;
+	}
+
+	pr_debug2("Use file %s for debuginfo\n", path);
+	fd = open(path, O_RDONLY);
+	if (fd < 0)
+		return NULL;
+
+	return dwfl_init_offline_dwarf(fd, dwflp, bias);
+}
+#endif
 
 /* Dwarf wrappers */
 

