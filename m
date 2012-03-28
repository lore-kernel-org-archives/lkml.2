Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758054Ab2C1TTs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 15:19:48 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:57737 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756786Ab2C1TTr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 15:19:47 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6663"; a="174370533"
Message-ID: <4F736451.8020900@codeaurora.org>
Date: Wed, 28 Mar 2012 12:19:45 -0700
From: Michael Bohan <mbohan@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: rnayak@ti.com, lrg@ti.com, LKML <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org
Subject: Re: Regulator supplies when using Device Tree
References: <4F6BCF47.4090200@codeaurora.org> <20120326130005.GQ3098@opensource.wolfsonmicro.com> <4F726B96.8070508@codeaurora.org> <20120328100957.GD3232@opensource.wolfsonmicro.com>
In-Reply-To: <20120328100957.GD3232@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/28/2012 3:09 AM, Mark Brown wrote:
> On Tue, Mar 27, 2012 at 06:38:30PM -0700, Michael Bohan wrote:
>> the answer is that we should invent another binding to portray the
>> name of the supply the driver should be checking against. But then
>> it would seem silly to have two bindings that pertain to supply
>> names.
>
> Absolutely not, that would be broken.  The whole point here is that
> supplies of all kinds are always requested with the name the chip uses
> for the supply.

Let's consider an example with two regulators:

regulator@0 {
   compatible = "ldo_driver";
   foo-supply = <&smps1>;
};

regulator@1 {
   compatible = "ldo_driver";
};

How do we write a single regulator driver that supports both of these 
regulator devices?

Within the regulator driver, we currently have to do an 
of_get_property(of_node, "foo-supply", NULL) to determine whether the 
device has a supply, and thus whether we should assign 
rdesc->supply_name to "foo" or not when calling regulator_register(). Is 
there a better way to do this? If we don't do this check for the case 
where a device does not have a supply specified in the Device Tree, then 
regulator_register() will fail.

Before Device Tree, regulators could get their supply names directly 
from the board file like so:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=blob;f=Documentation/power/regulator/machine.txt;h=ce63af0a8e35ecab32e2f326d13a9a2b33b62909;hb=refs/heads/master#l67

Thus the regulator driver was never concerned about the specifics of a 
supply name. And if the supply name was not specified, then the 
regulator_register() would happily succeed without any checks in the 
driver.

Thanks,
Mike

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
