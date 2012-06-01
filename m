Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932937Ab2FAKJl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 06:09:41 -0400
Received: from mga14.intel.com ([143.182.124.37]:5071 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932779Ab2FAKJk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 06:09:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="150338660"
Message-ID: <4FC894E6.7090000@intel.com>
Date: Fri, 01 Jun 2012 13:09:42 +0300
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: "Torne (Richard Coles)" <torne@google.com>
CC: Ben Hutchings <ben@decadent.org.uk>, cjb@laptop.org,
        linus.walleij@linaro.org, jh80.chung@samsung.com,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] MMC: core: cap MMC card timeouts at 2 seconds.
References: <1338226278-13336-1-git-send-email-torne@google.com> <1338258732.20487.171.camel@deadeye> <4FC87EEA.5010707@intel.com> <CAEV-rjcFx_+Zs+1K5rxapx7ngDkArEKSV8tDubbVL+BfYLDU5Q@mail.gmail.com> <CAEV-rjfkcoEc-4VmMS-wQburo5tZZVDemzHk8LyKGhuLfFnSng@mail.gmail.com>
In-Reply-To: <CAEV-rjfkcoEc-4VmMS-wQburo5tZZVDemzHk8LyKGhuLfFnSng@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/06/12 12:32, Torne (Richard Coles) wrote:
> On 1 June 2012 10:31, Torne (Richard Coles) <torne@google.com> wrote:
>> On 1 June 2012 09:35, Adrian Hunter <adrian.hunter@intel.com> wrote:
>>> On 29/05/12 05:32, Ben Hutchings wrote:
>>>> On Mon, 2012-05-28 at 18:31 +0100, Torne (Richard Coles) wrote:
>>>>> From: "Torne (Richard Coles)" <torne@google.com>
>>>>>
>>>>> MMC CSD info can specify very large, ridiculous timeouts, big enough to
>>>>> overflow timeout_ns on 32-bit machines. This can result in the card
>>>>> timing out on every operation because the wrapped timeout value is far
>>>>> too small.
>>>>>
>>>>> Fix the overflow by capping the result at 2 seconds.  Cards specifying
>>>>> longer timeouts are almost certainly insane, and host controllers
>>>>> generally cannot support timeouts that long in any case.
>>>>>
>>>>> 2 seconds should be plenty of time for any card to actually function;
>>>>> the timeout calculation code is already using 1 second as a "worst case"
>>>>> timeout for cards running in SPI mode.
>>>>
>>>> Needs a 'Signed-off-by'.
>>>>
>>>>> ---
>>>>>  drivers/mmc/core/core.c |   11 ++++++++++-
>>>>>  1 files changed, 10 insertions(+), 1 deletions(-)
>>>>>
>>>>> diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
>>>>> index 0b6141d..3b4a9fc 100644
>>>>> --- a/drivers/mmc/core/core.c
>>>>> +++ b/drivers/mmc/core/core.c
>>>>> @@ -512,7 +512,16 @@ void mmc_set_data_timeout(struct mmc_data *data, const struct mmc_card *card)
>>>>>      if (data->flags & MMC_DATA_WRITE)
>>>>>              mult <<= card->csd.r2w_factor;
>>>>>
>>>>> -    data->timeout_ns = card->csd.tacc_ns * mult;
>>>>> +    /*
>>>>> +     * The timeout in nanoseconds may overflow with some cards. Cap it at
>>>>> +     * two seconds both to avoid the overflow and also because host
>>>>> +     * controllers cannot generally generate timeouts that long anyway.
>>>>> +     */
>>>>> +    if (card->csd.tacc_ns <= (2 * NSEC_PER_SEC) / mult)
>>>>> +            data->timeout_ns = card->csd.tacc_ns * mult;
>>>>> +    else
>>>>> +            data->timeout_ns = 2 * NSEC_PER_SEC;
>>>>
>>>> We clearly need to guard against overflow here, and this is the correct
>>>> way to clamp the multiplication.  I can't speak as to whether 2 seconds
>>>> is the right limit.
>>>
>>> The host controllers I have looked at have a limit of around 2.5 seconds.
>>>
>>> But why not just use the size of the type as the limit? e.g.
>>>
>>>        if (card->csd.tacc_ns <= UINT_MAX / mult)
>>>                data->timeout_ns = card->csd.tacc_ns * mult;
>>>        else
>>>                data->timeout_ns = UINT_MAX;
>>
>> The host controller drivers don't seem to all do a very good job of
>> preventing further overflows or handling large values correctly
>> (though some do). sdhci takes the especially annoying additional step
>> of printk'ing a warning for *every single MMC command* where
>> data->timeout_ns is larger than the controller can accommodate.
>> Capping it to a value with a sensible order of magnitude seems to make
>> it more likely that cards with obviously bogus CSD parameters will
>> actually work. I don't object to using a larger number for the limit,
>> but UINT_MAX on a 64-bit system obviously doesn't limit this at all
>> and will leave you with timeouts up to 17 minutes, which seems
>> ridiculous :)
> 
> Er, not 17 minutes; 102.4 seconds as I used later in my mail. SD cards
> have their timeouts capped already, so their larger 100x multiplier is
> not a problem; 102.4 seconds is the longest for an MMC card.
> 

Linux is LP64. i.e. "int" is always 32-bit in the kernel

>> My original motivation for this patch is that I have a device with an
>> eMMC that specifies a 25.5 second timeout, attached to a sdhci host
>> whose maximum timeout is 2.8 seconds. Originally I proposed a patch to
>> just remove the warning in sdhci, but nobody replied, and when I
>> realised there was actually an overflow happening I opted to fix that
>> instead.
>>
>> So, yeah, we could use UINT_MAX, but then at minimum I also need to
>> kill the warning in sdhci to make my device work, and probably all the
>> host controller drivers need to be checked to make sure they don't use
>> timeout_ns in a way that can overflow.
>>
>> I've also just noticed that struct mmc_data's comment for timeout_ns
>> says /* data timeout (in ns, max 80ms) */ which is not true (the max
>> is 102.4 seconds if my math is correct), which may have contributed to
>> the host drivers not being too careful :)
>>
>> What do you think?

If you can identify the card, the you could make a new quirk in a fashion
similar to mmc_card_long_read_time().

Alternatively you could make use of SDHCI_QUIRK_BROKEN_TIMEOUT_VAL or
introduce your own sdhci quirk to suppress the warning.

>>
>>>>
>>>> Ben.
>>>>
>>>>>      data->timeout_clks = card->csd.tacc_clks * mult;
>>>>>
>>>>>      /*
>>>>
>>>
>>
>>
>>
>> --
>> Torne (Richard Coles)
>> torne@google.com
> 
> 
> 

