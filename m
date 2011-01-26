Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753417Ab1AZMN6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 07:13:58 -0500
Received: from hera.kernel.org ([140.211.167.34]:39805 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753186Ab1AZMN4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 07:13:56 -0500
Date: Wed, 26 Jan 2011 12:13:28 GMT
From: tip-bot for Venkatesh Pallipadi <venki@google.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, sruffell@digium.com, tglx@linutronix.de,
        venki@google.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, sruffell@digium.com, tglx@linutronix.de,
        venki@google.com, mingo@elte.hu
In-Reply-To: <1292980144-28796-6-git-send-email-venki@google.com>
References: <1292980144-28796-6-git-send-email-venki@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] softirqs: Account ksoftirqd time as cpustat softirq
Message-ID: <tip-414bee9ba613adb3804965e2d84db32d0599f9c6@git.kernel.org>
Git-Commit-ID: 414bee9ba613adb3804965e2d84db32d0599f9c6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 26 Jan 2011 12:13:28 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  414bee9ba613adb3804965e2d84db32d0599f9c6
Gitweb:     http://git.kernel.org/tip/414bee9ba613adb3804965e2d84db32d0599f9c6
Author:     Venkatesh Pallipadi <venki@google.com>
AuthorDate: Tue, 21 Dec 2010 17:09:04 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 26 Jan 2011 12:33:22 +0100

softirqs: Account ksoftirqd time as cpustat softirq

softirq time in ksoftirqd context is not accounted in ns granularity
per cpu softirq stats, as we want that to be a part of ksoftirqd
exec_runtime.

Accounting them as softirq on /proc/stat separately.

Tested-by: Shaun Ruffell <sruffell@digium.com>
Signed-off-by: Venkatesh Pallipadi <venki@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1292980144-28796-6-git-send-email-venki@google.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 2a3c979..8b718b5 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3686,6 +3686,14 @@ static void irqtime_account_process_tick(struct task_struct *p, int user_tick,
 		cpustat->irq = cputime64_add(cpustat->irq, tmp);
 	} else if (irqtime_account_si_update()) {
 		cpustat->softirq = cputime64_add(cpustat->softirq, tmp);
+	} else if (this_cpu_ksoftirqd() == p) {
+		/*
+		 * ksoftirqd time do not get accounted in cpu_softirq_time.
+		 * So, we have to handle it separately here.
+		 * Also, p->stime needs to be updated for ksoftirqd.
+		 */
+		__account_system_time(p, cputime_one_jiffy, one_jiffy_scaled,
+					&cpustat->softirq);
 	} else if (user_tick) {
 		account_user_time(p, cputime_one_jiffy, one_jiffy_scaled);
 	} else if (p == rq->idle) {
