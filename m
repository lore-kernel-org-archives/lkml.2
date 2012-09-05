Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758786Ab2IEMjH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 08:39:07 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:57259 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752102Ab2IEMjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 08:39:04 -0400
MIME-Version: 1.0
In-Reply-To: <201209051210.04880.arnd@arndb.de>
References: <1346839153-6465-1-git-send-email-loic.pallardy-ext@stericsson.com>
	<1346839153-6465-16-git-send-email-loic.pallardy-ext@stericsson.com>
	<201209051210.04880.arnd@arndb.de>
Date: Wed, 5 Sep 2012 14:39:03 +0200
Message-ID: <CACRpkdavDUEvJukHfSFqG8-ueDDo+86SzoV1SA0ZdWghuUxTPg@mail.gmail.com>
Subject: Re: [st-ericsson] [PATCH 15/17] mfd: dbx540-prcmu creation
From: Linus Walleij <linus.walleij@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>, Ulf Hansson <ulf.hansson@linaro.org>,
        Loic Pallardy <loic.pallardy-ext@stericsson.com>
Cc: linux-arm-kernel@lists.infradead.org, Samuel Ortiz <sameo@linux.intel.com>,
        Loic Pallardy <loic.pallardy@stericsson.com>,
        linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux <STEricsson_nomadik_linux@list.st.com>,
        Loic Pallardy <loic.pallardy@gmail.com>,
        LT ST-Ericsson <st-ericsson@lists.linaro.org>,
        Linus Walleij <linus.walleij@linaro.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 5, 2012 at 2:10 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Wednesday 05 September 2012, Loic Pallardy wrote:
>>
>> Signed-off-by: Loic Pallardy <loic.pallardy@stericsson.com>
>> Acked-by: Linus Walleij <linus.walleij@linaro.org>
>
> This makes me doubt the quality of Linus' Ack on other patches...

Basically the rationale is that to me the driver looks better after these
patches than before. But the basic problem is that I've read
the driver so much internally that I am already unable to see
some of it's shortcomings. (And a fair share of these comments
would apply to the already in-tree driver as well.) And we really
need help to figure out how to handle this beast. So fresh reviews
like this are much, much appreciated....

>> +#define PRCM_PLLDSITV_FREQ         (_PRCMU_BASE + 0x500)
>> +#define PRCM_PLLDSITV_ENABLE       (_PRCMU_BASE + 0x504)
>> +#define PRCM_PLLDSITV_LOCKP        (_PRCMU_BASE + 0x508)
>> +#define PRCM_PLLDSILCD_FREQ        (_PRCMU_BASE + 0x290)
>> +#define PRCM_PLLDSILCD_ENABLE      (_PRCMU_BASE + 0x294)
>> +#define PRCM_PLLDSILCD_LOCKP       (_PRCMU_BASE + 0x298)
>
> Please get rid of the global _PRCMU_BASE variable, at least for new
> code. Instead, please use ioremap() of the resources passed in the
> device tree, like we do for all other drivers.

Sounds reasonable, but historically we needed to write and control the
PRCMU before ioremap() is available. (Like at irq_init() time.)

If I'm not mistaken this has been fixed now, so what you say is true.

