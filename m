Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756796Ab1F1HlX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 03:41:23 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:53183 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756677Ab1F1Hji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 03:39:38 -0400
X-AuditID: b753bd60-a3c7dba0000050a4-f6-4e0985379362
X-AuditID: b753bd60-a3c7dba0000050a4-f6-4e0985379362
From: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
Subject: [PATCH -tip 2/4] perf script: print DSOs and symbols for BTS
 branch_from addr
To: Arnaldo Carvalho de Melo <acme@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Ahern <dsahern@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        pp-manager@sdl.hitachi.co.jp,
        Akihiro Nagai <akihiro.nagai.hw@hitachi.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        David Ahern <dsahern@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Date: Tue, 28 Jun 2011 16:40:37 +0900
Message-ID: <20110628074037.4269.7659.stgit@linux3>
In-Reply-To: <20110628074019.4269.32109.stgit@linux3>
References: <20110628074019.4269.32109.stgit@linux3>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Print DSOs and symbols for branch_from address of BTS.
BTS records branch_from address in 'addr' fields,
and branch_to address in 'ip' field. Latest perf-script
resolves DSOs and symbols only for 'ip' field.
This patch resolves them for 'addr' field too.

# perf script -f ip,addr,dso,sym
  3f03e016b0                  ([kernel.kallsyms]) ffffffff81467612 irq_return ([kernel.kallsyms])
  3f03e016b0           _start (/lib64/ld-2.14.so) ffffffff81467612 irq_return ([kernel.kallsyms])
  3f03e04b80        _dl_start (/lib64/ld-2.14.so)       3f03e016b3 _start (/lib64/ld-2.14.so)
  3f03e04b80        _dl_start (/lib64/ld-2.14.so) ffffffff81467612 irq_return ([kernel.kallsyms])
  3f03e04ba6        _dl_start (/lib64/ld-2.14.so) ffffffff81467612 irq_return ([kernel.kallsyms])

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
index e45433f..2d68086 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -306,6 +306,12 @@ static bool sample_addr_correlates_sym(struct perf_event_attr *attr)
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
 

