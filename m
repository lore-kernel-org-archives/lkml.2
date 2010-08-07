Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762431Ab0HGBew (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 21:34:52 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53027 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752810Ab0HGBeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 21:34:24 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 2/4] perf probe: Fix memory leaks in add_perf_probe_events
Date: Fri,  6 Aug 2010 22:34:07 -0300
Message-Id: <1281144849-22896-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1281144849-22896-1-git-send-email-acme@infradead.org>
References: <1281144849-22896-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Fix several memory leaks of pkgs and tevs in add_perf_probe_events().

Reported-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
LKML-Reference: <4C577ADC.1000309@hitachi.com>

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/probe-event.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 2e665cb..e72f05c 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -1606,8 +1606,10 @@ int add_perf_probe_events(struct perf_probe_event *pevs, int npevs,
 
 	/* Init vmlinux path */
 	ret = init_vmlinux();
-	if (ret < 0)
+	if (ret < 0) {
+		free(pkgs);
 		return ret;
+	}
 
 	/* Loop 1: convert all events */
 	for (i = 0; i < npevs; i++) {
@@ -1625,10 +1627,13 @@ int add_perf_probe_events(struct perf_probe_event *pevs, int npevs,
 		ret = __add_probe_trace_events(pkgs[i].pev, pkgs[i].tevs,
 						pkgs[i].ntevs, force_add);
 end:
-	/* Loop 3: cleanup trace events  */
-	for (i = 0; i < npevs; i++)
+	/* Loop 3: cleanup and free trace events  */
+	for (i = 0; i < npevs; i++) {
 		for (j = 0; j < pkgs[i].ntevs; j++)
 			clear_probe_trace_event(&pkgs[i].tevs[j]);
+		free(pkgs[i].tevs);
+	}
+	free(pkgs);
 
 	return ret;
 }
-- 
1.6.2.5

