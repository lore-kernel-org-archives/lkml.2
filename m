Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933555Ab2BBUBY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 15:01:24 -0500
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:34703 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753368Ab2BBUBW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 15:01:22 -0500
Message-ID: <4F2AEB87.70908@linux.vnet.ibm.com>
Date: Fri, 03 Feb 2012 01:31:11 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: pavel@ucw.cz, len.brown@intel.com, tj@kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PM/Hibernate: Thaw kernel threads in hibernation_snapshot()
 in error/test path
References: <20120202003359.9930.9844.stgit@srivatsabhat.in.ibm.com> <201202022011.55493.rjw@sisk.pl>
In-Reply-To: <201202022011.55493.rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12020220-5816-0000-0000-000001224E81
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/03/2012 12:41 AM, Rafael J. Wysocki wrote:

> On Thursday, February 02, 2012, Srivatsa S. Bhat wrote:
>> In the hibernation call path, the kernel threads are frozen inside
>> hibernation_snapshot(). If we happen to encounter an error further down
>> the road or if we are exiting early due to a successful freezer test,
>> then thaw kernel threads before returning to the caller.
>>
>> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
>> ---
>>
>>  kernel/power/hibernate.c |    6 ++++--
>>  kernel/power/user.c      |    8 ++------
>>  2 files changed, 6 insertions(+), 8 deletions(-)
>>
>> diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
>> index a5d4cf0..c6dee73 100644
>> --- a/kernel/power/hibernate.c
>> +++ b/kernel/power/hibernate.c
>> @@ -343,13 +343,13 @@ int hibernation_snapshot(int platform_mode)
>>  		 * successful freezer test.
>>  		 */
>>  		freezer_test_done = true;
>> -		goto Cleanup;
>> +		goto Thaw;
>>  	}
>>  
>>  	error = dpm_prepare(PMSG_FREEZE);
>>  	if (error) {
>>  		dpm_complete(PMSG_RECOVER);
>> -		goto Cleanup;
>> +		goto Thaw;
>>  	}
>>  
>>  	suspend_console();
>> @@ -385,6 +385,8 @@ int hibernation_snapshot(int platform_mode)
>>  	platform_end(platform_mode);
>>  	return error;
>>  
>> + Thaw:
>> +	thaw_kernel_threads();
> 
> Actaully, no.  You have to do swsusp_free() before thawing, otherwise
> some allocations made by the just thawed kernel threads may fail.
> 


But then what about the case (in the existing code) when
freeze_kernel_threads() fails? It would first thaw kernel threads (in
fact it used to thaw even userspace tasks earlier!) before calling
swsusp_free(). So, the existing code itself seems to be brittle, considering
the point you raised. Right?

>>   Cleanup:
>>  	swsusp_free();
>>  	goto Close;
>> diff --git a/kernel/power/user.c b/kernel/power/user.c
>> index 3e10007..7bee91f 100644
>> --- a/kernel/power/user.c
>> +++ b/kernel/power/user.c
>> @@ -249,16 +249,12 @@ static long snapshot_ioctl(struct file *filp, unsigned int cmd,
>>  		}
>>  		pm_restore_gfp_mask();
>>  		error = hibernation_snapshot(data->platform_support);
>> -		if (error) {
>> -			thaw_kernel_threads();
>> -		} else {
>> +		if (!error) {
>>  			error = put_user(in_suspend, (int __user *)arg);
>>  			if (!error && !freezer_test_done)
>>  				data->ready = 1;
>> -			if (freezer_test_done) {
>> +			if (freezer_test_done)
>>  				freezer_test_done = false;
>> -				thaw_kernel_threads();
>> -			}
>>  		}
>>  		break;
> 
> Overall, this seems to be a cleanup, or is it a bug fix?
> 


This was intended as a cleanup only, not a bug fix. But now, (see my point
above), I am beginning to feel that the existing code itself is not robust
enough...
 
Regards,
Srivatsa S. Bhat

