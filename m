Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752218Ab1AJQEh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 11:04:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29137 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751463Ab1AJQEg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 11:04:36 -0500
Date: Mon, 10 Jan 2011 17:04:18 +0100
From: Jiri Pirko <jpirko@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@elte.hu,
        acme@ghostprotocols.net
Subject: [PATCH] tools/perf: use PTHREAD_STACK_MIN to avoid
 pthread_attr_setstacksize() fail
Message-ID: <20110110160417.GB2685@psychotron.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

on ppc64:
/usr/include/bits/local_lim.h:#define PTHREAD_STACK_MIN	131072

therefore following set of commands:
# perf sched record date
# perf sched report

gives:
perf.2.6.37test: builtin-sched.c:493: create_tasks: Assertion `!(err)' failed.

So make sure we do not set stack size lower than PTHREAD_STACK_MIN.

Signed-off-by: Jiri Pirko <jpirko@redhat.com>

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 7a4ebeb..bec0161 100644
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
