Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757284Ab1CBCZl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 21:25:41 -0500
Received: from smtp-out.google.com ([216.239.44.51]:44019 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752686Ab1CBCZk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 21:25:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=QsNbqdyYuZA8ND4HJSjKpy2W994062NohhJlUAK3Bwlo43x+7airJDfZiEX4UXPuMj
         dqUtTU3ejZkYcs4WZXuw==
MIME-Version: 1.0
In-Reply-To: <4D689230.7020704@codeaurora.org>
References: <4D680EEE.1070706@codeaurora.org>
	<AANLkTinZCtbQnAk_OX92jqbW_GjH5wpxvbeoMkHV1inn@mail.gmail.com>
	<4D689230.7020704@codeaurora.org>
Date: Tue, 1 Mar 2011 18:25:36 -0800
X-Google-Sender-Auth: 1oEQjfVd60yDROTHaYxSEeGDg_Y
Message-ID: <AANLkTi=ePu9hTeecOfKoxKEXd6VZ6tJBN2XphDO5suOA@mail.gmail.com>
Subject: Re: [PATCH] msm: gpiomux: Remove GPIOMUX_VALID and merge config enums
From: Dima Zavin <dima@android.com>
To: Saravana Kannan <skannan@codeaurora.org>
Cc: Rohit Vaswani <rvaswani@codeaurora.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bryan Huntsman <bryanh@codeaurora.org>, dwalker@fifo99.com,
        David Brown <davidb@codeaurora.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Good point, ptr to anon struct would work.

I would still very much like to see the helper macros be added though
as it really would be very helpful in keeping the pinmuxing tidy in
the board files. Doing it as a separate patch is fine.

Other than the addition of helper macros, ack.

--Dima

On Fri, Feb 25, 2011 at 9:40 PM, Saravana Kannan <skannan@codeaurora.org> wrote:
> On 02/25/2011 05:20 PM, Dima Zavin wrote:
>>
>> On Fri, Feb 25, 2011 at 12:19 PM, Rohit Vaswani<rvaswani@codeaurora.org>
>>  wrote:
>>>
>>> diff --git a/arch/arm/mach-msm/board-qsd8x50.c
>>> b/arch/arm/mach-msm/board-qsd8x50.c
>>> index 33ab1fe..d665b0e 100644
>>> --- a/arch/arm/mach-msm/board-qsd8x50.c
>>> +++ b/arch/arm/mach-msm/board-qsd8x50.c
>>> @@ -38,19 +38,26 @@
>>>  #include "devices.h"
>>>  #include "gpiomux.h"
>>>
>>> -#define UART3_SUSPENDED (GPIOMUX_DRV_2MA | GPIOMUX_PULL_DOWN |\
>>> -            GPIOMUX_FUNC_1 | GPIOMUX_VALID)
>>> +static struct gpiomux_setting uart3_suspended = {
>>> +    .drv = GPIOMUX_DRV_2MA,
>>> +    .pull = GPIOMUX_PULL_DOWN,
>>> +    .func = GPIOMUX_FUNC_1,
>>> +};
>>>
>>>  extern struct sys_timer msm_timer;
>>>
>>> -struct msm_gpiomux_config qsd8x50_uart3_configs[] __initdata = {
>>> +struct msm_gpiomux_config qsd8x50_uart3_configs[] = {
>>>     {
>>>         .gpio = 86, /* UART3 RX */
>>> -        .suspended = UART3_SUSPENDED,
>>> +        .settings = {
>>> +            [GPIOMUX_SUSPENDED] =&uart3_suspended,
>>> +        },
>>>     },
>>>     {
>>>         .gpio = 87, /* UART3 TX */
>>> -        .suspended = UART3_SUSPENDED,
>>> +        .settings = {
>>> +            [GPIOMUX_SUSPENDED] =&uart3_suspended,
>>> +        },
>>>     },
>>>  };
>>
>> I think this new interface is way too verbose and will quickly get
>> unwieldy for configurations that have more than a few pins. For
>> instance, imagine what the above would look like when muxing a 24bit
>> LCD pin list...
>>
>> How about adding a "bool valid" to gpiomux_setting, and convert the
>> "sets" array to an array of settings and not pointers to settings.
>> This will allow us to do (in gpiomux.h):
>>
>> struct msm_gpiomux_rec {
>>     struct gpiomux_setting sets[GPIOMUX_NSETTINGS];
>>     int ref;
>> };
>>
>> struct gpiomux_setting {
>>     enum gpiomux_func func;
>>     enum gpiomux_drv  drv;
>>     enum gpiomux_pull pull;
>>     bool valid;
>> };
>>
>> This way, I can do something like (very rough):
>>
>> #define GPIOMUX_SET(func,drv,pull) { \
>>     .func = GPIOMUX_##func, \
>>     .drv = GPIOMUX_##drv, \
>>     .pull = GPIOMUX_##pull, \
>>     .valid = true, \
>>   }
>>
>> #define GPIOMUX_SET_NONE { .valid = false, }
>>
>> #define GPIOMUX_CFG(g, active, suspended) { \
>>      .gpio = g, \
>>      .sets = { \
>>          [GPIOMUX_ACTIVE] = active, \
>>          [GPIOMUX_SUSPENDED] = suspended, \
>>       }, \
>>  }
>>
>> This will then allow me to define the uart3 pinmuxing in my board file
>> as follows:
>>
>> struct msm_gpiomux_rec uart3_mux_cfg[] = {
>>     GPIOMUX_CFG(86, GPIOMUX_SET_NONE,
>>                            GPIOMUX_SET(FUNC_1, DRV_2MA, PULL_DOWN)),
>>     GPIOMUX_CFG(87, GPIOMUX_SET_NONE,
>>                            GPIOMUX_SET(FUNC_1, DRV_2MA, PULL_DOWN)),
>> };
>>
>> Thoughts?
>>
>
> I haven't read this GPIO code thoroughly, but by looking just at the diff, I
> think you can still have these type of macros with the structure definition
> Rohit chose. I have no opinion one which struct definition is better (not
> enough context). Just trying to help with writing helper macros.
>
> The trick is to use pointers to anonymous struct. A very rough macro:
>
> #define GPIOMUX_SET(f, d, p) \
> &(struct gpiomux_setting) {
>        .func = f,
>        .drv = d,
>        .pull = p,
> }
>
> #define GPIOMUX_CFG(g, active, suspended) { \
>        .gpio = g,
>        .settings = {
>                [ACTIVE] = active,
>                [SUSPENDED] = suspended,
>        }
> }
>
> struct msm_gpiomux_config foo_bar[] = {
>        GPIOMUX_CFG(10, GPIOMUX_SET(FUNC, 2MA, PULL_UP), NULL),
>        GPIOMUX_CFG(11, GPIOMUX_SET(FUNC, 2MA, PULL_UP), NULL),
> };
>
> I'm certain the pointer to anonymous struct stuff works. You might have to
> tweak the macros a bit though. Hope this help.
>
> -Saravana
>
> --
> Sent by an employee of the Qualcomm Innovation Center, Inc.
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
>
