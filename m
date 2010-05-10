Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755729Ab0EJRG5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 13:06:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33935 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755765Ab0EJRGz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 13:06:55 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip] perf probe: Don't compile CFI related code if elfutils
	is old
To: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@redhat.com>,
       lkml <linux-kernel@vger.kernel.org>
Cc: Robert Richter <robert.richter@amd.com>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@elte.hu>
Date: Mon, 10 May 2010 13:12:07 -0400
Message-ID: <20100510171207.26029.97604.stgit@localhost6.localdomain6>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check elfutils version, and if it is old don't compile
CFI analysis code. This allows to compile perf with
old elfutils.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Reported-by: Robert Richter <robert.richter@amd.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
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


-- 
Masami Hiramatsu
e-mail: mhiramat@redhat.com
