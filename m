Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754951Ab1DVMTa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 08:19:30 -0400
Received: from hera.kernel.org ([140.211.167.34]:56089 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753305Ab1DVMT2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 08:19:28 -0400
Date: Fri, 22 Apr 2011 12:19:10 GMT
From: tip-bot for Cyrill Gorcunov <gorcunov@gmail.com>
Message-ID: <tip-1ea5a6afd95a4803900c97ed63a47a883ebe7b3e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        gorcunov@openvz.org, gorcunov@gmail.com, ming.m.lin@intel.com,
        tglx@linutronix.de, mingo@elte.hu, dzickus@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        gorcunov@openvz.org, gorcunov@gmail.com, ming.m.lin@intel.com,
        tglx@linutronix.de, mingo@elte.hu, dzickus@redhat.com
In-Reply-To: <1303398203-2918-3-git-send-email-dzickus@redhat.com>
References: <1303398203-2918-3-git-send-email-dzickus@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf, x86: P4 PMU - Don't forget to clear cpuc->active_mask on overflow
Git-Commit-ID: 1ea5a6afd95a4803900c97ed63a47a883ebe7b3e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 22 Apr 2011 12:19:10 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1ea5a6afd95a4803900c97ed63a47a883ebe7b3e
Gitweb:     http://git.kernel.org/tip/1ea5a6afd95a4803900c97ed63a47a883ebe7b3e
Author:     Cyrill Gorcunov <gorcunov@gmail.com>
AuthorDate: Thu, 21 Apr 2011 11:03:21 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 22 Apr 2011 10:21:34 +0200

perf, x86: P4 PMU - Don't forget to clear cpuc->active_mask on overflow

It's not enough to simply disable event on overflow the
cpuc->active_mask should be cleared as well otherwise counter
may stall in "active" even in real being already disabled (which
potentially may lead to the situation that user may not use this
counter further).

Don pointed out that:

 " I also noticed this patch fixed some unknown NMIs
   on a P4 when I stressed the box".

Tested-by: Lin Ming <ming.m.lin@intel.com>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Acked-by: Don Zickus <dzickus@redhat.com>
Signed-off-by: Don Zickus <dzickus@redhat.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Link: http://lkml.kernel.org/r/1303398203-2918-3-git-send-email-dzickus@redhat.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event_p4.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_p4.c b/arch/x86/kernel/cpu/perf_event_p4.c
index c2520e1..d1f77e2 100644
--- a/arch/x86/kernel/cpu/perf_event_p4.c
+++ b/arch/x86/kernel/cpu/perf_event_p4.c
@@ -947,7 +947,7 @@ static int p4_pmu_handle_irq(struct pt_regs *regs)
 		if (!x86_perf_event_set_period(event))
 			continue;
 		if (perf_event_overflow(event, 1, &data, regs))
-			p4_pmu_disable_event(event);
+			x86_pmu_stop(event, 0);
 	}
 
 	if (handled) {
