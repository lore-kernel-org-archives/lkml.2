Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753534Ab1CUOzc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 10:55:32 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:12947
	"EHLO VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753464Ab1CUOza convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 10:55:30 -0400
X-SpamScore: -26
X-BigFish: VS-26(zz542N1432N98dN9371Pzz1202hzz8275bh8275dhz2dh2a8h668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Nguyen Dinh-R00091 <R00091@freescale.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "u.kleine-koenig@pengutronix.de" <u.kleine-koenig@pengutronix.de>,
        "arnaud.patard@rtp-net.org" <arnaud.patard@rtp-net.org>,
        Vaidyanathan Ranjani-RA5478 <RA5478@freescale.com>,
        Zhang Lily-R58066 <R58066@freescale.com>,
        "festevam@gmail.com" <festevam@gmail.com>
Subject: RE: [PATCHv4 3/3] ARM: mx51: Add support for low power suspend on
	MX51
Thread-Topic: [PATCHv4 3/3] ARM: mx51: Add support for low power suspend on
	MX51
Thread-Index: AQHL5YC2qGpbnN+ny0GdHXKnXxUlY5Q349Ng
Date: Mon, 21 Mar 2011 14:53:21 +0000
Message-ID: <56132A77AB93C141BF06E6B96CA6CFEA1BC0AF@039-SN1MPN1-004.039d.mgd.msft.net>
References: <1300461684-21775-1-git-send-email-Dinh.Nguyen@freescale.com>
 <1300461684-21775-2-git-send-email-Dinh.Nguyen@freescale.com>
 <1300461684-21775-3-git-send-email-Dinh.Nguyen@freescale.com>
 <20110318152502.GO29758@n2100.arm.linux.org.uk>
In-Reply-To: <20110318152502.GO29758@n2100.arm.linux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.81.68.39]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell,

>-----Original Message-----
>From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of
>Russell King - ARM Linux
>Sent: Friday, March 18, 2011 10:25 AM
>To: Nguyen Dinh-R00091
>Cc: linux-kernel@vger.kernel.org; linux-arm-kernel@lists.infradead.org; s.hauer@pengutronix.de;
>u.kleine-koenig@pengutronix.de; arnaud.patard@rtp-net.org; Vaidyanathan Ranjani-RA5478; Zhang Lily-
>R58066; festevam@gmail.com
>Subject: Re: [PATCHv4 3/3] ARM: mx51: Add support for low power suspend on MX51
>
>On Fri, Mar 18, 2011 at 10:21:24AM -0500, Dinh.Nguyen@freescale.com wrote:
>> +#include <linux/suspend.h>
>> +#include <linux/clk.h>
>> +#include <asm/mach/map.h>
>> +#include <asm/cacheflush.h>
>> +#include <asm/tlb.h>
>> +#include <mach/system.h>
>> +#include "crm_regs.h"
>
>Why does the code below require asm/mach/map.h ?

map.h can be replaced by linux/io.h for the __raw_writel().

>Why does it require asm/tlb.h ?

asm/tlb is for the local_flush_tlb_all() call.

Thanks for your review.

Dinh
>
>> +
>> +static struct clk *gpc_dvfs_clk;
>> +
>> +static int mx5_suspend_enter(suspend_state_t state)
>> +{
>> +	if (gpc_dvfs_clk == NULL)
>> +		gpc_dvfs_clk = clk_get(NULL, "gpc_dvfs");
>> +
>> +	if (gpc_dvfs_clk) {
>> +		clk_enable(gpc_dvfs_clk);
>> +		switch (state) {
>> +		case PM_SUSPEND_MEM:
>> +			mx5_cpu_lp_set(STOP_POWER_OFF);
>> +			break;
>> +		case PM_SUSPEND_STANDBY:
>> +			mx5_cpu_lp_set(WAIT_UNCLOCKED_POWER_OFF);
>> +			break;
>> +		default:
>> +			return -EINVAL;
>> +		}
>> +
>> +		if (state == PM_SUSPEND_MEM) {
>> +			local_flush_tlb_all();
>> +			flush_cache_all();
>> +
>> +			/*clear the EMPGC0/1 bits */
>> +			__raw_writel(0, MXC_SRPG_EMPGC0_SRPGCR);
>> +			__raw_writel(0, MXC_SRPG_EMPGC1_SRPGCR);
>> +		}
>> +		cpu_do_idle();
>> +		clk_disable(gpc_dvfs_clk);
>> +	}else {
>> +		printk(KERN_ERR "Cannot enter SRPG suspend -no gpc_dvfs clock!\n");
>> +		return -EPERM;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static int mx5_pm_valid(suspend_state_t state)
>> +{
>> +	return (state > PM_SUSPEND_ON && state <= PM_SUSPEND_MAX);
>> +}
>> +
>> +static const struct platform_suspend_ops mx5_suspend_ops = {
>> +	.valid = mx5_pm_valid,
>> +	.enter = mx5_suspend_enter,
>> +};
>> +
>> +static int __init mx5_pm_init(void)
>> +{
>> +	if (cpu_is_mx51())
>> +		suspend_set_ops(&mx5_suspend_ops);
>> +
>> +	return 0;
>> +}
>> +device_initcall(mx5_pm_init);
>> --
>> 1.6.0.4
>>
>>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/


