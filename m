Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755362Ab1LVQf6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 11:35:58 -0500
Received: from mail.lippert-at.com ([62.80.22.186]:3412 "EHLO
	domex.lippertembedded.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753195Ab1LVQfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 11:35:55 -0500
Message-ID: <4EF35C66.6010402@LiPPERTEmbedded.de>
Date: Thu, 22 Dec 2011 17:35:50 +0100
From: Jens Rottmann <JRottmann@LiPPERTEmbedded.de>
User-Agent: Thunderbird 1.5.0.14 (Windows/20071210)
MIME-Version: 1.0
To: Andres Salomon <dilinger@queued.net>, Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org, linux-geode@lists.infradead.org
Subject: [PATCH] cs5535-clockevt: allow the MFGPT IRQ to be shared
References: <4EE620A5.7080402@LiPPERTEmbedded.de>	<20111212123131.502be350@queued.net>	<4EE77416.8090907@LiPPERTEmbedded.de>	<4EE8ECF3.6000900@LiPPERTEmbedded.de> <20111214104724.292b02d4@queued.net>
In-Reply-To: <20111214104724.292b02d4@queued.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 Dec 2011 16:35:52.0012 (UTC) FILETIME=[C4D378C0:01CCC0C7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cs5535-clockevt: allow the MFGPT IRQ to be shared

Shared timer IRQs are not a good solution, however the Geode platform has no
APIC, IRQs are a scarce resource and there is no technical reason to forbid it
rightaway.  Increased latencies and overhead due to sharing are still better
than a driver refusing to load.

Signed-off-by: Jens Rottmann <JRottmann@LiPPERTEmbedded.de>
---

Hi,

I tested this a bit longer, this time with MFGPT IRQ actually being triggered,
with cs5535-clockevt driver loaded first or second when sharing the IRQ, with
some CPU load or without.

I didn't encounter any negative effects of this change. I did have suspend
problems with cs5535-clockevt, but that was in no way different from before I
applied this patch, it's an unrelated BIOS issue.

Thomas Gleixner wrote:
> No, you can share a timer irq. The other drivers don't have the SHARED
> flag set because they are on exclusive irq lines, ...

Is this an ACK?

> shared irqs suck and you figure that out once you try to
> use that shared timer irq on a preempt-rt enabled kernel.

Or a NACK?  :-|   (I did address this in the commit log.)

The kernel I tested with was 3.2-rc6, CONFIG_SMP=y and CONFIG_PREEMPT=y. As I
said, I didn't notice anything bad happening.

Thanks and have a nice christmas holiday,
Jens

--- linux-3.2-rc6/drivers/clocksource/cs5535-clockevt.c
+++ allow_shared_mfgpt_irq/drivers/clocksource/cs5535-clockevt.c
@@ -133,7 +133,7 @@ static irqreturn_t mfgpt_tick(int irq, v
 
 static struct irqaction mfgptirq  = {
 	.handler = mfgpt_tick,
-	.flags = IRQF_DISABLED | IRQF_NOBALANCING | IRQF_TIMER,
+	.flags = IRQF_DISABLED | IRQF_NOBALANCING | IRQF_TIMER | IRQF_SHARED,
 	.name = DRV_NAME,
 };
 
_

