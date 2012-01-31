Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754128Ab2AaNPb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 08:15:31 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:40787 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752242Ab2AaNPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 08:15:30 -0500
Message-ID: <4F27E96E.9010204@gmail.com>
Date: Tue, 31 Jan 2012 07:15:26 -0600
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: Shawn Guo <shawn.guo@linaro.org>
CC: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Milton Miller <miltonm@bga.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v3 14/25] irq_domain: Remove irq_domain_add_simple()
References: <1327700179-17454-1-git-send-email-grant.likely@secretlab.ca> <1327700179-17454-15-git-send-email-grant.likely@secretlab.ca> <20120131124500.GA28571@S2101-09.ap.freescale.net>
In-Reply-To: <20120131124500.GA28571@S2101-09.ap.freescale.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shawn,

On 01/31/2012 06:45 AM, Shawn Guo wrote:
> On Fri, Jan 27, 2012 at 02:36:08PM -0700, Grant Likely wrote:
>> irq_domain_add_simple() was a stop-gap measure until complete irq_domain
>> support was complete.  This patch removes the irq_domain_add_simple()
>> interface.
>>
>> v2: Updated to pass in host_data pointer on irq_domain allocation.
>>
>> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
>> Cc: Rob Herring <rob.herring@calxeda.com>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Cc: Milton Miller <miltonm@bga.com>
>> ---
>>  arch/arm/mach-imx/mach-imx6q.c      |    3 ++-
>>  arch/arm/mach-msm/board-msm8x60.c   |    8 ++------
>>  arch/arm/mach-mx5/imx51-dt.c        |    4 ++--
>>  arch/arm/mach-mx5/imx53-dt.c        |    4 ++--
>>  arch/arm/mach-omap2/board-generic.c |    2 +-
>>  arch/arm/mach-prima2/irq.c          |    2 +-
>>  drivers/mfd/twl-core.c              |    2 +-
>>  include/linux/irqdomain.h           |    1 -
>>  kernel/irq/irqdomain.c              |   10 ++--------
>>  9 files changed, 13 insertions(+), 23 deletions(-)
>>
> ...
>> --- a/arch/arm/mach-mx5/imx51-dt.c
>> +++ b/arch/arm/mach-mx5/imx51-dt.c
>> @@ -47,7 +47,7 @@ static const struct of_dev_auxdata imx51_auxdata_lookup[] __initconst = {
>>  static int __init imx51_tzic_add_irq_domain(struct device_node *np,
>>  				struct device_node *interrupt_parent)
>>  {
>> -	irq_domain_add_simple(np, 0);
>> +	irq_domain_add_legacy(np, 32, 0, 0, &irq_domain_simple_ops, NULL);
>>  	return 0;
>>  }
>>  
>> @@ -57,7 +57,7 @@ static int __init imx51_gpio_add_irq_domain(struct device_node *np,
>>  	static int gpio_irq_base = MXC_GPIO_IRQ_START + ARCH_NR_GPIOS;
>>  
>>  	gpio_irq_base -= 32;
>> -	irq_domain_add_simple(np, gpio_irq_base);
>> +	irq_domain_add_legacy(np, 32, gpio_irq_base, 0, &irq_domain_simple_ops, NULL);
> 
> The tzic on imx5 gets 128 irq lines rather than 32 here.  The current
> code will make any hwirq that is > 32 hit the WARN_ON below in
> irq_domain_legacy_revmap().

But this is the gpio controller code? Really this should be 4 domains,
but this temp fix is probably fine until you use my generic irq chip
support.

Rob

> 
> 	WARN_ON(hwirq < first_hwirq || hwirq >= first_hwirq + size)
> 
> The first_hwirq is 0 and size is 32 in this case.
> 
> Changing 32 to 128 seems fixing the problem.
> 
