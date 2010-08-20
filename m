Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753031Ab0HTOSl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 10:18:41 -0400
Received: from hera.kernel.org ([140.211.167.34]:55785 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752790Ab0HTOSj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 10:18:39 -0400
Date: Fri, 20 Aug 2010 14:18:08 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu, dzickus@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu,
        dzickus@redhat.com
In-Reply-To: <1282215916.1926.4696.camel@laptop>
References: <1282215916.1926.4696.camel@laptop>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] watchdog: Don't throttle the watchdog
Message-ID: <tip-b847b94fe2caff0f28a99af6353e9a27282e771a@git.kernel.org>
Git-Commit-ID: b847b94fe2caff0f28a99af6353e9a27282e771a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 20 Aug 2010 14:18:09 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b847b94fe2caff0f28a99af6353e9a27282e771a
Gitweb:     http://git.kernel.org/tip/b847b94fe2caff0f28a99af6353e9a27282e771a
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 20 Aug 2010 11:49:15 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 20 Aug 2010 15:00:06 +0200

watchdog: Don't throttle the watchdog

Stephane reported that when the machine locks up, the regular ticks,
which are responsible to resetting the throttle count, stop too.

Hence the NMI watchdog can end up being throttled before it reports on
the locked up state, and we end up being sad..

Cure this by having the watchdog overflow reset its own throttle count.

Reported-by: Stephane Eranian <eranian@google.com>
Tested-by: Stephane Eranian <eranian@google.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1282215916.1926.4696.camel@laptop>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/watchdog.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 613bc1f..0d53c8e 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -206,6 +206,9 @@ void watchdog_overflow_callback(struct perf_event *event, int nmi,
 		 struct perf_sample_data *data,
 		 struct pt_regs *regs)
 {
+	/* Ensure the watchdog never gets throttled */
+	event->hw.interrupts = 0;
+
 	if (__get_cpu_var(watchdog_nmi_touch) == true) {
 		__get_cpu_var(watchdog_nmi_touch) = false;
 		return;
