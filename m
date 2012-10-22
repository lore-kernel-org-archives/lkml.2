Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753483Ab2JVMYX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 08:24:23 -0400
Received: from smtp-out-125.synserver.de ([212.40.185.125]:1531 "EHLO
	smtp-out-125.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752087Ab2JVMYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 08:24:21 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 25152
Message-ID: <50853A0A.3070007@metafoo.de>
Date: Mon, 22 Oct 2012 14:20:26 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.9) Gecko/20121014 Icedove/10.0.9
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: Viresh Kumar <viresh.kumar@linaro.org>,
        Shiraz Hashim <shiraz.hashim@st.com>, linux-kernel@vger.kernel.org,
        spear-devel@list.st.com
Subject: Re: [PATCH V3] PWM: Add SPEAr PWM chip driver support
References: <1350877903-8578-1-git-send-email-shiraz.hashim@st.com> <CAOh2x=mNWNtwcWB3a=mCsfwC8WqXiisW8zeg9amsXy7b2nLCkA@mail.gmail.com> <20121022060641.GB3900@localhost.localdomain> <CAKohpo=LHjV2tV1R34Q_As4s2Yh071+t-bLyFBDGSZ_u5vKo7Q@mail.gmail.com> <20121022075534.GA4931@avionic-0098.mockup.avionic-design.de>
In-Reply-To: <20121022075534.GA4931@avionic-0098.mockup.avionic-design.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/2012 09:55 AM, Thierry Reding wrote:
> On Mon, Oct 22, 2012 at 11:51:11AM +0530, Viresh Kumar wrote:
>> On 22 October 2012 11:36, Shiraz Hashim <shiraz.hashim@st.com> wrote:
>>> On Mon, Oct 22, 2012 at 09:39:21AM +0530, viresh kumar wrote:
>>>> On Mon, Oct 22, 2012 at 9:21 AM, Shiraz Hashim <shiraz.hashim@st.com> wrote:
>>
>>>>> +static int spear_pwm_remove(struct platform_device *pdev)
>>>>> +{
>>>>> +       struct spear_pwm_chip *pc = platform_get_drvdata(pdev);
>>>>> +       int i;
>>>>> +
>>>>> +       for (i = 0; i < NUM_PWM; i++) {
>>>>> +               struct pwm_device *pwm = &pc->chip.pwms[i];
>>>>> +
>>>>> +               if (test_bit(PWMF_ENABLED, &pwm->flags)) {
>>>>> +                       spear_pwm_writel(pc, i, PWMCR, 0);
>>>>> +                       clk_disable(pc->clk);
>>>>> +               }
>>>>> +       }
>>>>> +
>>>>> +       /* clk was prepared in probe, hence unprepare it here */
>>>>> +       clk_unprepare(pc->clk);
>>>>
>>>> I believe you need to remove the chip first and then do above to
>>>> avoid any race conditions, that might occur.
>>>
>>> I am afraid, I would loose all chips and their related information
>>> (PWMF_ENABLED) then.
>>
>> I have just checked core's code, and yes you are correct.
>> Now i have another doubt :)
>>
>> Why shouldn't you do this instead:
>>
>>        for (i = 0; i < NUM_PWM; i++)
>>               pwm_diable(&pc->chip.pwms[i]);
>>
>> And, why should we put above code in pwmchip_remove() instead, so that
>> pwm drivers don't need to do all this?
>>
>> @Thierry: Your inputs are required here :)
> 
> We could probably do that in the core. I've had some discussions about
> this with Lars-Peter (Cc'ed) who also had doubts about how this is
> currently handled.
> 
> The problem is that the core driver code ignores errors from the
> driver's .remove() callback, so actually returning the error of
> pwmchip_remove() here isn't terribly useful. I had actually assumed
> (without checking the code) that the device wouldn't be removed if an
> error was returned, but that isn't true.
> 
> IIRC Lars-Peter suggested that we do reference counting on PWM devices
> so that they could stay around after the module is unloaded but return
> errors (-ENODEV?) on all operations to make sure users are aware of them
> disappearing.
> 
> What you're proposing is different, however. If we put that code in the
> core it will mean that once the module is unloaded, all PWM devices will
> be disabled. There is currently code in the core that prevents the chip
> from being removed if one or more PWM devices are busy. But as explained
> above, with the current core code this return value isn't useful at all.
> 
> This needs to be addressed, but I'm not quite sure how yet. Obviously it
> cannot be solved in the core, because the PWM devices may be provided by
> real hotpluggable devices, so just preventing the driver from being
> removed won't help.

In my opinion it would make sense to put this into the PWM core. Even if the
device is still physically connected, e.g. because it is a on-SoC device, it
should be stopped if the device is removed. You do not want the PWM device
to continue to provide it's service (which is the PWM signal) after the
device has been removed. This means this is something that needs to be
implemented by every PWM driver.

Btw. you still won't be able to remove the module while one or more devices
are busy. You'll just be able to either hotunplug the device or unbind it
via sysfs. Once the device is no longer bound you can then remove the module
as well. Or at least should be able.

