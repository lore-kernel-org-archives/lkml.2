Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752437Ab2KBFu2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 01:50:28 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:56459 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751427Ab2KBFu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 01:50:26 -0400
X-AuditID: 9c93016f-b7c7bae000000eb7-94-50935f20ed3e
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>, David Ahern <dsahern@gmail.com>,
        Irina Tirdea <irina.tirdea@gmail.com>
Subject: [PATCH RESEND 1/3] perf tools: Use normalized arch name for searching objdump path
Date: Fri,  2 Nov 2012 14:50:04 +0900
Message-Id: <1351835406-15208-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

David reported that perf report for i686 target data on x86_64 host
failed to work because it tried to find out cross-compiled objdump.

However objdump for x86_64 is compatible to i686 so that it doesn't
need to do it at all.  To prevent similar artifacts, normalize arch
name when comparing host and file architectures.

Reported-by: David Ahern <dsahern@gmail.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Irina Tirdea <irina.tirdea@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/arch/common.c | 40 +++++++++++++++++++++++++++++++++-------
 1 file changed, 33 insertions(+), 7 deletions(-)

diff --git a/tools/perf/arch/common.c b/tools/perf/arch/common.c
index 2367b253f039..5683529135b1 100644
--- a/tools/perf/arch/common.c
+++ b/tools/perf/arch/common.c
@@ -93,16 +93,46 @@ static int lookup_triplets(const char *const *triplets, const char *name)
 	return -1;
 }
 
+/*
+ * Return architecture name in a normalized form.
+ * The conversion logic comes from the Makefile.
+ */
+static const char *normalize_arch(char *arch)
+{
+	if (!strcmp(arch, "x86_64"))
+		return "x86";
+	if (arch[0] == 'i' && arch[2] == '8' && arch[3] == '6')
+		return "x86";
+	if (!strcmp(arch, "sun4u") || !strncmp(arch, "sparc", 5))
+		return "sparc";
+	if (!strncmp(arch, "arm", 3) || !strcmp(arch, "sa110"))
+		return "arm";
+	if (!strncmp(arch, "s390", 4))
+		return "s390";
+	if (!strncmp(arch, "parisc", 6))
+		return "parisc";
+	if (!strncmp(arch, "powerpc", 7) || !strncmp(arch, "ppc", 3))
+		return "powerpc";
+	if (!strncmp(arch, "mips", 4))
+		return "mips";
+	if (!strncmp(arch, "sh", 2) && isdigit(arch[2]))
+		return "sh";
+
+	return arch;
+}
+
 static int perf_session_env__lookup_binutils_path(struct perf_session_env *env,
 						  const char *name,
 						  const char **path)
 {
 	int idx;
-	char *arch, *cross_env;
+	const char *arch, *cross_env;
 	struct utsname uts;
 	const char *const *path_list;
 	char *buf = NULL;
 
+	arch = normalize_arch(env->arch);
+
 	if (uname(&uts) < 0)
 		goto out;
 
@@ -110,7 +140,7 @@ static int perf_session_env__lookup_binutils_path(struct perf_session_env *env,
 	 * We don't need to try to find objdump path for native system.
 	 * Just use default binutils path (e.g.: "objdump").
 	 */
-	if (!strcmp(uts.machine, env->arch))
+	if (!strcmp(normalize_arch(uts.machine), arch))
 		goto out;
 
 	cross_env = getenv("CROSS_COMPILE");
@@ -127,8 +157,6 @@ static int perf_session_env__lookup_binutils_path(struct perf_session_env *env,
 		free(buf);
 	}
 
-	arch = env->arch;
-
 	if (!strcmp(arch, "arm"))
 		path_list = arm_triplets;
 	else if (!strcmp(arch, "powerpc"))
@@ -139,9 +167,7 @@ static int perf_session_env__lookup_binutils_path(struct perf_session_env *env,
 		path_list = s390_triplets;
 	else if (!strcmp(arch, "sparc"))
 		path_list = sparc_triplets;
-	else if (!strcmp(arch, "x86") || !strcmp(arch, "i386") ||
-		 !strcmp(arch, "i486") || !strcmp(arch, "i586") ||
-		 !strcmp(arch, "i686"))
+	else if (!strcmp(arch, "x86"))
 		path_list = x86_triplets;
 	else if (!strcmp(arch, "mips"))
 		path_list = mips_triplets;
-- 
1.7.11.7

