Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965055Ab1JFOun (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 10:50:43 -0400
Received: from smtp-out.google.com ([74.125.121.67]:23974 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965043Ab1JFOuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 10:50:39 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:from:to:cc:subject:date:message-id:x-mailer:
	in-reply-to:references:x-system-of-record;
	b=DelyzEZccwMcIOeY9HLKfjiaKbHz45ewTo1DsV5kEwrp8SGkWWxA7M0QxmodiiVYn
	hZ4FhBGtRghPIL4Zx8NQg==
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, acme@redhat.com, ming.m.lin@intel.com,
        andi@firstfloor.org, robert.richter@amd.com, ravitillo@lbl.gov
Subject: [PATCH 11/12] perf: add support for sampling taken branch to perf record
Date: Thu,  6 Oct 2011 16:49:14 +0200
Message-Id: <1317912555-9559-12-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1317912555-9559-1-git-send-email-eranian@google.com>
References: <1317912555-9559-1-git-send-email-eranian@google.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a new option to enable taken branch stack
sampling, i.e., leverage the PERF_SAMPLE_BRANCH_STACK feature
of perf_events.

There is a new option to active this mode: -b.
It is possible to pass a set of filters to select the type of
branches to sample.

The following filters are available:
- any : any type of branches
- any_call : any function call or system call
- any_ret : any function return or system call return
- any_ind : any indirect branch
- u:  only when the branch target is at the user level
- k: only when the branch target is in the kernel

Filters can be combined by passing a comma separated list
to the option:

$ perf record -b any_call,u -e cycles:u branchy

Signed-off-by: Roberto Agostino Vitillo <ravitillo@lbl.gov>
Signed-off-by: Stephane Eranian <eranian@google.com>
---
 tools/perf/Documentation/perf-record.txt |   18 +++++++
 tools/perf/builtin-record.c              |   75 ++++++++++++++++++++++++++++++
 2 files changed, 93 insertions(+), 0 deletions(-)

diff --git a/tools/perf/Documentation/perf-record.txt b/tools/perf/Documentation/perf-record.txt
index 5a520f8..ddc1999 100644
--- a/tools/perf/Documentation/perf-record.txt
+++ b/tools/perf/Documentation/perf-record.txt
@@ -148,6 +148,24 @@ an empty cgroup (monitor all the time) using, e.g., -G foo,,bar. Cgroups must ha
 corresponding events, i.e., they always refer to events defined earlier on the command
 line.
 
+-b::
+--branch-stack::
+Enable taken branch stack sampling. Each sample captures a series of consecutive
+taken branches. The number of branches captured with each sample depends on the
+underlying hardware, the type of branches of interested and the executed code.
+It is possible to filter the types of branches by enabling filters. The
+following filters are defined: any (any type of branches), any_call (any function
+call or system call), any_ret (any function return or system call return), any_ind
+(any indirect branch), u (only when the branch target is at the user level), k (only when
+the branch target is in the kernel). At least one of any, any_call, any_ret, any_ind
+must be provided. The privilege levels may be ommitted, in which case, the privilege
+levels of the associated event is applied to the branch filter. When sampling on multiple
+events, branch stack sampling is enabled for all the sampling events. The sampled branch
+type is the same for all events. The privilege levels are adjusted based on those of
+the associated event unless specified explicitly with this option. Note that taken
+branch sampling may not be available on all processors. The various filters must
+be specified as a comma separated list: -b any_ret,u,k
+
 SEE ALSO
 --------
 linkperf:perf-stat[1], linkperf:perf-list[1]
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index f4c3fbe..4464677 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -57,6 +57,7 @@ static pid_t			child_pid			=     -1;
 static bool			no_inherit			=  false;
 static enum write_mode_t	write_mode			= WRITE_FORCE;
 static bool			call_graph			=  false;
+static int			branch_stack			=  0;
 static bool			inherit_stat			=  false;
 static bool			no_samples			=  false;
 static bool			sample_address			=  false;
@@ -204,6 +205,11 @@ static void config_attr(struct perf_evsel *evsel, struct perf_evlist *evlist)
 	if (system_wide)
 		attr->sample_type	|= PERF_SAMPLE_CPU;
 
+	if (branch_stack) {
+		attr->sample_type	|= PERF_SAMPLE_BRANCH_STACK;
+		attr->branch_sample_type = branch_stack;
+	}
+
 	if (sample_id_all_avail &&
 	    (sample_time || system_wide || !no_inherit || cpu_list))
 		attr->sample_type	|= PERF_SAMPLE_TIME;
@@ -717,6 +723,72 @@ out_delete_session:
 	return err;
 }
 
+#define BRANCH_OPT(n, m) \
+	{ .name = n, .mode = (m) }
+
+#define BRANCH_END { .name = NULL }
+
+struct branch_mode {
+	const char *name;
+	int mode;
+};
+
+static const struct branch_mode branch_modes[]={
+	BRANCH_OPT("u", PERF_SAMPLE_BRANCH_USER),
+	BRANCH_OPT("k", PERF_SAMPLE_BRANCH_KERNEL),
+	BRANCH_OPT("any", PERF_SAMPLE_BRANCH_ANY),
+	BRANCH_OPT("any_call", PERF_SAMPLE_BRANCH_ANY_CALL),
+	BRANCH_OPT("any_ret", PERF_SAMPLE_BRANCH_ANY_RETURN),
+	BRANCH_OPT("ind_call", PERF_SAMPLE_BRANCH_IND_CALL),
+	BRANCH_END
+};
+
+static int
+parse_branch_stack(const struct option *opt, const char *str, int unset __used)
+{
+#define ONLY_PLM (PERF_SAMPLE_BRANCH_USER|PERF_SAMPLE_BRANCH_KERNEL)
+	uint64_t *mode = (uint64_t *)opt->value;
+	const struct branch_mode *br;
+	char *s, *os, *p;
+	int ret = -1;
+
+	*mode = 0;
+
+	/* because str is read-only */
+	s = os = strdup(str);
+	if (!s)
+		return -1;
+
+	for (;;) {
+		p = strchr(s, ',');
+		if (p)
+			*p = '\0';
+
+		for (br = branch_modes; br->name; br++) {
+			if (!strcasecmp(s, br->name))
+				break;
+		}
+		if (!br->name)
+			goto error;
+
+		*mode |= br->mode;
+
+		if (!p)
+			break;
+
+		s = p + 1;
+	}
+	ret = 0;
+
+	if ((*mode & ~ONLY_PLM) == 0) {
+		pr_warning("error: needs at least one branch type with -b\n");
+		ret = -1;
+	}
+error:
+	free(os);
+	return ret;
+}
+
 static const char * const record_usage[] = {
 	"perf record [<options>] [<command>]",
 	"perf record [<options>] -- <command> [<options>]",
@@ -777,6 +849,9 @@ const struct option record_options[] = {
 	OPT_CALLBACK('G', "cgroup", &evsel_list, "name",
 		     "monitor event in cgroup name only",
 		     parse_cgroups),
+	OPT_CALLBACK('b', "branch stack", &branch_stack, "branch mode mask",
+		     "branch stack sampling modes",
+		     parse_branch_stack),
 	OPT_END()
 };
 
-- 
1.7.4.1

