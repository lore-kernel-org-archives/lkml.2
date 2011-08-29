Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417Ab1H2XPL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 19:15:11 -0400
Received: from ozlabs.org ([203.10.76.45]:55300 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755259Ab1H2XPJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 19:15:09 -0400
Date: Tue, 30 Aug 2011 09:15:06 +1000
From: Anton Blanchard <anton@samba.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, emunson@mgebm.net,
        penberg@cs.helsinki.fi
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] perf symbols: Synthesize anonymous mmap events
Message-ID: <20110830091506.60b51fe8@kryten>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.24.4; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


perf_event__synthesize_mmap_events does not create anonymous mmap
events even though the kernel does. As a result an already running
application with dynamically created code will not get profiled -
all samples end up in the unknown bucket.

This patch skips any entries with '[' in the name to avoid adding
events for special regions (eg the vsyscall page). All other
executable mmaps are assumed to be anonymous and an event is
synthesized.

Signed-off-by: Anton Blanchard <anton@samba.org>
---

diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 3c1b8a6..437f8ca 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -169,12 +169,17 @@ static int perf_event__synthesize_mmap_events(union perf_event *event,
 			continue;
 		pbf += n + 3;
 		if (*pbf == 'x') { /* vm_exec */
+			char anonstr[] = "//anon\n";
 			char *execname = strchr(bf, '/');
 
 			/* Catch VDSO */
 			if (execname == NULL)
 				execname = strstr(bf, "[vdso]");
 
+			/* Catch anonymous mmaps */
+			if ((execname == NULL) && !strstr(bf, "["))
+				execname = anonstr;
+
 			if (execname == NULL)
 				continue;
 
