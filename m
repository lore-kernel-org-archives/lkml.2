Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757621Ab1EaRBN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 13:01:13 -0400
Received: from eu1sys200aog119.obsmtp.com ([207.126.144.147]:51415 "EHLO
	eu1sys200aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756881Ab1EaRBK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 13:01:10 -0400
Message-ID: <4DE51EB7.7010606@stericsson.com>
Date: Tue, 31 May 2011 19:00:39 +0200
From: Mattias Wallin <mattias.wallin@stericsson.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Thunderbird/3.0.10
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 2/3] clocksource: add DB8500 PRCMU Timer support
References: <1306830661-9546-1-git-send-email-mattias.wallin@stericsson.com> <alpine.LFD.2.02.1105311236250.3078@ionos>
In-Reply-To: <alpine.LFD.2.02.1105311236250.3078@ionos>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/31/2011 12:38 PM, Thomas Gleixner wrote:
> On Tue, 31 May 2011, Mattias Wallin wrote:
>> +static cycle_t clksrc_db8500_prcmu_read(struct clocksource *cs)
>> +{
>> +	u32 count, count2;
>> +
>> +	do {
>> +		count = readl(PRCMU_TIMER_4_DOWNCOUNT);
>> +		count2 = readl(PRCMU_TIMER_4_DOWNCOUNT);
>> +	} while (count2 != count);
>
> What's the point of this exercise ?
It is a software workaround for a HW bug. If the timer is read exactly 
when the logic is in the process of flipping over to a new value you 
will get wrong value (large deviations). The problem was found running 
LTP tests reporting "Timer going backwards". Reading it two times will 
take long enough for the timer to stabilise according to our HW guys 
measurements.
I agree with you that it is odd enough to deserve a comment in the code. 
I will comment it in next version.
>
>> +	clocksource_calc_mult_shift(&clocksource_db8500_prcmu,
>> +		RATE_32K, SCHED_CLOCK_MIN_WRAP);
>> +	clocksource_register(&clocksource_db8500_prcmu);
>
> Please use clocksource_register_hz()
Ok.
>
>> diff --git a/include/linux/clksrc-db8500-prcmu.h b/include/linux/clksrc-db8500-prcmu.h
>> new file mode 100644
>> index 0000000..42b8587
>> --- /dev/null
>> +++ b/include/linux/clksrc-db8500-prcmu.h
>
> Huch, why needs this to be a separate head in include/linux ?
I will move the header file to mach-ux500/include/mach/. Ok?

(I have long time ago been thought to avoid include mach headers from 
the drivers. But if I understand it correct it is not true any more and 
in this case it certainly makes no sense since I break that rule myself.)
>
>> @@ -0,0 +1,17 @@
>> +/*
>> + * Copyright (C) ST-Ericsson SA 2011
>> + *
>> + * License Terms: GNU General Public License v2
>> + * Author: Mattias Wallin<mattias.wallin@stericsson.com>
>> + *
>> + */
>> +#ifndef __CLKSRC_DB8500_PRCMU_H
>> +#define __CLKSRC_DB8500_PRCMU_H
>> +
>> +#ifdef CONFIG_CLKSRC_DB8500_PRCMU
>> +void __init clksrc_db8500_prcmu_init(void);
>> +#else
>> +void __init clksrc_db8500_prcmu_init(void) {}
>> +#endif
>> +
>> +#endif
>> --
>> 1.7.4.3
>>
>>

