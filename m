Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753741Ab2BFI1L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 03:27:11 -0500
Received: from [62.80.22.186] ([62.80.22.186]:6783 "EHLO
	domex.lippertembedded.de" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750986Ab2BFI1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 03:27:10 -0500
Message-ID: <4F2F8D51.1010504@LiPPERTEmbedded.de>
Date: Mon, 06 Feb 2012 09:20:33 +0100
From: Jens Rottmann <JRottmann@LiPPERTEmbedded.de>
User-Agent: Thunderbird 1.5.0.14 (Windows/20071210)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, John Stultz <johnstul@us.ibm.com>
CC: Andres Salomon <dilinger@queued.net>, linux-kernel@vger.kernel.org,
        linux-geode@lists.infradead.org
Subject: [PATCH resend] cs5535-clockevt: don't ignore MFGPT on SMP-capable
 kernels
References: <4EE620A5.7080402@LiPPERTEmbedded.de>	<20111212123131.502be350@queued.net>	<4EE77416.8090907@LiPPERTEmbedded.de>	<4EE8ECF3.6000900@LiPPERTEmbedded.de> <20111214104724.292b02d4@queued.net>
In-Reply-To: <20111214104724.292b02d4@queued.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Feb 2012 08:27:04.0128 (UTC) FILETIME=[1B0C0400:01CCE4A9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cs5535-clockevt: don't ignore MFGPT on SMP-capable kernels

On SMP-capable kernels (e.g. generic distro kernel) the cs5535-clockevt driver
loads but is not actually used.

Setting cpumask to cpu_all_mask works for UP-only kernels, but if compiled for
SMP - though still running on the same UP hardware -
kernel/time/tick-common.c:tick_check_new_device() reads this as "non-cpu-local"
and silently ignores the device.

If we leave cpumask unset clockevents_register_device() will initialize it and
the cs5535-clockevt driver will be used no matter how the kernel was compiled.
Should anyone ever manage to stick a CS553x in an SMP system (is this even
possible?) then a warning will be printed.  This is fine as the cs5535-clockevt
driver was never written/tested for SMP.

If bisecting led you here this patch may have exposed a pre-existing MFGPT
problem.  Configure for UP-only and re-check.

Signed-off-by: Jens Rottmann <JRottmann@LiPPERTEmbedded.de>
Acked-by: Andres Salomon <dilinger@queued.net>
---

Hi again,

could you please take this, for linux-next?

Thanks,
Jens

--- linux-3.2-rc6/drivers/clocksource/cs5535-clockevt.c
+++ use_mfgpt_on_smp_kernels/drivers/clocksource/cs5535-clockevt.c
@@ -100,7 +100,6 @@ static struct clock_event_device cs5535_
 	.set_mode = mfgpt_set_mode,
 	.set_next_event = mfgpt_next_event,
 	.rating = 250,
-	.cpumask = cpu_all_mask,
 	.shift = 32
 };
 
_


