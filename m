Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759122Ab2CHWsW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 17:48:22 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:52031 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759046Ab2CHWsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 17:48:12 -0500
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, acme@redhat.com, asharma@fb.com,
        ravitillo@lbl.gov, vweaver1@eecs.utk.edu, khandual@linux.vnet.ibm.com,
        dsahern@gmail.com
Subject: [PATCH 1/4] perf record: provide default branch stack sampling mode option
Date: Thu,  8 Mar 2012 23:47:45 +0100
Message-Id: <1331246868-19905-2-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1331246868-19905-1-git-send-email-eranian@google.com>
References: <1331246868-19905-1-git-send-email-eranian@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch chanegs the logic of the -b, --branch-stack options
of perf record.

Based on users' request, the patch provides a default filter
mode with the -b (or --branch-any) option.  With the option,
any type of taken branches is sampled.

With -j (or --branch-filter), the user can specify any
valid combination of branch types and privilege levels
if supported by the underlying hardware.

The -b (--branch any) is a shortcut for: --branch-filter any.

$ perf record -b foo
or
$ perf record --branch-filter any foo

For more specific filtering:
$ perf record --branch-filter ind_call,u foo

Signed-off-by: Stephane Eranian <eranian@google.com>
---
 tools/perf/Documentation/perf-record.txt |   23 ++++++----
 tools/perf/builtin-record.c              |   68 +++++++++++++++++++-----------
 2 files changed, 57 insertions(+), 34 deletions(-)

diff --git a/tools/perf/Documentation/perf-record.txt b/tools/perf/Documentation/perf-record.txt
index 60bddaf..a1386b2 100644
--- a/tools/perf/Documentation/perf-record.txt
+++ b/tools/perf/Documentation/perf-record.txt
@@ -153,14 +153,19 @@ corresponding events, i.e., they always refer to events defined earlier on the c
 line.
 
 -b::
---branch-stack::
+--branch-any::
+Enable taken branch stack sampling. Any type of taken branch may be sampled.
+This is a shortcut for --branch-filter any. See --branch-filter for more infos.
+
+-j::
+--branch-filter::
 Enable taken branch stack sampling. Each sample captures a series of consecutive
 taken branches. The number of branches captured with each sample depends on the
 underlying hardware, the type of branches of interest, and the executed code.
 It is possible to select the types of branches captured by enabling filters. The
 following filters are defined:
 
-        -  any :  any type of branches
+        - any:  any type of branches
         - any_call: any function call or system call
         - any_ret: any function return or system call return
         - any_ind: any indirect branch
@@ -169,13 +174,13 @@ It is possible to select the types of branches captured by enabling filters. The
         - hv: only when the target is at the hypervisor level
 
 +
-At least one of any, any_call, any_ret, any_ind must be provided. The privilege levels may
-be ommitted, in which case, the privilege levels of the associated event are applied to the
-branch filter. Both kernel (k) and hypervisor (hv) privilege levels are subject to
-permissions.  When sampling on multiple events, branch stack sampling is enabled for all
-the sampling events. The sampled branch type is the same for all events.
-Note that taken branch sampling may not be available on all processors.
-The various filters must be specified as a comma separated list: -b any_ret,u,k
+The option requires at least one branch type among any, any_call, any_ret, ind_call.
+The privilege levels may be ommitted, in which case, the privilege levels of the associated
+event are applied to the branch filter. Both kernel (k) and hypervisor (hv) privilege
+levels are subject to permissions.  When sampling on multiple events, branch stack sampling
+is enabled for all the sampling events. The sampled branch type is the same for all events.
+The various filters must be specified as a comma separated list: --branch-filter any_ret,u,k
+Note that this feature may not be available on all processors.
 
 SEE ALSO
 --------
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 1c49d4e..a7c53a9 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -660,7 +660,7 @@ static const struct branch_mode branch_modes[] = {
 };
 
 static int
-parse_branch_stack(const struct option *opt, const char *str, int unset __used)
+parse_branch_stack(const struct option *opt, const char *str, int unset)
 {
 #define ONLY_PLM \
 	(PERF_SAMPLE_BRANCH_USER	|\
@@ -669,40 +669,53 @@ parse_branch_stack(const struct option *opt, const char *str, int unset __used)
 
 	uint64_t *mode = (uint64_t *)opt->value;
 	const struct branch_mode *br;
-	char *s, *os, *p;
+	char *s, *os = NULL, *p;
 	int ret = -1;
 
-	*mode = 0;
+	if (unset)
+		return 0;
 
-	/* because str is read-only */
-	s = os = strdup(str);
-	if (!s)
+	/*
+	 * cannot set it twice, -b + --branch-filter for instance
+	 */
+	if (*mode)
 		return -1;
 
-	for (;;) {
-		p = strchr(s, ',');
-		if (p)
-			*p = '\0';
-
-		for (br = branch_modes; br->name; br++) {
-			if (!strcasecmp(s, br->name))
-				break;
-		}
-		if (!br->name)
-			goto error;
+	/* str may be NULL in case no arg is passed to -b */
+	if (str) {
+		/* because str is read-only */
+		s = os = strdup(str);
+		if (!s)
+			return -1;
+
+		for (;;) {
+			p = strchr(s, ',');
+			if (p)
+				*p = '\0';
+
+			for (br = branch_modes; br->name; br++) {
+				if (!strcasecmp(s, br->name))
+					break;
+			}
+			if (!br->name) {
+				ui__warning("unknown branch filter %s,"
+					    " check man page\n", s);
+				goto error;
+			}
 
-		*mode |= br->mode;
+			*mode |= br->mode;
 
-		if (!p)
-			break;
+			if (!p)
+				break;
 
-		s = p + 1;
+			s = p + 1;
+		}
 	}
 	ret = 0;
 
+	/* default to any branch */
 	if ((*mode & ~ONLY_PLM) == 0) {
-		error("need at least one branch type with -b\n");
-		ret = -1;
+		*mode = PERF_SAMPLE_BRANCH_ANY;
 	}
 error:
 	free(os);
@@ -798,8 +811,13 @@ const struct option record_options[] = {
 		     "monitor event in cgroup name only",
 		     parse_cgroups),
 	OPT_STRING('u', "uid", &record.uid_str, "user", "user to profile"),
-	OPT_CALLBACK('b', "branch-stack", &record.opts.branch_stack,
-		     "branch mode mask", "branch stack sampling modes",
+
+	OPT_CALLBACK_NOOPT('b', "branch-any", &record.opts.branch_stack,
+		     "branch any", "sample any taken branches",
+		     parse_branch_stack),
+
+	OPT_CALLBACK('j', "branch-filter", &record.opts.branch_stack,
+		     "branch filter mask", "branch stack filter modes",
 		     parse_branch_stack),
 	OPT_END()
 };
-- 
1.7.4.1

