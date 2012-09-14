Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756379Ab2INHSz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 03:18:55 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:61874 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756176Ab2INHSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 03:18:52 -0400
MIME-Version: 1.0
In-Reply-To: <1347599944.9481.3.camel@joe2Laptop>
References: <1347565754-9534-1-git-send-email-thomas.petazzoni@free-electrons.com>
	<1347599944.9481.3.camel@joe2Laptop>
Date: Fri, 14 Sep 2012 00:18:51 -0700
Message-ID: <CAMbhsRSaHOgyTn56vQndn0TKh3AT9dk3pRVuJx3qJXWowsLVaA@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: use kasprintf() in pinmux_request_gpio()
From: Colin Cross <ccross@google.com>
To: Joe Perches <joe@perches.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Lior Amsalem <alior@marvell.com>, Maen Suleiman <maen@marvell.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 13, 2012 at 10:19 PM, Joe Perches <joe@perches.com> wrote:
> On Thu, 2012-09-13 at 21:49 +0200, Thomas Petazzoni wrote:
>> Instead of using a temporary buffer, snprintf() and kstrdup(), just
>> use kasprintf() that does the same thing in just oneline.
>>
>> Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
>> ---
>>  drivers/pinctrl/pinmux.c |    5 +----
>>  1 file changed, 1 insertion(+), 4 deletions(-)
>>
>> diff --git a/drivers/pinctrl/pinmux.c b/drivers/pinctrl/pinmux.c
>> index 3d5ac73..9301a7a 100644
>> --- a/drivers/pinctrl/pinmux.c
>> +++ b/drivers/pinctrl/pinmux.c
>> @@ -232,14 +232,11 @@ int pinmux_request_gpio(struct pinctrl_dev *pctldev,
>>                       struct pinctrl_gpio_range *range,
>>                       unsigned pin, unsigned gpio)
>>  {
>> -     char gpiostr[16];
>>       const char *owner;
>>       int ret;
>>
>>       /* Conjure some name stating what chip and pin this is taken by */
>> -     snprintf(gpiostr, 15, "%s:%d", range->name, gpio);
>> -
>> -     owner = kstrdup(gpiostr, GFP_KERNEL);
>> +     owner = kasprintf(GFP_KERNEL, "%s:%d", range->name, gpio);
>>       if (!owner)
>>               return -EINVAL;
>>
>
> No not really.  It's a bit different because the first
> snprintf is length limited but the kasprintf is not.

The one it's replacing is worse, it never sets gpiostr[15] to 0 and
kstrdup will read past the end of the buffer if the string is
truncated.
