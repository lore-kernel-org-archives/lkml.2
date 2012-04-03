Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752961Ab2DCBxg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 21:53:36 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:40347 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752276Ab2DCBxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 21:53:34 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6668"; a="175974099"
Message-ID: <4F7A581D.2020303@codeaurora.org>
Date: Mon, 02 Apr 2012 18:53:33 -0700
From: Michael Bohan <mbohan@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:11.0) Gecko/20120312 Thunderbird/11.0
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: rnayak@ti.com, lrg@ti.com, LKML <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org
Subject: Re: Regulator supplies when using Device Tree
References: <20120326130005.GQ3098@opensource.wolfsonmicro.com> <4F726B96.8070508@codeaurora.org> <20120328100957.GD3232@opensource.wolfsonmicro.com> <4F736451.8020900@codeaurora.org> <20120328193341.GD3232@opensource.wolfsonmicro.com> <4F73A798.6030607@codeaurora.org> <20120329111159.GJ3668@opensource.wolfsonmicro.com> <4F7509F4.6010303@codeaurora.org> <20120330103602.GE21950@opensource.wolfsonmicro.com> <4F79E35A.5040908@codeaurora.org> <20120402212232.GA3160@opensource.wolfsonmicro.com>
In-Reply-To: <20120402212232.GA3160@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/2/2012 2:22 PM, Mark Brown wrote:
> On Mon, Apr 02, 2012 at 10:35:22AM -0700, Michael Bohan wrote:
>> Some of our regulators take inputs from other regulators. Some
>> regulators take their input from the battery. We support both types
>
> Oh, if that's all it is that's totally normal and unsurprising.  Just
> tell the regulator API about the battery supply, typically people use
> a fixed regulator for this.  You don't have to specify a voltage when
> you use them.

One problem here is the added run-time overhead. This includes the 
callbacks for the battery device which serve no functional purpose. And 
then there's the contention for a single mutex on the battery regulator, 
which all regulators using it as a supply would have to contend for. 
That is actually a sizable number of devices in our configuration; And 
these operations are frequent and time sensitive.

Plus, then there's other complexities that arise here by introducing yet 
another regulator driver into the configuration. The 'fixed' regulator 
driver initializes at subsys_initcall, but our other regulator drivers 
are registered at arch_initcall. This is because with Device Tree 
configurations we are forced to explicitly register drivers in a precise 
sequence in order to satisfy device dependencies and early probe times. 
But using 'fixed' would complicate this process, since we don't have 
control over it.

And generally speaking, why incur a larger memory footprint by linking 
another driver when there's no technical need to?

Thus it seems like there are use cases to have a single driver that can 
support regulators with or without supplies specified. I see adding a 
few lines of ugly code in the driver more ideal than accepting the 
problems above. But it would be nice if the regulator Device Tree 
support could handle it natively.

Thanks,
Mike

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
