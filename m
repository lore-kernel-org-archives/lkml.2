Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754507Ab2DRSzP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 14:55:15 -0400
Received: from 50-56-35-84.static.cloud-ips.com ([50.56.35.84]:43773 "EHLO
	mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790Ab2DRSzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 14:55:12 -0400
Date: Wed, 18 Apr 2012 18:56:10 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: "Eric W. Beiderman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org,
        Linux Containers <containers@lists.linux-foundation.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        linux-security-module@vger.kernel.org,
        Al Viro <viro@ZenIV.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 24/43] userns: Convert ptrace, kill, set_priority
 permission checks to work with kuids and kgids
Message-ID: <20120418185610.GA5186@mail.hallyn.com>
References: <m11unyn70b.fsf@fess.ebiederm.org>
 <1333862139-31737-24-git-send-email-ebiederm@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1333862139-31737-24-git-send-email-ebiederm@xmission.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric W. Beiderman (ebiederm@xmission.com):
> From: Eric W. Biederman <ebiederm@xmission.com>
> 
> Update the permission checks to use the new uid_eq and gid_eq helpers
> and remove the now unnecessary user_ns equality comparison.
> 
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
> ---
>  kernel/ptrace.c |   13 ++++++-------
>  kernel/signal.c |   15 ++++++---------
>  kernel/sys.c    |   18 ++++++++----------
>  3 files changed, 20 insertions(+), 26 deletions(-)
> 
> diff --git a/kernel/ptrace.c b/kernel/ptrace.c
> index 24e0a5a..a232bb5 100644
> --- a/kernel/ptrace.c
> +++ b/kernel/ptrace.c
> @@ -198,13 +198,12 @@ int __ptrace_may_access(struct task_struct *task, unsigned int mode)
>  		return 0;
>  	rcu_read_lock();
>  	tcred = __task_cred(task);
> -	if (cred->user_ns == tcred->user_ns &&
> -	    (cred->uid == tcred->euid &&
> -	     cred->uid == tcred->suid &&
> -	     cred->uid == tcred->uid  &&
> -	     cred->gid == tcred->egid &&
> -	     cred->gid == tcred->sgid &&
> -	     cred->gid == tcred->gid))
> +	if (uid_eq(cred->uid, tcred->euid) &&
> +	    uid_eq(cred->uid, tcred->suid) &&
> +	    uid_eq(cred->uid, tcred->uid)  &&
> +	    gid_eq(cred->gid, tcred->egid) &&
> +	    gid_eq(cred->gid, tcred->sgid) &&
> +	    gid_eq(cred->gid, tcred->gid))
>  		goto ok;
>  	if (ptrace_has_cap(tcred->user_ns, mode))
>  		goto ok;
> diff --git a/kernel/signal.c b/kernel/signal.c
> index d630327..9797939 100644
> --- a/kernel/signal.c
> +++ b/kernel/signal.c
> @@ -767,11 +767,10 @@ static int kill_ok_by_cred(struct task_struct *t)
>  	const struct cred *cred = current_cred();
>  	const struct cred *tcred = __task_cred(t);
>  
> -	if (cred->user_ns == tcred->user_ns &&
> -	    (cred->euid == tcred->suid ||
> -	     cred->euid == tcred->uid ||
> -	     cred->uid  == tcred->suid ||
> -	     cred->uid  == tcred->uid))
> +	if (uid_eq(cred->euid, tcred->suid) ||
> +	    uid_eq(cred->euid, tcred->uid)  ||
> +	    uid_eq(cred->uid,  tcred->suid) ||
> +	    uid_eq(cred->uid,  tcred->uid))
>  		return 1;
>  
>  	if (ns_capable(tcred->user_ns, CAP_KILL))
> @@ -1389,10 +1388,8 @@ static int kill_as_cred_perm(const struct cred *cred,
>  			     struct task_struct *target)
>  {
>  	const struct cred *pcred = __task_cred(target);
> -	if (cred->user_ns != pcred->user_ns)
> -		return 0;
> -	if (cred->euid != pcred->suid && cred->euid != pcred->uid &&
> -	    cred->uid  != pcred->suid && cred->uid  != pcred->uid)
> +	if (uid_eq(cred->euid, pcred->suid) && uid_eq(cred->euid, pcred->uid) &&

These should be !uid_eq() right?
> +	    uid_eq(cred->uid,  pcred->suid) && uid_eq(cred->uid,  pcred->uid))
>  		return 0;
>  	return 1;
>  }
> diff --git a/kernel/sys.c b/kernel/sys.c
> index aff09f2..f484077 100644
> --- a/kernel/sys.c
> +++ b/kernel/sys.c
> @@ -131,9 +131,8 @@ static bool set_one_prio_perm(struct task_struct *p)
>  {
>  	const struct cred *cred = current_cred(), *pcred = __task_cred(p);
>  
> -	if (pcred->user_ns == cred->user_ns &&
> -	    (pcred->uid  == cred->euid ||
> -	     pcred->euid == cred->euid))
> +	if (uid_eq(pcred->uid,  cred->euid) ||
> +	    uid_eq(pcred->euid, cred->euid))
>  		return true;
>  	if (ns_capable(pcred->user_ns, CAP_SYS_NICE))
>  		return true;
> @@ -1582,13 +1581,12 @@ static int check_prlimit_permission(struct task_struct *task)
>  		return 0;
>  
>  	tcred = __task_cred(task);
> -	if (cred->user_ns == tcred->user_ns &&
> -	    (cred->uid == tcred->euid &&
> -	     cred->uid == tcred->suid &&
> -	     cred->uid == tcred->uid &&
> -	     cred->gid == tcred->egid &&
> -	     cred->gid == tcred->sgid &&
> -		    cred->gid == tcred->gid))
> +	if (uid_eq(cred->uid, tcred->euid) &&
> +	    uid_eq(cred->uid, tcred->suid) &&
> +	    uid_eq(cred->uid, tcred->uid)  &&
> +	    gid_eq(cred->gid, tcred->egid) &&
> +	    gid_eq(cred->gid, tcred->sgid) &&
> +	    gid_eq(cred->gid, tcred->gid))
>  		return 0;
>  	if (ns_capable(tcred->user_ns, CAP_SYS_RESOURCE))
>  		return 0;
> -- 
> 1.7.2.5
> 
> _______________________________________________
> Containers mailing list
> Containers@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/containers
