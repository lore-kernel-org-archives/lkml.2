Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933009Ab2LMOLW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:11:22 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44817 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932991Ab2LMOLR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:11:17 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "David S. Miller" <davem@davemloft.net>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 170/241] sparc64: Fix bit twiddling in sparc_pmu_enable_event().
Date: Thu, 13 Dec 2012 11:58:55 -0200
Message-Id: <1355407206-17100-171-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "David S. Miller" <davem@davemloft.net>

commit e793d8c6740f8fe704fa216e95685f4d92c4c4b9 upstream.

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
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 arch/sparc/kernel/perf_event.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/sparc/kernel/perf_event.c b/arch/sparc/kernel/perf_event.c
index b0cce26..ac18037 100644
--- a/arch/sparc/kernel/perf_event.c
+++ b/arch/sparc/kernel/perf_event.c
@@ -557,11 +557,13 @@ static u64 nop_for_index(int idx)
 
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
-- 
1.7.9.5

