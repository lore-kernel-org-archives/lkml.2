Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753091Ab1AGKbh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 05:31:37 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38770 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751399Ab1AGKaI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 05:30:08 -0500
From: Thomas Renninger <trenn@suse.de>
Cc: linux-perf-users@vger.kernel.org, mingo@elte.hu, arjan@linux.intel.com,
        lenb@kernel.org, j-pihet@ti.com, Thomas Renninger <trenn@suse.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 9/9] perf: timechart: Fix memleak
Date: Fri,  7 Jan 2011 11:29:50 +0100
Message-Id: <1294396190-23031-10-git-send-email-trenn@suse.de>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1294396190-23031-1-git-send-email-trenn@suse.de>
References: <1294396190-23031-1-git-send-email-trenn@suse.de>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are others, but these are not worth it, e.g. built
up power event list which gets destroyed on program exit anyway or
some bytes when trace events get parsed.

This one showed by far the biggest memory waste, was easy to
fix and could help when parsing huge trace event records.

Signed-off-by: Thomas Renninger <trenn@suse.de>
CC: Arjan van de Ven <arjan@linux.intel.com>
CC: Ingo Molnar <mingo@elte.hu>
CC: linux-perf-users@vger.kernel.org
CC: linux-kernel@vger.kernel.org

Found with valgrind, fixes:
==43509== 1,402 bytes in 251 blocks are definitely lost in loss record 61 of 74
==43509==    at 0x4C261D7: malloc (in /usr/lib64/valgrind/vgpreload_memcheck-amd64-linux.so)
==43509==    by 0x61573B1: strdup (in /lib64/libc-2.11.1.so)
==43509==    by 0x41DD3D: draw_wakeups (builtin-timechart.c:706)
==43509==    by 0x41E7C9: write_svg_file (builtin-timechart.c:957)
==43509==    by 0x41E87E: __cmd_timechart (builtin-timechart.c:989)
==43509==    by 0x41EB3C: cmd_timechart (builtin-timechart.c:1097)
==43509==    by 0x40D776: run_builtin (perf.c:286)
==43509==    by 0x40D993: handle_internal_command (perf.c:357)
==43509==    by 0x40DAD2: run_argv (perf.c:401)
==43509==    by 0x40DCB3: main (perf.c:487)
==43509==
==43509== 2,826 bytes in 429 blocks are definitely lost in loss record 63 of 74
==43509==    at 0x4C261D7: malloc (in /usr/lib64/valgrind/vgpreload_memcheck-amd64-linux.so)
==43509==    by 0x61573B1: strdup (in /lib64/libc-2.11.1.so)
==43509==    by 0x41DD70: draw_wakeups (builtin-timechart.c:710)
==43509==    by 0x41E7C9: write_svg_file (builtin-timechart.c:957)
==43509==    by 0x41E87E: __cmd_timechart (builtin-timechart.c:989)
==43509==    by 0x41EB3C: cmd_timechart (builtin-timechart.c:1097)
==43509==    by 0x40D776: run_builtin (perf.c:286)
==43509==    by 0x40D993: handle_internal_command (perf.c:357)
==43509==    by 0x40DAD2: run_argv (perf.c:401)
==43509==    by 0x40DCB3: main (perf.c:487)
---
 tools/perf/builtin-timechart.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index 54e9c37..63dc1fd 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -696,10 +696,14 @@ static void draw_wakeups(void)
 					if (c->Y && c->start_time <= we->time && c->end_time >= we->time) {
 						if (p->pid == we->waker && !from) {
 							from = c->Y;
+							if (task_from)
+								free(task_from);
 							task_from = strdup(c->comm);
 						}
 						if (p->pid == we->wakee && !to) {
 							to = c->Y;
+							if (task_to)
+								free(task_to);
 							task_to = strdup(c->comm);
 						}
 					}
@@ -709,10 +713,14 @@ static void draw_wakeups(void)
 				while (c) {
 					if (p->pid == we->waker && !from) {
 						from = c->Y;
+						if (task_from)
+							free(task_from);
 						task_from = strdup(c->comm);
 					}
 					if (p->pid == we->wakee && !to) {
 						to = c->Y;
+						if (task_to)
+							free(task_to);
 						task_to = strdup(c->comm);
 					}
 					c = c->next;
-- 
1.7.3.1

