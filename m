Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752987Ab1KRXhT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 18:37:19 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53395 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083Ab1KRXhR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 18:37:17 -0500
Date: Fri, 18 Nov 2011 15:36:56 -0800
From: tip-bot for Andrew Vagin <avagin@openvz.org>
Message-ID: <tip-5d81e5cfb37a174e8ddc0413e2e70cdf05807ace@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, avagin@openvz.org,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, avagin@openvz.org,
        mingo@elte.hu
In-Reply-To: <1320670457-2633428-3-git-send-email-avagin@openvz.org>
References: <1320670457-2633428-3-git-send-email-avagin@openvz.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] events: Don't divide events if it has field period
Git-Commit-ID: 5d81e5cfb37a174e8ddc0413e2e70cdf05807ace
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 18 Nov 2011 15:37:02 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5d81e5cfb37a174e8ddc0413e2e70cdf05807ace
Gitweb:     http://git.kernel.org/tip/5d81e5cfb37a174e8ddc0413e2e70cdf05807ace
Author:     Andrew Vagin <avagin@openvz.org>
AuthorDate: Mon, 7 Nov 2011 15:54:12 +0300
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 14 Nov 2011 13:31:28 +0100

events: Don't divide events if it has field period

This patch solves the following problem:

Now some samples may be lost due to throttling. The number of samples is
restricted by sysctl_perf_event_sample_rate/HZ.  A trace event is
divided on some samples according to event's period.  I don't sure, that
we should generate more than one sample on each trace event. I think the
better way to use SAMPLE_PERIOD.

E.g.: I want to trace when a process sleeps. I created a process, which
sleeps for 1ms and for 4ms.  perf got 100 events in both cases.

swapper     0 [000]  1141.371830: sched_stat_sleep: comm=foo pid=1801 delay=1386750 [ns]
swapper     0 [000]  1141.369444: sched_stat_sleep: comm=foo pid=1801 delay=4499585 [ns]

In the first case a kernel want to send 4499585 events and
in the second case it wants to send 1386750 events.
perf-reports shows that process sleeps in both places equal time. It's
bug.

With this patch kernel generates one event on each "sleep" and the time
slice is saved in the field "period". Perf knows how handle it.

Signed-off-by: Andrew Vagin <avagin@openvz.org>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1320670457-2633428-3-git-send-email-avagin@openvz.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/events/core.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index eadac69..8d9dea5 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -4528,7 +4528,6 @@ static void perf_swevent_overflow(struct perf_event *event, u64 overflow,
 	struct hw_perf_event *hwc = &event->hw;
 	int throttle = 0;
 
-	data->period = event->hw.last_period;
 	if (!overflow)
 		overflow = perf_swevent_set_period(event);
 
@@ -4562,6 +4561,12 @@ static void perf_swevent_event(struct perf_event *event, u64 nr,
 	if (!is_sampling_event(event))
 		return;
 
+	if ((event->attr.sample_type & PERF_SAMPLE_PERIOD) && !event->attr.freq) {
+		data->period = nr;
+		return perf_swevent_overflow(event, 1, data, regs);
+	} else
+		data->period = event->hw.last_period;
+
 	if (nr == 1 && hwc->sample_period == 1 && !event->attr.freq)
 		return perf_swevent_overflow(event, 1, data, regs);
 
