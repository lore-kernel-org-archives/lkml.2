Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754481Ab2AYJpW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 04:45:22 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:38992 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484Ab2AYJpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 04:45:20 -0500
Message-ID: <4F1FCF6A.20108@linaro.org>
Date: Wed, 25 Jan 2012 13:46:18 +0400
From: Dmitry Antipov <dmitry.antipov@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: john stultz <johnstul@us.ibm.com>
CC: linaro-dev@lists.linaro.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Amit Kucheria <amit.kucheria@linaro.org>
Subject: Re: [PATCH] hrtimers, timers: eliminate some jiffies-backed code
References: <1327333258-20734-1-git-send-email-dmitry.antipov@linaro.org> <1327449689.11738.34.camel@work-vm>
In-Reply-To: <1327449689.11738.34.camel@work-vm>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/25/2012 04:01 AM, john stultz wrote:

> Why do you want to move loops like the above from jiffies based timeouts
> to hrtimers?

I'm trying to see whether there are possible benefits in the sense of power management.
More hrtimers with larger expire deltas -> more opportunities to coalesce hrtimer
interrupts -> less frequency of hrtimer interrupts -> longer idle/suspend/stanby/etc.
periods.

> Is there an actual need for sub-jiffy granularity in these sorts of
> timeouts?

I didn't collect a representative statistics among the large set of different drivers,
but I believe the answer is 'no' for the most of them. The main reason is described above.

> Or is this really just a "getting away from using jiffies" cleanup?

A bit of this too, definitely. Documentation/timers/highres.txt notices 'complete jiffies
removal' as something which may take place sometime; at least, I don't have an ideas why
to use jiffies in a new code.

> Calling get_time() again on each hrtimer_wakeup isn't free.
>
> With this we end up when the irq fires, calling hrtimer_interrupt, which
> reads the time and goes through the timer list running expired timers,
> which then runs the sleeper's timer which then reads the time again!
> Additinoally, this extra overhead is done even no one wants the elapsed
> time.

Thanks, I'll think about reworking of this.

Dmitry
