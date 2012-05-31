Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757933Ab2EaMuN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 08:50:13 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:50158 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757290Ab2EaMuM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 08:50:12 -0400
Message-ID: <4FC768F8.4050406@ti.com>
Date: Thu, 31 May 2012 14:50:00 +0200
From: "Cousson, Benoit" <b-cousson@ti.com>
Organization: Texas Instruments
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Felipe Balbi <balbi@ti.com>, Russell King <linux@arm.linux.org.uk>,
        Stephen Boyd <sboyd@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mike Turquette <mturquette@ti.com>
Subject: Re: [RFC PATCH] clk: add extension API
References: <1338285540-24407-1-git-send-email-pdeschrijver@nvidia.com> <4FC5DFCF.1020606@codeaurora.org> <20120531075125.GL8026@tbergstrom-lnx.Nvidia.com> <20120531081841.GG5377@arwen.pp.htv.fi> <20120531083131.GQ8026@tbergstrom-lnx.Nvidia.com> <20120531085432.GK5377@arwen.pp.htv.fi> <20120531090518.GR8026@tbergstrom-lnx.Nvidia.com>
In-Reply-To: <20120531090518.GR8026@tbergstrom-lnx.Nvidia.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On 5/31/2012 11:05 AM, Peter De Schrijver wrote:
>>
>> What if a module needs two clocks and you drive the reset on both of the
>> clocks ? What would happen ?
>>
>
> Only 'leave clocks' have this reset method and a module can only have 1 of
> them.
>
>>> but then we would have the keep a list of IDs (1 per module) which the drivers
>>> can use to call some tegra reset function which would in the end use registers
>>> in the same memory area to cause a reset. (the registers controlling
>>> modulereset are interleaved with those controlling the enable/disable of the
>>> main moduleclock and bitpositions are identical)
>>
>> Well, under a generic device-level API, you could just call an internal
>> clk_reset() function because you know which clocks feed into which
>> devices anyway. It could look something like:
>>
>> on Tegra:
>>
>> device_reset(dev)
>> 	->  dev_pm_domain->reset()
>> 		->  tegra_periph_reset()
>>
>
> These methods are also needed internally by the powergating code.
>
>> on OMAP:
>>
>> device_reset(dev)
>> 	->  dev_pm_domain->reset()
>> 		->  omap_hwmod_reset()
>>
>>
>> btw:
>>
>> tegra_periph_reset(....)
>> {
>> 	tegra_periph_reset_assert(...);
>> 	udelay(2);
>> 	tegra_periph_reset_deassert(...);
>> }
>
> which uses the clockframework currently.

Hehe, that a little bit why we had to introduce hwmod for OMAP.
A HW IP cannot just be represented by a clock node like it used to be in 
the good old time.

Now the question is should we extend the Linux device structure to 
handle such HW IP, or should we extend the clock definition to handle 
this kind of extended clock node.

It looks to me that this kind of function does belong to the device more 
than to the clock node.

FWIW, we do have as well issue managing properly the reset for OMAP IPs. 
It is done using custom OMAP hooks today and hwmod whereas it looks like 
it is really a common problem for SoC in general.

Regards,
Benoit
