Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756628Ab2KNHas (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 02:30:48 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44137 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869Ab2KNHar (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 02:30:47 -0500
Date: Tue, 13 Nov 2012 23:30:10 -0800
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-1e82574d1db1451f137cb520f21b9176f05284c9@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, namhyung@kernel.org,
        ak@linux.intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, namhyung@kernel.org,
        ak@linux.intel.com, tglx@linutronix.de
In-Reply-To: <1352273234-28912-4-git-send-email-namhyung@kernel.org>
References: <1352273234-28912-4-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Fix detection of stack area
Git-Commit-ID: 1e82574d1db1451f137cb520f21b9176f05284c9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 13 Nov 2012 23:30:16 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1e82574d1db1451f137cb520f21b9176f05284c9
Gitweb:     http://git.kernel.org/tip/1e82574d1db1451f137cb520f21b9176f05284c9
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Wed, 7 Nov 2012 16:27:11 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 8 Nov 2012 11:59:32 -0300

perf tools: Fix detection of stack area

Output of /proc/<pid>/maps contains helpful information to anonymous
mappings like stack, heap, ...  For the case of stack, it can show
multiple stack area for each thread in the process:

  $ cat /proc/$(pidof gnome-shell)/maps | grep stack
  7fe019946000-7fe01a146000 rw-p 00000000 00:00 0          [stack:1624]
  7fe040e32000-7fe041632000 rw-p 00000000 00:00 0          [stack:1451]
  7fe041643000-7fe041e43000 rw-p 00000000 00:00 0          [stack:1450]
  7fe04204b000-7fe04284b000 rw-p 00000000 00:00 0          [stack:1449]
  7fe042a7e000-7fe04327e000 rw-p 00000000 00:00 0          [stack:1446]
  7fe0432ff000-7fe043aff000 rw-p 00000000 00:00 0          [stack:1445]
  7fe043b00000-7fe044300000 rw-p 00000000 00:00 0          [stack:1444]
  7fe044301000-7fe044b01000 rw-p 00000000 00:00 0          [stack:1443]
  7fe044b02000-7fe045302000 rw-p 00000000 00:00 0          [stack:1442]
  7fe045303000-7fe045b03000 rw-p 00000000 00:00 0          [stack:1441]
  7fe045b04000-7fe046304000 rw-p 00000000 00:00 0          [stack:1440]
  7fe046305000-7fe046b05000 rw-p 00000000 00:00 0          [stack:1439]
  7fe046b06000-7fe047306000 rw-p 00000000 00:00 0          [stack:1438]
  7fff4b16f000-7fff4b190000 rw-p 00000000 00:00 0          [stack]

However perf only knew about the main thread's.  Fix it.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1352273234-28912-4-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/map.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index 9b40c44..5791878 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -24,7 +24,7 @@ static inline int is_anon_memory(const char *filename)
 
 static inline int is_no_dso_memory(const char *filename)
 {
-	return !strcmp(filename, "[stack]") ||
+	return !strncmp(filename, "[stack", 6) ||
 	       !strcmp(filename, "[heap]");
 }
 
