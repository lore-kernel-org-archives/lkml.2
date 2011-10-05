Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758060Ab1JEU6z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 16:58:55 -0400
Received: from higgs.elka.pw.edu.pl ([194.29.160.5]:57690 "EHLO
	higgs.elka.pw.edu.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754846Ab1JEU6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 16:58:54 -0400
X-Comment: RFC 2476 MSA function at elektron.elka.pw.edu.pl logged sender identity as: wzabolot
Message-ID: <4E8CC500.50308@ise.pw.edu.pl>
Date: Wed, 05 Oct 2011 22:58:40 +0200
From: =?UTF-8?B?V29qY2llY2ggWmFib8WCb3RueQ==?= <wzab@ise.pw.edu.pl>
Reply-To: wzab@ise.pw.edu.pl
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.21) Gecko/20110831 Icedove/3.1.13
MIME-Version: 1.0
To: "vger.kernel.org, " <linux-kernel@vger.kernel.org>
Subject: Re: Error in kernel 3.0.4 for at91 - atmel_tcb.1 is not detected
 in tc_probe, fix provided
References: <4E8CB644.8060003@ise.pw.edu.pl>
In-Reply-To: <4E8CB644.8060003@ise.pw.edu.pl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry in my previous post the links were corrupted. Now the corrected version.

Hi,

I've ported my driver, which uses the atmel_tcb.1 block as PWM source (in AT91SAM9260).
The code worked perfectly in kernel.2.6.29.3, but now during the initialization I get the following error:

atmel_tcb: probe of atmel_tcb.1 failed with error -22

I have added printk invocations in the tc_probe routine, and I've found, that the problem occures, when tc_probe attempts to get clock for atmel_tcb.1 (In this line: 
http://lxr.linux.no/linux+v3.0.4/drivers/misc/atmel_tclib.c#L125 )

The atmel_tcb.0 is correctly used as clocksource:
tcb_clksrc: tc0 at 12.916 MHz

I have found, that the tc_probe always looks for "t0_clk", "t1_clk" and "t2_clk", and
function at91_add_device_tc performs the following operations:

( http://lxr.linux.no/linux+v2.6.29.3/arch/arm/mach-at91/at91sam9260_devices.c#L599 )
static void __init at91_add_device_tc(void)
{
/* this chip has a separate clock and irq for each TC channel */
at91_clock_associate("tc0_clk", &at91sam9260_tcb0_device.dev, "t0_clk");
at91_clock_associate("tc1_clk", &at91sam9260_tcb0_device.dev, "t1_clk");
at91_clock_associate("tc2_clk", &at91sam9260_tcb0_device.dev, "t2_clk");
platform_device_register(&at91sam9260_tcb0_device);
at91_clock_associate("tc3_clk", &at91sam9260_tcb1_device.dev, "t0_clk");
at91_clock_associate("tc4_clk", &at91sam9260_tcb1_device.dev, "t1_clk");
at91_clock_associate("tc5_clk", &at91sam9260_tcb1_device.dev, "t2_clk");
platform_device_register(&at91sam9260_tcb1_device);
}

While the code mapping the clock names in 3.0.4 has the following form:

(see: http://lxr.linux.no/#linux+v3.0.4/arch/arm/mach-at91/at91sam9260.c#L234 )
static struct clk_lookup periph_clocks_lookups[] = {
CLKDEV_CON_DEV_ID("spi_clk", "atmel_spi.0", &spi0_clk),
CLKDEV_CON_DEV_ID("spi_clk", "atmel_spi.1", &spi1_clk),
CLKDEV_CON_DEV_ID("t0_clk", "atmel_tcb.0", &tc0_clk),
CLKDEV_CON_DEV_ID("t1_clk", "atmel_tcb.0", &tc1_clk),
CLKDEV_CON_DEV_ID("t2_clk", "atmel_tcb.0", &tc2_clk),
CLKDEV_CON_DEV_ID("t3_clk", "atmel_tcb.1", &tc3_clk),
CLKDEV_CON_DEV_ID("t4_clk", "atmel_tcb.1", &tc4_clk),
CLKDEV_CON_DEV_ID("t5_clk", "atmel_tcb.1", &tc5_clk),
CLKDEV_CON_DEV_ID("pclk", "ssc.0", &ssc_clk),
};

To assure correct detection and operation of atmel_tcb.1, I had to change the above
code as shown below:

static struct clk_lookup periph_clocks_lookups[] = {
CLKDEV_CON_DEV_ID("spi_clk", "atmel_spi.0", &spi0_clk),
CLKDEV_CON_DEV_ID("spi_clk", "atmel_spi.1", &spi1_clk),
CLKDEV_CON_DEV_ID("t0_clk", "atmel_tcb.0", &tc0_clk),
CLKDEV_CON_DEV_ID("t1_clk", "atmel_tcb.0", &tc1_clk),
CLKDEV_CON_DEV_ID("t2_clk", "atmel_tcb.0", &tc2_clk),
CLKDEV_CON_DEV_ID("t0_clk", "atmel_tcb.1", &tc3_clk),
CLKDEV_CON_DEV_ID("t1_clk", "atmel_tcb.1", &tc4_clk),
CLKDEV_CON_DEV_ID("t2_clk", "atmel_tcb.1", &tc5_clk),
CLKDEV_CON_DEV_ID("pclk", "ssc.0", &ssc_clk),
};

-- 
Regards,
Wojciech M. Zabolotny


