Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758651Ab2EIIeJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 04:34:09 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:39529 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720Ab2EIIeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 04:34:05 -0400
Message-ID: <4FAA2673.50007@linux.vnet.ibm.com>
Date: Wed, 09 May 2012 13:40:27 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120424 Thunderbird/12.0
MIME-Version: 1.0
To: Bojan Smojver <bojan@rexursive.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM list <linux-pm@vger.kernel.org>, linux-kernel@vger.kernel.org,
        bp@alien8.de
Subject: Re: [PATCH]: In kernel hibernation, suspend to both
References: <1336515735.2097.23.camel@shrek.rexursive.com>
In-Reply-To: <1336515735.2097.23.camel@shrek.rexursive.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12050822-0260-0000-0000-0000010A3842
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/09/2012 03:52 AM, Bojan Smojver wrote:

> Hi Rafael,
> 
> Here is the same thing, this time with signed off. Looks like all the
> memory used for hibernation is being released before power_down(), so I
> guess we should be good. The patch is against linux-next.
> 
> ------------------------------
> Enable suspend to both for in-kernel hibernation.
> 
> It is often useful to suspend to memory after hibernation image has been
> written to disk. If the battery runs out or power is otherwise lost, the
> computer will resume from the hibernated image. If not, it will resume
> from memory and hibernation image will be discarded.
> 
> Signed-off-by: Bojan Smojver <bojan@rexursive.com>
> ---
>  Documentation/power/swsusp.txt |    5 +++++
>  kernel/power/hibernate.c       |   36 ++++++++++++++++++++++++++++++++++++
>  kernel/power/power.h           |    3 +++
>  kernel/power/swap.c            |   28 ++++++++++++++++++++++++++++
>  4 files changed, 72 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/power/swsusp.txt b/Documentation/power/swsusp.txt
> index ac190cf..92341b8 100644
> --- a/Documentation/power/swsusp.txt
> +++ b/Documentation/power/swsusp.txt
> @@ -33,6 +33,11 @@ echo shutdown > /sys/power/disk; echo disk > /sys/power/state
> 
>  echo platform > /sys/power/disk; echo disk > /sys/power/state
> 
> +. If you would like to write hibernation image to swap and then suspend
> +to RAM (provided your platform supports it), you can try
> +
> +echo suspend > /sys/power/disk; echo disk > /sys/power/state
> +
>  . If you have SATA disks, you'll need recent kernels with SATA suspend
>  support. For suspend and resume to work, make sure your disk drivers
>  are built into kernel -- not modules. [There's way to make
> diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
> index e09dfbf..3b5726f 100644
> --- a/kernel/power/hibernate.c
> +++ b/kernel/power/hibernate.c
> @@ -5,6 +5,7 @@
>   * Copyright (c) 2003 Open Source Development Lab
>   * Copyright (c) 2004 Pavel Machek <pavel@ucw.cz>
>   * Copyright (c) 2009 Rafael J. Wysocki, Novell Inc.
> + * Copyright (C) 2012 Bojan Smojver <bojan@rexursive.com>
>   *
>   * This file is released under the GPLv2.
>   */
> @@ -44,6 +45,9 @@ enum {
>  	HIBERNATION_PLATFORM,
>  	HIBERNATION_SHUTDOWN,
>  	HIBERNATION_REBOOT,
> +#ifdef CONFIG_SUSPEND
> +	HIBERNATION_SUSPEND,
> +#endif
>  	/* keep last */
>  	__HIBERNATION_AFTER_LAST
>  };
> @@ -572,6 +576,10 @@ int hibernation_platform_enter(void)
>   */
>  static void power_down(void)
>  {
> +#ifdef CONFIG_SUSPEND
> +	int error;
> +#endif
> +
>  	switch (hibernation_mode) {
>  	case HIBERNATION_REBOOT:
>  		kernel_restart(NULL);
> @@ -581,6 +589,25 @@ static void power_down(void)
>  	case HIBERNATION_SHUTDOWN:
>  		kernel_power_off();
>  		break;
> +#ifdef CONFIG_SUSPEND
> +	case HIBERNATION_SUSPEND:
> +		error = suspend_devices_and_enter(PM_SUSPEND_MEM);


I can imagine running into a host of problems here, since the suspend
sequence is not carried out fully, from the beginning.

For example, this will skip sending out the PM_SUSPEND_PREPARE and the
PM_POST_SUSPEND notifiers. Worse, we actually send out the PM_HIBERNATION_PREPARE
and PM_POST_HIBERNATION notifiers and then do a suspend instead, underneath!

(Similar cases for the rest of the notifiers sent during suspend vs hibernation).

Don't we need to handle such things properly, in order to make suspend-to-both
work reliably?

Regards,
Srivatsa S. Bhat

> +		if (error) {
> +			if (hibernation_ops)
> +				hibernation_mode = HIBERNATION_PLATFORM;
> +			else
> +				hibernation_mode = HIBERNATION_SHUTDOWN;
> +			power_down();
> +		}
> +		/*
> +		 * Restore swap signature.
> +		 */
> +		error = swsusp_unmark();
> +		if (error)
> +			printk(KERN_ERR "PM: Swap will be unusable! "
> +			                "Try swapon -a.\n");
> +		return;
> +#endif

>  	}

>  	kernel_halt();
>  	/*


