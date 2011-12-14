Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757972Ab1LNSho (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 13:37:44 -0500
Received: from mail.lippert-at.com ([62.80.22.186]:14919 "EHLO
	domex.lippertembedded.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757717Ab1LNShh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 13:37:37 -0500
Message-ID: <4EE8ECF3.6000900@LiPPERTEmbedded.de>
Date: Wed, 14 Dec 2011 19:37:39 +0100
From: Jens Rottmann <JRottmann@LiPPERTEmbedded.de>
User-Agent: Thunderbird 1.5.0.14 (Windows/20071210)
MIME-Version: 1.0
To: Andres Salomon <dilinger@queued.net>
CC: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        linux-geode@lists.infradead.org
Subject: Re: IRQF_TIMER | IRQF_SHARED ?
References: <4EE620A5.7080402@LiPPERTEmbedded.de> <20111212123131.502be350@queued.net> <4EE77416.8090907@LiPPERTEmbedded.de>
In-Reply-To: <4EE77416.8090907@LiPPERTEmbedded.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Dec 2011 18:37:33.0119 (UTC) FILETIME=[7151FCF0:01CCBA8F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Rottmann schrieb:
> Andres Salomon schrieb:
>> Just loading cs5535-clockevt should start the periodic timer.
>> On my XO-1, IRQ 7 starts firing immediately.
> Hmm, no, doesn't work. :-|  In /proc/interrupts IRQ 0 gets increased,
> not (in my case) IRQ 11.

Update: I found that SMP-enabled kernels (like the generic one I was using) do
load cs5535-clockevt fine but ignore it and keep using the pit timer instead.

Responsible seems kernel/time/tick-common.c: tick_check_new_device()
                /*
                 * If the cpu affinity of the device interrupt can not
                 * be set, ignore it.
                 */
                if (!irq_can_set_affinity(newdev->irq))
                        goto out_bc;

Looks like it has been that way for quite some time, maybe cs5535-clockevt
hasn't ever worked on SMP kernels.

If I turn off SMP, cs5535-clockevt replaces the pit timer and the MFGPT IRQ
starts firing just as you said - at least on 3.0.9. 3.2-rc5 prefers to hang
instead, looks like no timer events get generated. Sigh.

I'll try to narrow it down tomorrow, but now I'm calling it a day.

Cheers
Jens
