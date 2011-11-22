Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758441Ab1KVUpb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 15:45:31 -0500
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:44105 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758416Ab1KVUpa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 15:45:30 -0500
Message-ID: <4ECC09D7.7050601@linux.vnet.ibm.com>
Date: Wed, 23 Nov 2011 02:15:11 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Pavel Machek <pavel@ucw.cz>, len.brown@intel.com, tj@kernel.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH] PM / Hibernation: Fix *massive* memory leak at early
 exits in hibernation
References: <20111121173939.9486.38357.stgit@srivatsabhat.in.ibm.com> <20111122114549.GC32023@elf.ucw.cz> <4ECBF271.3040308@linux.vnet.ibm.com> <201111222132.35984.rjw@sisk.pl>
In-Reply-To: <201111222132.35984.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 11112210-5140-0000-0000-0000004BE425
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/23/2011 02:02 AM, Rafael J. Wysocki wrote:
> On Tuesday, November 22, 2011, Srivatsa S. Bhat wrote:
>> On 11/22/2011 05:15 PM, Pavel Machek wrote:
>>> On Mon 2011-11-21 23:25:39, Rafael J. Wysocki wrote:
>>>> On Monday, November 21, 2011, Srivatsa S. Bhat wrote:
>>>>> At some of the early exit points during hibernation (exiting either due
>>>>> to failure or after a successful hibernation test, the memory pre-allocated
>>>>> for hibernation is not freed up. And this is *very* serious, because, during
>>>>> pre-allocation, it could have allocated upto a few *gigabytes* of memory!
>>>>> And hence, if a hibernation fails or even if we run some hibernation tests
>>>>> using the 'pm_test' framework, the system is rendered unstable due to memory
>>>>> becoming signifantly lower. Fix this bug.
>>>>
>>>> While the observation is valid, I'd prefer to do something like the patch
>>>> below.
>>>
>>> The code slowly becomes goto maze :-(.
>>>
>>
>> I agree.. It is already quite a mess.
>>
>>>> @@ -357,12 +357,14 @@ int hibernation_snapshot(int platform_mo
>>>>  		 * successful freezer test.
>>>>  		 */
>>>>  		freezer_test_done = true;
>>>> -		goto Close;
>>>> +		goto Cleanup;
>>>>  	}
>>>>  
>>>>  	error = dpm_prepare(PMSG_FREEZE);
>>>> -	if (error)
>>>> -		goto Complete_devices;
>>>> +	if (error) {
>>>> +		dpm_complete(msg);
>>>> +		goto Cleanup;
>>>> +	}
>>>
>>> Perhaps dpm_prepare should be changed to clean after itself in the
>>> error case? That is the normal convention AFAICT....
>>>
>>
>> If the intention here is to merely clean up hibernation_snapshot() code,
>> I would not prefer to change the behaviour of dpm_prepare(), considering
>> things like, what parameter should we pass to dpm_complete(); is the
>> resultant behaviour change in dpm_suspend_start() correct or not; what
>> happens to all the code that uses the nice pair: dpm_suspend_start() and
>> dpm_resume_end() and so on.
>>
>> Perhaps there are bigger issues involved there, since I observed on a brief
>> look that the current code doesn't seem to strictly follow the above
>> convention that whoever called dpm_prepare() should call dpm_complete()
>> upon failure. Or may be its doing the right thing.. I don't know.
>>
>> But anyway, the good news is, even without changing dpm_prepare()'s
>> behaviour, we can clean up quite a bit of code in hibernation_snapshot(),
>> as it is.
>>
>> The first patch below does the cleanup, the second patch fixes the memory
>> leak and applies on top of the first patch.
> 
> Wait, wait.  These changes can be made in the 3.3 merge window, while I'd
> like the fix the bug _now_.
> 
> Does anyone have any _technical_ problem with my patch posted previously
> in this thread?
> 

Technically, your patch is fine :-)

Acked-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

Thanks,
Srivatsa S. Bhat

