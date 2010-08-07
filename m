Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762580Ab0HGHB6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Aug 2010 03:01:58 -0400
Received: from hera.kernel.org ([140.211.167.34]:50746 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761772Ab0HGHBy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Aug 2010 03:01:54 -0400
Date: Sat, 7 Aug 2010 07:01:02 GMT
From: tip-bot for Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
        hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
        masami.hiramatsu.pt@hitachi.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, masami.hiramatsu.pt@hitachi.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4C577ADC.1000309@hitachi.com>
References: <4C577ADC.1000309@hitachi.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf probe: Fix memory leaks in add_perf_probe_events
Message-ID: <tip-449e5b247ca7c9dc9fc3391b7eebfefdeb2ce1fc@git.kernel.org>
Git-Commit-ID: 449e5b247ca7c9dc9fc3391b7eebfefdeb2ce1fc
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 07 Aug 2010 07:01:03 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  449e5b247ca7c9dc9fc3391b7eebfefdeb2ce1fc
Gitweb:     http://git.kernel.org/tip/449e5b247ca7c9dc9fc3391b7eebfefdeb2ce1fc
Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
AuthorDate: Tue, 3 Aug 2010 11:11:40 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 6 Aug 2010 16:25:56 -0300

perf probe: Fix memory leaks in add_perf_probe_events

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
