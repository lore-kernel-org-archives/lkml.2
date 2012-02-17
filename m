Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754968Ab2BQWse (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 17:48:34 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:58765 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753027Ab2BQWsd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 17:48:33 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: Re: [PATCH] PM/Hibernate: Enable usermodehelpers in hibernate() error path
Date: Fri, 17 Feb 2012 23:52:28 +0100
User-Agent: KMail/1.13.6 (Linux/3.3.0-rc3+; KDE/4.6.0; x86_64; ; )
Cc: pavel@ucw.cz, len.brown@intel.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20120216122243.14749.34988.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20120216122243.14749.34988.stgit@srivatsabhat.in.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201202172352.28478.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, February 16, 2012, Srivatsa S. Bhat wrote:
> If create_basic_memory_bitmaps() fails, usermodehelpers are not re-enabled
> before returning. Fix this. And while at it, reword the goto labels so that
> they look more meaningful.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

Applied, thanks for catching this!

Rafael


> ---
> 
>  kernel/power/hibernate.c |    7 ++++---
>  1 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
> index 72baaf0..0a186cf 100644
> --- a/kernel/power/hibernate.c
> +++ b/kernel/power/hibernate.c
> @@ -618,7 +618,7 @@ int hibernate(void)
>  	/* Allocate memory management structures */
>  	error = create_basic_memory_bitmaps();
>  	if (error)
> -		goto Exit;
> +		goto Enable_umh;
>  
>  	printk(KERN_INFO "PM: Syncing filesystems ... ");
>  	sys_sync();
> @@ -626,7 +626,7 @@ int hibernate(void)
>  
>  	error = freeze_processes();
>  	if (error)
> -		goto Finish;
> +		goto Free_bitmaps;
>  
>  	error = hibernation_snapshot(hibernation_mode == HIBERNATION_PLATFORM);
>  	if (error || freezer_test_done)
> @@ -659,8 +659,9 @@ int hibernate(void)
>  	/* Don't bother checking whether freezer_test_done is true */
>  	freezer_test_done = false;
>  
> - Finish:
> + Free_bitmaps:
>  	free_basic_memory_bitmaps();
> + Enable_umh:
>  	usermodehelper_enable();
>   Exit:
>  	pm_notifier_call_chain(PM_POST_HIBERNATION);
> 
> 
> 

