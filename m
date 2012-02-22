Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753580Ab2BVQEb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 11:04:31 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50954 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752917Ab2BVQE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 11:04:29 -0500
Date: Wed, 22 Feb 2012 08:03:19 -0800
From: tip-bot for Stephane Eranian <eranian@google.com>
Message-ID: <tip-6b1bee9035d430c4b4f586df6df4b3f840e89b5b@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        hpa@zytor.com, mingo@redhat.com, eric.dumazet@gmail.com,
        peterz@infradead.org, dsahern@gmail.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, eric.dumazet@gmail.com,
        peterz@infradead.org, dsahern@gmail.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <20120221145424.GA6757@quad>
References: <20120221145424.GA6757@quad>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: fix broken perf record -a mode
Git-Commit-ID: 6b1bee9035d430c4b4f586df6df4b3f840e89b5b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 22 Feb 2012 08:03:40 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6b1bee9035d430c4b4f586df6df4b3f840e89b5b
Gitweb:     http://git.kernel.org/tip/6b1bee9035d430c4b4f586df6df4b3f840e89b5b
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Tue, 21 Feb 2012 15:54:25 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 21 Feb 2012 15:05:43 -0200

perf tools: fix broken perf record -a mode

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
