Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753585Ab1K2J2y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 04:28:54 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59791 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823Ab1K2J2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 04:28:51 -0500
Date: Tue, 29 Nov 2011 01:22:08 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Feng Tang <feng.tang@intel.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        kwlee@mtekvision.com, joel.clark@intel.com
Subject: Re: [PATCH 1/2] Input: tsc2007 - Disable irq when the irq thread is
 handling data
Message-ID: <20111129092208.GA21758@core.coreip.homeip.net>
References: <1322554378-348-1-git-send-email-feng.tang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322554378-348-1-git-send-email-feng.tang@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Feng,

On Tue, Nov 29, 2011 at 04:12:57PM +0800, Feng Tang wrote:
> The TSC2007 data sheet say in some case the HW may fire some false
> interrrupt, which I also met during integrating one TSC2007 device.
> So add the disable_irq/enable_irq protection around data handling.

IRQF_ONESHOT should prevent IRQ from firing again while thread is
servicing it. Did you actually observe it not working?

Thanks.

> 
> Signed-off-by: Feng Tang <feng.tang@intel.com>
> ---
>  drivers/input/touchscreen/tsc2007.c |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/input/touchscreen/tsc2007.c b/drivers/input/touchscreen/tsc2007.c
> index 1f674cb..789f216 100644
> --- a/drivers/input/touchscreen/tsc2007.c
> +++ b/drivers/input/touchscreen/tsc2007.c
> @@ -171,6 +171,13 @@ static irqreturn_t tsc2007_soft_irq(int irq, void *handle)
>  	struct ts_event tc;
>  	u32 rt;
>  
> +	/*
> +	 * Disable the irq, as it may fire several other IRQs during
> +	 * this thread is handling data, as suggested by the TSC2007
> +	 * datasheet, p19, "Touch Detect" chapter
> +	 */
> +	disable_irq_nosync(irq);
> +
>  	while (!ts->stopped && tsc2007_is_pen_down(ts)) {
>  
>  		/* pen is down, continue with the measurement */
> @@ -221,6 +228,7 @@ static irqreturn_t tsc2007_soft_irq(int irq, void *handle)
>  	if (ts->clear_penirq)
>  		ts->clear_penirq();
>  
> +	enable_irq(irq);
>  	return IRQ_HANDLED;
>  }
>  
> -- 
> 1.7.1
> 
> 

-- 
Dmitry
