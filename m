Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752791Ab1AQKqX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 05:46:23 -0500
Received: from hera.kernel.org ([140.211.167.34]:42746 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751090Ab1AQKqV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 05:46:21 -0500
Date: Mon, 17 Jan 2011 10:45:46 GMT
From: tip-bot for Anton Blanchard <anton@samba.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, anton@samba.org,
        hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
        acme@ghostprotocols.net, benh@kernel.crashing.org, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, anton@samba.org, paulus@samba.org,
        linux-kernel@vger.kernel.org, benh@kernel.crashing.org,
        a.p.zijlstra@chello.nl, acme@ghostprotocols.net, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <20110117161742.5feb3761@kryten>
References: <20110117161742.5feb3761@kryten>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] powerpc: perf: Fix frequency calculation for overflowing counters
Message-ID: <tip-4bca770ede796a1ef7af9c983166d5608d9ccfaf@git.kernel.org>
Git-Commit-ID: 4bca770ede796a1ef7af9c983166d5608d9ccfaf
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 17 Jan 2011 10:45:49 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4bca770ede796a1ef7af9c983166d5608d9ccfaf
Gitweb:     http://git.kernel.org/tip/4bca770ede796a1ef7af9c983166d5608d9ccfaf
Author:     Anton Blanchard <anton@samba.org>
AuthorDate: Mon, 17 Jan 2011 16:17:42 +1100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 17 Jan 2011 11:43:02 +0100

powerpc: perf: Fix frequency calculation for overflowing counters

When profiling a benchmark that is almost 100% userspace, I noticed some wildly
inaccurate profiles that showed almost all time spent in the kernel.

Closer examination shows we were programming a tiny number of cycles into the
PMU after each overflow (about ~200 away from the next overflow). This gets us
stuck in a loop which we eventually break out of by throttling the PMU (there
are regular throttle/unthrottle events in the log).

It looks like we aren't setting event->hw.last_period to something same and the
frequency to period calculations in perf are going haywire.

With the following patch we find the correct period after a few interrupts and
stay there. I also see no more throttle events.

Signed-off-by: Anton Blanchard <anton@samba.org>
Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linuxppc-dev@lists.ozlabs.org
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
LKML-Reference: <20110117161742.5feb3761@kryten>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/powerpc/kernel/perf_event.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/kernel/perf_event.c b/arch/powerpc/kernel/perf_event.c
index 5674807..ab6f6be 100644
--- a/arch/powerpc/kernel/perf_event.c
+++ b/arch/powerpc/kernel/perf_event.c
@@ -1212,6 +1212,7 @@ static void record_and_restart(struct perf_event *event, unsigned long val,
 			if (left <= 0)
 				left = period;
 			record = 1;
+			event->hw.last_period = event->hw.sample_period;
 		}
 		if (left < 0x80000000LL)
 			val = 0x80000000LL - left;
