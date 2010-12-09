Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756738Ab0LIXhF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 18:37:05 -0500
Received: from hera.kernel.org ([140.211.167.34]:56386 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755715Ab0LIXhD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 18:37:03 -0500
Date: Thu, 9 Dec 2010 23:36:45 GMT
From: tip-bot for David Ahern <daahern@cisco.com>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@redhat.com, tglx@linutronix.de, daahern@cisco.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, tglx@linutronix.de, daahern@cisco.com
In-Reply-To: <1291775986-16475-1-git-send-email-daahern@cisco.com>
References: <1291775986-16475-1-git-send-email-daahern@cisco.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf report: Allow user to specify path to kallsyms file
Message-ID: <tip-b226a5a72901bc9c73d639ea2e53e6c304bf3b74@git.kernel.org>
Git-Commit-ID: b226a5a72901bc9c73d639ea2e53e6c304bf3b74
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 09 Dec 2010 23:36:46 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b226a5a72901bc9c73d639ea2e53e6c304bf3b74
Gitweb:     http://git.kernel.org/tip/b226a5a72901bc9c73d639ea2e53e6c304bf3b74
Author:     David Ahern <daahern@cisco.com>
AuthorDate: Tue, 7 Dec 2010 19:39:46 -0700
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 9 Dec 2010 11:07:07 -0200

perf report: Allow user to specify path to kallsyms file

This is useful for analyzing a perf data file on a different system than
the one data was collected on and still include symbols from loaded
kernel modules in the output.

Commiter note: Updated the man page accordingly.

LKML-Reference: <1291775986-16475-1-git-send-email-daahern@cisco.com>
Signed-off-by: David Ahern <daahern@cisco.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-report.txt |    3 +++
 tools/perf/builtin-report.c              |    2 ++
 tools/perf/util/symbol.c                 |    9 +++++++--
 tools/perf/util/symbol.h                 |    1 +
 4 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/tools/perf/Documentation/perf-report.txt b/tools/perf/Documentation/perf-report.txt
index 59a1f57..fefea77 100644
--- a/tools/perf/Documentation/perf-report.txt
+++ b/tools/perf/Documentation/perf-report.txt
@@ -104,6 +104,9 @@ OPTIONS
 --vmlinux=<file>::
         vmlinux pathname
 
+--kallsyms=<file>::
+        kallsyms pathname
+
 -m::
 --modules::
         Load module symbols. WARNING: This should only be used with -k and
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 904519f..b6a2a89 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -443,6 +443,8 @@ static const struct option options[] = {
 		    "dump raw trace in ASCII"),
 	OPT_STRING('k', "vmlinux", &symbol_conf.vmlinux_name,
 		   "file", "vmlinux pathname"),
+	OPT_STRING(0, "kallsyms", &symbol_conf.kallsyms_name,
+		   "file", "kallsyms pathname"),
 	OPT_BOOLEAN('f', "force", &force, "don't complain, do it"),
 	OPT_BOOLEAN('m', "modules", &symbol_conf.use_modules,
 		    "load module symbols - WARNING: use only with -k and LIVE kernel"),
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index a348906..f40c076 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1830,8 +1830,8 @@ static int dso__load_kernel_sym(struct dso *self, struct map *map,
 	const char *kallsyms_filename = NULL;
 	char *kallsyms_allocated_filename = NULL;
 	/*
-	 * Step 1: if the user specified a vmlinux filename, use it and only
-	 * it, reporting errors to the user if it cannot be used.
+	 * Step 1: if the user specified a kallsyms or vmlinux filename, use
+	 * it and only it, reporting errors to the user if it cannot be used.
 	 *
 	 * For instance, try to analyse an ARM perf.data file _without_ a
 	 * build-id, or if the user specifies the wrong path to the right
@@ -1844,6 +1844,11 @@ static int dso__load_kernel_sym(struct dso *self, struct map *map,
 	 * validation in dso__load_vmlinux and will bail out if they don't
 	 * match.
 	 */
+	if (symbol_conf.kallsyms_name != NULL) {
+		kallsyms_filename = symbol_conf.kallsyms_name;
+		goto do_kallsyms;
+	}
+
 	if (symbol_conf.vmlinux_name != NULL) {
 		err = dso__load_vmlinux(self, map,
 					symbol_conf.vmlinux_name, filter);
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 038f220..12defbe 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -72,6 +72,7 @@ struct symbol_conf {
 			show_cpu_utilization,
 			initialized;
 	const char	*vmlinux_name,
+			*kallsyms_name,
 			*source_prefix,
 			*field_sep;
 	const char	*default_guest_vmlinux_name,
