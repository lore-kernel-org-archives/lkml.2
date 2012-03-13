Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757238Ab2CMQSH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 12:18:07 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41712 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753066Ab2CMQSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 12:18:04 -0400
Date: Tue, 13 Mar 2012 09:17:42 -0700
From: tip-bot for Stephane Eranian <eranian@google.com>
Message-ID: <tip-8aa8a7c80ccdfac2df5ee48a51a4a7bee2143d4f@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, eranian@google.com,
        hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20120313155102.GA6465@quad>
References: <20120313155102.GA6465@quad>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf record:
  Fix buffer overrun bug in tracepoint_id_to_path()
Git-Commit-ID: 8aa8a7c80ccdfac2df5ee48a51a4a7bee2143d4f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 13 Mar 2012 09:17:48 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8aa8a7c80ccdfac2df5ee48a51a4a7bee2143d4f
Gitweb:     http://git.kernel.org/tip/8aa8a7c80ccdfac2df5ee48a51a4a7bee2143d4f
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Tue, 13 Mar 2012 16:51:02 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 13 Mar 2012 17:01:28 +0100

perf record: Fix buffer overrun bug in tracepoint_id_to_path()

This patch fixes a buffer overrun bug in
tracepoint_id_to_path(). The bug manisfested itself as a memory
error reported by perf record. I ran into it with perf sched:

 $ perf sched rec noploop 2 noploop for 2 seconds
 [ perf record: Woken up 14 times to write data ]
 [ perf record: Captured and wrote 42.701 MB perf.data (~1865622 samples) ]
 Fatal: No memory to alloc tracepoints list

It turned out that tracepoint_id_to_path() was reading the
tracepoint id using read() but the buffer was not large enough
to include the \n terminator for id with 4 digits or more.

The patch fixes the problem by extending the buffer to a more
reasonable size covering all possible id length include \n
terminator. Note that atoll() stops at the first non digit
character, thus it is not necessary to clear the buffer between
each read.

Signed-off-by: Stephane Eranian <eranian@google.com>
Acked-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: fweisbec@gmail.com
Cc: dsahern@gmail.com
Link: http://lkml.kernel.org/r/20120313155102.GA6465@quad
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/util/parse-events.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index b029296..c7a6f6f 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -165,7 +165,7 @@ struct tracepoint_path *tracepoint_id_to_path(u64 config)
 	struct tracepoint_path *path = NULL;
 	DIR *sys_dir, *evt_dir;
 	struct dirent *sys_next, *evt_next, sys_dirent, evt_dirent;
-	char id_buf[4];
+	char id_buf[24];
 	int fd;
 	u64 id;
 	char evt_path[MAXPATHLEN];
