Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758750Ab1BSAAP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 19:00:15 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48917 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753371Ab1BSAAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 19:00:08 -0500
Date: Fri, 18 Feb 2011 15:59:21 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: LSM <linux-security-module@vger.kernel.org>,
        James Morris <jmorris@namei.org>, Kees Cook <kees.cook@canonical.com>,
        containers@lists.linux-foundation.org,
        kernel list <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>, xemul@parallels.com,
        dhowells@redhat.com
Subject: Re: [PATCH 4/9] allow killing tasks in your own or child userns
Message-Id: <20110218155921.440f1137.akpm@linux-foundation.org>
In-Reply-To: <20110217150325.GD26395@mail.hallyn.com>
References: <20110217150224.GA26334@mail.hallyn.com>
	<20110217150325.GD26395@mail.hallyn.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Feb 2011 15:03:25 +0000
"Serge E. Hallyn" <serge@hallyn.com> wrote:

>  /*
> + * called with RCU read lock from check_kill_permission()
> + */
> +static inline int kill_ok_by_cred(struct task_struct *t)
> +{
> +	const struct cred *cred = current_cred();
> +	const struct cred *tcred = __task_cred(t);
> +
> +	if (cred->user->user_ns == tcred->user->user_ns &&
> +	    (cred->euid == tcred->suid ||
> +	     cred->euid == tcred->uid ||
> +	     cred->uid  == tcred->suid ||
> +	     cred->uid  == tcred->uid))
> +		return 1;
> +
> +	if (ns_capable(tcred->user->user_ns, CAP_KILL))
> +		return 1;
> +
> +	return 0;
> +}

The compiler will inline this for us.

> +/*
>   * Bad permissions for sending the signal
>   * - the caller must hold the RCU read lock
>   */
>  static int check_kill_permission(int sig, struct siginfo *info,
>  				 struct task_struct *t)
>  {
> -	const struct cred *cred, *tcred;
>  	struct pid *sid;
>  	int error;
>  
> @@ -656,14 +676,8 @@ static int check_kill_permission(int sig, struct siginfo *info,
>  	if (error)
>  		return error;
>  
> -	cred = current_cred();
> -	tcred = __task_cred(t);
>  	if (!same_thread_group(current, t) &&
> -	    (cred->euid ^ tcred->suid) &&
> -	    (cred->euid ^ tcred->uid) &&
> -	    (cred->uid  ^ tcred->suid) &&
> -	    (cred->uid  ^ tcred->uid) &&
> -	    !capable(CAP_KILL)) {
> +	    !kill_ok_by_cred(t)) {
>  		switch (sig) {
>  		case SIGCONT:
>  			sid = task_session(t);

