Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756587Ab2KNHWw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 02:22:52 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43976 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755314Ab2KNHWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 02:22:50 -0500
Date: Tue, 13 Nov 2012 23:22:09 -0800
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-48ed0ece1b8063313284812ef048b26c3c4250af@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, dsahern@gmail.com,
        irina.tirdea@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, irina.tirdea@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1351835406-15208-1-git-send-email-namhyung@kernel.org>
References: <1351835406-15208-1-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Use normalized arch name for searching objdump path
Git-Commit-ID: 48ed0ece1b8063313284812ef048b26c3c4250af
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 13 Nov 2012 23:22:16 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  48ed0ece1b8063313284812ef048b26c3c4250af
Gitweb:     http://git.kernel.org/tip/48ed0ece1b8063313284812ef048b26c3c4250af
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Fri, 2 Nov 2012 14:50:04 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 5 Nov 2012 14:03:58 -0300

perf tools: Use normalized arch name for searching objdump path

David reported that perf report for i686 target data on x86_64 host
failed to work because it tried to find out cross-compiled objdump.

However objdump for x86_64 is compatible to i686 so that it doesn't need
to do it at all.  To prevent similar artifacts, normalize arch name when
comparing host and file architectures.

Reported-by: David Ahern <dsahern@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Reviewed-by: David Ahern <dsahern@gmail.com>
Tested-by: David Ahern <dsahern@gmail.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Irina Tirdea <irina.tirdea@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1351835406-15208-1-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/arch/common.c |   40 +++++++++++++++++++++++++++++++++-------
 1 files changed, 33 insertions(+), 7 deletions(-)

diff --git a/tools/perf/arch/common.c b/tools/perf/arch/common.c
index 2367b25..5683529 100644
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
