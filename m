Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754541Ab2BURft (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 12:35:49 -0500
Received: from merlin.infradead.org ([205.233.59.134]:36676 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753024Ab2BURfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 12:35:47 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Stephane Eranian <eranian@google.com>,
        David Ahern <dsahern@gmail.com>, Eric Dumazet <eric.dumazet@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 3/3] perf tools: fix broken perf record -a mode
Date: Tue, 21 Feb 2012 15:35:27 -0200
Message-Id: <1329845727-21512-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.123.g65da0
In-Reply-To: <1329845727-21512-1-git-send-email-acme@infradead.org>
References: <1329845727-21512-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephane Eranian <eranian@google.com>

The following commit:
b52956c perf tools: Allow multiple threads or processes in record, stat, top

introduced a bug in the thread_map code which caused perf record -a to
not setup system-wide monitoring properly.

$ taskset -c 1 noploop 1000 &
$ perf record -a -C 1 sleep 10
$ perf report -D | tail -20
cycles stats:
           TOTAL events:       4413
            MMAP events:       4025
            COMM events:        340
          SAMPLE events:         48

Here I was expecting about 10,000 samples and not 48.

In system-wide mode, the PID passed to perf_event_open() must be -1 and
it was 0. That caused the kernel to setup a per-process event on PID:0.
Consequently, the number of samples captured does not correspond to the
requested measurement.

The following one-liner fixes the problem for me with or without -C.

I would also suggest to change the malloc() to something that matches
the struct definition. thread_map->map[] is declared as int map[] and
not pid_t map[]. If map[] can only contain pids, then change the struct
definition.

Acked-by: David Ahern <dsahern@gmail.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20120221145424.GA6757@quad
Signed-off-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/thread_map.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/thread_map.c b/tools/perf/util/thread_map.c
index e15983c..84d9bd78 100644
--- a/tools/perf/util/thread_map.c
+++ b/tools/perf/util/thread_map.c
@@ -229,7 +229,7 @@ static struct thread_map *thread_map__new_by_tid_str(const char *tid_str)
 	if (!tid_str) {
 		threads = malloc(sizeof(*threads) + sizeof(pid_t));
 		if (threads != NULL) {
-			threads->map[1] = -1;
+			threads->map[0] = -1;
 			threads->nr	= 1;
 		}
 		return threads;
-- 
1.7.9.123.g65da0

