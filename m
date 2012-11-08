Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755427Ab2KHLXz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 06:23:55 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:57939 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755350Ab2KHLXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 06:23:49 -0500
Date: Thu, 8 Nov 2012 12:23:45 +0100
From: Alban Bedel <alban.bedel@avionic-design.de>
To: Roland Stigge <stigge@antcom.de>
Cc: Thierry Reding <thierry.reding@avionic-design.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Alexandre Pereira da Silva <aletes.xgr@gmail.com>,
        Alban Bedel <alban.bedel@avionic-design.de>
Subject: Re: [PATCH] pwm: lpc32xx - Fix the PWM polarity
Message-ID: <20121108122345.72aa0f6c@avionic-0020.adnet.avionic-design.de>
In-Reply-To: <509B8D20.6070208@antcom.de>
References: <20121106181939.61c50233@avionic-0020.adnet.avionic-design.de>
	<1352301955-15960-1-git-send-email-alban.bedel@avionic-design.de>
	<509B80A7.1060700@antcom.de>
	<20121108113353.4fdbb25c@avionic-0020.adnet.avionic-design.de>
	<509B8D20.6070208@antcom.de>
Organization: Avionic Design
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:g3tD8LJqoq6WweCHtzzhuCjt9/nsq03XOMVSw65/EJe
 NNflW12S9cg5dLHh6BInfl5Ekjv/zqHqtoumuDQ2I9ZxGpuf8c
 b5c2bSvFnszDeQi4aOqCSulkF79DoUl0jaFHoDBxXT8HYWdoAW
 oytaSogWm26pqTCSCIZ4scf70zrohofbrRKtY/AAkky61bmcPP
 yIoPq2ySbpqYRACQvSk7FZgxsYKieeqyXU23oOJ6LaG8WbNwnn
 TCcnSxb1rCCFWLcK6ZDK540K8Tmv3nDQVniMXjEFt1IQd1yBU4
 bLQyG83KCNcWx89TaQKZD1xhq24BaJZ6yaHPARaYIHxpHSVgUY
 n3WWukUDObBP6OlS3exgCqeMhw38aPHf/6I7BqaLhU41xzx0EP
 Lh/2AhFitjbN23MKtHZ9YRhJcwJunKnvdXbo72Dv18upuiovYA
 YHH/y
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 08 Nov 2012 11:44:48 +0100
Roland Stigge <stigge@antcom.de> wrote:

> On 08/11/12 11:33, Alban Bedel wrote:
> > On Thu, 08 Nov 2012 10:51:35 +0100
> > Roland Stigge <stigge@antcom.de> wrote:
> > 
> >> On 07/11/12 16:25, Alban Bedel wrote:
> >>> Signed-off-by: Alban Bedel <alban.bedel@avionic-design.de>
> >>> ---
> >>>  drivers/pwm/pwm-lpc32xx.c |    6 +++++-
> >>>  1 files changed, 5 insertions(+), 1 deletions(-)
> >>>
> >>> diff --git a/drivers/pwm/pwm-lpc32xx.c b/drivers/pwm/pwm-lpc32xx.c
> >>> index adb87f0..0dc278d 100644
> >>> --- a/drivers/pwm/pwm-lpc32xx.c
> >>> +++ b/drivers/pwm/pwm-lpc32xx.c
> >>> @@ -51,7 +51,11 @@ static int lpc32xx_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
> >>>  
> >>>  	c = 256 * duty_ns;
> >>>  	do_div(c, period_ns);
> >>> -	duty_cycles = c;
> >>> +	if (c == 0)
> >>> +		c = 256;
> >>> +	if (c > 255)
> >>> +		c = 255;
> >>> +	duty_cycles = 256 - c;
> >>
> >> Except for the range check (for the original c > 255), this results in:
> >>
> >> 	duty_cycles = 256 - c
> >>
> >> except for (c == 0) where
> >>
> >> 	duty_cycles = 1
> > 
> > No it lead to duty_cycles = 0
> 
> Let's do it step by step with the above code:
> 
> c == 0
> 
> >>> +	if (c == 0)
> >>> +		c = 256;
> 
> c == 256
> 
> >>> +	if (c > 255)
> >>> +		c = 255;
> 
> c == 255
> 
> >>> +	duty_cycles = 256 - c;
> 
> c == 1
> 
> See?

Right, my bad.
 
> > 
> >> which actually is
> >>
> >> 	duty_cycles = (256 - c) - 255
> >>
> >> (think with the original c)
> >>
> >> i.e. nearly a polarity inversion in the case of (c == 0).
> >>
> >> Why is the case (c == 0) so special here? Maybe you can document this,
> >> if it is really intended?
> > 
> > It is intended, the formular for duty value in the register is:
> > 
> > duty = (256 - 256*duty_ns/period_ns) % 256
> 
> Where does this modulo defined? In the Manual, there is sth. like this
> defined for RELOADV (tables 606+607), but not for DUTY.
> 
> Maybe I missed sth. in the manual. Link or hint appreciated!

The manual doesn't mention this explicitly but you can see that without
the modulo when duty_ns==0 DUTY would be 256, but the register is only
8 bits wide (ie. modulo 256). I made a few test and looked at the PWM
output on a scope they confirm this:

 DUTY     HIGH LEVEL
  1         99.9%
  25        90.0%
  128       50.0%
  220       10.0%
  255        0.1%
  0          0.0%

I'll resubmit the patch with the clamping in the correct order.

Alban
