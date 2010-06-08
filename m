Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756452Ab0FHUzq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 16:55:46 -0400
Received: from hera.kernel.org ([140.211.167.34]:44985 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754655Ab0FHUzo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 16:55:44 -0400
Date: Tue, 8 Jun 2010 20:55:13 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, a.p.zijlstra@chello.nl, stable@kernel.org,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, a.p.zijlstra@chello.nl, stable@kernel.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Fix signed comparison in perf_adjust_period()
Message-ID: <tip-f6ab91add6355e231e1c47897027b2a6ee4fa268@git.kernel.org>
Git-Commit-ID: f6ab91add6355e231e1c47897027b2a6ee4fa268
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 08 Jun 2010 20:55:15 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f6ab91add6355e231e1c47897027b2a6ee4fa268
Gitweb:     http://git.kernel.org/tip/f6ab91add6355e231e1c47897027b2a6ee4fa268
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 4 Jun 2010 15:18:01 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 8 Jun 2010 18:43:00 +0200

perf: Fix signed comparison in perf_adjust_period()

Frederic reported that frequency driven swevents didn't work properly
and even caused a division-by-zero error.

It turns out there are two bugs, the division-by-zero comes from a
failure to deal with that in perf_calculate_period().

The other was more interesting and turned out to be a wrong comparison
in perf_adjust_period(). The comparison was between an s64 and u64 and
got implicitly converted to an unsigned comparison. The problem is
that period_left is typically < 0, so it ended up being always true.

Cure this by making the local period variables s64.

Reported-by: Frederic Weisbecker <fweisbec@gmail.com>
Tested-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: <stable@kernel.org>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/perf_event.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 31d6afe..ff86c55 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -1507,6 +1507,9 @@ do {					\
 		divisor = nsec * frequency;
 	}
 
+	if (!divisor)
+		return dividend;
+
 	return div64_u64(dividend, divisor);
 }
 
@@ -1529,7 +1532,7 @@ static int perf_event_start(struct perf_event *event)
 static void perf_adjust_period(struct perf_event *event, u64 nsec, u64 count)
 {
 	struct hw_perf_event *hwc = &event->hw;
-	u64 period, sample_period;
+	s64 period, sample_period;
 	s64 delta;
 
 	period = perf_calculate_period(event, nsec, count);
