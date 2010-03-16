Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966387Ab0CPOsO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 10:48:14 -0400
Received: from hera.kernel.org ([140.211.167.34]:44590 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966352Ab0CPOsH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 10:48:07 -0400
Date: Tue, 16 Mar 2010 14:47:03 GMT
From: tip-bot for Masami Hiramatsu <mhiramat@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       dle-develop@lists.sourceforge.net, tglx@linutronix.de,
       mhiramat@redhat.com, systemtap@sources.redhat.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       dle-develop@lists.sourceforge.net, tglx@linutronix.de,
       mhiramat@redhat.com, systemtap@sources.redhat.com, mingo@elte.hu
In-Reply-To: <20100315170235.31852.91195.stgit@localhost6.localdomain6>
References: <20100315170235.31852.91195.stgit@localhost6.localdomain6>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf probe: Use original address instead of CU-based address
Message-ID: <tip-d0cb4260f899d07462d49fc67e29f2438dbaca2f@git.kernel.org>
Git-Commit-ID: d0cb4260f899d07462d49fc67e29f2438dbaca2f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 16 Mar 2010 14:47:03 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d0cb4260f899d07462d49fc67e29f2438dbaca2f
Gitweb:     http://git.kernel.org/tip/d0cb4260f899d07462d49fc67e29f2438dbaca2f
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Mon, 15 Mar 2010 13:02:35 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 16 Mar 2010 10:02:19 +0100

perf probe: Use original address instead of CU-based address

Use original address for looking up the location of variables
for dwarf_getlocation_addr() instead of CU-based address.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: systemtap <systemtap@sources.redhat.com>
Cc: DLE <dle-develop@lists.sourceforge.net>
LKML-Reference: <20100315170235.31852.91195.stgit@localhost6.localdomain6>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/util/probe-finder.c |   11 ++---------
 tools/perf/util/probe-finder.h |    1 -
 2 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index 0e8c8f1..c171a24 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -352,8 +352,7 @@ static void show_variable(Dwarf_Die *vr_die, struct probe_finder *pf)
 	if (dwarf_attr(vr_die, DW_AT_location, &attr) == NULL)
 		goto error;
 	/* TODO: handle more than 1 exprs */
-	ret = dwarf_getlocation_addr(&attr, (pf->addr - pf->cu_base),
-				     &expr, &nexpr, 1);
+	ret = dwarf_getlocation_addr(&attr, pf->addr, &expr, &nexpr, 1);
 	if (ret <= 0 || nexpr == 0)
 		goto error;
 
@@ -437,8 +436,7 @@ static void show_probe_point(Dwarf_Die *sp_die, struct probe_finder *pf)
 
 	/* Get the frame base attribute/ops */
 	dwarf_attr(sp_die, DW_AT_frame_base, &fb_attr);
-	ret = dwarf_getlocation_addr(&fb_attr, (pf->addr - pf->cu_base),
-				     &pf->fb_ops, &nops, 1);
+	ret = dwarf_getlocation_addr(&fb_attr, pf->addr, &pf->fb_ops, &nops, 1);
 	if (ret <= 0 || nops == 0)
 		pf->fb_ops = NULL;
 
@@ -644,7 +642,6 @@ static void find_probe_point_by_func(struct probe_finder *pf)
 int find_probe_point(int fd, struct probe_point *pp)
 {
 	struct probe_finder pf = {.pp = pp};
-	int ret;
 	Dwarf_Off off, noff;
 	size_t cuhl;
 	Dwarf_Die *diep;
@@ -671,10 +668,6 @@ int find_probe_point(int fd, struct probe_point *pp)
 			pf.fname = NULL;
 
 		if (!pp->file || pf.fname) {
-			/* Save CU base address (for frame_base) */
-			ret = dwarf_lowpc(&pf.cu_die, &pf.cu_base);
-			if (ret != 0)
-				pf.cu_base = 0;
 			if (pp->function)
 				find_probe_point_by_func(&pf);
 			else if (pp->lazy_line)
diff --git a/tools/perf/util/probe-finder.h b/tools/perf/util/probe-finder.h
index d1a6517..21f7354 100644
--- a/tools/perf/util/probe-finder.h
+++ b/tools/perf/util/probe-finder.h
@@ -71,7 +71,6 @@ struct probe_finder {
 
 	/* For variable searching */
 	Dwarf_Op		*fb_ops;	/* Frame base attribute */
-	Dwarf_Addr		cu_base;	/* Current CU base address */
 	const char		*var;		/* Current variable name */
 	char			*buf;		/* Current output buffer */
 	int			len;		/* Length of output buffer */
