Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932729Ab2EVBAm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 21:00:42 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:36846 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932093Ab2EVBAl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 21:00:41 -0400
MIME-Version: 1.0
In-Reply-To: <4FBA76C6.9030201@wwwdotorg.org>
References: <1337346755-8761-1-git-send-email-b29396@freescale.com>
	<1337346755-8761-2-git-send-email-b29396@freescale.com>
	<4FB6AB9A.4080006@wwwdotorg.org>
	<20120521123929.GA27055@shlinux2.ap.freescale.net>
	<4FBA76C6.9030201@wwwdotorg.org>
Date: Tue, 22 May 2012 09:00:40 +0800
Message-ID: <CAA+hA=RzX9EsFbPWqgoAm-4-Rv-0tQ1s2rQ0+DtSE3Mxu36ShA@mail.gmail.com>
Subject: Re: [PATCH RFC v2 2/2] pinctrl: add pinctrl gpio binding support
From: Dong Aisheng <dongas86@gmail.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Dong Aisheng <aisheng.dong@freescale.com>,
        Dong Aisheng-B29396 <B29396@freescale.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 22, 2012 at 1:09 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 05/21/2012 06:39 AM, Dong Aisheng wrote:
>> On Sat, May 19, 2012 at 04:05:46AM +0800, Stephen Warren wrote:
>>> On 05/18/2012 07:12 AM, Dong Aisheng wrote:
>>>> The gpio ranges standard dt binding format is
>>>> <&gpio $gpio_offset $pin_offset $npin>
>>>>
>>>> The core will parse and register the pinctrl gpio ranges
>>>> from device tree.
> ...
>>>> +   pinctrl_add_gpio_ranges(pctldev, ranges, nranges);
>>>
>>> I think we should also store ranges somewhere separate in pctldev ...
>>
>> Hmm, i'm not quite understand,
>> What do you mean separate in pctldev?
>> We already save the ranges in pctldev's gpio_ranges list.
>>
>>>> +void pinctrl_dt_remove_gpio_ranges(struct pinctrl_dev *pctldev,
>>>> +                              struct pinctrl_gpio_range *ranges,
>>>> +                              unsigned nranges)
>>>
>>> ... so that this function doesn't need ranges/nranges passed to it; it
>>> can just get them out of pctldec.
>>
>> For remove ranges/nranges, maybe we can use list_for_each_entry_safe
>> plus list_del like:
>> list_for_each_entry_safe(range, tmp, &pctldev->gpio_ranges, node)
>>     list_del(range->node);
>
> If some GPIO ranges are added using pinctrl_dt_add_gpio_ranges() and
> some are added using pinctrl_add_gpio_range(), how will
> pinctrl_dt_remove_gpio_ranges() know which ones to remove, unless
>
Yes, you're right.

> a) The list of ranges is passed to pinctrl_dt_remove_gpio_ranges() as
> above (but then where does the caller find the list to pass in)
>
> or:
>
> b) The list of ranges added by pinctrl_dt_add_gpio_ranges() is stored
> separately from the overall gpio_ranges list, so the code knows which
> were added by that API.
>
> Perhaps the simplest way to implement this is to add a new Boolean field
> to struct gpio_range that says whether pinctrl_dt_add_gpio_ranges()
> added it, and set it to true/false in  pinctrl_dt_add_gpio_ranges() and
>  pinctrl_add_gpio_ranges().
>
Maybe we should not allow people to use pinctrl_add_gpio_ranges for dt
and i can not see it helps too much.
Then we do not have two case.

>> I just follow the original way here and if change we may need another
>> patch.
>>
>>> Or better yet, what if pinctrl_unregister automatically removed any
>>> ranges registered by pinctrl_dt_add_gpio_ranges, so this function
>>> doesn't even need to exist?
>>
>> Yes, it seems this can also work for non-dt registered gpio ranges added by
>> pinctrl_add_gpio_ranges, e.g, remove need pinctrl_remove_gpio_range too,
>> It seems it should be in a separate patch which is not related to gpio ranges
>> binding.
>>
>> Do you want me to work on that patch first for this series to rebase or
>> we can do it later?
>
> Maybe we should just delete the functions pinctrl_remove_gpio_range()
> and pinctrl_dt_remove_gpio_range() completely. They only remove the gpio
> range from the list in the pctldev, and since the pctldev is being
> unregistered anyway, that doesn't seem very useful. The ranges don't
> need to be free()'d since pinctrl_dt_add_gpio_ranges() allocates them
> using devm_kzalloc() anyway, and in the non-DT case, if they need
> free-ing, the driver already had to do that itself.
>
Yes, i agree with this one.
I will re-order the patch series to remove pinctrl_remove_gpio_range first.

Regards
Dong Aisheng
