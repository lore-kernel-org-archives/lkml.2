Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753283Ab1ARTHk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 14:07:40 -0500
Received: from hera.kernel.org ([140.211.167.34]:50259 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753228Ab1ARTHh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 14:07:37 -0500
Date: Tue, 18 Jan 2011 19:06:59 GMT
From: tip-bot for Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
        hpa@zytor.com, mingo@redhat.com, stern@rowland.harvard.edu,
        a.p.zijlstra@chello.nl, roland@redhat.com, fweisbec@gmail.com,
        tglx@linutronix.de, oleg@redhat.com, mingo@elte.hu,
        prasad@linux.vnet.ibm.com
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, stern@rowland.harvard.edu,
        a.p.zijlstra@chello.nl, fweisbec@gmail.com, roland@redhat.com,
        oleg@redhat.com, tglx@linutronix.de, prasad@linux.vnet.ibm.com,
        mingo@elte.hu
In-Reply-To: <20110118161008.GB693@redhat.com>
References: <20110118161008.GB693@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf: Find_get_context: fix the per-cpu-counter check
Message-ID: <tip-22a4ec729017ba613337a28f306f94ba5023fe2e@git.kernel.org>
Git-Commit-ID: 22a4ec729017ba613337a28f306f94ba5023fe2e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 18 Jan 2011 19:07:00 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  22a4ec729017ba613337a28f306f94ba5023fe2e
Gitweb:     http://git.kernel.org/tip/22a4ec729017ba613337a28f306f94ba5023fe2e
Author:     Oleg Nesterov <oleg@redhat.com>
AuthorDate: Tue, 18 Jan 2011 17:10:08 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 18 Jan 2011 19:34:23 +0100

perf: Find_get_context: fix the per-cpu-counter check

If task == NULL, find_get_context() should always check that cpu
is correct.

Afaics, the bug was introduced by 38a81da2 "perf events: Clean
up pid passing", but even before that commit "&& cpu != -1" was
not exactly right, -ESRCH from find_task_by_vpid() is not
accurate.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Prasad <prasad@linux.vnet.ibm.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: gregkh@suse.de
Cc: stable@kernel.org
LKML-Reference: <20110118161008.GB693@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/perf_event.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 76be4c7..a962b19 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -2228,7 +2228,7 @@ find_get_context(struct pmu *pmu, struct task_struct *task, int cpu)
 	unsigned long flags;
 	int ctxn, err;
 
-	if (!task && cpu != -1) {
+	if (!task) {
 		/* Must be root to operate on a CPU event: */
 		if (perf_paranoid_cpu() && !capable(CAP_SYS_ADMIN))
 			return ERR_PTR(-EACCES);
