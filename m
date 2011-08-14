Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753479Ab1HNPyo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 11:54:44 -0400
Received: from hera.kernel.org ([140.211.167.34]:40220 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751457Ab1HNPyl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 11:54:41 -0400
Date: Sun, 14 Aug 2011 15:54:13 GMT
From: tip-bot for Mark Rutland <mark.rutland@arm.com>
Message-ID: <tip-7e5b2a01d2ca2eae4ef913b59f84341f9a70e206@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, will.deacon@arm.com, mark.rutland@arm.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        will.deacon@arm.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        mark.rutland@arm.com, mingo@elte.hu
In-Reply-To: <1313062280-19123-1-git-send-email-mark.rutland@arm.com>
References: <1313062280-19123-1-git-send-email-mark.rutland@arm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: provide PMU when initing events
Git-Commit-ID: 7e5b2a01d2ca2eae4ef913b59f84341f9a70e206
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 14 Aug 2011 15:54:16 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7e5b2a01d2ca2eae4ef913b59f84341f9a70e206
Gitweb:     http://git.kernel.org/tip/7e5b2a01d2ca2eae4ef913b59f84341f9a70e206
Author:     Mark Rutland <mark.rutland@arm.com>
AuthorDate: Thu, 11 Aug 2011 12:31:20 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 14 Aug 2011 11:53:05 +0200

perf: provide PMU when initing events

Currently, an event's 'pmu' field is set after pmu::event_init() is
called. This means that pmu::event_init() must figure out which struct
pmu the event was initialised from. This makes it difficult to
consolidate common event initialisation code for similar PMUs, and
very difficult to implement drivers for PMUs which can have multiple
instances (e.g. a USB controller PMU, a GPU PMU, etc).

This patch sets the 'pmu' field before initialising the event, allowing
event init code to identify the struct pmu instance easily. In the
event of failure to initialise an event, the event is destroyed via
kfree() without calling perf_event::destroy(), so this shouldn't
result in bad behaviour even if the destroy field was set before
failure to initialise was noted.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Reviewed-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1313062280-19123-1-git-send-email-mark.rutland@arm.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/events/core.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index d4c8542..adc3ef3 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -5716,6 +5716,7 @@ struct pmu *perf_init_event(struct perf_event *event)
 	pmu = idr_find(&pmu_idr, event->attr.type);
 	rcu_read_unlock();
 	if (pmu) {
+		event->pmu = pmu;
 		ret = pmu->event_init(event);
 		if (ret)
 			pmu = ERR_PTR(ret);
@@ -5723,6 +5724,7 @@ struct pmu *perf_init_event(struct perf_event *event)
 	}
 
 	list_for_each_entry_rcu(pmu, &pmus, entry) {
+		event->pmu = pmu;
 		ret = pmu->event_init(event);
 		if (!ret)
 			goto unlock;
@@ -5849,8 +5851,6 @@ done:
 		return ERR_PTR(err);
 	}
 
-	event->pmu = pmu;
-
 	if (!event->parent) {
 		if (event->attach_state & PERF_ATTACH_TASK)
 			jump_label_inc(&perf_sched_events);
