Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619Ab0LVLd0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 06:33:26 -0500
Received: from hera.kernel.org ([140.211.167.34]:49469 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752396Ab0LVLdX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 06:33:23 -0500
Date: Wed, 22 Dec 2010 11:32:59 GMT
From: tip-bot for Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
        masami.hiramatsu.pt@hitachi.com, rostedt@goodmis.org,
        srikar@linux.vnet.ibm.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        masami.hiramatsu.pt@hitachi.com, rostedt@goodmis.org,
        srikar@linux.vnet.ibm.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20101217131218.24123.62424.stgit@ltc236.sdl.hitachi.co.jp>
References: <20101217131218.24123.62424.stgit@ltc236.sdl.hitachi.co.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf probe: Fix to support libdwfl older than 0.148
Message-ID: <tip-3b4694de3596edac0159524b15a4a06945875421@git.kernel.org>
Git-Commit-ID: 3b4694de3596edac0159524b15a4a06945875421
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 22 Dec 2010 11:33:00 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3b4694de3596edac0159524b15a4a06945875421
Gitweb:     http://git.kernel.org/tip/3b4694de3596edac0159524b15a4a06945875421
Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
AuthorDate: Fri, 17 Dec 2010 22:12:18 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 21 Dec 2010 19:24:57 -0200

perf probe: Fix to support libdwfl older than 0.148

Since the libdwfl library before 0.148 fails to analyze live kernel debuginfo,
'perf probe --list' compiled with those old libdwfl sometimes crashes.

To avoid that bug, perf probe does not use libdwfl's live kernel analysis
routine when it is compiled with older libdwfl.

Side effect: perf with older libdwfl doesn't support listing probe in modules
with source code line. Those could be shown by symbol+offset.

Cc: 2nddept-manager@sdl.hitachi.co.jp
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <20101217131218.24123.62424.stgit@ltc236.sdl.hitachi.co.jp>
Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/probe-finder.c |   85 ++++++++++++++++++++++++++--------------
 1 files changed, 55 insertions(+), 30 deletions(-)

diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index 3991d73..ddf4d45 100644
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
 
