Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755667Ab0KZPF0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 10:05:26 -0500
Received: from hera.kernel.org ([140.211.167.34]:40491 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755300Ab0KZPFX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 10:05:23 -0500
Date: Fri, 26 Nov 2010 15:04:56 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        francis.moro@gmail.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, francis.moro@gmail.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Ignore non-sampling overflows
Message-ID: <tip-963988262c3c8f4234f64a0dde59446a295e07bb@git.kernel.org>
Git-Commit-ID: 963988262c3c8f4234f64a0dde59446a295e07bb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 26 Nov 2010 15:04:57 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  963988262c3c8f4234f64a0dde59446a295e07bb
Gitweb:     http://git.kernel.org/tip/963988262c3c8f4234f64a0dde59446a295e07bb
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 24 Nov 2010 18:55:29 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 26 Nov 2010 15:14:55 +0100

perf: Ignore non-sampling overflows

Some arch implementations call perf_event_overflow() by 'accident',
ignore this.

Reported-by: Francis Moreau <francis.moro@gmail.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/perf_event.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 98c5549..af1e63f 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -4240,6 +4240,13 @@ static int __perf_event_overflow(struct perf_event *event, int nmi,
 	struct hw_perf_event *hwc = &event->hw;
 	int ret = 0;
 
+	/*
+	 * Non-sampling counters might still use the PMI to fold short
+	 * hardware counters, ignore those.
+	 */
+	if (unlikely(!is_sampling_event(event)))
+		return 0;
+
 	if (!throttle) {
 		hwc->interrupts++;
 	} else {
