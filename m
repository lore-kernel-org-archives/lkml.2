Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755905Ab1AKLLf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 06:11:35 -0500
Received: from hera.kernel.org ([140.211.167.34]:36245 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755827Ab1AKLLc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 06:11:32 -0500
Date: Tue, 11 Jan 2011 11:11:03 GMT
From: tip-bot for Jiri Pirko <jpirko@redhat.com>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@redhat.com, peterz@infradead.org,
        jpirko@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, peterz@infradead.org,
        jpirko@redhat.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20110110160417.GB2685@psychotron.brq.redhat.com>
References: <20110110160417.GB2685@psychotron.brq.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf sched: Use PTHREAD_STACK_MIN to avoid pthread_attr_setstacksize() fail
Message-ID: <tip-12f7e0364375ba1ba55abcc5ac082b68fb526c80@git.kernel.org>
Git-Commit-ID: 12f7e0364375ba1ba55abcc5ac082b68fb526c80
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 11 Jan 2011 11:11:03 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  12f7e0364375ba1ba55abcc5ac082b68fb526c80
Gitweb:     http://git.kernel.org/tip/12f7e0364375ba1ba55abcc5ac082b68fb526c80
Author:     Jiri Pirko <jpirko@redhat.com>
AuthorDate: Mon, 10 Jan 2011 14:14:23 -0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 10 Jan 2011 14:16:00 -0200

perf sched: Use PTHREAD_STACK_MIN to avoid pthread_attr_setstacksize() fail

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
