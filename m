Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758280Ab1DZVGb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 17:06:31 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:29797 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754071Ab1DZVG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 17:06:29 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6328"; a="87785737"
Message-ID: <4DB733D4.3000002@codeaurora.org>
Date: Tue, 26 Apr 2011 14:06:28 -0700
From: Michael Bohan <mbohan@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
CC: Kevin Cernekee <cernekee@gmail.com>, mingo@elte.hu,
        akpm@linux-foundation.org, simon.kagstrom@netinsight.net,
        David.Woodhouse@intel.com, lethal@linux-sh.org, tj@kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: console_cpu_notify can cause scheduling BUG during CPU hotplug
References: <4DB604C7.8090305@codeaurora.org> <BANLkTimPHaiiiVC_A6jtUtaa_pYJuhepYg@mail.gmail.com> <4DB65EEC.7060604@ti.com>
In-Reply-To: <4DB65EEC.7060604@ti.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/25/2011 10:58 PM, Santosh Shilimkar wrote:
> On 4/26/2011 5:48 AM, Kevin Cernekee wrote:
>> On Mon, Apr 25, 2011 at 4:33 PM, Michael Bohan<mbohan@codeaurora.org>
>> wrote:
>>> I was curious if this scenario was accounted for in the design of the
>>> console CPU notifier. One workaround for this problem is to remove
>>> CPU_DEAD
>>> from the possible actions in console_cpu_notify(). In fact, v1-v4 of the
>>> patch above did not have CPU_DEAD, CPU_DYING or CPU_DOWN_FAILED in
>>> the list
>>> of actions. I wasn't able to track down why the other cases were
>>> added in
>>> the final patch.
>>
>> Here is the background information on the CPU_{DEAD,DYING,DOWN_FAILED}
>> cases:
>>
>> http://lkml.org/lkml/2010/6/29/65
> That's right.
> May be the change log for commit '034260d67' would have been
> bit more descriptive about the CPU hot-plug events.

Thanks for the clarification. Now regarding the problem, it seems like 
we can't be taking a semaphore in that path. That is to say, we can't be 
calling console_lock from within stop_machine. A few options that come 
to mind:

-Use console_trylock and accept the possibility that the output is not 
guaranteed to be synchronous with the hotplug operation.
-Defer the console output emission (eg. workqueue) during hotplug.
-Hybrid of the two: if the console_trylock fails, then we defer the 
console output emission.

Any opinions? I can submit a patch if one of these approaches is reasonable.

Thanks,
Mike

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum
