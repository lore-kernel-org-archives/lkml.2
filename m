Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758368Ab2DFXh7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 19:37:59 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63567 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752848Ab2DFXh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 19:37:58 -0400
Date: Fri, 6 Apr 2012 16:37:55 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Thomas Gleixner <tglx@linutronix.de>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT pull] timer updates for 3.4-rc
In-Reply-To: <alpine.LFD.2.02.1204070131010.2542@ionos>
Message-ID: <alpine.DEB.2.00.1204061636260.32765@chino.kir.corp.google.com>
References: <alpine.LFD.2.02.1204070131010.2542@ionos>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 7 Apr 2012, Thomas Gleixner wrote:

> diff --git a/kernel/itimer.c b/kernel/itimer.c
> index 22000c3..c70369a 100644
> --- a/kernel/itimer.c
> +++ b/kernel/itimer.c
> @@ -284,8 +284,11 @@ SYSCALL_DEFINE3(setitimer, int, which, struct itimerval __user *, value,
>  	if (value) {
>  		if(copy_from_user(&set_buffer, value, sizeof(set_buffer)))
>  			return -EFAULT;
> -	} else
> +	} else {
>  		memset((char *) &set_buffer, 0, sizeof(set_buffer));
> +		WARN_ONCE(1, "setitimer: new_value pointer is NULL."
> +			  " Misfeature support will be removed\n");
> +	}
>  
>  	error = do_setitimer(which, &set_buffer, ovalue ? &get_buffer : NULL);
>  	if (error || !ovalue)

When I tried doing this for the deprecated /proc/pid/oom_adj there was a 
complaint that WARN_ONCE() screws up log parsing scripts that think there 
is a kernel issue so I had to change it to printk_once() and include 
get_task_comm(current) and current->pid.  See
http://lkml.indiana.edu/hypermail/linux/kernel/1108.0/00446.html
