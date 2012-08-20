Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756741Ab2HTOnK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 10:43:10 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:59609 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754703Ab2HTOnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 10:43:06 -0400
Message-ID: <50324CF4.7060304@gmail.com>
Date: Mon, 20 Aug 2012 16:43:00 +0200
From: Sebastian Hesselbarh <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111114 Icedove/3.1.16
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Lior Amsalem <alior@marvell.com>, Andrew Lunn <andrew@lunn.ch>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 02/11] pinctrl: mvebu: dove pinctrl driver
References: <1344689809-6223-1-git-send-email-sebastian.hesselbarth@gmail.com>	<1344689809-6223-3-git-send-email-sebastian.hesselbarth@gmail.com> <CACRpkda9BL5+NiDOsMKG0kv2coBsw=Er=ZccXnNkgeftV9hPhQ@mail.gmail.com>
In-Reply-To: <CACRpkda9BL5+NiDOsMKG0kv2coBsw=Er=ZccXnNkgeftV9hPhQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20/2012 03:43 PM, Linus Walleij wrote:
>>   config PINCTRL_MVEBU
>>          bool "Marvell SoC pin controller drivers"
>> -       depends on ARCH_MVEBU
>> +       depends on ARCH_MVEBU || ARCH_DOVE
>
> Hmmmm.
>
> Shouldn't this thing rather be:
> depends on PLAT_ORION
> else you end up lining up all Marvell machines here...
 > (...)
 >> +config PINCTRL_DOVE
 >> +       bool "Support for Marvell Dove SoCs"
 >> +       depends on PINCTRL_MVEBU
 >
 > Shouldn't this rather be:
 >
 > depends on ARCH_DOVE
 > select PINCTRL_MVEBU
 >
 > since you call down into the mvebu driver, it definatley needs
 > to select that.

Yes, this is a bit difficult but PLAT_ORION is basically all existing
Marvell SoCs of the Orion family. Armada 370/XP are two new SoCs
_and_ the approach to combine all into one mach-mvebu. The pinctrl
driver will only be made available to mach-mvebu as I am already close
to have at least mach-dove ported over.

After the review of Andrew, I already changed the Kconfig to have the 
structure you are proposing.

>> +#define  DOVE_AU0_AC97_SEL             (1<<  16)
>
> It is way cleaner to say:
> #include<linux/bitops.h>
> #define  DOVE_AU0_AC97_SEL             BIT(16)

Ok.

> Same comments about the magic numbers as in the review of the first
> patch.

I just agree with all of these comments and will work them in.

>> +       if (ctrl->pid == 24)
>> +               mask = DOVE_CAM_GPIO_SEL;
>> +       else if (ctrl->pid == 40)
>> +               mask = DOVE_SD0_GPIO_SEL;
>> +       else if (ctrl->pid == 46)
>> +               mask = DOVE_SD1_GPIO_SEL;
>> +       else if (ctrl->pid == 58)
>> +               mask = DOVE_SPI_GPIO_SEL;
>> +       else if (ctrl->pid == 62)
>> +               mask = DOVE_UART1_GPIO_SEL;
>> +       else
>> +               return -EINVAL;
>
> Magic numbers, atleast provide a comment on what is so special about
> these pins, and can you use a switch() statement instead?

Sure.

>> +static int dove_audio1_ctrl_gpio_req(struct mvebu_mpp_ctrl *ctrl, u8 pid)
>> +{
>> +       unsigned long config;
>> +
>> +       dove_audio1_ctrl_get(ctrl,&config);
>> +
>> +       switch (config) {
>> +       /* mode 0x00 i2s1/spdifo : no gpio */
>> +       /* mode 0x0c ssp/spdifo  : no gpio */
>> +       /* mode 0x0f ssp/twsi    : no gpio */
>> +       case 0x00:
>> +       case 0x0c:
>> +       case 0x0f:
>> +               return -ENOTSUPP;
>
> Nice with the comments (also before the function),
> now I understand what's happening, this is pretty OK,
> I would have put the comments on the same
> line as the magic number but whatever.
>
> However you could just delete these lines and let them
> fall through to -ENOTSUPP at the bottom.

Ok.

>> +/* mpp[52:57] has gpio pins capable of in and out */
>> +static int dove_audio1_ctrl_gpio_dir(struct mvebu_mpp_ctrl *ctrl, u8 pid,
>> +                               bool input)
>> +{
>> +       return 0;
>> +}
>
> So should this not return a -ENOTSUPP for
> pin<  52 || pin>  57?

Well, as pinctrl-mvebu and pinctrl core are already checking for pin
ranges, I think it's ok not to do it here again. But I don't have a
strong opinion about that.

>> +       /*
>> +        * General MPP Configuration Register is part of pdma registers.
>> +        * grab clk to make sure it is clocked.
>> +        */
>> +       pdma_clk = clk_get_sys("dove-pdma", NULL);
>
> First there is something really weird with the name of this
> clock. Atleast call the variable holding the clk something
> apropriate like just "clk".
>
> Second why are you fetching a sys clock instead of using the clkdev
> device binding in the clock tree so you could say:
>
> clk = clk_get(&pdev->dev, NULL);

pdma is the name of the clock gating control bit used in DS, IIRC it
stands for Peripheral DMA. Moreover, as I already mentioned it is now
using devm_clk_get. I think the time the pinctrl-dove driver patch was
posted there was no clock binding in 3.6.

>> +static int __devexit dove_pinctrl_remove(struct platform_device *pdev)
>> +{
>> +       int ret;
>> +
>> +       ret = mvebu_pinctrl_remove(pdev);
>> +       if (!IS_ERR(pdma_clk)) {
>> +               clk_disable_unprepare(pdma_clk);
>> +               clk_put(pdma_clk);
>> +       }
>
> You don't need this (!IS_ERR()) clause, look in yout probe function:
> you bail out if the clock is not found.

Agree.

Sebastian
