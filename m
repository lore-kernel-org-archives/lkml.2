Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753760Ab0DCQZn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Apr 2010 12:25:43 -0400
Received: from hera.kernel.org ([140.211.167.34]:37837 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753384Ab0DCQZj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Apr 2010 12:25:39 -0400
Date: Sat, 3 Apr 2010 16:25:19 GMT
From: tip-bot for Anton Blanchard <anton@samba.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
       anton@samba.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, davem@davemloft.net, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, anton@samba.org, paulus@samba.org,
       linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, davem@davemloft.net
In-Reply-To: <20100403115331.GK5594@kryten>
References: <20100403115331.GK5594@kryten>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf symbols: Fill in pgoff in mmap synthesized events
Message-ID: <tip-4af8b35db6634dd1e0d616de689582b6c93550af@git.kernel.org>
Git-Commit-ID: 4af8b35db6634dd1e0d616de689582b6c93550af
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 03 Apr 2010 16:25:20 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4af8b35db6634dd1e0d616de689582b6c93550af
Gitweb:     http://git.kernel.org/tip/4af8b35db6634dd1e0d616de689582b6c93550af
Author:     Anton Blanchard <anton@samba.org>
AuthorDate: Sat, 3 Apr 2010 22:53:31 +1100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Sat, 3 Apr 2010 10:20:31 -0300

perf symbols: Fill in pgoff in mmap synthesized events

When we synthesize mmap events we need to fill in the pgoff field.

I wasn't able to test this completely since I couldn't find an
executable region with a non 0 offset. We will see it when we start
doing data profiling.

Signed-off-by: Anton Blanchard <anton@samba.org>
Cc: David Miller <davem@davemloft.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
LKML-Reference: <20100403115331.GK5594@kryten>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/event.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 052eaec..571fb25 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -130,6 +130,7 @@ static int event__synthesize_mmap_events(pid_t pid, pid_t tgid,
 			continue;
 		pbf += n + 3;
 		if (*pbf == 'x') { /* vm_exec */
+			u64 vm_pgoff;
 			char *execname = strchr(bf, '/');
 
 			/* Catch VDSO */
@@ -139,6 +140,14 @@ static int event__synthesize_mmap_events(pid_t pid, pid_t tgid,
 			if (execname == NULL)
 				continue;
 
+			pbf += 3;
+			n = hex2u64(pbf, &vm_pgoff);
+			/* pgoff is in bytes, not pages */
+			if (n >= 0)
+				ev.mmap.pgoff = vm_pgoff << getpagesize();
+			else
+				ev.mmap.pgoff = 0;
+
 			size = strlen(execname);
 			execname[size - 1] = '\0'; /* Remove \n */
 			memcpy(ev.mmap.filename, execname, size);