>> +#define CLK_MGT_ENTRY(_name, _branch, _clk38div)[PRCMU_##_name] = \
>> +     { (PRCM_##_name##_MGT), 0 , _branch, _clk38div}
>> +static struct clk_mgt clk_mgt[PRCMU_NUM_REG_CLOCKS] = {
>> +     CLK_MGT_ENTRY(SGACLK, PLL_DIV, false),
>> +     CLK_MGT_ENTRY(UARTCLK, PLL_FIX, true),
>(...)
> Another option would be to put the table into the device tree so you
> can abstract the differences between the two prmu versions more easily.

This falls back to the debate of whether SoC properties shall be
heavily encoded into the device tree, a point of contention. Doing
that may make the driver even harder to read than these macros,
like you need the driver, the device tree and the data sheet and
read all three simultaneously to understand what is going on.

>> +/**
>> + * replug_cpu1 - Power gate ON CPU1 for U9540
>> + * * void
>> + * * Returns:
>> + */
>> +static int replug_cpu1(void)
>> +{
>> +     int r = 0;
>> +#ifdef CONFIG_UX500_ROMCODE_SHARED_MUTEX
>> +     struct upap_req req;
>> +     struct upap_ack ack;
>
> Can you move these to a separate cpu-hotplug file?

Isn't this a more general comment such as that we should distribute
out the code in the PRCMU out into the device drivers? I think you or
someone else said that at some point, and that would then go for
all of them I think, then the PRCMU driver would just be a MFD
hub and mailbox/regmap provider in the end.

How to get there is another question...

>> +static unsigned long dbx540_prcmu_clock_rate(u8 clock)
>> +{
>> +     if (clock < PRCMU_NUM_REG_CLOCKS)
>> +             return clock_rate(clock);
>> +     else if (clock == PRCMU_TIMCLK)
>> +             return ROOT_CLOCK_RATE / 16;
>> +     else if (clock == PRCMU_SYSCLK)
>> +             return ROOT_CLOCK_RATE;
>> +     else if (clock == PRCMU_PLLSOC0)
>> +             return pll_rate(PRCM_PLLSOC0_FREQ, ROOT_CLOCK_RATE, PLL_RAW);
>> +     else if (clock == PRCMU_PLLSOC1)
>> +             return pll_rate(PRCM_PLLSOC1_FREQ, ROOT_CLOCK_RATE, PLL_RAW);
>> +     else if (clock == PRCMU_PLLDDR)
>> +             return pll_rate(PRCM_PLLDDR_FREQ, ROOT_CLOCK_RATE, PLL_RAW);
>> +     else if (clock == PRCMU_PLLDSI)
>> +             return pll_rate(PRCM_PLLDSITV_FREQ, clock_rate(PRCMU_HDMICLK),
>> +                     PLL_RAW);
>> +     else if (clock == PRCMU_ARMSS)
>> +             return KHZ_TO_HZ(armss_rate());
>> +     else if (clock == PRCMU_ARMCLK)
>> +             return KHZ_TO_HZ(get_arm_freq());
>> +     else if ((clock == PRCMU_DSI0CLK) || (clock == PRCMU_DSI1CLK))
>> +             return dsiclk_rate(clock - PRCMU_DSI0CLK, false);
>> +     else if ((PRCMU_DSI0ESCCLK <= clock) && (clock <= PRCMU_DSI2ESCCLK))
>> +             return dsiescclk_rate(clock - PRCMU_DSI0ESCCLK);
>> +     else if (clock == PRCMU_PLLDSI_LCD)
>> +             return pll_rate(PRCM_PLLDSILCD_FREQ,
>> +                                     clock_rate(PRCMU_SPARE1CLK), PLL_RAW);
>> +     else if ((clock == PRCMU_DSI0CLK_LCD) || (clock == PRCMU_DSI1CLK_LCD))
>> +             return dsiclk_rate(clock - PRCMU_DSI0CLK_LCD, true);
>> +     else
>> +             return 0;
>> +}
>
> Please use the common clock code for managing these.
> No more private clock implementations.

So here again there is a driver split issue. I think Ulf's current clock
implementation just use these implementations, so this would be a matter
of pushing that code down into the clock driver and decentralize this
PRCMU driver a bit more.

>> +     db8500_prcmu_init_mb0(&mb0);
>> +     /*  mailbox 1 used by UniqPAP */
>> +     db8500_prcmu_init_mb2(&mb2);
>> +     db8500_prcmu_init_mb3(&mb3);
>> +     db8500_prcmu_init_mb4(&mb4);
>> +     db8500_prcmu_init_mb5(&mb5);
>
> I think it would be good to split out all the mailbox handling into a
> separate file, and provide a proper abstraction for it,

This is what is happening in patch 11/17, elbeit it's just a separate
header. Thinking of it, I think it's possible to create a separate file
for the code too.

> based on a
> data structure that can hold pointers to the init/read/write/... functions
> as well as the common data for all mailboxes, such as
>
> struct prcmu_mailbox {
>         struct mutex lock;
>         struct completion complete;
>         bool (*read)(struct prcmu_mailbox *);
>         void (*init)(struct prcmu_mailbox *):
> }

This looks like a good idea.

Yours,
Linus Walleij
