Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752650Ab1FRUnz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jun 2011 16:43:55 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38956 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752226Ab1FRUnx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jun 2011 16:43:53 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Michal Kubecek <mkubecek@suse.cz>
Subject: Re: [linux-pm] [PATCH 3.0-rc3] PM: free memory bitmaps if opening /dev/snapshot fails
Date: Sat, 18 Jun 2011 22:44:36 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc3+; KDE/4.6.0; x86_64; ; )
Cc: linux-pm@lists.linux-foundation.org, LKML <linux-kernel@vger.kernel.org>
References: <20110617175231.A80284030A@alaris.suse.cz>
In-Reply-To: <20110617175231.A80284030A@alaris.suse.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106182244.36876.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, June 17, 2011, Michal Kubecek wrote:
> From: Michal Kubecek <mkubecek@suse.cz>
> 
> When opening /dev/snapshot device, snapshot_open() creates memory
> bitmaps which are freed in snapshot_release(). But if any of the
> callbacks called by pm_notifier_call_chain() returns NOTIFY_BAD, open()
> fails, snapshot_release() is never called and bitmaps are not freed.
> Next attempt to open /dev/snapshot then triggers BUG_ON() check in
> create_basic_memory_bitmaps(). This happens e.g. when vmwatchdog module
> is active on s390x.
> 
> Signed-off-by: Michal Kubecek <mkubecek@suse.cz>

Thanks, I'm going to push your patch for 3.0 + stable.

Rafael


> --- 
> 
> diff --git a/kernel/power/user.c b/kernel/power/user.c
> index 7d02d33..42ddbc6 100644
> --- a/kernel/power/user.c
> +++ b/kernel/power/user.c
> @@ -113,8 +113,10 @@ static int snapshot_open(struct inode *inode, struct file *filp)
>  		if (error)
>  			pm_notifier_call_chain(PM_POST_RESTORE);
>  	}
> -	if (error)
> +	if (error) {
> +		free_basic_memory_bitmaps();
>  		atomic_inc(&snapshot_device_available);
> +	}
>  	data->frozen = 0;
>  	data->ready = 0;
>  	data->platform_support = 0;
> _______________________________________________
> linux-pm mailing list
> linux-pm@lists.linux-foundation.org
> https://lists.linux-foundation.org/mailman/listinfo/linux-pm
> 
> 

