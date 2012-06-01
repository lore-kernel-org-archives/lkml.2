Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759735Ab2FANMn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 09:12:43 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:57848 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759667Ab2FANMl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 09:12:41 -0400
MIME-Version: 1.0
In-Reply-To: <4FC8BCA0.1000207@intel.com>
References: <1338226278-13336-1-git-send-email-torne@google.com>
	<1338258732.20487.171.camel@deadeye>
	<4FC87EEA.5010707@intel.com>
	<CAEV-rjcFx_+Zs+1K5rxapx7ngDkArEKSV8tDubbVL+BfYLDU5Q@mail.gmail.com>
	<CAEV-rjfkcoEc-4VmMS-wQburo5tZZVDemzHk8LyKGhuLfFnSng@mail.gmail.com>
	<4FC894E6.7090000@intel.com>
	<CAEV-rjc0i5i3nU+VgkY3-mF_ndtSzzp8vk7622C9WCNsfcRP+A@mail.gmail.com>
	<4FC8BCA0.1000207@intel.com>
Date: Fri, 1 Jun 2012 14:12:40 +0100
Message-ID: <CAEV-rjehr=zWTetxoBCwx0FR5ZzOqZxOTFHAuv1+3u+K=YqAAw@mail.gmail.com>
Subject: Re: [PATCH V2] MMC: core: cap MMC card timeouts at 2 seconds.
From: "Torne (Richard Coles)" <torne@google.com>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Ben Hutchings <ben@decadent.org.uk>, cjb@laptop.org,
        linus.walleij@linaro.org, jh80.chung@samsung.com,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1 June 2012 13:59, Adrian Hunter <adrian.hunter@intel.com> wrote:
