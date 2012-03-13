Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757046Ab2CMPvI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 11:51:08 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:49439 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756088Ab2CMPvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 11:51:06 -0400
Date: Tue, 13 Mar 2012 16:51:02 +0100
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, acme@redhat.com, mingo@elte.hu, fweisbec@gmail.com,
        dsahern@gmail.com
Subject: [PATCH] perf record: fix buffer overrun bug in
 tracepoint_id_to_path()
Message-ID: <20120313155102.GA6465@quad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch fixes a buffer overrun bug in tracepoint_id_to_path().
The bug manisfested itself as a memory error reported by perf record.
I ran into it with perf sched:

$ perf sched rec noploop 2
noploop for 2 seconds
[ perf record: Woken up 14 times to write data ]
[ perf record: Captured and wrote 42.701 MB perf.data (~1865622 samples) ]
  Fatal: No memory to alloc tracepoints list

It turned out that tracepoint_id_to_path() was reading the tracepoint id
using read() but the buffer was not large enough to include the \n terminator
for id with 4 digits or more.

The patch fixes the problem by extending the buffer to a more reasonable size
covering all possible id length include \n terminator. Note that atoll() stops
at the first non digit character, thus it is not necessary to clear the buffer
between each read.

Signed-off-by: Stephane Eranian <eranian@google.com>
---

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index b029296..8a3c8c0 100644
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
