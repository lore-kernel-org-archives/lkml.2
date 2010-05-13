Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759535Ab0EMW5X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 18:57:23 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43049 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751950Ab0EMW5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 18:57:21 -0400
Date: Thu, 13 May 2010 15:56:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiri Slaby <jslaby@suse.cz>
Cc: adobriyan@gmail.com, nhorman@tuxdriver.com, oleg@redhat.com,
       linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: Re: [PATCH v3 05/11] rlimits: allow setrlimit to non-current tasks
Message-Id: <20100513155621.51ca77a4.akpm@linux-foundation.org>
In-Reply-To: <1273514451-28894-5-git-send-email-jslaby@suse.cz>
References: <1273514451-28894-1-git-send-email-jslaby@suse.cz>
	<1273514451-28894-5-git-send-email-jslaby@suse.cz>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 May 2010 20:00:45 +0200
Jiri Slaby <jslaby@suse.cz> wrote:

> From: Jiri Slaby <jirislaby@gmail.com>
> 
> Add locking to allow setrlimit accept task parameter other than
> current.
> 
> Namely, lock tasklist_lock for read and check whether the task
> structure has sighand non-null. Do all the signal processing under
> that lock still held.
> 
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> Cc: Oleg Nesterov <oleg@redhat.com>
> ---
>  kernel/sys.c |   11 ++++++++++-
>  1 files changed, 10 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/sys.c b/kernel/sys.c
> index 7c76f84..eb21661 100644
> --- a/kernel/sys.c
> +++ b/kernel/sys.c
> @@ -1272,6 +1272,7 @@ SYSCALL_DEFINE2(old_getrlimit, unsigned int, resource,
>  
>  #endif
>  
> +/* make sure you are allowed to change @tsk limits before calling this */
>  int do_setrlimit(struct task_struct *tsk, unsigned int resource,
>  		struct rlimit *new_rlim)
>  {
> @@ -1285,9 +1286,16 @@ int do_setrlimit(struct task_struct *tsk, unsigned int resource,
>  	if (resource == RLIMIT_NOFILE && new_rlim->rlim_max > sysctl_nr_open)
>  		return -EPERM;
>  
> +	/* protect tsk->signal and tsk->sighand from disappearing */
> +	read_lock(&tasklist_lock);
> +	if (!tsk->sighand) {
> +		retval = -ESRCH;
> +		goto out;
> +	}
> +
>  	retval = security_task_setrlimit(tsk, resource, new_rlim);

I looked at the amount of code which exists under
security_task_setrlimit() and nearly died.  Please convince me that it
is correct to do all that work under tasklist_lock, and that it is also
maintainable.

> 	update_rlimit_cpu(tsk, new_rlim->rlim_cur);
>  out:
> +	read_unlock(&tasklist_lock);

And this causes task-struct.sighand->siglock to be taken under
tasklist_lock.  Was that a pre-existing ranking, or is it a new one?

