Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755723Ab1DFLN7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 07:13:59 -0400
Received: from hera.kernel.org ([140.211.167.34]:42883 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754371Ab1DFLN6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 07:13:58 -0400
Date: Wed, 6 Apr 2011 11:13:37 GMT
From: tip-bot for Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@redhat.com, peterz@infradead.org,
        masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com,
        ming.m.lin@intel.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, fweisbec@gmail.com, masami.hiramatsu.pt@hitachi.com,
        peterz@infradead.org, ming.m.lin@intel.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <20110330092553.2132.42691.stgit@ltc236.sdl.hitachi.co.jp>
References: <20110330092553.2132.42691.stgit@ltc236.sdl.hitachi.co.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf probe: Fix multiple --vars options behavior
Message-ID: <tip-cc446446ff48e82c157dc8c937a3490f2a2ce535@git.kernel.org>
Git-Commit-ID: cc446446ff48e82c157dc8c937a3490f2a2ce535
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 06 Apr 2011 11:13:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cc446446ff48e82c157dc8c937a3490f2a2ce535
Gitweb:     http://git.kernel.org/tip/cc446446ff48e82c157dc8c937a3490f2a2ce535
Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
AuthorDate: Wed, 30 Mar 2011 18:25:53 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 5 Apr 2011 15:36:04 -0300

perf probe: Fix multiple --vars options behavior

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
 
