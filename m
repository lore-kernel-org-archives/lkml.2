Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754640Ab1DUUEd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 16:04:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38268 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753341Ab1DUUEc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 16:04:32 -0400
From: Don Zickus <dzickus@redhat.com>
To: <x86@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Cyrill Gorcunov <gorcunov@gmail.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>, Don Zickus <dzickus@redhat.com>
Subject: [PATCH 2/4] perf, x86: P4 PMU - Don't forget to clear cpuc->active_mask on overflow
Date: Thu, 21 Apr 2011 11:03:21 -0400
Message-Id: <1303398203-2918-3-git-send-email-dzickus@redhat.com>
In-Reply-To: <1303398203-2918-1-git-send-email-dzickus@redhat.com>
References: <1303398203-2918-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cyrill Gorcunov <gorcunov@gmail.com>

It's not enough to simply disable event on overflow the cpuc->active_mask
should be cleared as well otherwise counter may stall in "active" even
in real being already disabled (which potentially may lead to the situation
that user may not use this counter further).

Don pointed "I also noticed this patch fixed some unknown NMIs on a P4 when
I stressed the box".

Tested-by: Lin Ming <ming.m.lin@intel.com>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Acked-by: Don Zickus <dzickus@redhat.com>
Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 arch/x86/kernel/cpu/perf_event_p4.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_p4.c b/arch/x86/kernel/cpu/perf_event_p4.c
index 6f2bd89..56ba449 100644
--- a/arch/x86/kernel/cpu/perf_event_p4.c
+++ b/arch/x86/kernel/cpu/perf_event_p4.c
@@ -946,7 +946,7 @@ static int p4_pmu_handle_irq(struct pt_regs *regs)
 		if (!x86_perf_event_set_period(event))
 			continue;
 		if (perf_event_overflow(event, 1, &data, regs))
-			p4_pmu_disable_event(event);
+			x86_pmu_stop(event, 0);
 	}
 
 	if (handled) {
-- 
1.7.4.2

