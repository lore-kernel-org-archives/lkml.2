Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753472Ab2LSSr7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 13:47:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21565 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751852Ab2LSSrv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 13:47:51 -0500
Date: Wed, 19 Dec 2012 19:47:57 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        linux-kernel@vger.kernel.org, Serge Hallyn <serge@hallyn.com>,
        Gao feng <gaofeng@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 07/11] pidns: Wait in zap_pid_ns_processes until
	pid_ns->nr_hashed == 1
Message-ID: <20121219184757.GB22991@redhat.com>
References: <8739097bkk.fsf@xmission.com> <1353083750-3621-1-git-send-email-ebiederm@xmission.com> <1353083750-3621-7-git-send-email-ebiederm@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353083750-3621-7-git-send-email-ebiederm@xmission.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/16, Eric W. Biederman wrote:
>
> @@ -216,22 +216,15 @@ void zap_pid_ns_processes(struct pid_namespace *pid_ns)
>
>  	/*
>  	 * sys_wait4() above can't reap the TASK_DEAD children.
> -	 * Make sure they all go away, see __unhash_process().
> +	 * Make sure they all go away, see free_pid().
>  	 */
>  	for (;;) {
> -		bool need_wait = false;
> -
> -		read_lock(&tasklist_lock);
> -		if (!list_empty(&current->children)) {
> -			__set_current_state(TASK_UNINTERRUPTIBLE);
> -			need_wait = true;
> -		}
> -		read_unlock(&tasklist_lock);
> -
> -		if (!need_wait)
> +		set_current_state(TASK_UNINTERRUPTIBLE);
> +		if (pid_ns->nr_hashed == 1)
>  			break;
>  		schedule();
>  	}

I agree, the patch itself looks fine.

But, with all other changes I do not understand this part at all.

A task from the parent namespace can do setns + fork at any time
(until nr_hashed >= 0). So ->nr_hashed can be incremented again
after zap_pid_ns_processes() returns.

Or, we can sleep in TASK_UNINTERRUPTIBLE "forever" if this happens
after kill-them-all.

Could you explain why do we need to wait at all? I can be easily
wrong, but at first glance the original reason for this wait has
gone away?

Oleg.

