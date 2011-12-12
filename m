Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752988Ab1LLP4i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 10:56:38 -0500
Received: from mail.lippert-at.com ([62.80.22.186]:42997 "EHLO
	domex.lippertembedded.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751810Ab1LLP4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 10:56:37 -0500
X-Greylist: delayed 912 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 Dec 2011 10:56:37 EST
Message-ID: <4EE620A5.7080402@LiPPERTEmbedded.de>
Date: Mon, 12 Dec 2011 16:41:25 +0100
From: Jens Rottmann <JRottmann@LiPPERTEmbedded.de>
User-Agent: Thunderbird 1.5.0.14 (Windows/20071210)
MIME-Version: 1.0
To: Andres Salomon <dilinger@queued.net>
CC: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        linux-geode@lists.infradead.org
Subject: IRQF_TIMER | IRQF_SHARED ?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Dec 2011 15:41:20.0830 (UTC) FILETIME=[7EEB35E0:01CCB8E4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andres,

one of our customers tripped over the fact that the MFGPT driver won't share its
IRQ with anyone else. (MFGPT defaulted to same IRQ as audio, MFGPT driver loaded
first, audio fails.) *No big deal!* They don't actually need MFGPT and will
simply disable it. It just made me wonder ...

Why would it be such a bad idea to use IRQF_TIMER | IRQF_SHARED (see patch
below)? mfgpt_tick() already does properly return IRQ_NONE when it feels
unresponsible. I tested it with either driver loaded first and it seemed to work
(well, at least audio worked, don't know how to explicitly test cs5535-clockevt).

I thought about latencies of IRQ sharing being unacceptable for a timer, but ...
- If MFGPT is loaded first there is no additional latency, is there? Audio
  recieves its IRQs only as 2nd in list but that's not a problem.
- If MFGPT is loaded second - well, there is a latency, but without sharing the
  IRQ the driver failed to load at all, so that's still an improvement.

But I did not fail to notice that _none_ of the code in drivers/clocksource/
uses IRQF_SHARED, obviously this must be deliberate.

So, what's so bad about IRQF_TIMER | IRQF_SHARED?

Any education would be welcome, even if combined with flame. :-)

Thanks and best regards,
Jens

--- linux-3.2-rc4/drivers/clocksource/cs5535-clockevt.c
+++ shared_mfgpt_irq/drivers/clocksource/cs5535-clockevt.c
@@ -133,7 +133,7 @@ static irqreturn_t mfgpt_tick(int irq, v

 static struct irqaction mfgptirq  = {
 	.handler = mfgpt_tick,
-	.flags = IRQF_DISABLED | IRQF_NOBALANCING | IRQF_TIMER,
+	.flags = IRQF_DISABLED | IRQF_NOBALANCING | IRQF_TIMER | IRQF_SHARED,
 	.name = DRV_NAME,
 };

_

