Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756701Ab1KRJSF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 04:18:05 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:45308 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753309Ab1KRJSA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 04:18:00 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: Re: [PATCH v2] PM/Hibernation: Fix the early termination of test modes
Date: Fri, 18 Nov 2011 10:20:43 +0100
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc10+; KDE/4.6.0; x86_64; ; )
Cc: len.brown@intel.com, pavel@ucw.cz, rdunlap@xenotime.net, tj@kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
References: <20111118031623.32591.73677.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20111118031623.32591.73677.stgit@srivatsabhat.in.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201111181020.44167.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, November 18, 2011, Srivatsa S. Bhat wrote:
> Commit 2aede851ddf08666f68ffc17be446420e9d2a056
> (PM / Hibernate: Freeze kernel threads after preallocating memory)
> postponed the freezing of kernel threads to after preallocating memory
> for hibernation. But while doing that, the hibernation test TEST_FREEZER
> and the test mode HIBERNATION_TESTPROC were not moved accordingly.
> 
> As a result, when using these test modes, it only goes upto the freezing of
> userspace and exits, when in fact it should go till the complete end of task
> freezing stage, namely the freezing of kernel threads as well.
> 
> So, move these points of exit to appropriate places so that freezing of
> kernel threads is also tested while using these test harnesses. And while at
> it, add some documentation about these test modes.
> 
> v2: Changed 'freezer_test_done' flag from int to bool.
> 
> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

On a second thought I'm not sure about the documentation changes.
In fact, the "test" and "testproc" modes are deprecated and I was going to
remove them some time this year.  That's why they weren't documented
(i.e. intentionally) and it's better to keep it that way IMO.

> ---
> 
>  Documentation/power/basic-pm-debugging.txt |   16 ++++++++++++----
>  kernel/power/hibernate.c                   |   28 ++++++++++++++++++++++------
>  2 files changed, 34 insertions(+), 10 deletions(-)
> 
> diff --git a/Documentation/power/basic-pm-debugging.txt b/Documentation/power/basic-pm-debugging.txt
> index 40a4c65..ba6c879 100644
> --- a/Documentation/power/basic-pm-debugging.txt
> +++ b/Documentation/power/basic-pm-debugging.txt
> @@ -38,10 +38,18 @@ identify what goes wrong.
>  
>  a) Test modes of hibernation
>  
> -To find out why hibernation fails on your system, you can use a special testing
> -facility available if the kernel is compiled with CONFIG_PM_DEBUG set.  Then,
> -there is the file /sys/power/pm_test that can be used to make the hibernation
> -core run in a test mode.  There are 5 test modes available:
> +To find out why hibernation fails on your system, you can use some special
> +testing facilities available if the kernel is compiled with CONFIG_PM_DEBUG set.
> +Hibernation will then have 2 more modes that can be used, namely "testproc" and
> +"test". When the "testproc" mode is used, it executes everything upto the task
> +freezing phase and reverts back. When the "test" mode is used, it goes much
> +deeper down, stopping just short of actually hibernating the machine, and then
> +reverts back to normal state.
> +
> +However, there is an even more fine-grained debugging tool, also enabled by
> +setting CONFIG_PM_DEBUG: there appears a file /sys/power/pm_test that can be
> +used to make the hibernation core run in a test mode.
> +There are 5 test modes available:
>  
>  freezer
>  - test the freezing of processes
> diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
> index b4511b6..257e8e7 100644
> --- a/kernel/power/hibernate.c
> +++ b/kernel/power/hibernate.c
> @@ -55,6 +55,8 @@ enum {
>  
>  static int hibernation_mode = HIBERNATION_SHUTDOWN;
>  
> +static bool freezer_test_done;
> +
>  static const struct platform_hibernation_ops *hibernation_ops;
>  
>  /**
> @@ -347,6 +349,17 @@ int hibernation_snapshot(int platform_mode)
>  	if (error)
>  		goto Close;
>  
> +	if (hibernation_test(TEST_FREEZER) ||
> +		hibernation_testmode(HIBERNATION_TESTPROC)) {
> +
> +		/*
> +		 * Indicate to the caller that we are returning due to a
> +		 * successful freezer test.
> +		 */
> +		freezer_test_done = true;
> +		goto Close;
> +	}
> +
>  	error = dpm_prepare(PMSG_FREEZE);
>  	if (error)
>  		goto Complete_devices;
> @@ -641,15 +654,13 @@ int hibernate(void)
>  	if (error)
>  		goto Finish;
>  
> -	if (hibernation_test(TEST_FREEZER))
> -		goto Thaw;
> -
> -	if (hibernation_testmode(HIBERNATION_TESTPROC))
> -		goto Thaw;
> -
>  	error = hibernation_snapshot(hibernation_mode == HIBERNATION_PLATFORM);
>  	if (error)
>  		goto Thaw;
> +	if (freezer_test_done) {
> +		freezer_test_done = false;
> +		goto Thaw;
> +	}

What happens if hibernation_snapshot() and freezer_test_done is 'true'?
Won't that leek freezer_test_done to the next hibernation cycle?

>  
>  	if (in_suspend) {
>  		unsigned int flags = 0;
> @@ -864,6 +875,11 @@ static const char * const hibernation_modes[] = {
>   *
>   * If a platform hibernation driver is in use, 'platform' will be supported
>   * and will be used by default.  Otherwise, 'shutdown' will be used by default.
> + * The 2 test modes are useful only when CONFIG_PM_DEBUG is set. In that case,
> + * using the 'testproc' mode will do everything upto the freezing of tasks
> + * and exits after undoing all that it did. The 'test' mode is deeper, in that,
> + * it does everything except actually hibernating the machine and exits after
> + * restoring the machine back to its original state.
>   * The selected option (i.e. the one corresponding to the current value of
>   * hibernation_mode) is enclosed by a square bracket.
>   *

Thanks,
Rafael
