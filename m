Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933892Ab1JaSaO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 14:30:14 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:52787 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933659Ab1JaSaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 14:30:12 -0400
Message-ID: <4EAEE92D.4080402@gmail.com>
Date: Mon, 31 Oct 2011 11:30:05 -0700
From: David Daney <ddaney.cavm@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: John Stultz <johnstul@us.ibm.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>
CC: zhangfx <zhangfx@lemote.com>, Chen Jie <chenj@lemote.com>,
        Yong Zhang <yong.zhang0@gmail.com>,
        "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
        LKML <linux-kernel@vger.kernel.org>, yanhua <yanh@lemote.com>,
        =?UTF-8?B?6aG55a6H?= <xiangy@lemote.com>,
        =?UTF-8?B?5a2Z5rW35YuH?= <sunhy@lemote.com>
Subject: Re: [MIPS]clocks_calc_mult_shift() may gen a too big mult value
References: <CAGXxSxXmgzxN361Cko1fY_+oWwfgjXLhS61gtvqB8YYXHXZVyw@mail.gmail.com>	 <CAM2zO=CodQLE05ZNOOba3jv_qJ5XuZj3yrnS0aHCOj+cp_24Xw@mail.gmail.com>	 <CAGXxSxUHGN99hXK8K5k9ayVfMenAWAbWVpqkotix_JyUbPCU+w@mail.gmail.com>	 <1320066197.2266.11.camel@js-netbook> <4EAEA9AF.1060904@lemote.com> <1320084763.8964.22.camel@js-netbook>
In-Reply-To: <1320084763.8964.22.camel@js-netbook>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/31/2011 11:12 AM, John Stultz wrote:
> On Mon, 2011-10-31 at 21:59 +0800, zhangfx wrote:
[...]
>>
>> In short, choosing a mult close to 2^32 is dangerous. But I don't know
>> what's the best way to avoid it for general cases, because I don't know
>> how big error can be and the adj can be for different systems.
>
> Ah. Ok, sorry for being so slow to understand.
>
> So yea, I think you're right that the issue seems to be that for certain
> feq values, the resulting mult,shift pair is optimized a little too far,
> and we don't leave enough room for ntp adjustments to mult, without the
> possibility of overflowing mult.
>
> The following patch should handle it (although I'm at a conf right now,
> so I couldn't test it), although I might be trying to be too smart here.
> Rather then just checking if mult is larger then 0xf0000000, we try to
> quantify the largest valid mult adjustment, and then make sure mult +
> that value doesn't overflow. NTP limits adjustments to 500ppm, but the
> kernel might have to deal with larger internal adjustments. Probably we
> could be safe ruling out larger then 5% adjustments.
>
> So then its just a matter of 1/2^4. So the largest mult adjustment
> should be 1<<  (cs->shift - 4)
>
> Does this seem reasonable? Let me know if this seems to work for you.
>
> Thomas: does this fix look like its in a reasonable spot? I don't want
> to clutter up the calc_mult_shift() code up since this really only
> applies to clocksources and not clockevents.
>
> NOT TESTED&  NOT FOR INCLUSION (YET)
> Signed-off-by: John Stultz<john.stultz@linaro.org>
> diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
> index cf52fda..73518d2 100644
> --- a/kernel/time/clocksource.c
> +++ b/kernel/time/clocksource.c
> @@ -640,7 +640,7 @@ static void clocksource_enqueue(struct clocksource *cs)
>   void __clocksource_updatefreq_scale(struct clocksource *cs, u32 scale, u32 freq)
>   {
>   	u64 sec;
> -
> +	u32 maxadj;
>   	/*
>   	 * Calc the maximum number of seconds which we can run before
>   	 * wrapping around. For clocksources which have a mask>  32bit
> @@ -661,6 +661,22 @@ void __clocksource_updatefreq_scale(struct clocksource *cs, u32 scale, u32 freq)
>
>   	clocks_calc_mult_shift(&cs->mult,&cs->shift, freq,
>   			       NSEC_PER_SEC / scale, sec * scale);
> +
> +	/*
> +	 * Since mult may be adjusted by ntp, add an extra saftey margin
> +	 * for clocksources that have large mults, to avoid overflow.
> +	 *
> +	 * Assume we won't try to correct for more then 5% adjustments

Can we do any better than making assumptions about this?

The current assumption appears to be that only very small adjustments 
will be made, and that didn't workout so well.

Is it possible to put hard constraints on these things, so that it will 
always work?

David Daney


> +	 * (50,000 ppm), which approximates to 1/16 or 1/2^4.
> +	 * Thus 1<<  (shift - 4) is the largest mult adjustment we'll
> +	 * support.
> +	 */
> +	maxadj = 1<<  (shift-4);
> +	if ((cs->mult + maxadj<  cs->mult) || (cs->mult - maxadj>  cs->mult)) {
> +		cs->mult>>= 1;
> +		cs->shift--;
> +	}
> +
>   	cs->max_idle_ns = clocksource_max_deferment(cs);
>   }
>   EXPORT_SYMBOL_GPL(__clocksource_updatefreq_scale);
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

