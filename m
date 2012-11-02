Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760369Ab2KBBMN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 21:12:13 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:64069 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755382Ab2KBBMB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 21:12:01 -0400
X-AuditID: 9c930179-b7c8bae000003559-08-50931ddebcbe
From: Namhyung Kim <namhyung@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Irina Tirdea <irina.tirdea@gmail.com>
Subject: Re: why is perf-report asking for objdump path?
References: <5092E51A.8040200@gmail.com>
Date: Fri, 02 Nov 2012 10:11:58 +0900
In-Reply-To: <5092E51A.8040200@gmail.com> (David Ahern's message of "Thu, 01
	Nov 2012 15:09:46 -0600")
Message-ID: <87sj8s4xlt.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Thu, 01 Nov 2012 15:09:46 -0600, David Ahern wrote:
> $ /tmp/pbuild/perf report -i perf.data --kallsyms kallsyms
> Error:
> Please install objdump for i686.
> You can add it to PATH, set CROSS_COMPILE or override the default
> using --objdump.
>
> And worse it refuses to run without it. If I was running the annotate
> command I could understand the request -- but this is the report path.

Agreed.  It should not affect when no annotation was used.

>
> Furthermore objdump exists:
>
> $ which objdump
> /usr/bin/objdump
>
> yes, the file was created on an i686 target, but I should be able to
> use the x86_64 host objdump if I were doing an annotate.

Could you test the below patch?  It'd great if you can do it in a
reverse situation - using x86_64 target on i686 host.


>From f0a9d6303f83452c8b6f81081abae8fdf9c81778 Mon Sep 17 00:00:00 2001
From: Namhyung Kim <namhyung.kim@lge.com>
Date: Fri, 2 Nov 2012 09:48:17 +0900
Subject: [PATCH] perf tools: Use normalized arch name for searching objdump
 path

David reported that perf report for i686 target data on x86_64 host
failed to work because it tried to find out cross-compiled objdump.

However objdump for x86_64 is compatible to i686 so that it doesn't
need to do it at all.  To prevent similar artifacts, normalize arch
name when comparing host and file architectures.

Reported-by: David Ahern <dsahern@gmail.com>
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

