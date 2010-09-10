Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755147Ab0IJPsm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 11:48:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:47005 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755041Ab0IJPsk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 11:48:40 -0400
Date: Fri, 10 Sep 2010 15:48:20 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Fix perf_init_event()
Message-ID: <tip-e5f4d3394a52ac351f1a479fe136d92fa5228eff@git.kernel.org>
Git-Commit-ID: e5f4d3394a52ac351f1a479fe136d92fa5228eff
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 10 Sep 2010 15:48:21 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e5f4d3394a52ac351f1a479fe136d92fa5228eff
Gitweb:     http://git.kernel.org/tip/e5f4d3394a52ac351f1a479fe136d92fa5228eff
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 10 Sep 2010 17:38:06 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 10 Sep 2010 17:41:55 +0200

perf: Fix perf_init_event()

We ought to return -ENOENT when non of the registered PMUs
recognise the requested event.

This fixes a boot crash that occurs if no PMU is available
but the NMI watchdog tries to register an event.

Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/perf_event.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index f395fb4..f29b525 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -5236,12 +5236,15 @@ struct pmu *perf_init_event(struct perf_event *event)
 	list_for_each_entry_rcu(pmu, &pmus, entry) {
 		int ret = pmu->event_init(event);
 		if (!ret)
-			break;
+			goto unlock;
+
 		if (ret != -ENOENT) {
 			pmu = ERR_PTR(ret);
-			break;
+			goto unlock;
 		}
 	}
+	pmu = ERR_PTR(-ENOENT);
+unlock:
 	srcu_read_unlock(&pmus_srcu, idx);
 
 	return pmu;
