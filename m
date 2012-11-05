Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964923Ab2KEXXr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 18:23:47 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:39529 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964894Ab2KEXXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 18:23:38 -0500
Message-ID: <50984A6A.8050505@ti.com>
Date: Mon, 5 Nov 2012 18:23:22 -0500
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
> copy). Is this done to avoid including mach/ header files here? It will
> actually be better to include the mach/ files here as a temporary
> solution and then remove the include mach/ files once all the SoCs have
> been converted over.
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
Are you expecting something like this?

static struct davinci_clk *psc_clocks[] = {
     [dsp - dsp]        = &clk_dsp,
     [arm - dsp]        = &clk_arm,
     [vicp - dsp]        = &clk_vicp,
     [vpss_maste - dsp]    = &clk_vpss_master,
     [vpss_slave - dsp]    = &clk_vpss_slave,
     [uart0 - dsp]        = &clk_uart0,
     [uart1 - dsp]        = &clk_uart1,

Murali
>
> Thanks,
> Sekhar
>

