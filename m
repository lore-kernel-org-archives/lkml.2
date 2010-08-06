Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935119Ab0HFUGJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 16:06:09 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:44627 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933168Ab0HFUGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 16:06:03 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6066"; a="50025536"
Message-ID: <4C5C6B2A.9040808@codeaurora.org>
Date: Fri, 06 Aug 2010 13:06:02 -0700
From: Rohit Vaswani <rvaswani@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.7) Gecko/20100713 Thunderbird/3.1.1
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: linux-kernel@vger.kernel.org, rvaswani@codeaurora.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: CPU Hotplug add/remove optimizations
References: <4C5742FE.5040907@codeaurora.org> <87y6codspt.fsf@basil.nowhere.org>
In-Reply-To: <87y6codspt.fsf@basil.nowhere.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 8/3/2010 1:07 AM, Andi Kleen wrote:
> Rohit Vaswani<rvaswani@codeaurora.org>  writes:
>
>>   Hi,
>>
>> We are trying to use cpu hotplug to turn off a cpu when it is not in
>> use to improve power management.
> It might not be a big issue on smaller systems, but CPU hotunplug
> involves stop_machine() and that is a very costly thing
> to do as systems become larger.
I think that currently for users, the cpu hotplug add time is what 
matters more - so that the user does not experience that latency in the 
UI when the core comes up. So I guess we could accept the latency for 
CPU hotunplug for the time being because eventually it will save power.
>> I am trying to optimize the cpu
>> hotplug add and cpu hotplug remove timings. Currently cpu hotplug add
>> takes around 250ms and cpu hotplug remove takes 190 ms. For the
>> current purposes we want to assume that we are removing and adding the
>> same core. It seems that since we are actually not replacing the core
>> – there could be a lot of initialization overhead that could be
>> saved and restored instead of calibrating the entire core again.
>> One such thing we have been looking at is that once a core is powered
>> up during cpu hotplug add, it runs the calibrate_delay routine to
>> calculate the value of loops_per_jiffy. In such a case could we bypass
>> the calibrate_delay function and just save and restore the value of
>> loops_per_jiffy?
>> Does this approach seem wrong to anyone?
> It's wrong on a system that supports socket hotplug. The CPU you're
> power up again might not be the same.
Could we have a separate code path for bringing up the same core that we 
just hot-unplugged?
One way could be that the user can specify that it is bringing up the 
same core and thus the calibrate_delay function could be skipped. If a 
new core is being added - the code path would calibrate the core again.
Currently the calibrate_delay function takes up almost the entire 250ms 
of cpu hotplug-add time. Thus, if we can get rid of that function call, 
when we know that we are bringing up the same core - the cpu hotplug add 
could be almost instantaneous.
Is there a better way to accomplish this?
Are there any other issues that I may be missing in order to get this 
working?
> In theory you could have some low level interface that distingushes
> these two cases, but right now that's not there.
>
>> Can we safely assume that the core will start at the same clock speed
>> at which the value was stored and then restored?
> That neither.
>
> -Andi
Thanks,
Rohit Vaswani

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
