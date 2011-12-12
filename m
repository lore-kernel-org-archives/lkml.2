Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754137Ab1LLUly (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 15:41:54 -0500
Received: from lunge.queued.net ([173.255.254.236]:59498 "EHLO
	lunge.queued.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701Ab1LLUlx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 15:41:53 -0500
X-Greylist: delayed 620 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 Dec 2011 15:41:53 EST
Date: Mon, 12 Dec 2011 12:31:31 -0800
From: Andres Salomon <dilinger@queued.net>
To: Jens Rottmann <JRottmann@LiPPERTEmbedded.de>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        linux-geode@lists.infradead.org
Subject: Re: IRQF_TIMER | IRQF_SHARED ?
Message-ID: <20111212123131.502be350@queued.net>
In-Reply-To: <4EE620A5.7080402@LiPPERTEmbedded.de>
References: <4EE620A5.7080402@LiPPERTEmbedded.de>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Dec 2011 16:41:25 +0100
Jens Rottmann <JRottmann@LiPPERTEmbedded.de> wrote:

> Hi Andres,
> 
> one of our customers tripped over the fact that the MFGPT driver
> won't share its IRQ with anyone else. (MFGPT defaulted to same IRQ as
> audio, MFGPT driver loaded first, audio fails.) *No big deal!* They
> don't actually need MFGPT and will simply disable it. It just made me
> wonder ...
> 
> Why would it be such a bad idea to use IRQF_TIMER | IRQF_SHARED (see
> patch below)? mfgpt_tick() already does properly return IRQ_NONE when
> it feels unresponsible. I tested it with either driver loaded first
> and it seemed to work (well, at least audio worked, don't know how to
> explicitly test cs5535-clockevt).

Just loading cs5535-clockevt should start the periodic timer.  On my
XO-1, IRQ 7 starts firing immediately.


> 
> I thought about latencies of IRQ sharing being unacceptable for a
> timer, but ...
> - If MFGPT is loaded first there is no additional latency, is there?
> Audio recieves its IRQs only as 2nd in list but that's not a problem.
> - If MFGPT is loaded second - well, there is a latency, but without
> sharing the IRQ the driver failed to load at all, so that's still an
> improvement.
> 
> But I did not fail to notice that _none_ of the code in
> drivers/clocksource/ uses IRQF_SHARED, obviously this must be
> deliberate.

Hm, maybe tglx knows?  For my part, I don't think it would be a
problem, but I can imagine the reason for not sharing being clock drift
or something to that effect.


> 
> So, what's so bad about IRQF_TIMER | IRQF_SHARED?
> 
> Any education would be welcome, even if combined with flame. :-)
> 
> Thanks and best regards,
> Jens
> 
> --- linux-3.2-rc4/drivers/clocksource/cs5535-clockevt.c
> +++ shared_mfgpt_irq/drivers/clocksource/cs5535-clockevt.c
> @@ -133,7 +133,7 @@ static irqreturn_t mfgpt_tick(int irq, v
> 
>  static struct irqaction mfgptirq  = {
>  	.handler = mfgpt_tick,
> -	.flags = IRQF_DISABLED | IRQF_NOBALANCING | IRQF_TIMER,
> +	.flags = IRQF_DISABLED | IRQF_NOBALANCING | IRQF_TIMER |
> IRQF_SHARED, .name = DRV_NAME,
>  };
> 
> _
> 
