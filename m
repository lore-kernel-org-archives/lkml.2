Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932661Ab0JDUZq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 16:25:46 -0400
Received: from hera.kernel.org ([140.211.167.34]:39721 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932085Ab0JDUZo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 16:25:44 -0400
Date: Mon, 4 Oct 2010 20:25:02 GMT
From: tip-bot for Cyrill Gorcunov <gorcunov@gmail.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@redhat.com, gorcunov@openvz.org, gorcunov@gmail.com,
        robert.richter@amd.com, ming.m.lin@intel.com, tglx@linutronix.de,
        mingo@elte.hu, dzickus@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, gorcunov@openvz.org, gorcunov@gmail.com,
        robert.richter@amd.com, ming.m.lin@intel.com, tglx@linutronix.de,
        mingo@elte.hu, dzickus@redhat.com
In-Reply-To: <1285815698-4298-1-git-send-email-dzickus@redhat.com>
References: <1285815698-4298-1-git-send-email-dzickus@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf, x86: Handle in flight NMIs on P4 platform
Message-ID: <tip-03e22198d2379ffa746c9ea332fbb1f094f9423b@git.kernel.org>
Git-Commit-ID: 03e22198d2379ffa746c9ea332fbb1f094f9423b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 04 Oct 2010 20:25:03 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  03e22198d2379ffa746c9ea332fbb1f094f9423b
Gitweb:     http://git.kernel.org/tip/03e22198d2379ffa746c9ea332fbb1f094f9423b
Author:     Cyrill Gorcunov <gorcunov@gmail.com>
AuthorDate: Wed, 29 Sep 2010 23:01:38 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 30 Sep 2010 09:17:59 +0200

perf, x86: Handle in flight NMIs on P4 platform

Stephane reported we've forgot to guard the P4 platform
against spurious in-flight performance IRQs. Fix it.

This fixes potential spurious 'dazed and confused' NMI
messages.

Reported-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Signed-off-by: Don Zickus <dzickus@redhat.com>
Cc: fweisbec@gmail.com
Cc: peterz@infradead.org
Cc: Robert Richter <robert.richter@amd.com>
Cc: Lin Ming <ming.m.lin@intel.com>
LKML-Reference: <1285815698-4298-1-git-send-email-dzickus@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event_p4.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_p4.c b/arch/x86/kernel/cpu/perf_event_p4.c
index b560db3..2490151 100644
--- a/arch/x86/kernel/cpu/perf_event_p4.c
+++ b/arch/x86/kernel/cpu/perf_event_p4.c
@@ -660,8 +660,12 @@ static int p4_pmu_handle_irq(struct pt_regs *regs)
 	for (idx = 0; idx < x86_pmu.num_counters; idx++) {
 		int overflow;
 
-		if (!test_bit(idx, cpuc->active_mask))
+		if (!test_bit(idx, cpuc->active_mask)) {
+			/* catch in-flight IRQs */
+			if (__test_and_clear_bit(idx, cpuc->running))
+				handled++;
 			continue;
+		}
 
 		event = cpuc->events[idx];
 		hwc = &event->hw;
