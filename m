Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464Ab1KVTGs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 14:06:48 -0500
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:46695 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752360Ab1KVTGq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 14:06:46 -0500
Message-ID: <4ECBF271.3040308@linux.vnet.ibm.com>
Date: Wed, 23 Nov 2011 00:35:21 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, len.brown@intel.com, tj@kernel.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH] PM / Hibernation: Fix *massive* memory leak at early
 exits in hibernation
References: <20111121173939.9486.38357.stgit@srivatsabhat.in.ibm.com> <201111212325.39330.rjw@sisk.pl> <20111122114549.GC32023@elf.ucw.cz>
In-Reply-To: <20111122114549.GC32023@elf.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 11112219-5816-0000-0000-000000271EDC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/22/2011 05:15 PM, Pavel Machek wrote:
> On Mon 2011-11-21 23:25:39, Rafael J. Wysocki wrote:
>> On Monday, November 21, 2011, Srivatsa S. Bhat wrote:
>>> At some of the early exit points during hibernation (exiting either due
>>> to failure or after a successful hibernation test, the memory pre-allocated
>>> for hibernation is not freed up. And this is *very* serious, because, during
>>> pre-allocation, it could have allocated upto a few *gigabytes* of memory!
>>> And hence, if a hibernation fails or even if we run some hibernation tests
>>> using the 'pm_test' framework, the system is rendered unstable due to memory
>>> becoming signifantly lower. Fix this bug.
>>
>> While the observation is valid, I'd prefer to do something like the patch
>> below.
> 
> The code slowly becomes goto maze :-(.
> 

I agree.. It is already quite a mess.

>> @@ -357,12 +357,14 @@ int hibernation_snapshot(int platform_mo
>>  		 * successful freezer test.
>>  		 */
>>  		freezer_test_done = true;
>> -		goto Close;
>> +		goto Cleanup;
>>  	}
>>  
>>  	error = dpm_prepare(PMSG_FREEZE);
>> -	if (error)
>> -		goto Complete_devices;
>> +	if (error) {
>> +		dpm_complete(msg);
>> +		goto Cleanup;
>> +	}
> 
> Perhaps dpm_prepare should be changed to clean after itself in the
> error case? That is the normal convention AFAICT....
> 

If the intention here is to merely clean up hibernation_snapshot() code,
I would not prefer to change the behaviour of dpm_prepare(), considering
things like, what parameter should we pass to dpm_complete(); is the
resultant behaviour change in dpm_suspend_start() correct or not; what
happens to all the code that uses the nice pair: dpm_suspend_start() and
dpm_resume_end() and so on.

Perhaps there are bigger issues involved there, since I observed on a brief
look that the current code doesn't seem to strictly follow the above
convention that whoever called dpm_prepare() should call dpm_complete()
upon failure. Or may be its doing the right thing.. I don't know.

But anyway, the good news is, even without changing dpm_prepare()'s
behaviour, we can clean up quite a bit of code in hibernation_snapshot(),
as it is.

The first patch below does the cleanup, the second patch fixes the memory
leak and applies on top of the first patch.

---
From: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Subject: PM / Hibernation: Refactor and simplify hibernation_snapshot() code

The goto statements in hibernation_snapshot() are a bit complex.
Refactor the code to remove some of them, thereby simplifying the
implementation.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 kernel/power/hibernate.c |   28 ++++++++++++----------------
 1 files changed, 12 insertions(+), 16 deletions(-)

diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
index 196c0126..fe7e83e 100644
--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -333,7 +333,7 @@ static int create_image(int platform_mode)
  */
 int hibernation_snapshot(int platform_mode)
 {
-	pm_message_t msg = PMSG_RECOVER;
+	pm_message_t msg;
 	int error;
 
 	error = platform_begin(platform_mode);
@@ -361,25 +361,27 @@ int hibernation_snapshot(int platform_mode)
 	}
 
 	error = dpm_prepare(PMSG_FREEZE);
-	if (error)
-		goto Complete_devices;
+	if (error) {
+		dpm_complete(PMSG_RECOVER);
+		goto Close;
+	}
 
 	suspend_console();
 	pm_restrict_gfp_mask();
+
 	error = dpm_suspend(PMSG_FREEZE);
-	if (error)
-		goto Recover_platform;
 
-	if (hibernation_test(TEST_DEVICES))
-		goto Recover_platform;
+	if (error || hibernation_test(TEST_DEVICES))
+		platform_recover(platform_mode);
+	else
+		error = create_image(platform_mode);
 
-	error = create_image(platform_mode);
 	/*
-	 * Control returns here (1) after the image has been created or the
+	 * In the case that we call create_image() above, the control
+	 * returns here (1) after the image has been created or the
 	 * image creation has failed and (2) after a successful restore.
 	 */
 
- Resume_devices:
 	/* We may need to release the preallocated image pages here. */
 	if (error || !in_suspend)
 		swsusp_free();
@@ -392,16 +394,10 @@ int hibernation_snapshot(int platform_mode)
 
 	resume_console();
 
- Complete_devices:
-	dpm_complete(msg);
-
  Close:
 	platform_end(platform_mode);
 	return error;
 
- Recover_platform:
-	platform_recover(platform_mode);
-	goto Resume_devices;
 }
 
 /**



==============================================
The second patch:

---
From: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Subject: PM / Hibernation: Fix memory leak in hibernation at error/test paths

At some points in the hibernation code, if we exit early either due to an
error or a successful hibernation test, the memory pre-allocated for
hibernation is not freed up, which might be quite significant. Fix this
memory leak.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 kernel/power/hibernate.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
index fe7e83e..7aea7e5 100644
--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -347,7 +347,7 @@ int hibernation_snapshot(int platform_mode)
 
 	error = freeze_kernel_threads();
 	if (error)
-		goto Close;
+		goto Free_mem;
 
 	if (hibernation_test(TEST_FREEZER) ||
 		hibernation_testmode(HIBERNATION_TESTPROC)) {
@@ -357,13 +357,13 @@ int hibernation_snapshot(int platform_mode)
 		 * successful freezer test.
 		 */
 		freezer_test_done = true;
-		goto Close;
+		goto Free_mem;
 	}
 
 	error = dpm_prepare(PMSG_FREEZE);
 	if (error) {
 		dpm_complete(PMSG_RECOVER);
-		goto Close;
+		goto Free_mem;
 	}
 
 	suspend_console();
@@ -398,6 +398,9 @@ int hibernation_snapshot(int platform_mode)
 	platform_end(platform_mode);
 	return error;
 
+ Free_mem:
+	swsusp_free();
+	goto Close;
 }
 
 /**


