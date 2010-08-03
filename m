Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753452Ab0HCCLs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 22:11:48 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:51995 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753144Ab0HCCLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 22:11:45 -0400
X-AuditID: b753bd60-a5abcba000005a63-4f-4c577adf559d
Message-ID: <4C577ADC.1000309@hitachi.com>
Date: Tue, 03 Aug 2010 11:11:40 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, 2nddept-manager@sdl.hitachi.co.jp
Subject: [PATCH 2/2] [BUGFIX] perf probe: Fix memory leaks in	add_perf_probe_events
References: <20100802121739.31805.94789.stgit@ltc236.sdl.hitachi.co.jp>
In-Reply-To: <20100802121739.31805.94789.stgit@ltc236.sdl.hitachi.co.jp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix several memory leaks of pkgs and tevs in add_perf_probe_events().

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Reported-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
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
Masami HIRAMATSU
2nd Research Dept.
Hitachi, Ltd., Systems Development Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
