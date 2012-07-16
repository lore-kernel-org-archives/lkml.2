Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751584Ab2GPJLQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 05:11:16 -0400
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:51432 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751182Ab2GPJLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 05:11:13 -0400
Message-ID: <5003DAAA.2070301@ti.com>
Date: Mon, 16 Jul 2012 14:41:06 +0530
From: Rajendra Nayak <rnayak@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.20) Gecko/20110805 Thunderbird/3.1.12
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org, loml <linux-omap@vger.kernel.org>
Subject: Re: [PATCH RFT 1/2] regulator: twl: Fix the formula to calculate
 vsel and voltage for twl6030ldo
References: <1341804151.14367.1.camel@phoenix> <1341831686.4343.7.camel@phoenix>
In-Reply-To: <1341831686.4343.7.camel@phoenix>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Axel,

My apologies for the delay in responding to this one.

On Monday 09 July 2012 04:31 PM, Axel Lin wrote:
> 於 一，2012-07-09 於 11:22 +0800，Axel Lin 提到：
>> In twl6030ldo_set_voltage, current code use below formula to calculate vsel:
>>          vsel = (min_uV/1000 - 1000)/100 + 1;
>> This is worng because when min_uV is 1000000 uV, vsel is 1.
>> It should be 0 in this case.

Why? Do you know of any documentation which states this?
I am referring to the twl6030 Top Functional spec version 1.18
and Table - 223 "LDO Output Voltage Selection Code" clearly
states that the vsel should be 1 when voltage expected is 1000000 uV.

Also refer to equation 3 "LDO Output Voltage Selection Code" in the
same document and you will see this mentioned..
Absolute Voltage value = 1.0V + 0.1V * (binary value – 00000001)

>> Fix it by change the equation to: (This equation is common for linear mapping)
>>          vsel = DIV_ROUND_UP(min_uV - rdev->desc->min_uV, rdev->desc->uV_step);
>>
>> In twl6030ldo_get_voltage, current code use below formula to calculate voltage:
>>          mV = 1000mv + 100mv * (vsel - 1)
>> This is worng because when vsel is 0, mV is 900mV. Note the min_uV is 1000mV.
>> Fix it by change the equation to: (This equation is common for linear mapping)
>>          return rdev->desc->min_uV + vsel * rdev->desc->uV_step;
>
> While I'm thinking I need to rework this patch so that it doesn't use
> rdev->desc->min_uV and rdev->desc->uV_step and then can be applied
> to current Linus' tree.
>
> But while I am tracking back to commit 3e3d3be79c
> Author: Rajendra Nayak<rnayak@ti.com>
> Date:   Thu Apr 22 14:18:32 2010 +0530
>
>      twl6030: regulator: Remove vsel tables and use formula for
> calculation
>
>      All twl6030 regulators can be programmed from 1.0v to 3.3v
>      with 100mV steps.
>      The below formula can be used to calculate the vsel values
>      to be programmed in the VREG_VOLTAGE registers.
>
>      Voltage(in mV) = 1000mv + 100mv * (vsel - 1)
>
>      Ex: if vsel = 0x9, mV = 1000 + 100 * (9 -1) = 1800mV.
>
>      This patch removes all existing VSEL tables for twl6030 adjustable
>      regulators and just uses the formula directly for vsel calculations
>      after verifing they fall in the allowed range.
>
>      Signed-off-by: Rajendra Nayak<rnayak@ti.com>
>
> I found a problem that before commit 3e3d3be79c, the voltage tables were
> not linear mapping. So why we can convert these voltage mapping table to
> Voltage(in mV) = 1000mv + 100mv * (vsel - 1)?
>
> Did I miss something?

All voltage tables before commit '3e3d3be79c' for twl6030 regulators
were clearly wrong. They assumed similarity with twl4030 regulators
which was not right.

regards,
Rajendra

>
> Regards,
> Axel
>
>

