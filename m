Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756653Ab2KNH3d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 02:29:33 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44095 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932067Ab2KNH3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 02:29:32 -0500
Date: Tue, 13 Nov 2012 23:29:10 -0800
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-4552cf0f774ae3d24bf31e91324586274a552a66@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, namhyung@kernel.org,
        ak@linux.intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, namhyung@kernel.org,
        ak@linux.intel.com, tglx@linutronix.de
In-Reply-To: <1352273234-28912-3-git-send-email-namhyung@kernel.org>
References: <1352273234-28912-3-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf machine: Set kernel data mapping length
Git-Commit-ID: 4552cf0f774ae3d24bf31e91324586274a552a66
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 13 Nov 2012 23:29:16 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4552cf0f774ae3d24bf31e91324586274a552a66
Gitweb:     http://git.kernel.org/tip/4552cf0f774ae3d24bf31e91324586274a552a66
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Wed, 7 Nov 2012 16:27:10 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 8 Nov 2012 11:56:16 -0300

perf machine: Set kernel data mapping length

Currently only text (function) mapping was set, so that the kernel data
addresses couldn't parsed correctly.  Fix it.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1352273234-28912-3-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/machine.c |   22 +++++++++++++---------
 1 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 502eec0..4c6754a 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -84,15 +84,19 @@ int machine__process_lost_event(struct machine *machine __maybe_unused,
 static void machine__set_kernel_mmap_len(struct machine *machine,
 					 union perf_event *event)
 {
-	machine->vmlinux_maps[MAP__FUNCTION]->start = event->mmap.start;
-	machine->vmlinux_maps[MAP__FUNCTION]->end   = (event->mmap.start +
-						       event->mmap.len);
-	/*
-	 * Be a bit paranoid here, some perf.data file came with
-	 * a zero sized synthesized MMAP event for the kernel.
-	 */
-	if (machine->vmlinux_maps[MAP__FUNCTION]->end == 0)
-		machine->vmlinux_maps[MAP__FUNCTION]->end = ~0ULL;
+	int i;
+
+	for (i = 0; i < MAP__NR_TYPES; i++) {
+		machine->vmlinux_maps[i]->start = event->mmap.start;
+		machine->vmlinux_maps[i]->end   = (event->mmap.start +
+						   event->mmap.len);
+		/*
+		 * Be a bit paranoid here, some perf.data file came with
+		 * a zero sized synthesized MMAP event for the kernel.
+		 */
+		if (machine->vmlinux_maps[i]->end == 0)
+			machine->vmlinux_maps[i]->end = ~0ULL;
+	}
 }
 
 static int machine__process_kernel_mmap_event(struct machine *machine,
