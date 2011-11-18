Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757183Ab1KRJqS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 04:46:18 -0500
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:51284 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756669Ab1KRJqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 04:46:17 -0500
Message-ID: <4EC62956.8060608@linux.vnet.ibm.com>
Date: Fri, 18 Nov 2011 15:15:58 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: len.brown@intel.com, pavel@ucw.cz, rdunlap@xenotime.net, tj@kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH v2] PM/Hibernation: Fix the early termination of test
 modes
References: <20111118031623.32591.73677.stgit@srivatsabhat.in.ibm.com> <201111181020.44167.rjw@sisk.pl> <4EC6250F.4010501@linux.vnet.ibm.com>
In-Reply-To: <4EC6250F.4010501@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 11111809-5564-0000-0000-000000286D59
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2011 02:57 PM, Srivatsa S. Bhat wrote:
> On 11/18/2011 02:50 PM, Rafael J. Wysocki wrote:
>>> diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
>>> index b4511b6..257e8e7 100644
>>> --- a/kernel/power/hibernate.c
>>> +++ b/kernel/power/hibernate.c
>>> @@ -55,6 +55,8 @@ enum {
>>>  
>>>  static int hibernation_mode = HIBERNATION_SHUTDOWN;
>>>  
>>> +static bool freezer_test_done;
>>> +
>>>  static const struct platform_hibernation_ops *hibernation_ops;
>>>  
>>>  /**
>>> @@ -347,6 +349,17 @@ int hibernation_snapshot(int platform_mode)
>>>  	if (error)
>>>  		goto Close;
>>>  
>>> +	if (hibernation_test(TEST_FREEZER) ||
>>> +		hibernation_testmode(HIBERNATION_TESTPROC)) {
>>> +
>>> +		/*
>>> +		 * Indicate to the caller that we are returning due to a
>>> +		 * successful freezer test.
>>> +		 */
>>> +		freezer_test_done = true;
>>> +		goto Close;
>>> +	}
>>> +
>>>  	error = dpm_prepare(PMSG_FREEZE);
>>>  	if (error)
>>>  		goto Complete_devices;
>>> @@ -641,15 +654,13 @@ int hibernate(void)
>>>  	if (error)
>>>  		goto Finish;
>>>  
>>> -	if (hibernation_test(TEST_FREEZER))
>>> -		goto Thaw;
>>> -
>>> -	if (hibernation_testmode(HIBERNATION_TESTPROC))
>>> -		goto Thaw;
>>> -
>>>  	error = hibernation_snapshot(hibernation_mode == HIBERNATION_PLATFORM);
>>>  	if (error)
>>>  		goto Thaw;
>>> +	if (freezer_test_done) {
>>> +		freezer_test_done = false;
>>> +		goto Thaw;
>>> +	}
>>
>> What happens if hibernation_snapshot() and freezer_test_done is 'true'?
>> Won't that leek freezer_test_done to the next hibernation cycle?
>>
> 
> Oh yes, thanks for catching that! I'll fix that and send an updated patch.
>

Sorry, I think I hit reply too soon.
To restate your question, you are asking if freezer_test_done was set in
hibernation_snapshot() and then there was a genuine error in
hibernation_snapshot() which it returned, then won't freezer_test_done
leak to the next cycle.., right?

If there is a genuine error before hibernation_test(TEST_FREEZER)... is
done, then we will never set freezer_test_done flag to true.

And whenever freezer_test_done is set (inside hibernation_snapshot) there
is no way it will continue further executing normal code. It will jump to
the Close label and come out, so that here in hibernate(), the first
check for error will fail (because it returned 0) and the subsequent
check for freezer_test_done will succeed. So I don't see how it can leak.

Or, am I missing something?

Thanks,
Srivatsa S. Bhat

