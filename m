Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755013Ab1AKA2W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 19:28:22 -0500
Received: from canuck.infradead.org ([134.117.69.58]:40084 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558Ab1AKA2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 19:28:20 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Jiri Pirko <jpirko@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 4/6] perf sched: Use PTHREAD_STACK_MIN to avoid pthread_attr_setstacksize() fail
Date: Mon, 10 Jan 2011 22:28:10 -0200
Message-Id: <1294705692-9537-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1294705692-9537-1-git-send-email-acme@infradead.org>
References: <1294705692-9537-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Pirko <jpirko@redhat.com>

on ppc64:
/usr/include/bits/local_lim.h:#define PTHREAD_STACK_MIN	131072

therefore following set of commands:

gives:
perf.2.6.37test: builtin-sched.c:493: create_tasks: Assertion `!(err)' failed.

So make sure we do not set stack size lower than PTHREAD_STACK_MIN.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <20110110160417.GB2685@psychotron.brq.redhat.com>
Signed-off-by: Jiri Pirko <jpirko@redhat.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-sched.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 54024d2..abd4b84 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -489,7 +489,8 @@ static void create_tasks(void)
 
 	err = pthread_attr_init(&attr);
 	BUG_ON(err);
-	err = pthread_attr_setstacksize(&attr, (size_t)(16*1024));
+	err = pthread_attr_setstacksize(&attr,
+			(size_t) max(16 * 1024, PTHREAD_STACK_MIN));
 	BUG_ON(err);
 	err = pthread_mutex_lock(&start_work_mutex);
 	BUG_ON(err);
-- 
1.6.2.5

