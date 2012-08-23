Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933521Ab2HWRM0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 13:12:26 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:43232 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933061Ab2HWRMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 13:12:23 -0400
Message-ID: <50366464.4070801@metafoo.de>
Date: Thu, 23 Aug 2012 19:12:04 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120724 Icedove/3.0.11
MIME-Version: 1.0
To: =?UTF-8?B?QmVub8OudCBUaMOpYmF1ZGVhdQ==?= 
	<benoit.thebaudeau@advansee.com>
CC: Thierry Reding <thierry.reding@avionic-design.de>,
        linux-kernel@vger.kernel.org, Sascha Hauer <kernel@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, Bryan Wu <bryan.wu@canonical.com>,
        Richard Purdie <rpurdie@rpsys.net>, linux-leds@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org
Subject: Re: [PATCH] pwm: Call pwm_enable() before pwm_config()
References: <36966374.2768747.1345741025741.JavaMail.root@advansee.com>
In-Reply-To: <36966374.2768747.1345741025741.JavaMail.root@advansee.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/23/2012 06:57 PM, Benoît Thébaudeau wrote:
> On Thursday, August 23, 2012 5:43:32 PM, Lars-Peter Clausen wrote:
>> On 08/23/2012 04:19 PM, Benoît Thébaudeau wrote:
>>> Some PWM drivers enable the clock of the PWM peripheral in
>>> pwm_enable(). Hence,
>>> for these drivers, a call to pwm_config() does not have any effect
>>> before
>>> pwm_enable() has been called.
>>>
>>> This patch fixes the PWM users to make sure that they call
>>> pwm_enable() before
>>> pwm_config().
>>>
>>> This fixes the first setting of brightness through sysfs that had
>>> no effect with
>>> leds-pwm and the i.MX PWM driver.
>>
>> But isn't this a bug in the PWM peripheral driver? With this change
>> the PWM
>> will start with the old settings first. While this is not so much of
>> a problem
>> for a backlight (although it might cause a short flickering) it might
>> cause
>> problems for other applications, like using the PWM pin as a timing
>> generator.
>> In my opinion it's better to fix the PWM peripheral drivers which
>> have this
>> problem instead of trying to work around it in every user of the PWM
>> API.
> 
> I don't know. See my detailed description of this issue here:
> http://lists.infradead.org/pipermail/linux-arm-kernel/2012-August/115667.html
> 
> Where the bug is depends on the detailed definition of the PWM API, which I
> don't find documented anywhere.
> 
> If pwm_enable() means "start PWM timer with the configured settings", then the
> bug is in the drivers. If it means "enable the PWM peripheral so that we can
> work with it", then the bug is in the PWM users.

It really is the former. See the description of pwm_enable() in drivers/pwm/core.c

> 
> I don't really have time to work on this, so I suggested this patch as a simple
> solution. Otherwise, it means reworking several PWM drivers for different
> hardware that is not available to everyone for testing.
> 
> If we decide to only change the i.MX PWM driver, the fix would be:
> pwm_config()
> {
>         save passed config in private data;
>         if (pwm enabled)
>                 apply passed config;
> }
> 
> pwm_enable()
> {
>         if (!(pwm enabled)) {
>                 enable pwm ip clk;
>                 apply config from private data;
>         }
> }

Another option is to enable the clock if it is disabled when the device is
configured. E.g. that's what tegra does.

> 
> If we fix only this driver, we must not forget that the same issue probably
> exists with several other PWM drivers.
> 

Since this seems to be a common pattern in a number of PWM drivers it might
make sense to simply add support for enabling/disabling a clk to the pwm core.
Or maybe just use the runtime pm API for this. This probably makes even more
sense and grab a reference to the pm context when the enable() is called,
release it when disable() is called and also grab it before calling the
device's config callback and release it afterward.

- Lars
