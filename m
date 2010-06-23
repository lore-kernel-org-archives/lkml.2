Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753742Ab0FWX7Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 19:59:24 -0400
Received: from tundra.namei.org ([65.99.196.166]:41836 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751751Ab0FWX7X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 19:59:23 -0400
Date: Thu, 24 Jun 2010 09:58:45 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Jiri Slaby <jslaby@suse.cz>
cc: jirislaby@gmail.com, Oleg Nesterov <oleg@redhat.com>,
       akpm@linux-foundation.org, adobriyan@gmail.com, nhorman@tuxdriver.com,
       Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@parisplace.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 01/12] rlimits: security, add task_struct to
 setrlimit
In-Reply-To: <1277329933-8139-1-git-send-email-jslaby@suse.cz>
Message-ID: <alpine.LRH.2.00.1006240957350.1601@tundra.namei.org>
References: <1277329933-8139-1-git-send-email-jslaby@suse.cz>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Jun 2010, Jiri Slaby wrote:

> From: Jiri Slaby <jirislaby@gmail.com>
> 
> Add task_struct to task_setrlimit of security_operations to be able to set
> rlimit of task other than current.

Given the scope of the changes, I'm not sure which tree these should go 
into.  They affect the security API, so possibly mine.


> 
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> Acked-by: Eric Paris <eparis@redhat.com>
> Acked-by: James Morris <jmorris@namei.org>
> ---
>  include/linux/security.h |    9 ++++++---
>  kernel/sys.c             |    2 +-
>  security/capability.c    |    3 ++-
>  security/security.c      |    5 +++--
>  security/selinux/hooks.c |    7 ++++---
>  5 files changed, 16 insertions(+), 10 deletions(-)
> 
> diff --git a/include/linux/security.h b/include/linux/security.h
> index 5bcb395..a22219a 100644
> --- a/include/linux/security.h
> +++ b/include/linux/security.h
> @@ -1499,7 +1499,8 @@ struct security_operations {
>  	int (*task_setnice) (struct task_struct *p, int nice);
>  	int (*task_setioprio) (struct task_struct *p, int ioprio);
>  	int (*task_getioprio) (struct task_struct *p);
> -	int (*task_setrlimit) (unsigned int resource, struct rlimit *new_rlim);
> +	int (*task_setrlimit) (struct task_struct *p, unsigned int resource,
> +			struct rlimit *new_rlim);
>  	int (*task_setscheduler) (struct task_struct *p, int policy,
>  				  struct sched_param *lp);
>  	int (*task_getscheduler) (struct task_struct *p);
> @@ -1749,7 +1750,8 @@ void security_task_getsecid(struct task_struct *p, u32 *secid);
>  int security_task_setnice(struct task_struct *p, int nice);
>  int security_task_setioprio(struct task_struct *p, int ioprio);
>  int security_task_getioprio(struct task_struct *p);
> -int security_task_setrlimit(unsigned int resource, struct rlimit *new_rlim);
> +int security_task_setrlimit(struct task_struct *p, unsigned int resource,
> +		struct rlimit *new_rlim);
>  int security_task_setscheduler(struct task_struct *p,
>  				int policy, struct sched_param *lp);
>  int security_task_getscheduler(struct task_struct *p);
> @@ -2311,7 +2313,8 @@ static inline int security_task_getioprio(struct task_struct *p)
>  	return 0;
>  }
>  
> -static inline int security_task_setrlimit(unsigned int resource,
> +static inline int security_task_setrlimit(struct task_struct *p,
> +					  unsigned int resource,
>  					  struct rlimit *new_rlim)
>  {
>  	return 0;
> diff --git a/kernel/sys.c b/kernel/sys.c
> index e83ddbb..1ba4522 100644
> --- a/kernel/sys.c
> +++ b/kernel/sys.c
> @@ -1290,7 +1290,7 @@ SYSCALL_DEFINE2(setrlimit, unsigned int, resource, struct rlimit __user *, rlim)
>  	if (resource == RLIMIT_NOFILE && new_rlim.rlim_max > sysctl_nr_open)
>  		return -EPERM;
>  
> -	retval = security_task_setrlimit(resource, &new_rlim);
> +	retval = security_task_setrlimit(current, resource, &new_rlim);
>  	if (retval)
>  		return retval;
>  
> diff --git a/security/capability.c b/security/capability.c
> index 4aeb699..830a213 100644
> --- a/security/capability.c
> +++ b/security/capability.c
> @@ -411,7 +411,8 @@ static int cap_task_getioprio(struct task_struct *p)
>  	return 0;
>  }
>  
> -static int cap_task_setrlimit(unsigned int resource, struct rlimit *new_rlim)
> +static int cap_task_setrlimit(struct task_struct *p, unsigned int resource,
> +		struct rlimit *new_rlim)
>  {
>  	return 0;
>  }
> diff --git a/security/security.c b/security/security.c
> index 7461b1b..c53949f 100644
> --- a/security/security.c
> +++ b/security/security.c
> @@ -780,9 +780,10 @@ int security_task_getioprio(struct task_struct *p)
>  	return security_ops->task_getioprio(p);
>  }
>  
> -int security_task_setrlimit(unsigned int resource, struct rlimit *new_rlim)
> +int security_task_setrlimit(struct task_struct *p, unsigned int resource,
> +		struct rlimit *new_rlim)
>  {
> -	return security_ops->task_setrlimit(resource, new_rlim);
> +	return security_ops->task_setrlimit(p, resource, new_rlim);
>  }
>  
>  int security_task_setscheduler(struct task_struct *p,
> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> index 5c9f25b..e3ce6b4 100644
> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c
> @@ -3371,16 +3371,17 @@ static int selinux_task_getioprio(struct task_struct *p)
>  	return current_has_perm(p, PROCESS__GETSCHED);
>  }
>  
> -static int selinux_task_setrlimit(unsigned int resource, struct rlimit *new_rlim)
> +static int selinux_task_setrlimit(struct task_struct *p, unsigned int resource,
> +		struct rlimit *new_rlim)
>  {
> -	struct rlimit *old_rlim = current->signal->rlim + resource;
> +	struct rlimit *old_rlim = p->signal->rlim + resource;
>  
>  	/* Control the ability to change the hard limit (whether
>  	   lowering or raising it), so that the hard limit can
>  	   later be used as a safe reset point for the soft limit
>  	   upon context transitions.  See selinux_bprm_committing_creds. */
>  	if (old_rlim->rlim_max != new_rlim->rlim_max)
> -		return current_has_perm(current, PROCESS__SETRLIMIT);
> +		return current_has_perm(p, PROCESS__SETRLIMIT);
>  
>  	return 0;
>  }
> -- 
> 1.7.1
> 
> 

-- 
James Morris
<jmorris@namei.org>
