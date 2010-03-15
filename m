Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965455Ab0COQyb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 12:54:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7101 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965416Ab0COQya (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 12:54:30 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip 2/2] [BUGFIX] perf probe: Use origial address instead of
	CU-based address
To: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>, Ingo Molnar <mingo@elte.hu>
Date: Mon, 15 Mar 2010 13:02:35 -0400
Message-ID: <20100315170235.31852.91195.stgit@localhost6.localdomain6>
In-Reply-To: <20100315170228.31852.71946.stgit@localhost6.localdomain6>
References: <20100315170228.31852.71946.stgit@localhost6.localdomain6>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use original address for looking up the location of variables for
dwarf_getlocation_addr() instead of CU-based address.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
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


-- 
Masami Hiramatsu
e-mail: mhiramat@redhat.com
