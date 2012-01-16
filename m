Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751802Ab2APFZt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 00:25:49 -0500
Received: from mailx.hitachi.co.jp ([133.145.228.49]:44779 "EHLO
	mailx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333Ab2APFZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 00:25:47 -0500
X-AuditID: b753bd60-98392ba000007b1b-d4-4f13b4558703
X-AuditID: b753bd60-98392ba000007b1b-d4-4f13b4558703
From: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
Subject: [PATCH -tip v4 3/5] perf script: enhance IP and ADDR correlate
 detection for BTS
To: Arnaldo Carvalho de Melo <acme@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Ahern <dsahern@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        yrl.pp-manager.tt@hitachi.com,
        Akihiro Nagai <akihiro.nagai.hw@hitachi.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        David Ahern <dsahern@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Date: Mon, 16 Jan 2012 14:22:22 +0900
Message-ID: <20120116052222.2485.53573.stgit@linux3>
In-Reply-To: <20120116052146.2485.48349.stgit@linux3>
References: <20120116052146.2485.48349.stgit@linux3>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BTS records branch_from_addr and branch_to_addr in IP and ADDR field in perf_sample.
This patch detects this correlation in perf-script.

# perf script -f ip,addr,dso,sym
3f03e016b0    _start (/lib64/ld-2.14.so) ffffffff814675d2 irq_return ([kernel.kallsyms])
3f03e016b0    _start (/lib64/ld-2.14.so) ffffffff814675d2 irq_return ([kernel.kallsyms])
3f03e04b80 _dl_start (/lib64/ld-2.14.so)       3f03e016b3     _start (/lib64/ld-2.14.so)
3f03e04b80 _dl_start (/lib64/ld-2.14.so) ffffffff814675d2 irq_return ([kernel.kallsyms])
3f03e04ba6 _dl_start (/lib64/ld-2.14.so) ffffffff814675d2 irq_return ([kernel.kallsyms])
3f03e04bad _dl_start (/lib64/ld-2.14.so) ffffffff814675d2 irq_return ([kernel.kallsyms])
3f03e04c1d _dl_start (/lib64/ld-2.14.so)       3f03e04bfb  _dl_start (/lib64/ld-2.14.so)
[snip]


Signed-off-by: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
---

 tools/perf/builtin-script.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 11859eb..360a4da 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -312,6 +312,12 @@ static bool sample_addr_correlates_sym(struct perf_event_attr *attr)
 	     (attr->config == PERF_COUNT_SW_PAGE_FAULTS_MAJ)))
 		return true;
 
+	/* BTS Events */
+	if ((attr->type == PERF_TYPE_HARDWARE) &&
+	    (attr->config & PERF_COUNT_HW_BRANCH_INSTRUCTIONS) &&
+	    (attr->sample_period == 1))
+		return true;
+
 	return false;
 }
 

