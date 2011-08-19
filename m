Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754363Ab1HSVNP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 17:13:15 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:53654 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752686Ab1HSVNO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 17:13:14 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 07/16] freezer: don't distinguish nosig tasks on thaw
Date: Fri, 19 Aug 2011 23:14:52 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc2+; KDE/4.6.0; x86_64; ; )
Cc: menage@google.com, linux-kernel@vger.kernel.org, arnd@arndb.de,
        oleg@redhat.com,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>
References: <1313763382-12341-1-git-send-email-tj@kernel.org> <1313763382-12341-8-git-send-email-tj@kernel.org>
In-Reply-To: <1313763382-12341-8-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201108192314.53010.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, August 19, 2011, Tejun Heo wrote:
> There's no point in thawing nosig tasks before others.  There's no
> ordering requirement between the two groups on thaw, which the staged
> thawing can't guarantee anyway.  Simplify thaw_processes() by removing
> the distinction and collapsing thaw_tasks() into thaw_processes().
> This will help further updates to freezer.

I'm not sure if I like this patch.

Right now there are no ordering requirements between the two groups
of processes, but if we decide to freeze filesystems on suspend,
we'll need to thaw them between nosig and sig I suppose.

Thanks,
Rafael


> Signed-off-by: Tejun Heo <tj@kernel.org>
> ---
>  kernel/power/process.c |   20 +++++++-------------
>  1 files changed, 7 insertions(+), 13 deletions(-)
> 
> diff --git a/kernel/power/process.c b/kernel/power/process.c
> index ddfaba4..3eee548 100644
> --- a/kernel/power/process.c
> +++ b/kernel/power/process.c
> @@ -160,34 +160,28 @@ int freeze_processes(void)
>  	return error;
>  }
>  
> -static void thaw_tasks(bool nosig_only)
> +void thaw_processes(void)
>  {
>  	struct task_struct *g, *p;
>  
> +	oom_killer_enable();
> +
> +	printk("Restarting tasks ... ");
> +
> +	thaw_workqueues();
> +
>  	read_lock(&tasklist_lock);
>  	do_each_thread(g, p) {
>  		if (!freezable(p))
>  			continue;
>  
> -		if (nosig_only && should_send_signal(p))
> -			continue;
> -
>  		if (cgroup_freezing_or_frozen(p))
>  			continue;
>  
>  		__thaw_task(p);
>  	} while_each_thread(g, p);
>  	read_unlock(&tasklist_lock);
> -}
> -
> -void thaw_processes(void)
> -{
> -	oom_killer_enable();
>  
> -	printk("Restarting tasks ... ");
> -	thaw_workqueues();
> -	thaw_tasks(true);
> -	thaw_tasks(false);
>  	schedule();
>  	printk("done.\n");
>  }
> 

