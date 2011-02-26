Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751293Ab1BZCPG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 21:15:06 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:31590 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202Ab1BZCPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 21:15:04 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6268"; a="76605070"
Message-ID: <4D686226.1090804@codeaurora.org>
Date: Fri, 25 Feb 2011 18:15:02 -0800
From: Rohit Vaswani <rvaswani@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Dima Zavin <dima@android.com>
CC: David Brown <davidb@codeaurora.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>, dwalker@fifo99.com,
        linux-arm-msm@vger.kernel.org,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] msm: gpiomux: Remove GPIOMUX_VALID and merge config enums
References: <4D680EEE.1070706@codeaurora.org> <AANLkTinZCtbQnAk_OX92jqbW_GjH5wpxvbeoMkHV1inn@mail.gmail.com>
In-Reply-To: <AANLkTinZCtbQnAk_OX92jqbW_GjH5wpxvbeoMkHV1inn@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/25/2011 5:20 PM, Dima Zavin wrote:
> On Fri, Feb 25, 2011 at 12:19 PM, Rohit Vaswani<rvaswani@codeaurora.org>  wrote:
>> Remove GPIOMUX_VALID, simplify the API, and absorb the complexity
>> of determining which gpiomux configs are used and which are
>> not back into the gpiomux implementation where it belongs.
>> Allow NULL settings to be represented appropriately.
>> The configuration enumerations represent a single abstraction
>> and were needlessly split. As such, collapse the conflicting
>> abstractions into a consistent one and move the implementation
>> complexity down into the implementation (where it belongs) and
>> away from the interface (where it doesn't belong).
>>
>> Signed-off-by: Rohit Vaswani<rvaswani@codeaurora.org>
>> ---
>>   arch/arm/mach-msm/board-msm7x30.c |   23 +++++++--
>>   arch/arm/mach-msm/board-qsd8x50.c |   17 +++++--
>>   arch/arm/mach-msm/gpiomux-v1.c    |    9 ++-
>>   arch/arm/mach-msm/gpiomux-v1.h    |   59 ----------------------
>>   arch/arm/mach-msm/gpiomux-v2.c    |    8 ++-
>>   arch/arm/mach-msm/gpiomux-v2.h    |   59 ----------------------
>>   arch/arm/mach-msm/gpiomux.c       |   77 +++++++++++++++++-------------
>>   arch/arm/mach-msm/gpiomux.h       |   96
>> +++++++++++++++++++++++-------------
>>   8 files changed, 145 insertions(+), 203 deletions(-)
>>   delete mode 100644 arch/arm/mach-msm/gpiomux-v1.h
>>   delete mode 100644 arch/arm/mach-msm/gpiomux-v2.h
>>
>> diff --git a/arch/arm/mach-msm/board-msm7x30.c
>> b/arch/arm/mach-msm/board-msm7x30.c
>> index 59b91de..4223329 100644
>> --- a/arch/arm/mach-msm/board-msm7x30.c
>> +++ b/arch/arm/mach-msm/board-msm7x30.c
>> @@ -39,8 +39,11 @@
>>   #include "gpiomux.h"
>>   #include "proc_comm.h"
>>
>> -#define UART2_SUSPENDED (GPIOMUX_DRV_2MA | GPIOMUX_PULL_DOWN |\
>> -            GPIOMUX_FUNC_2 | GPIOMUX_VALID)
>> +static struct gpiomux_setting uart2_suspended = {
>> +    .func = GPIOMUX_FUNC_2,
>> +    .drv = GPIOMUX_DRV_2MA,
>> +    .pull = GPIOMUX_PULL_DOWN,
>> +};
>>
>>   extern struct sys_timer msm_timer;
>>
>> @@ -59,19 +62,27 @@ static struct msm_otg_platform_data msm_otg_pdata = {
>>   struct msm_gpiomux_config msm7x30_uart2_configs[] __initdata = {
>>      {
>>          .gpio = 49, /* UART2 RFR */
>> -        .suspended = UART2_SUSPENDED,
>> +        .settings = {
>> +            [GPIOMUX_SUSPENDED] =&uart2_suspended,
>> +        },
>>      },
>>      {
>>          .gpio = 50, /* UART2 CTS */
>> -        .suspended = UART2_SUSPENDED,
>> +        .settings = {
>> +            [GPIOMUX_SUSPENDED] =&uart2_suspended,
>> +        },
>>      },
>>      {
>>          .gpio = 51, /* UART2 RX */
>> -        .suspended = UART2_SUSPENDED,
>> +        .settings = {
>> +            [GPIOMUX_SUSPENDED] =&uart2_suspended,
>> +        },
>>      },
>>      {
>>          .gpio = 52, /* UART2 TX */
>> -        .suspended = UART2_SUSPENDED,
>> +        .settings = {
>> +            [GPIOMUX_SUSPENDED] =&uart2_suspended,
>> +        },
>>      },
>>   };
>>
>> diff --git a/arch/arm/mach-msm/board-qsd8x50.c
>> b/arch/arm/mach-msm/board-qsd8x50.c
>> index 33ab1fe..d665b0e 100644
>> --- a/arch/arm/mach-msm/board-qsd8x50.c
>> +++ b/arch/arm/mach-msm/board-qsd8x50.c
>> @@ -38,19 +38,26 @@
>>   #include "devices.h"
>>   #include "gpiomux.h"
>>
>> -#define UART3_SUSPENDED (GPIOMUX_DRV_2MA | GPIOMUX_PULL_DOWN |\
>> -            GPIOMUX_FUNC_1 | GPIOMUX_VALID)
>> +static struct gpiomux_setting uart3_suspended = {
>> +    .drv = GPIOMUX_DRV_2MA,
>> +    .pull = GPIOMUX_PULL_DOWN,
>> +    .func = GPIOMUX_FUNC_1,
>> +};
>>
>>   extern struct sys_timer msm_timer;
>>
>> -struct msm_gpiomux_config qsd8x50_uart3_configs[] __initdata = {
>> +struct msm_gpiomux_config qsd8x50_uart3_configs[] = {
>>      {
>>          .gpio = 86, /* UART3 RX */
>> -        .suspended = UART3_SUSPENDED,
>> +        .settings = {
>> +            [GPIOMUX_SUSPENDED] =&uart3_suspended,
>> +        },
>>      },
>>      {
>>          .gpio = 87, /* UART3 TX */
>> -        .suspended = UART3_SUSPENDED,
>> +        .settings = {
>> +            [GPIOMUX_SUSPENDED] =&uart3_suspended,
>> +        },
>>      },
>>   };
> I think this new interface is way too verbose and will quickly get
> unwieldy for configurations that have more than a few pins. For
> instance, imagine what the above would look like when muxing a 24bit
> LCD pin list...
>
> How about adding a "bool valid" to gpiomux_setting, and convert the
> "sets" array to an array of settings and not pointers to settings.
> This will allow us to do (in gpiomux.h):
>
> struct msm_gpiomux_rec {
>      struct gpiomux_setting sets[GPIOMUX_NSETTINGS];
>      int ref;
> };
>
> struct gpiomux_setting {
>      enum gpiomux_func func;
>      enum gpiomux_drv  drv;
>      enum gpiomux_pull pull;
>      bool valid;
> };
>
> This way, I can do something like (very rough):
>
> #define GPIOMUX_SET(func,drv,pull) { \
>      .func = GPIOMUX_##func, \
>      .drv = GPIOMUX_##drv, \
>      .pull = GPIOMUX_##pull, \
>      .valid = true, \
>    }
>
> #define GPIOMUX_SET_NONE { .valid = false, }
>
> #define GPIOMUX_CFG(g, active, suspended) { \
>       .gpio = g, \
>       .sets = { \
>           [GPIOMUX_ACTIVE] = active, \
>           [GPIOMUX_SUSPENDED] = suspended, \
>        }, \
>   }
>
> This will then allow me to define the uart3 pinmuxing in my board file
> as follows:
>
> struct msm_gpiomux_rec uart3_mux_cfg[] = {
>      GPIOMUX_CFG(86, GPIOMUX_SET_NONE,
>                             GPIOMUX_SET(FUNC_1, DRV_2MA, PULL_DOWN)),
>      GPIOMUX_CFG(87, GPIOMUX_SET_NONE,
>                             GPIOMUX_SET(FUNC_1, DRV_2MA, PULL_DOWN)),
> };
>
> Thoughts?
>
> --Dima
>

Thanks for you feedback Dima. I agree that the above change makes the 
pin configurations verbose - but its neither too verbose to so as to 
become cumbersome to use nor typically unmanageable. We did think about 
adding a valid/invalid bool to the configurations - but the fact was 
that they it simply did not belong there. The gpiomux configurations are 
never "invalid" as such. Another important part to this decision was 
that - with adding another variable as a part of the gpiomux 
configurations meant that we were transferring responsibility of 
maintaining something that belongs to the "gpiomux internals" to the 
user. We felt that having the user to append a valid/invalid flag with 
every configuration to was not a step in the right direction.
On the contrary, the explicit structures improved readability and kept 
things pretty simple. Thinking about it more - it doesn't even make it 
verbose - but it just may seem that way because we expand it into a 
structure instead of hiding behind a macro.
Also, we currently use this same design for a number of GPIOs far 
greater than 24 and my/our experience has never been bothersome.
Hope that answers your query.

  Thanks,
Rohit Vaswani

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

