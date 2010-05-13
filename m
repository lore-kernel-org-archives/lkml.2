Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759624Ab0EMW5m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 18:57:42 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51249 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759585Ab0EMW53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 18:57:29 -0400
Date: Thu, 13 May 2010 15:56:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiri Slaby <jslaby@suse.cz>
Cc: adobriyan@gmail.com, nhorman@tuxdriver.com, oleg@redhat.com,
       linux-kernel@vger.kernel.org, jirislaby@gmail.com,
       Heiko Carstens <heiko.carstens@de.ibm.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH v3 06/11] rlimits: do security check under task_lock
Message-Id: <20100513155626.8d1fe293.akpm@linux-foundation.org>
In-Reply-To: <1273514451-28894-6-git-send-email-jslaby@suse.cz>
References: <1273514451-28894-1-git-send-email-jslaby@suse.cz>
	<1273514451-28894-6-git-send-email-jslaby@suse.cz>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 May 2010 20:00:46 +0200
Jiri Slaby <jslaby@suse.cz> wrote:

> Do security_task_setrlimit under task_lock. Other tasks may
> change limits under our hands while we are checking limits
> inside the function. From now on, they can't.
>
> ...
>
> --- a/kernel/sys.c
> +++ b/kernel/sys.c
> @@ -1277,7 +1277,7 @@ int do_setrlimit(struct task_struct *tsk, unsigned int resource,
>  		struct rlimit *new_rlim)
>  {
>  	struct rlimit *old_rlim;
> -	int retval;
> +	int retval = 0;
>  
>  	if (resource >= RLIM_NLIMITS)
>  		return -EINVAL;
> @@ -1293,10 +1293,6 @@ int do_setrlimit(struct task_struct *tsk, unsigned int resource,
>  		goto out;
>  	}
>  
> -	retval = security_task_setrlimit(tsk, resource, new_rlim);
> -	if (retval)
> -		goto out;
> -
>  	if (resource == RLIMIT_CPU && new_rlim->rlim_cur == 0) {
>  		/*
>  		 * The caller is asking for an immediate RLIMIT_CPU
> @@ -1309,11 +1305,13 @@ int do_setrlimit(struct task_struct *tsk, unsigned int resource,
>  
>  	old_rlim = tsk->signal->rlim + resource;
>  	task_lock(tsk->group_leader);
> -	if ((new_rlim->rlim_max <= old_rlim->rlim_max) ||
> -				capable(CAP_SYS_RESOURCE))
> -		*old_rlim = *new_rlim;
> -	else
> +	if ((new_rlim->rlim_max > old_rlim->rlim_max) &&
> +				!capable(CAP_SYS_RESOURCE))
>  		retval = -EPERM;
> +	if (!retval)
> +		retval = security_task_setrlimit(tsk, resource, new_rlim);
> +	if (!retval)
> +		*old_rlim = *new_rlim;
>  	task_unlock(tsk->group_leader);
>  
>  	if (retval || resource != RLIMIT_CPU)

Yikes, so the locking around all that selinux code becomes even more
brutal.  How much rope are you tying around the selinux developers'
hands here?


