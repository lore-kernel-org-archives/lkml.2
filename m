Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754473Ab2K0LPo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 06:15:44 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:28800 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754176Ab2K0LPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 06:15:42 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6908"; a="9836094"
Message-ID: <50B4A0D1.7010707@codeaurora.org>
Date: Tue, 27 Nov 2012 16:45:29 +0530
From: Anirudh Ghayal <aghayal@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        collinsd@codeaurora.org, khilman@ti.com, tsoni@codeaurora.org
Subject: Re: Shared regulator usage
References: <1b9aae54f83056035d83c049a7ac1876.squirrel@www.codeaurora.org> <20121126134719.GI9411@opensource.wolfsonmicro.com>
In-Reply-To: <20121126134719.GI9411@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/2012 7:17 PM, Mark Brown wrote:
> On Mon, Nov 26, 2012 at 05:13:37AM -0800, aghayal@codeaurora.org wrote:
>
>> For example:
>> Consumer (A) cpu-freq sets the voltage range to {1.275v, 1.375v}. The
>> regulator framework eventually sets the regulator to 1.275v. Consumer (B)
>> recommends a lower the voltage say (1.25v) and executes set_volatge on
>> {1.25v, 1.25v}. This is where regulator_check_consumers() fails as it does
>> not meet the (A)'s constraint.
>
> Well, of course.  What else would you expect to happen in this case?
>
>> We are looking for the right way to handle such a situation using
>> regulator framework, considering this to be a valid usecase. One way we
>> could think of is having one of the driver (say cpu-freq) register a
>> virtual regulator device and have the other driver be its consumer. This
>> way all the regulator calls to the physical hardware will be routed though
>> one primary driver which can take care of the adjustments. The problem
>> with such approach would be scalability for a new consumer, i.e. adding
>> another consumer for the primary driver would present a similar problem as
>> the original one.
>
> Why not just fix your consumers to request the voltage ranges they
> actually want?  Clearly in your above example one of the consumers can
> support a wider voltage range than it is actually requesting so it
> should just request that voltage range.
>
Mark,

Let me try to explain this further.

Both our cpu-freq and the core-power-reduction (CPR) driver manipulate 
the voltage to the same physical device (apps core) and both these 
drivers are independent. The cpu-freq driver has predefined static 
<frequency, voltage> mappings and accordingly sets the nominal voltage 
based on the target frequency. The CPR then does micro adjustments to 
this voltage making it more optimal to save power. This is very similar 
to the SmartReflex design on the OMAP 
(http://omappedia.org/wiki/SR_Voltage_Control_Migration, 
http://lists.linuxfoundation.org/pipermail/linux-pm/2012-April/034117.html), 
the only difference being that in our case both the consumer drivers use 
the regulator framework to manipulate the voltage. I suppose on OMAP 
they handle such a case inside the OMAP-specific voltage layer.

A typical example in our case is --

cpu-freq mappings
<1.4Ghz, 1.3v>
<1.2Ghz, 1.2v>
<1.1Ghz, 1.1v>

At 1.4Ghz the cpu-freq driver votes for 1.3v, then the CPR kicks in and 
recommends a voltage of 1.275v. Now a set_voltage with this new level 
(1.275v, 1.275)  fails as it does not satisfy the limits of the cpu-freq 
driver. It is not possible to tweak this range any further as it would 
not achieve the goal of micro-adjusting the voltage to save power.

Such scenarios are very likely to occur in the future on embedded 
systems where there is a need to conserve power by introducing some 
adaptive voltage scaling techniques based on various parameters such as 
temperature/sensitivity.

Thank you,
~Anirudh

-- 
QUALCOMM INDIA, on behalf of Qualcomm Innovation Center, Inc. is a 
member of Code Aurora Forum, hosted by The Linux Foundation.
