Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757750Ab0DXCGY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 22:06:24 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:62883 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755965Ab0DXCFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 22:05:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=mGz01HhSVDIaF8qGqK6zlnxJLjsYaZg27kFmhXhW67llzx0cG35j1zor6ZalzpBFQ7
         NqtgbI6kswcEfy6CbDh5unGw4AnZ0s0CfFOjcy1gUtr2fVlhcGbjdwaIA4Br76dbMF+o
         iRLtL2qakUAPXgnLfe1a1MsVyAdOlRBS6AzOc=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Ingo Molnar <mingo@elte.hu>, Masami Hiramatsu <mhiramat@redhat.com>,
       Tom Zanussi <tzanussi@gmail.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 5/9] perf: Use generic sample reordering in perf kmem
Date: Sat, 24 Apr 2010 04:05:38 +0200
Message-Id: <1272074742-3654-6-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <1272074742-3654-1-git-send-regression-fweisbec@gmail.com>
References: <1272074742-3654-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new generic sample events reordering from perf kmem,
this drops the need of multiplexing the buffers on record time,
improving the scalability of perf kmem.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Li Zefan <lizf@cn.fujitsu.com>
---
 tools/perf/builtin-kmem.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index db474bb..ab906cb 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -335,8 +335,9 @@ static int process_sample_event(event_t *event, struct perf_session *session)
 }
 
 static struct perf_event_ops event_ops = {
-	.sample	= process_sample_event,
-	.comm	= event__process_comm,
+	.sample			= process_sample_event,
+	.comm			= event__process_comm,
+	.ordered_samples	= true,
 };
 
 static double fragmentation(unsigned long n_req, unsigned long n_alloc)
@@ -730,7 +731,6 @@ static const char *record_args[] = {
 	"record",
 	"-a",
 	"-R",
-	"-M",
 	"-f",
 	"-c", "1",
 	"-e", "kmem:kmalloc",
-- 
1.6.2.3

