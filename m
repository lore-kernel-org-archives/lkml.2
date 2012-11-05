Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751043Ab2KEPnR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 10:43:17 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:36783 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750756Ab2KEPnP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 10:43:15 -0500
Message-ID: <5097DE82.2090701@ti.com>
Date: Mon, 5 Nov 2012 10:42:58 -0500
From: Murali Karicheri <m-karicheri2@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: Sekhar Nori <nsekhar@ti.com>
CC: <mturquette@linaro.org>, <arnd@arndb.de>, <akpm@linux-foundation.org>,
        <shawn.guo@linaro.org>, <rob.herring@calxeda.com>,
        <linus.walleij@linaro.org>, <viresh.linux@gmail.com>,
        <linux-kernel@vger.kernel.org>, <khilman@ti.com>,
        <linux@arm.linux.org.uk>, <sshtylyov@mvista.com>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-keystone@list.ti.com>
Subject: Re: [PATCH v3 05/11] clk: davinci - add dm644x clock initialization
References: <1351181518-11882-1-git-send-email-m-karicheri2@ti.com> <1351181518-11882-6-git-send-email-m-karicheri2@ti.com> <50951C81.5050501@ti.com>
In-Reply-To: <50951C81.5050501@ti.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/03/2012 09:30 AM, Sekhar Nori wrote:
> On 10/25/2012 9:41 PM, Murali Karicheri wrote:
>> This patch adds dm644x clock initialization code that consists of
>> clocks data for various clocks and clock register callouts to
>> various clock drivers. It uses following clk drivers for this
>>
>>   1. clk-fixed-rate - for ref clock
>>   2. clk-mux - for mux at the input and output of main pll
>>   3. davinci specific clk-pll for main pll clock
>>   4. davinci specific clk-div for pll divider clock
>>   5. clk-fixed-factor for fixed factor clock such as auxclk
>>   6. davinci specific clk-psc for psc clocks
>>
>> This patch also moves all of the PLL and PSC register definitions
>> from clock.h and psc.h under davinci to the clk/davinci folder so
>> that various soc specific clock initialization code can share these
>> definitions.
> Except this patch does not move the defines, it creates a copy of them
> (which is bad since you quickly lose track of which is the correct
> copy). Is this done to avoid including mach/ header files here?
Yes.
> It will
> actually be better to include the mach/ files here as a temporary
> solution and then remove the include mach/ files once all the SoCs have
> been converted over.

I was thinking we are not allowed to include mach/* header files in 
driver files. But most of the clk drivers
such clk-imx28, spear6xx_clock.c. versatile/clk-integrator.c etc are 
including mach/ headers. One issue is that the definitions in pll.h are 
re-usable across other machines falling under c6x and Keystone (new 
device we are working on) as well. Where do we keep includes that can be 
re-used across different architectures? include/linux/platform_data/ ? I 
see clk-integrator.h, clk-nomadik.h and clk-u300 sitting there. So I 
suggest moving any header files that defines utility functions, register 
definitions across different architectures to 
include/linux/platform_data. Candidate files would be clock.h, pll.h, 
clk-psc.h, clk-pll.h and clk-div.h. This way these can be used across 
the above machines that use the above architectures. Can we do this in 
my next version? This way we don't have to make another move later. All 
these CLK IPs are re-used across multiple architectures and make perfect 
sense to me to move to the above folder.
>
>> Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
>> ---
>>   drivers/clk/davinci/dm644x-clock.c |  304 ++++++++++++++++++++++++++++++++++++
>>   drivers/clk/davinci/pll.h          |   83 ++++++++++
>>   drivers/clk/davinci/psc.h          |  215 +++++++++++++++++++++++++
>>   3 files changed, 602 insertions(+)
>>   create mode 100644 drivers/clk/davinci/dm644x-clock.c
>>   create mode 100644 drivers/clk/davinci/pll.h
>>   create mode 100644 drivers/clk/davinci/psc.h
>>
>> +/* all clocks available in DM644x SoCs */
>> +enum dm644x_clk {
>> +	clkin, oscin, ref_clk_mux, pll1, pll1_plldiv_clk_mux, auxclk,
>> +	clk_pll1_sysclk1, clk_pll1_sysclk2, clk_pll1_sysclk3, clk_pll1_sysclk4,
>> +	clk_pll1_sysclk5, clk_pll1_sysclkbp, pll2, pll2_plldiv_clk_mux,
>> +	clk_pll2_sysclk1, clk_pll2_sysclk2, clk_pll2_sysclkbp, dsp, arm, vicp,
>> +	vpss_master, vpss_slave, uart0, uart1, uart2, emac, i2c, ide, asp,
>> +	mmcsd, spi, gpio, usb, vlynq, aemif, pwm0, pwm1, pwm2, timer0, timer1,
>> +	timer2, clk_max
>> +};
>> +
>> +static struct davinci_clk *psc_clocks[] = {
>> +	&clk_dsp, &clk_arm, &clk_vicp, &clk_vpss_master, &clk_vpss_slave,
>> +	&clk_uart0, &clk_uart1, &clk_uart2, &clk_emac, &clk_i2c, &clk_ide,
>> +	&clk_asp0, &clk_mmcsd, &clk_spi, &clk_gpio, &clk_usb, &clk_vlynq,
>> +	&clk_aemif, &clk_pwm0, &clk_pwm1, &clk_pwm2, &clk_timer0, &clk_timer1,
>> +	&clk_timer2
>> +};
> You rely on perfect order between this array and dm644x_clk enum above.
> Can you initialize this array using the enum as the index so that it is
> clear. Current method is too error prone.

Ok. Will do.
>
> Thanks,
> Sekhar
>

