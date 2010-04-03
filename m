Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753524Ab0DCLyx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Apr 2010 07:54:53 -0400
Received: from ozlabs.org ([203.10.76.45]:42506 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753417Ab0DCLyt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Apr 2010 07:54:49 -0400
Date: Sat, 3 Apr 2010 22:53:31 +1100
From: Anton Blanchard <anton@samba.org>
To: David Miller <davem@davemloft.net>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] perf symbols: Fill in pgoff in mmap synthesized events
Message-ID: <20100403115331.GK5594@kryten>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When we synthesize mmap events we need to fill in the pgoff field. 

Signed-off-by: Anton Blanchard <anton@samba.org>
---

I wasn't able to test this completely since I couldn't find an executable
region with a non 0 offset. We will see it when we start doing data
profiling.

Index: linux.trees.git/tools/perf/util/event.c
===================================================================
--- linux.trees.git.orig/tools/perf/util/event.c	2010-04-01 07:55:13.000000000 +1100
+++ linux.trees.git/tools/perf/util/event.c	2010-04-03 22:45:02.000000000 +1100
@@ -130,6 +130,7 @@ static int event__synthesize_mmap_events
 			continue;
 		pbf += n + 3;
 		if (*pbf == 'x') { /* vm_exec */
+			u64 vm_pgoff;
 			char *execname = strchr(bf, '/');
 
 			/* Catch VDSO */
@@ -139,6 +140,14 @@ static int event__synthesize_mmap_events
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
