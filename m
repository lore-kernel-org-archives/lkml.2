Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755136Ab2B1JOy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 04:14:54 -0500
Received: from terminus.zytor.com ([198.137.202.10]:51328 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753382Ab2B1JOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 04:14:52 -0500
Date: Tue, 28 Feb 2012 01:13:42 -0800
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-30ce2f7eef095d1b8d070740f1948629814fe3c7@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, acme@ghostprotocols.net,
        namhyung.kim@lge.com, fweisbec@gmail.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com,
        a.p.zijlstra@chello.nl, acme@ghostprotocols.net, namhyung.kim@lge.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1330391978-28070-1-git-send-email-namhyung.kim@lge.com>
References: <1330391978-28070-1-git-send-email-namhyung.kim@lge.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf/hwbp: Fix a possible memory leak
Git-Commit-ID: 30ce2f7eef095d1b8d070740f1948629814fe3c7
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 28 Feb 2012 01:14:12 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  30ce2f7eef095d1b8d070740f1948629814fe3c7
Gitweb:     http://git.kernel.org/tip/30ce2f7eef095d1b8d070740f1948629814fe3c7
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Tue, 28 Feb 2012 10:19:38 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 28 Feb 2012 09:52:54 +0100

perf/hwbp: Fix a possible memory leak

If kzalloc() for TYPE_DATA failed on a given cpu, previous chunk
of TYPE_INST will be leaked. Fix it.

Thanks to Peter Zijlstra for suggesting this better solution. It
should work as long as the initial value of the region is all
0's and that's the case of static (per-cpu) memory allocation.

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Link: http://lkml.kernel.org/r/1330391978-28070-1-git-send-email-namhyung.kim@lge.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/events/hw_breakpoint.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/events/hw_breakpoint.c b/kernel/events/hw_breakpoint.c
index b7971d6..ee706ce 100644
--- a/kernel/events/hw_breakpoint.c
+++ b/kernel/events/hw_breakpoint.c
@@ -651,10 +651,10 @@ int __init init_hw_breakpoint(void)
 
  err_alloc:
 	for_each_possible_cpu(err_cpu) {
-		if (err_cpu == cpu)
-			break;
 		for (i = 0; i < TYPE_MAX; i++)
 			kfree(per_cpu(nr_task_bp_pinned[i], cpu));
+		if (err_cpu == cpu)
+			break;
 	}
 
 	return -ENOMEM;
