Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932347Ab2CIN3G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 08:29:06 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58745 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932152Ab2CIN3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 08:29:03 -0500
Date: Fri, 9 Mar 2012 05:28:27 -0800
From: tip-bot for Roberto Agostino Vitillo <ravitillo@lbl.gov>
Message-ID: <tip-bdfebd848f2a14e639031a0b0e61d7c7ee5e5fd2@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@redhat.com, ravitillo@lbl.gov, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, ravitillo@lbl.gov, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <1328826068-11713-13-git-send-email-eranian@google.com>
References: <1328826068-11713-13-git-send-email-eranian@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/hw-branch-sampling] perf record:
  Add support for sampling taken branch
Git-Commit-ID: bdfebd848f2a14e639031a0b0e61d7c7ee5e5fd2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 09 Mar 2012 05:28:54 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bdfebd848f2a14e639031a0b0e61d7c7ee5e5fd2
Gitweb:     http://git.kernel.org/tip/bdfebd848f2a14e639031a0b0e61d7c7ee5e5fd2
Author:     Roberto Agostino Vitillo <ravitillo@lbl.gov>
AuthorDate: Thu, 9 Feb 2012 23:21:02 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 9 Mar 2012 08:26:05 +0100

perf record: Add support for sampling taken branch

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
 - hv: only when the branch target is in the hypervisor

Filters can be combined by passing a comma separated list
to the option:

$ perf record -b any_call,u -e cycles:u branchy

Signed-off-by: Roberto Agostino Vitillo <ravitillo@lbl.gov>
Signed-off-by: Stephane Eranian <eranian@google.com>
Cc: peterz@infradead.org
Cc: acme@redhat.com
Cc: robert.richter@amd.com
Cc: ming.m.lin@intel.com
Cc: andi@firstfloor.org
Cc: asharma@fb.com
Cc: vweaver1@eecs.utk.edu
Cc: khandual@linux.vnet.ibm.com
Cc: dsahern@gmail.com
Link: http://lkml.kernel.org/r/1328826068-11713-13-git-send-email-eranian@google.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/Documentation/perf-record.txt |   25 ++++++++++
 tools/perf/builtin-record.c              |   74 ++++++++++++++++++++++++++++++
 tools/perf/perf.h                        |    1 +
 tools/perf/util/evsel.c                  |    4 ++
 4 files changed, 104 insertions(+), 0 deletions(-)

diff --git a/tools/perf/Documentation/perf-record.txt b/tools/perf/Documentation/perf-record.txt
index a5766b4..60bddaf 100644
--- a/tools/perf/Documentation/perf-record.txt
+++ b/tools/perf/Documentation/perf-record.txt
@@ -152,6 +152,31 @@ an empty cgroup (monitor all the time) using, e.g., -G foo,,bar. Cgroups must ha
 corresponding events, i.e., they always refer to events defined earlier on the command
 line.
 
+-b::
+--branch-stack::
+Enable taken branch stack sampling. Each sample captures a series of consecutive
+taken branches. The number of branches captured with each sample depends on the
+underlying hardware, the type of branches of interest, and the executed code.
+It is possible to select the types of branches captured by enabling filters. The
+following filters are defined:
+
+        -  any :  any type of branches
+        - any_call: any function call or system call
+        - any_ret: any function return or system call return
+        - any_ind: any indirect branch
+        - u:  only when the branch target is at the user level
+        - k: only when the branch target is in the kernel
+        - hv: only when the target is at the hypervisor level
+
++
+At least one of any, any_call, any_ret, any_ind must be provided. The privilege levels may
+be ommitted, in which case, the privilege levels of the associated event are applied to the
+branch filter. Both kernel (k) and hypervisor (hv) privilege levels are subject to
+permissions.  When sampling on multiple events, branch stack sampling is enabled for all
+the sampling events. The sampled branch type is the same for all events.
+Note that taken branch sampling may not be available on all processors.
+The various filters must be specified as a comma separated list: -b any_ret,u,k
+
 SEE ALSO
 --------
 linkperf:perf-stat[1], linkperf:perf-list[1]
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 75d230f..1c49d4e 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -638,6 +638,77 @@ out_delete_session:
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
+static const struct branch_mode branch_modes[] = {
+	BRANCH_OPT("u", PERF_SAMPLE_BRANCH_USER),
+	BRANCH_OPT("k", PERF_SAMPLE_BRANCH_KERNEL),
+	BRANCH_OPT("hv", PERF_SAMPLE_BRANCH_HV),
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
+#define ONLY_PLM \
+	(PERF_SAMPLE_BRANCH_USER	|\
+	 PERF_SAMPLE_BRANCH_KERNEL	|\
+	 PERF_SAMPLE_BRANCH_HV)
+
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
+		error("need at least one branch type with -b\n");
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
@@ -727,6 +798,9 @@ const struct option record_options[] = {
 		     "monitor event in cgroup name only",
 		     parse_cgroups),
 	OPT_STRING('u', "uid", &record.uid_str, "user", "user to profile"),
+	OPT_CALLBACK('b', "branch-stack", &record.opts.branch_stack,
+		     "branch mode mask", "branch stack sampling modes",
+		     parse_branch_stack),
 	OPT_END()
 };
 
diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index 358f401..eec392e 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -222,6 +222,7 @@ struct perf_record_opts {
 	unsigned int freq;
 	unsigned int mmap_pages;
 	unsigned int user_freq;
+	int	     branch_stack;
 	u64	     default_interval;
 	u64	     user_interval;
 	const char   *cpu_list;
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index a1fd1cd..f421f7c 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -126,6 +126,10 @@ void perf_evsel__config(struct perf_evsel *evsel, struct perf_record_opts *opts)
 		attr->watermark = 0;
 		attr->wakeup_events = 1;
 	}
+	if (opts->branch_stack) {
+		attr->sample_type	|= PERF_SAMPLE_BRANCH_STACK;
+		attr->branch_sample_type = opts->branch_stack;
+	}
 
 	attr->mmap = track;
 	attr->comm = track;
