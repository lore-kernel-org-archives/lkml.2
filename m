Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932319Ab2EaPAe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 11:00:34 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:43022 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754085Ab2EaPAc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 11:00:32 -0400
MIME-Version: 1.0
In-Reply-To: <CAEV-rjd1zymsZwsJjzJtF-9fvgYLz00r+K4K4xD2aeLwi76mPw@mail.gmail.com>
References: <CAEV-rjeEKMNs2N8KEatCi+guFKihgFok4k4nDnd=vTQ5x7iStg@mail.gmail.com>
	<1338282140-11106-1-git-send-email-torne@google.com>
	<CAPDyKFrpXc7cODie9g-QK_ZhVpmVZPQ36TDF9CWJcVPL_-EU2Q@mail.gmail.com>
	<CAEV-rjd1zymsZwsJjzJtF-9fvgYLz00r+K4K4xD2aeLwi76mPw@mail.gmail.com>
Date: Thu, 31 May 2012 23:00:31 +0800
Message-ID: <CAPDyKFrtdFn-t43r03m630gScYz6Cz+asfruSa=sGcxP0+C+tQ@mail.gmail.com>
Subject: Re: [PATCH] MMC: core: cap MMC card timeouts at 2 seconds.
From: Ulf Hansson <ulf.hansson@linaro.org>
To: "Torne (Richard Coles)" <torne@google.com>
Cc: cjb@laptop.org, linus.walleij@linaro.org, jh80.chung@samsung.com,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        ben@decadent.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Richard,

On 31 May 2012 18:15, Torne (Richard Coles) <torne@google.com> wrote:
> On 31 May 2012 11:00, Ulf Hansson <ulf.hansson@linaro.org> wrote:
>> Hi Richard,
>>
>> On 29 May 2012 17:02, Torne (Richard Coles) <torne@google.com> wrote:
>>> From: "Torne (Richard Coles)" <torne@google.com>
>>>
>>> MMC CSD info can specify very large, ridiculous timeouts, big enough to
>>> overflow timeout_ns on 32-bit machines. This can result in the card
>>> timing out on every operation because the wrapped timeout value is far
>>> too small.
>>>
>>> Fix the overflow by capping the result at 2 seconds.  Cards specifying
>>> longer timeouts are almost certainly insane, and host controllers
>>> generally cannot support timeouts that long in any case.
>>>
>>> 2 seconds should be plenty of time for any card to actually function;
>>> the timeout calculation code is already using 1 second as a "worst case"
>>> timeout for cards running in SPI mode.
>>>
>>> Signed-off-by: Torne (Richard Coles) <torne@google.com>
>>> ---
>>>  drivers/mmc/core/core.c |   11 ++++++++++-
>>>  1 files changed, 10 insertions(+), 1 deletions(-)
>>>
>>> diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
>>> index 0b6141d..3b4a9fc 100644
>>> --- a/drivers/mmc/core/core.c
>>> +++ b/drivers/mmc/core/core.c
>>> @@ -512,7 +512,16 @@ void mmc_set_data_timeout(struct mmc_data *data, const struct mmc_card *card)
>>>        if (data->flags & MMC_DATA_WRITE)
>>>                mult <<= card->csd.r2w_factor;
>>>
>>> -       data->timeout_ns = card->csd.tacc_ns * mult;
>>> +       /*
>>> +        * The timeout in nanoseconds may overflow with some cards. Cap it at
>>> +        * two seconds both to avoid the overflow and also because host
>>> +        * controllers cannot generally generate timeouts that long anyway.
>>> +        */
>>> +       if (card->csd.tacc_ns <= (2 * NSEC_PER_SEC) / mult)
>>> +               data->timeout_ns = card->csd.tacc_ns * mult;
>>> +       else
>>> +               data->timeout_ns = 2 * NSEC_PER_SEC;
>>> +
>>
>> The above looks OK to me, although if doing this for tacc_ns we might
>> want to do this for tacc_clks as well. Could we include that is this
>> patch as well?
>
> timeout_clks can't overflow, that I can see: the highest possible
> value for tacc_clks is 25500 (it's an 8 bit field specified in
> 100-clock increments) and the highest mult is 12800 (r2w_factor only
> goes up to 128). This only makes 0x13747800 :)
>

Thanks for sorting this out and sorry for me being too lazy to read
the spec. :-)

Acked-by: Ulf Hansson <ulf.hansson@linaro.org>

Kind regards
Ulf Hansson
