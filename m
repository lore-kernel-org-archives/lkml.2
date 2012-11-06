Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751365Ab2KFJhN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 04:37:13 -0500
Received: from antcom.de ([188.40.178.216]:39441 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751060Ab2KFJhG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 04:37:06 -0500
Message-ID: <5098DA10.3080002@antcom.de>
Date: Tue, 06 Nov 2012 10:36:16 +0100
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM Open Source Research and Development
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.7) Gecko/20120922 Icedove/10.0.7
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: Alban Bedel <alban.bedel@avionic-design.de>, linux-kernel@vger.kernel.org,
        Alexandre Pereira da Silva <aletes.xgr@gmail.com>
Subject: Re: [PATCH] pwm: lpc32xx - Fix the PWM polarity
References: <1352134125-22405-1-git-send-email-alban.bedel@avionic-design.de> <20121105210317.GA9930@avionic-0098.mockup.avionic-design.de>
In-Reply-To: <20121105210317.GA9930@avionic-0098.mockup.avionic-design.de>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11/12 22:03, Thierry Reding wrote:
> Cc'ing Roland and Alexandre. What do you guys think?
> 
> On Mon, Nov 05, 2012 at 05:48:45PM +0100, Alban Bedel wrote:
>> Signed-off-by: Alban Bedel <alban.bedel@avionic-design.de> --- 
>> drivers/pwm/pwm-lpc32xx.c |    6 +++++- 1 files changed, 5
>> insertions(+), 1 deletions(-)
>> 
>> diff --git a/drivers/pwm/pwm-lpc32xx.c
>> b/drivers/pwm/pwm-lpc32xx.c index adb87f0..a2704b8 100644 ---
>> a/drivers/pwm/pwm-lpc32xx.c +++ b/drivers/pwm/pwm-lpc32xx.c @@
>> -51,7 +51,11 @@ static int lpc32xx_pwm_config(struct pwm_chip
>> *chip, struct pwm_device *pwm,
>> 
>> c = 256 * duty_ns; do_div(c, period_ns); -	duty_cycles = c; +	if
>> (c > 255) +		c = 255; +	if (c < 1) +		c = 1; +	duty_cycles = 256
>> - c;
>> 
>> writel(PWM_ENABLE | PWM_RELOADV(period_cycles) |
>> PWM_DUTY(duty_cycles), lpc32xx->base + (pwm->hwpwm << 2));
> 
> Shouldn't duty_cycles rather be 255 - c, such that it can still be
> 0?
> 
> Thierry

According to the Manual: [Low]/[High] = [PWM_DUTY] / [256-PWM_DUTY],
i.e., the PWM polarity inversion looks good.

However, as Thierry pointed out, the valid range 0..255 should be
maintained differently, maybe:

if (c > 255)
	c = 255;
duty_cycles = 255 - c;

?

Thanks,

Roland
