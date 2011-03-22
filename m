Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754980Ab1CVXJD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 19:09:03 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:52869 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754436Ab1CVXI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 19:08:59 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6293"; a="81473911"
Message-ID: <4D892C0A.1090606@codeaurora.org>
Date: Tue, 22 Mar 2011 16:08:58 -0700
From: David Collins <collinsd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Deadlock scenario in regulator core
References: <4D891C59.1030009@codeaurora.org> <20110322223702.GO14675@home.goodmis.org>
In-Reply-To: <20110322223702.GO14675@home.goodmis.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/2011 03:37 PM, Steven Rostedt wrote:
> On Tue, Mar 22, 2011 at 03:02:01PM -0700, David Collins wrote:
>> Assume that A has already called regulator_enable for S1 some time in the
>> past.
>>
>> Consumer A thread execution:
>> 	regulator_disable(S1)
>> 	mutex_lock(S1)
>> 	_regulator_disable(S1)
>> 	_notifier_call_chain(S1)
>> 	mutex_lock(L2)
>>
>> Consumer B thread execution:
>> 	regulator_enable(L2)
>> 	mutex_lock(L2)
>> 	_regulator_enable(L2)
>> 	mutex_lock(S1)
>>
>> The locks for S1 and L2 are taken in opposite orders in the two threads;
>> therefore, it is possible to achieve deadlock.  I am not sure about the
>> best way to resolve this situation.  Is there a correctness requirement
>> that regulator_enable holds the child regulator's lock when it attempts to
>> enable the parent regulator?  Likewise, is the lock around
>> _notifier_call_chain required?
> 
> I'm curious, if you had enabled lockdep, do you get a warning? If not,
> why not?
> 
> Thanks,
> 
> -- Steve
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-arm-msm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

I have tried running with lockdep enabled.  It does not produce a warning
about possible deadlock from locks being taken in opposite orders in two
threads.  I assume that this is because it can only keep track of locks
taken in the current stack backtrace.

It does produce a warning for regulator_disable by itself though on a
regulator with a non-empty supply_list:

 =============================================
 [ INFO: possible recursive locking detected ]
 2.6.38-rc7+ #231
 ---------------------------------------------
 sh/25 is trying to acquire lock:
  (&rdev->mutex){+.+...}, at: [<c0137ae4>] _notifier_call_chain+0x28/0x6c

 but task is already holding lock:
  (&rdev->mutex){+.+...}, at: [<c0138410>] regulator_disable+0x24/0x74

The locks that it is noting are different; one is for the parent regulator
and the other is for the child regulator. Any thoughts?

Thanks,
David

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