> On 01/06/12 13:20, Torne (Richard Coles) wrote:
>> On 1 June 2012 11:09, Adrian Hunter <adrian.hunter@intel.com> wrote:
>>> On 01/06/12 12:32, Torne (Richard Coles) wrote:
>>>> On 1 June 2012 10:31, Torne (Richard Coles) <torne@google.com> wrote:
>>>>> On 1 June 2012 09:35, Adrian Hunter <adrian.hunter@intel.com> wrote:
>>>>>> On 29/05/12 05:32, Ben Hutchings wrote:
>>>>>>> On Mon, 2012-05-28 at 18:31 +0100, Torne (Richard Coles) wrote:
>>>>>>>> From: "Torne (Richard Coles)" <torne@google.com>
>>>>>>>>
>>>>>>>> MMC CSD info can specify very large, ridiculous timeouts, big enough to
>>>>>>>> overflow timeout_ns on 32-bit machines. This can result in the card
>>>>>>>> timing out on every operation because the wrapped timeout value is far
>>>>>>>> too small.
>>>>>>>>
>>>>>>>> Fix the overflow by capping the result at 2 seconds.  Cards specifying
>>>>>>>> longer timeouts are almost certainly insane, and host controllers
>>>>>>>> generally cannot support timeouts that long in any case.
>>>>>>>>
>>>>>>>> 2 seconds should be plenty of time for any card to actually function;
>>>>>>>> the timeout calculation code is already using 1 second as a "worst case"
>>>>>>>> timeout for cards running in SPI mode.
>>>>>>>
>>>>>>> Needs a 'Signed-off-by'.
>>>>>>>
>>>>>>>> ---
>>>>>>>>  drivers/mmc/core/core.c |   11 ++++++++++-
>>>>>>>>  1 files changed, 10 insertions(+), 1 deletions(-)
>>>>>>>>
>>>>>>>> diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
>>>>>>>> index 0b6141d..3b4a9fc 100644
>>>>>>>> --- a/drivers/mmc/core/core.c
>>>>>>>> +++ b/drivers/mmc/core/core.c
>>>>>>>> @@ -512,7 +512,16 @@ void mmc_set_data_timeout(struct mmc_data *data, const struct mmc_card *card)
>>>>>>>>      if (data->flags & MMC_DATA_WRITE)
>>>>>>>>              mult <<= card->csd.r2w_factor;
>>>>>>>>
>>>>>>>> -    data->timeout_ns = card->csd.tacc_ns * mult;
>>>>>>>> +    /*
>>>>>>>> +     * The timeout in nanoseconds may overflow with some cards. Cap it at
>>>>>>>> +     * two seconds both to avoid the overflow and also because host
>>>>>>>> +     * controllers cannot generally generate timeouts that long anyway.
>>>>>>>> +     */
>>>>>>>> +    if (card->csd.tacc_ns <= (2 * NSEC_PER_SEC) / mult)
>>>>>>>> +            data->timeout_ns = card->csd.tacc_ns * mult;
>>>>>>>> +    else
>>>>>>>> +            data->timeout_ns = 2 * NSEC_PER_SEC;
>>>>>>>
>>>>>>> We clearly need to guard against overflow here, and this is the correct
>>>>>>> way to clamp the multiplication.  I can't speak as to whether 2 seconds
>>>>>>> is the right limit.
>>>>>>
>>>>>> The host controllers I have looked at have a limit of around 2.5 seconds.
>>>>>>
>>>>>> But why not just use the size of the type as the limit? e.g.
>>>>>>
>>>>>>        if (card->csd.tacc_ns <= UINT_MAX / mult)
>>>>>>                data->timeout_ns = card->csd.tacc_ns * mult;
>>>>>>        else
>>>>>>                data->timeout_ns = UINT_MAX;
>>>>>
>>>>> The host controller drivers don't seem to all do a very good job of
>>>>> preventing further overflows or handling large values correctly
>>>>> (though some do). sdhci takes the especially annoying additional step
>>>>> of printk'ing a warning for *every single MMC command* where
>>>>> data->timeout_ns is larger than the controller can accommodate.
>>>>> Capping it to a value with a sensible order of magnitude seems to make
>>>>> it more likely that cards with obviously bogus CSD parameters will
>>>>> actually work. I don't object to using a larger number for the limit,
>>>>> but UINT_MAX on a 64-bit system obviously doesn't limit this at all
>>>>> and will leave you with timeouts up to 17 minutes, which seems
>>>>> ridiculous :)
>>>>
>>>> Er, not 17 minutes; 102.4 seconds as I used later in my mail. SD cards
>>>> have their timeouts capped already, so their larger 100x multiplier is
>>>> not a problem; 102.4 seconds is the longest for an MMC card.
>>>>
>>>
>>> Linux is LP64. i.e. "int" is always 32-bit in the kernel
>>
>> Oh, sorry; didn't think that through. So, yeah, that'd be 4.29
>> seconds, which is still too long for many hosts :)
>>
>>>>> My original motivation for this patch is that I have a device with an
>>>>> eMMC that specifies a 25.5 second timeout, attached to a sdhci host
>>>>> whose maximum timeout is 2.8 seconds. Originally I proposed a patch to
>>>>> just remove the warning in sdhci, but nobody replied, and when I
>>>>> realised there was actually an overflow happening I opted to fix that
>>>>> instead.
>>>>>
>>>>> So, yeah, we could use UINT_MAX, but then at minimum I also need to
>>>>> kill the warning in sdhci to make my device work, and probably all the
>>>>> host controller drivers need to be checked to make sure they don't use
>>>>> timeout_ns in a way that can overflow.
>>>>>
>>>>> I've also just noticed that struct mmc_data's comment for timeout_ns
>>>>> says /* data timeout (in ns, max 80ms) */ which is not true (the max
>>>>> is 102.4 seconds if my math is correct), which may have contributed to
>>>>> the host drivers not being too careful :)
>>>>>
>>>>> What do you think?
>>>
>>> If you can identify the card, the you could make a new quirk in a fashion
>>> similar to mmc_card_long_read_time().
>>>
>>> Alternatively you could make use of SDHCI_QUIRK_BROKEN_TIMEOUT_VAL or
>>> introduce your own sdhci quirk to suppress the warning.
>>
>> Those would work, but it seems silly to me to suppress the warning
>> only for some cards, or to cap the timeout only for some cards. The
>> best way to identify a card that has a "broken" timeout value is.. if
>> the timeout value is a really big number, no? I am very skeptical that
>> there is a card out there anywhere that will actually take more than
>> two seconds (or 4.29 seconds, if you prefer) to successfully complete
>> a command.
>>
>> The warning itself seems to have extremely limited use; there's
>> nothing you can do
about it other than suppress it (the driver is
>> already capping the timeout for you), and because timeouts are
>> calculated per-command the warning is absurdly noisy (in fact, the fun
>> part on my system was the warning being logged to klogd, being written
>> to logfiles on the eMMC, causing more warnings, causing more log
>> messages, etc) :) sdhci is the only host driver that complains about
>> this; it seems logical for the warning to apply to all hosts, or to
>> none of them...
>
> I just noticed that from linux 3.4, the SD write timeout is now 3 seconds
> triggering the sdhci driver warning on every write on every SD card.
> So change pr_warning to DGB in sdhci_calc_timeout().  Chris?
>

Woah, I didn't notice that change. Yeah, sdhci definitely needs changing then :)

If we do that, then it makes sense to just cap the MMC timeout at
UINT_MAX, I think. I'll send a new patch that does that.

-- 
Torne (Richard Coles)
torne@google.com
