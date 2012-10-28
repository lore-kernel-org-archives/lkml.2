Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757099Ab2J1XwO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 19:52:14 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:41758 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756231Ab2J1X05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 19:26:57 -0400
Message-Id: <20121028231541.060088859@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 28 Oct 2012 23:15:49 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 013/105] sparc64: Fix bit twiddling in sparc_pmu_enable_event().
In-Reply-To: <20121028231536.970033833@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "David S. Miller" <davem@davemloft.net>

[ Upstream commit e793d8c6740f8fe704fa216e95685f4d92c4c4b9 ]

There was a serious disconnect in the logic happening in
sparc_pmu_disable_event() vs. sparc_pmu_enable_event().

Event disable is implemented by programming a NOP event into the PCR.

However, event enable was not reversing this operation.  Instead, it
was setting the User/Priv/Hypervisor trace enable bits.

That's not sparc_pmu_enable_event()'s job, that's what
sparc_pmu_enable() and sparc_pmu_disable() do .

The intent of sparc_pmu_enable_event() is clear, since it first clear
out the event type encoding field.  So fix this by OR'ing in the event
encoding rather than the trace enable bits.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/sparc/kernel/perf_event.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/sparc/kernel/perf_event.c b/arch/sparc/kernel/perf_event.c
index 5331ae1..3c8f220 100644
--- a/arch/sparc/kernel/perf_event.c
+++ b/arch/sparc/kernel/perf_event.c
@@ -555,11 +555,13 @@ static u64 nop_for_index(int idx)
 
 static inline void sparc_pmu_enable_event(struct cpu_hw_events *cpuc, struct hw_perf_event *hwc, int idx)
 {
-	u64 val, mask = mask_for_index(idx);
+	u64 enc, val, mask = mask_for_index(idx);
+
+	enc = perf_event_get_enc(cpuc->events[idx]);
 
 	val = cpuc->pcr;
 	val &= ~mask;
-	val |= hwc->config;
+	val |= event_encoding(enc, idx);
 	cpuc->pcr = val;
 
 	pcr_ops->write(cpuc->pcr);


