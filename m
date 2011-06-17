Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933053Ab1FQUzy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 16:55:54 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:59700 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932205Ab1FQUzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 16:55:51 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6380"; a="98278602"
From: Jeff Ohlstein <johlstei@codeaurora.org>
To: Daniel Walker <dwalker@fifo99.com>, Bryan Huntsman <bryanh@codeaurora.org>,
        David Brown <davidb@codeaurora.org>
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Jeff Ohlstein <johlstei@codeaurora.org>,
        stable@kernel.org, Russell King <linux@arm.linux.org.uk>
Subject: [PATCH v2] msm: timer: compensate for timer shift in msm_read_timer_count
Date: Fri, 17 Jun 2011 13:55:38 -0700
Message-Id: <1308344138-2862-1-git-send-email-johlstei@codeaurora.org>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some msm targets have timers whose lower bits are unreliable. So, we
present our timers as lower frequency than they actually are, and ignore
the bottom 5 bits on such targets. This compensation was erroneously
removed from the msm_read_timer_count function, so restore it.

This was broken by 94790ec25 "msm: timer: SMP timer support for msm".

Signed-off-by: Jeff Ohlstein <johlstei@codeaurora.org>
---
 arch/arm/mach-msm/timer.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-msm/timer.c b/arch/arm/mach-msm/timer.c
index 38b95e9..608ec4d 100644
--- a/arch/arm/mach-msm/timer.c
+++ b/arch/arm/mach-msm/timer.c
@@ -100,7 +100,11 @@ static cycle_t msm_read_timer_count(struct clocksource *cs)
 {
 	struct msm_clock *clk = container_of(cs, struct msm_clock, clocksource);
 
-	return readl(clk->global_counter);
+	/*
+	 * Shift timer count down by a constant due to unreliable lower bits
+	 * on some targets.
+	 */
+	return readl(clk->global_counter) >> clk->shift;
 }
 
 static struct msm_clock *clockevent_to_clock(struct clock_event_device *evt)
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

