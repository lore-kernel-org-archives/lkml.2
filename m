Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964780Ab2CINdz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 08:33:55 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58821 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932250Ab2CINdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 08:33:54 -0500
Date: Fri, 9 Mar 2012 05:33:19 -0800
From: tip-bot for Stephane Eranian <eranian@google.com>
Message-ID: <tip-a5aabdacde9caff54886ae454e0fad2f26929753@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1331246868-19905-2-git-send-email-eranian@google.com>
References: <1331246868-19905-2-git-send-email-eranian@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/hw-branch-sampling] perf record:
  Provide default branch stack sampling mode option
Git-Commit-ID: a5aabdacde9caff54886ae454e0fad2f26929753
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 09 Mar 2012 05:33:41 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a5aabdacde9caff54886ae454e0fad2f26929753
Gitweb:     http://git.kernel.org/tip/a5aabdacde9caff54886ae454e0fad2f26929753
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Thu, 8 Mar 2012 23:47:45 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 9 Mar 2012 08:26:07 +0100

perf record: Provide default branch stack sampling mode option

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

or:

 $ perf record --branch-filter any foo

For more specific filtering:

 $ perf record --branch-filter ind_call,u foo

Signed-off-by: Stephane Eranian <eranian@google.com>
Cc: peterz@infradead.org
Cc: acme@redhat.com
Cc: asharma@fb.com
Cc: ravitillo@lbl.gov
Cc: vweaver1@eecs.utk.edu
Cc: khandual@linux.vnet.ibm.com
Cc: dsahern@gmail.com
Link: http://lkml.kernel.org/r/1331246868-19905-2-git-send-email-eranian@google.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
@@ -169,13 +174,13 @@ following filters are defined:
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
