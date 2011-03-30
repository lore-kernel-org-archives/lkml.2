Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932283Ab1C3Jcl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 05:32:41 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:41633 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932302Ab1C3Jci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 05:32:38 -0400
X-AuditID: b753bd60-a50bbba000004916-89-4d92f8b4c8b1
X-AuditID: b753bd60-a50bbba000004916-89-4d92f8b4c8b1
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH -tip 03/12] [BUGFIX]perf probe: Fix multiple --vars options
	behavior
To: Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        2nddept-manager@sdl.hitachi.co.jp,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Date: Wed, 30 Mar 2011 18:25:53 +0900
Message-ID: <20110330092553.2132.42691.stgit@ltc236.sdl.hitachi.co.jp>
In-Reply-To: <20110330092533.2132.35412.stgit@ltc236.sdl.hitachi.co.jp>
References: <20110330092533.2132.35412.stgit@ltc236.sdl.hitachi.co.jp>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a bug that perf-probe fails to initialize libdwfl and
shows incorrect error when user gives multiple --vars options.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
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
 

