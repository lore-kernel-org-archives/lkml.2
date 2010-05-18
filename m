Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753833Ab0ERB6m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 21:58:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:52262 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753229Ab0ERB6k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 21:58:40 -0400
Date: Tue, 18 May 2010 01:57:38 GMT
From: tip-bot for Masami Hiramatsu <mhiramat@redhat.com>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
       hpa@zytor.com, mingo@redhat.com, robert.richter@amd.com,
       tglx@linutronix.de, mhiramat@redhat.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
       linux-kernel@vger.kernel.org, acme@redhat.com, robert.richter@amd.com,
       tglx@linutronix.de, mhiramat@redhat.com, mingo@elte.hu
In-Reply-To: <20100510171207.26029.97604.stgit@localhost6.localdomain6>
References: <20100510171207.26029.97604.stgit@localhost6.localdomain6>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf probe: Don't compile CFI related code if elfutils is old
Message-ID: <tip-7752f1b096e13991f20b59fd11ba73da3809d93c@git.kernel.org>
Git-Commit-ID: 7752f1b096e13991f20b59fd11ba73da3809d93c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 18 May 2010 01:57:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7752f1b096e13991f20b59fd11ba73da3809d93c
Gitweb:     http://git.kernel.org/tip/7752f1b096e13991f20b59fd11ba73da3809d93c
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Mon, 10 May 2010 13:12:07 -0400
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 17 May 2010 22:13:51 -0300

perf probe: Don't compile CFI related code if elfutils is old

Check elfutils version, and if it is old don't compile CFI analysis code. This
allows to compile perf with old elfutils.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Tested-by: Stephane Eranian <eranian@google.com>
Reported-by: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>
LKML-Reference: <20100510171207.26029.97604.stgit@localhost6.localdomain6>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/probe-finder.c |    4 ++++
 tools/perf/util/probe-finder.h |    3 +++
 2 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index 562b144..93583eb 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -668,6 +668,7 @@ static int convert_probe_point(Dwarf_Die *sp_die, struct probe_finder *pf)
 	ret = dwarf_getlocation_addr(&fb_attr, pf->addr, &pf->fb_ops, &nops, 1);
 	if (ret <= 0 || nops == 0) {
 		pf->fb_ops = NULL;
+#if _ELFUTILS_PREREQ(0, 142)
 	} else if (nops == 1 && pf->fb_ops[0].atom == DW_OP_call_frame_cfa &&
 		   pf->cfi != NULL) {
 		Dwarf_Frame *frame;
@@ -677,6 +678,7 @@ static int convert_probe_point(Dwarf_Die *sp_die, struct probe_finder *pf)
 				   (uintmax_t)pf->addr);
 			return -ENOENT;
 		}
+#endif
 	}
 
 	/* Find each argument */
@@ -956,8 +958,10 @@ int find_kprobe_trace_events(int fd, struct perf_probe_event *pev,
 		return -EBADF;
 	}
 
+#if _ELFUTILS_PREREQ(0, 142)
 	/* Get the call frame information from this dwarf */
 	pf.cfi = dwarf_getcfi(dbg);
+#endif
 
 	off = 0;
 	line_list__init(&pf.lcache);
diff --git a/tools/perf/util/probe-finder.h b/tools/perf/util/probe-finder.h
index 66f1980..e1f61dc 100644
--- a/tools/perf/util/probe-finder.h
+++ b/tools/perf/util/probe-finder.h
@@ -29,6 +29,7 @@ extern int find_line_range(int fd, struct line_range *lr);
 
 #include <dwarf.h>
 #include <libdw.h>
+#include <version.h>
 
 struct probe_finder {
 	struct perf_probe_event	*pev;		/* Target probe event */
@@ -44,7 +45,9 @@ struct probe_finder {
 	struct list_head	lcache;		/* Line cache for lazy match */
 
 	/* For variable searching */
+#if _ELFUTILS_PREREQ(0, 142)
 	Dwarf_CFI		*cfi;		/* Call Frame Information */
+#endif
 	Dwarf_Op		*fb_ops;	/* Frame base attribute */
 	struct perf_probe_arg	*pvar;		/* Current target variable */
 	struct kprobe_trace_arg	*tvar;		/* Current result variable */
