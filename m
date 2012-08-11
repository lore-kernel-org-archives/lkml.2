Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753462Ab2HKKRZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2012 06:17:25 -0400
Received: from inca-roads.misterjones.org ([213.251.177.50]:41251 "EHLO
	inca-roads.misterjones.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750804Ab2HKKRV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2012 06:17:21 -0400
X-Greylist: delayed 768 seconds by postgrey-1.27 at vger.kernel.org; Sat, 11 Aug 2012 06:17:21 EDT
To: Rohit Vaswani <rvaswani@codeaurora.org>
Subject: Re: [PATCH 1/2] ARM: local timers: Unmask interrupt before new TVAL is set
X-PHP-Originating-Script: 0:func.inc
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Sat, 11 Aug 2012 12:17:14 +0200
From: Marc Zyngier <marc.zyngier@arm.com>
Cc: Russell King <linux@arm.linux.org.uk>, <linux-arm-msm@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Organization: ARM Ltd
In-Reply-To: <1344635854-5033-1-git-send-email-rvaswani@codeaurora.org>
References: <1344635854-5033-1-git-send-email-rvaswani@codeaurora.org>
Message-ID: <cdb51f00bafa8151a880d8cc7898631e@localhost>
User-Agent: RoundCube Webmail/0.3.1
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Rcpt-To: rvaswani@codeaurora.org, linux@arm.linux.org.uk, linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: marc.zyngier@arm.com
X-SA-Exim-Scanned: No (on inca-roads.misterjones.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Aug 2012 14:57:34 -0700, Rohit Vaswani
<rvaswani@codeaurora.org>
wrote:
> Level triggered interrupt is deasserted when a new TVAL is written
> only when the interrupt is unmasked. Make sure that the interrupt
> is unmasked in CTL register before TVAL is written.
> If this order is not followed, there are chances that on some
> hardware you would not receive any timer interrupts.
> 
> Signed-off-by: Rohit Vaswani <rvaswani@codeaurora.org>
> ---
>  arch/arm/kernel/arch_timer.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/arm/kernel/arch_timer.c b/arch/arm/kernel/arch_timer.c
> index dd58035..1d0d9df 100644
> --- a/arch/arm/kernel/arch_timer.c
> +++ b/arch/arm/kernel/arch_timer.c
> @@ -126,8 +126,8 @@ static int arch_timer_set_next_event(unsigned long
evt,
>  	ctrl |= ARCH_TIMER_CTRL_ENABLE;
>  	ctrl &= ~ARCH_TIMER_CTRL_IT_MASK;
>  
> -	arch_timer_reg_write(ARCH_TIMER_REG_TVAL, evt);
>  	arch_timer_reg_write(ARCH_TIMER_REG_CTRL, ctrl);
> +	arch_timer_reg_write(ARCH_TIMER_REG_TVAL, evt);

But by doing so, you're opening a window where TVAL can be negative (from
a previous timer trigger) and the interrupt unmasked, which would lead to
an immediate trigger, before TVAL is updated with the new value.

Does your hardware deassert the interrupt even when the enable bit is not
set? If so, would the following sequence work?

        ctrl &= ~(ARCH_TIMER_CTRL_ENABLE | ARCH_TIMER_CTRL_IT_MASK);
        arch_timer_reg_write(ARCH_TIMER_REG_CTRL, ctrl);

	arch_timer_reg_write(ARCH_TIMER_REG_TVAL, evt);

        ctrl |= ARCH_TIMER_CTRL_ENABLE;
        arch_timer_reg_write(ARCH_TIMER_REG_CTRL, ctrl);

Thanks,

        M.
-- 
Fast, cheap, reliable. Pick two.

