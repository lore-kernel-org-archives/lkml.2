Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751698Ab0F3Dz2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 23:55:28 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:47713 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266Ab0F3Dz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 23:55:26 -0400
X-Authority-Analysis: v=1.1 cv=fhltGCNqn7I0vuW4QMEj3LCOhQQl14bnXIhcDW1W0Bg= c=1 sm=0 a=BpbFXrSub_kA:10 a=GQCbJdZ--msA:10 a=kj9zAlcOel0A:10 a=Nqdp4+S2FArj7gZzHVn+tA==:17 a=DfNHnWVPAAAA:8 a=VwQbUJbxAAAA:8 a=YXCCc8iNaj-nCfMThe4A:9 a=sGg0HsvFY7M1Hj8s2bwA:7 a=OFn6XsJhu8CmpSIwoVa7NhQ28QYA:4 a=CjuIK1q_8ugA:10 a=x8gzFH9gYPwA:10 a=lBRciGGoxdUA:10 wl=env:18 a=Nqdp4+S2FArj7gZzHVn+tA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 70.120.198.24
Date: Tue, 29 Jun 2010 22:56:09 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Kees Cook <kees.cook@canonical.com>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Yama: add PTRACE exception tracking
Message-ID: <20100630035609.GA16307@hallyn.com>
References: <20100630003844.GE4837@outflux.net>
 <20100630004027.GG4837@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100630004027.GG4837@outflux.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Kees Cook (kees.cook@canonical.com):
> Some application suites have external crash handlers that depend on
> being able to use PTRACE to generate crash reports (KDE, Chromium, etc).
> Since the inferior process generally knows the PID of the debugger,
> it can use PR_SET_PTRACER to allow a specific PID and its descendants
> to perform the PTRACE instead of only a direct ancestor.
> 
> Signed-off-by: Kees Cook <kees.cook@canonical.com>
> ---

Hi Kees - very nice, overall.  One little note though:

> @@ -32,27 +204,20 @@ static int yama_ptrace_access_check(struct task_struct *child,
>  {
>  	int rc;
>  
> +	/* If standard caps disallows it, so does Yama.  We should
> +	 * should only tighten restrictions further.
> +	 */
>  	rc = cap_ptrace_access_check(child, mode);

This means that if capable(CAP_SYS_PTRACE) we'll always shortcut
here, so

> -	if (rc != 0)
> +	if (rc)
>  		return rc;
>  
>  	/* require ptrace target be a child of ptracer on attach */
> -	if (mode == PTRACE_MODE_ATTACH && ptrace_scope &&
> -	    !capable(CAP_SYS_PTRACE)) {
> -		struct task_struct *walker = child;
> -
> -		rcu_read_lock();
> -		read_lock(&tasklist_lock);
> -		while (walker->pid > 0) {
> -			if (walker == current)
> -				break;
> -			walker = walker->real_parent;
> -		}
> -		if (walker->pid == 0)
> -			rc = -EPERM;
> -		read_unlock(&tasklist_lock);
> -		rcu_read_unlock();
> -	}
> +	if (mode == PTRACE_MODE_ATTACH &&
> +	    ptrace_scope &&
> +	    !capable(CAP_SYS_PTRACE) &&

You don't need the CAP_SYS_PTRACE check here AFAICS.

> +	    !task_is_descendant(current, child) &&
> +	    !ptracer_exception_found(current, child))
> +		rc = -EPERM;
>  
>  	if (rc) {
>  		char name[sizeof(current->comm)];
> @@ -170,6 +335,8 @@ static struct security_operations yama_ops = {
>  	.ptrace_access_check =	yama_ptrace_access_check,
>  	.inode_follow_link =	yama_inode_follow_link,
>  	.path_link =		yama_path_link,
> +	.task_prctl =		yama_task_prctl,
> +	.task_free =		yama_task_free,
>  };
>  
>  #ifdef CONFIG_SYSCTL
> @@ -221,6 +388,8 @@ static __init int yama_init(void)
>  
>  	printk(KERN_INFO "Yama: becoming mindful.\n");
>  
> +	spin_lock_init(&ptracer_relations_lock);
> +
>  	if (register_security(&yama_ops))
>  		panic("Yama: kernel registration failed.\n");
>  
> -- 
> 1.7.1
> 
> 
> -- 
> Kees Cook
> Ubuntu Security Team
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
