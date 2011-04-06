Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755588Ab1DFLBl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 07:01:41 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:51862 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752434Ab1DFLAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 07:00:34 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        2nddept-manager@sdl.hitachi.co.jp,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Lin Ming <ming.m.lin@intel.com>, Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 3/5] perf probe: Fix multiple --vars options behavior
Date: Wed,  6 Apr 2011 08:00:21 -0300
Message-Id: <1302087623-14724-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1302087623-14724-1-git-send-email-acme@infradead.org>
References: <1302087623-14724-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Fix a bug that perf-probe fails to initialize libdwfl and shows incorrect error
when user gives multiple --vars options.

Cc: 2nddept-manager@sdl.hitachi.co.jp
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Lin Ming <ming.m.lin@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <20110330092553.2132.42691.stgit@ltc236.sdl.hitachi.co.jp>
Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/probe-event.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index a372d74..f022316 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -510,18 +510,18 @@ int show_available_vars(struct perf_probe_event *pevs, int npevs,
 	if (ret < 0)
 		return ret;
 
-	fd = open_vmlinux(module);
-	if (fd < 0) {
-		pr_warning("Failed to open debug information file.\n");
-		return fd;
-	}
-
 	setup_pager();
 
-	for (i = 0; i < npevs && ret >= 0; i++)
+	for (i = 0; i < npevs && ret >= 0; i++) {
+		fd = open_vmlinux(module);
+		if (fd < 0) {
+			pr_warning("Failed to open debug information file.\n");
+			ret = fd;
+			break;
+		}
 		ret = show_available_vars_at(fd, &pevs[i], max_vls, _filter,
 					     externs);
-
+	}
 	return ret;
 }
 
-- 
1.6.2.5

