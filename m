Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753977Ab1JaOGu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 10:06:50 -0400
Received: from mail.lemote.com ([222.92.8.141]:50252 "EHLO lemote.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752138Ab1JaOGt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 10:06:49 -0400
X-Greylist: delayed 452 seconds by postgrey-1.27 at vger.kernel.org; Mon, 31 Oct 2011 10:06:48 EDT
Message-ID: <4EAEA9AF.1060904@lemote.com>
Date: Mon, 31 Oct 2011 21:59:11 +0800
From: zhangfx <zhangfx@lemote.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: John Stultz <johnstul@us.ibm.com>
CC: Chen Jie <chenj@lemote.com>, Yong Zhang <yong.zhang0@gmail.com>,
        linux-mips@linux-mips.org, LKML <linux-kernel@vger.kernel.org>,
        tglx@linutronix.de, yanhua <yanh@lemote.com>,
        =?UTF-8?B?6aG55a6H?= <xiangy@lemote.com>,
        =?UTF-8?B?5a2Z5rW35YuH?= <sunhy@lemote.com>
Subject: Re: [MIPS]clocks_calc_mult_shift() may gen a too big mult value
References: <CAGXxSxXmgzxN361Cko1fY_+oWwfgjXLhS61gtvqB8YYXHXZVyw@mail.gmail.com>  <CAM2zO=CodQLE05ZNOOba3jv_qJ5XuZj3yrnS0aHCOj+cp_24Xw@mail.gmail.com>  <CAGXxSxUHGN99hXK8K5k9ayVfMenAWAbWVpqkotix_JyUbPCU+w@mail.gmail.com> <1320066197.2266.11.camel@js-netbook>
In-Reply-To: <1320066197.2266.11.camel@js-netbook>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Sirs,
>> Thanks for the suggestion. And sorry for I didn't notice the upstream
>> code has already hooked to clocksource_register_hz() in csrc-r4k.c
>> (We're using r4000 clock source)
>>
>> I'm afraid this still doesn't fix my case. Through
>> clocksource_register_hz()->__clocksource_register_scale()->__clocksource_updatefreq_scale,
>> I got a calculated maxsec = (0xffffffff - (0xffffffff>>5))/250000500 =
>> 16        # assume mips_hpt_frequency=250000500
>>
>> With this maxsec, I got a mult of 0xffffde72, still too big.
> Hrmm. Yong Zang is right to suggest clocksource_register_hz(), as the
> intention of that code is to try to avoid these sorts of issues.
>
> What is the corresponding shift value you're getting for the value
> above?
>
> Could you annotate clocks_calc_mult_shift() a little bit to see where
> things might be going wrong?
Let me give some real world data:
in one machine with 500MHz freq,
the calculated freq = 500084016, and clocks_calc_mult_shift() give
   mult = 4294245725
   shift = 30

but in the 1785th call to update_wall_time, due to error correction 
algorithm, the mult become 4293964632,
in next update_wall_time, the ntp_error is 0x301c93b7927c, which lead to 
an adj of 20, then mult is overflow:
    mult = 4293964632 + (1<<20) = 45912
with this mult, if anyone call timekeeping_get_ns or others using mult, 
the time concept will be extremely wrong, so some sleep will 
(almost)never return => virtually hang

We are not abosulately sure that the error source is normal, but anyway 
it is a possible for the code to overflow, and it will cause hang.

For this case, the timekeeping_bigadjust should be able to control adj 
to a maximum of around 20 with the lookahead for any error. So if the 
mult is chosen at shift = 29, then mult becomes 4294245725/2, it will 
not be possible to be overflowed.

In short, choosing a mult close to 2^32 is dangerous. But I don't know 
what's the best way to avoid it for general cases, because I don't know 
how big error can be and the adj can be for different systems.

Regards

Yours
Fuxin Zhang

>
> thanks
> -john
>
>
