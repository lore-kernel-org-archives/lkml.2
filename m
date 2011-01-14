Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757522Ab1ANOqU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 09:46:20 -0500
Received: from wavehammer.waldi.eu.org ([82.139.201.20]:33586 "EHLO
	wavehammer.waldi.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751928Ab1ANOqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 09:46:13 -0500
Date: Fri, 14 Jan 2011 15:46:09 +0100
From: Bastian Blank <bastian@waldi.eu.org>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: containers@lists.linux-foundation.org,
        kernel list <linux-kernel@vger.kernel.org>,
        LSM <linux-security-module@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Kees Cook <kees.cook@canonical.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>
Subject: Re: [PATCH 05/08] Allow ptrace from non-init user namespaces
Message-ID: <20110114144608.GA20945@wavehammer.waldi.eu.org>
Mail-Followup-To: Bastian Blank <bastian@waldi.eu.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	containers@lists.linux-foundation.org,
	kernel list <linux-kernel@vger.kernel.org>,
	LSM <linux-security-module@vger.kernel.org>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Kees Cook <kees.cook@canonical.com>,
	Alexey Dobriyan <adobriyan@gmail.com>,
	Michael Kerrisk <mtk.manpages@gmail.com>
References: <20110111064342.GA27515@mail.hallyn.com>
 <20110111064439.GF27515@mail.hallyn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20110111064439.GF27515@mail.hallyn.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This mail did not show up in my inbox, even if I'm listed as receipient.
I only got a copy via the mailinglist.

On Tue, Jan 11, 2011 at 06:44:39AM +0000, Serge E. Hallyn wrote:
> diff --git a/kernel/ptrace.c b/kernel/ptrace.c
> index 99bbaa3..ec7605d 100644
> --- a/kernel/ptrace.c
> +++ b/kernel/ptrace.c
> @@ -134,21 +134,24 @@ int __ptrace_may_access(struct task_struct *task, unsigned int mode)
>  		return 0;
>  	rcu_read_lock();
>  	tcred = __task_cred(task);
> -	if ((cred->uid != tcred->euid ||
> -	     cred->uid != tcred->suid ||
> -	     cred->uid != tcred->uid  ||
> -	     cred->gid != tcred->egid ||
> -	     cred->gid != tcred->sgid ||
> -	     cred->gid != tcred->gid) &&
> -	    !capable(CAP_SYS_PTRACE)) {
> -		rcu_read_unlock();
> -		return -EPERM;
> -	}
> +	if (cred->user->user_ns == tcred->user->user_ns &&
> +	    (cred->uid == tcred->euid &&
> +	     cred->uid == tcred->suid &&
> +	     cred->uid == tcred->uid  &&
> +	     cred->gid == tcred->egid &&
> +	     cred->gid == tcred->sgid &&
> +	     cred->gid == tcred->gid))
> +		goto ok;
> +	if (ns_capable(tcred->user->user_ns, CAP_SYS_PTRACE))
> +		goto ok;
> +	rcu_read_unlock();
> +	return -EPERM;
> +ok:

This is wrong. Please move that out into functions if you are unable to
get the conditions right.

Bastian

-- 
If a man had a child who'd gone anti-social, killed perhaps, he'd still
tend to protect that child.
		-- McCoy, "The Ultimate Computer", stardate 4731.3
