Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751616Ab0KWDGZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 22:06:25 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:48180 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534Ab0KWDGV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 22:06:21 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6175"; a="63962910"
Message-ID: <4CEB2FAC.8040305@codeaurora.org>
Date: Mon, 22 Nov 2010 19:06:20 -0800
From: Stepan Moskovchenko <stepanm@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.11) Gecko/20101013 Thunderbird/3.1.5
MIME-Version: 1.0
To: Daniel Walker <dwalker@codeaurora.org>
CC: davidb@codeaurora.org, bryanh@codeaurora.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] msm: iommu: Rework clock logic and add IOMMU bus
 clock control
References: <1290222154-11096-1-git-send-email-stepanm@codeaurora.org>	 <1290222154-11096-4-git-send-email-stepanm@codeaurora.org> <1290469909.4258.34.camel@m0nster>
In-Reply-To: <1290469909.4258.34.camel@m0nster>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/22/2010 3:51 PM, Daniel Walker wrote:
> On Fri, 2010-11-19 at 19:02 -0800, Stepan Moskovchenko wrote:
>> Clean up the clock control code in the probe calls, and add
>> support for controlling the clock for the IOMMU bus
>> interconnect. With the (proper) clock driver in place, the
>> clock control logic in the probe function can be made much
>> cleaner since it does not have to deal with the placeholder
>> driver anymore.
>>
>> Change-Id: I1040bc4e18f4ab4b7cc0dd5fe667f9df83b9f1f5
> You need to remove this Change-Id ..
Fixed in v2.

>
>> +		pr_err("Could not request memory region: start=%p, len=%d\n",
>> +							(void *) r->start, len);(void *) r->start, len);
> You usually just tab over till you get to the " like this,
>
> pr_err("Could not request memory region: start=%p, len=%d\n",
> 	(void *) r->start, len);
Fixed in v2.

>>   	drv = platform_get_drvdata(pdev);
>>   	if (drv) {
>> -		memset(drv, 0, sizeof(struct msm_iommu_drvdata));
>> +		if (drv->clk)
>> +			clk_put(drv->clk);
>> +		clk_put(drv->pclk);
>> +		memset(drv, 0, sizeof(*drv));
> Do you really need the memset ?
I guess not.. it seemed like good practice to poison the memory in case 
someone else had a stale reference to it. I guess I can remove them.

>> +	if (ret)
>> +		goto fail;
>> +
>> +	if (drvdata->clk) {
>> +		ret = clk_enable(drvdata->clk);
>> +		if (ret) {
>> +			clk_disable(drvdata->pclk);
>> +			goto fail;
>> +		}
>> +	}
> You did this in a prior patch also, you could combine them into a single
> helper function. Maybe do the same for the disable side too.
That was in a different file (where it gets used much more extensively 
than just in the one case here). I would rather not make a bunch of my 
internal stuff visible to the global namespace if I can help it, and 
it's a trivial enough operation to enable two clocks.

I will send out v2 in a few minutes.

Steve

---

  Sent by an employee of the Qualcomm Innovation Center, Inc.
  The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.


