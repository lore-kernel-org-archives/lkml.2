Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753770Ab2JZAGz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 20:06:55 -0400
Received: from mail.kernel.org ([198.145.19.201]:53047 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753614Ab2JZAGv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 20:06:51 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 39/42] sparc64: Fix bit twiddling in sparc_pmu_enable_event().
Date: Thu, 25 Oct 2012 17:05:47 -0700
Message-Id: <20121026000128.725101189@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121026000124.790781113@linuxfoundation.org>
References: <20121026000124.790781113@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/sparc/kernel/perf_event.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

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


