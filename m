Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755305Ab2FAEkn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 00:40:43 -0400
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:37866 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754286Ab2FAEkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 00:40:41 -0400
Message-ID: <4FC847C1.2060809@ti.com>
Date: Fri, 01 Jun 2012 10:10:33 +0530
From: Rajendra Nayak <rnayak@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.20) Gecko/20110805 Thunderbird/3.1.12
MIME-Version: 1.0
To: Saravana Kannan <skannan@codeaurora.org>
CC: Ben Dooks <ben.dooks@codethink.co.uk>, mturquette@linaro.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        mturquette@ti.com
Subject: Re: [PATCH 2/2] clk: Add support for rate table based dividers
References: <1337250134-29206-1-git-send-email-rnayak@ti.com> <1337250134-29206-3-git-send-email-rnayak@ti.com> <4FBA0F3D.0@codethink.co.uk> <4FBB19E6.2040403@ti.com> <4FC6EE00.8010401@codeaurora.org>
In-Reply-To: <4FC6EE00.8010401@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 31 May 2012 09:35 AM, Saravana Kannan wrote:
> On 05/21/2012 09:45 PM, Rajendra Nayak wrote:
>> Hi Ben,
>>
>> On Monday 21 May 2012 03:17 PM, Ben Dooks wrote:
>>> On 17/05/12 11:22, Rajendra Nayak wrote:
>>>> Some divider clks do not have any obvious relationship
>>>> between the divider and the value programmed in the
>>>> register. For instance, say a value of 1 could signify divide
>>>> by 6 and a value of 2 could signify divide by 4 etc.
>>>> Also there are dividers where not all values possible
>>>> based on the bitfield width are valid. For instance
>>>> a 3 bit wide bitfield can be used to program a value
>>>> from 0 to 7. However its possible that only 0 to 4
>>>> are valid values.
>>>>
>>>> All these cases need the platform code to pass a simple
>>>> table of divider/value tuple, so the framework knows
>>>> the exact value to be written based on the divider
>>>> calculation and can also do better error checking.
>>>>
>>>> This patch adds support for such rate table based
>>>> dividers.
>>>
>>> I was considering the idea that you simply pass a
>>> pointer to a set of routines and a data pointer to
>>> the clk-divider code so that any new cases don't
>>> require changing the drivers/clk/clk-divider.c
>>
>> I don;t know if I understand your comment completely.
>> Are you suggesting the get min/max etc be function pointers
>> passed by platform code (and implemented in platform code?)
>> so clk-divider does not need an update every time a new divider
>> type is added?
>> The idea of extending clk-divider was so its useful for more
>> than just OMAP, so the code in clk-divider can be reused across
>> multiple platforms. Did I understand your comment right?
>>
>> regards,
>> Rajendra
>>
>>>
>>> This would make the get max / min / special just
>>> a function call through a struct.
>>>
>>>> Signed-off-by: Rajendra Nayak<rnayak@ti.com>
>>>> ---
>>>> drivers/clk/clk-divider.c | 67
>>>> ++++++++++++++++++++++++++++++++++++++++--
>>>> include/linux/clk-private.h | 3 +-
>>>> include/linux/clk-provider.h | 10 +++++-
>>>> 3 files changed, 75 insertions(+), 5 deletions(-)
>>>>
>>>> diff --git a/drivers/clk/clk-divider.c b/drivers/clk/clk-divider.c
>>>> index e548c43..e4911ee 100644
>>>> --- a/drivers/clk/clk-divider.c
>>>> +++ b/drivers/clk/clk-divider.c
>>>> @@ -32,30 +32,69 @@
>>>> #define div_mask(d) ((1<< (d->width)) - 1)
>>>> #define is_power_of_two(i) !(i& ~i)
>>>>
>>>> +static unsigned int _get_table_maxdiv(const struct clk_div_table
>>>> *table)
>>>> +{
>>>> + unsigned int maxdiv;
>>>> + const struct clk_div_table *clkt;
>>>> +
>>>> + for (clkt = table; clkt->div; clkt++)
>>>> + if (clkt->div> maxdiv)
>>>> + maxdiv = clkt->div;
>>>> + return maxdiv;
>>>> +}
>>>> +
>>>> static unsigned int _get_maxdiv(struct clk_divider *divider)
>>>> {
>>>> if (divider->flags& CLK_DIVIDER_ONE_BASED)
>>>> return div_mask(divider);
>>>> if (divider->flags& CLK_DIVIDER_POWER_OF_TWO)
>>>> return 1<< div_mask(divider);
>
> Where are these flags defined? I don't see it in any of the patches in
> the series. Is my search foo not up to par today?

Well, the flag was already part of Mike's original series, it was just
not used.

>
> I think what Ben is saying is that you provider a way (using function or
> data/table pointers in clk_divider) that will allow the clk provider to
> define a "divider" to "register value" mapping. Say you decide to do
> that using a function pointer, then you would implement the following in
> clk-divider.c.
>
> div_to_reg_one_based
> div_to_reg_pow_two
>
> The actual clock-provider code will pick one of these or implement their
> own mapping function. That way, clk-divider won't have to change for any
> other convoluted variants of clk divider to register value mapping.

I get the point. But I am just wondering if there are any such
convoluted variants (which are platform specific).
I though the table should be able to handle *all* such variants.

>
> -Saravana
>

