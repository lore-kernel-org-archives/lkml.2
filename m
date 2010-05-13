Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759609Ab0EMW5a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 18:57:30 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46261 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758922Ab0EMW5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 18:57:23 -0400
Date: Thu, 13 May 2010 15:56:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiri Slaby <jslaby@suse.cz>
Cc: adobriyan@gmail.com, nhorman@tuxdriver.com, oleg@redhat.com,
       linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: Re: [PATCH v3 10/11] rlimits: implement prlimit64 syscall
Message-Id: <20100513155630.9ca5ab16.akpm@linux-foundation.org>
In-Reply-To: <1273514451-28894-10-git-send-email-jslaby@suse.cz>
References: <1273514451-28894-1-git-send-email-jslaby@suse.cz>
	<1273514451-28894-10-git-send-email-jslaby@suse.cz>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 May 2010 20:00:50 +0200
Jiri Slaby <jslaby@suse.cz> wrote:

> This patch adds the code to support the sys_prlimit64 syscall which
> modifies-and-returns the rlim values of a selected process
> atomically. The first parameter, pid, being 0 means current process.
> 
> Unlike the current implementation, it is a generic interface,
> architecture indepentent so that we needn't handle compat stuff
> anymore. In the future, after glibc start to use this we can deprecate
> sys_setrlimit and sys_getrlimit in favor to clean up the code finally.
> 
> It also adds a possibility of changing limits of other processes. We
> check the user's permissions to do that and if it succeeds, the new
> limits are propagated online. This is good for large scale
> applications such as SAP or databases where administrators need to
> change limits time by time (e.g. on crashes increase core size). And
> it is unacceptable to restart the service.
> 
> For safety, all rlim users now either use accessors or doesn't need
> them due to
> - locking
> - the fact a process was just forked and nobody else knows about it
>   yet (and nobody can't thus read/write limits)
> hence it is safe to modify limits now.
> 
> The limitation is that we currently stay at ulong internal
> representation. So we use the rlim64_is_infinity check where we
> compare to ULONG_MAX on 32-bit which is the maximum value there.
> 
> And since internally we hold limits in struct rlimit, we introduce
> converters used before and after do_prlimit call in sys_prlimit64.
> 

Is this worth all the new code and the increase in locking dependencies
which I think is there?

This could all be done in userspace, couldn't it?  Write a little library
which clones a thread then waits for someone to send it a
change-your-rlimits message.  Write a little tool to send those
messages and voila.

>
> ...
>
> +SYSCALL_DEFINE4(prlimit64, pid_t, pid, unsigned int, resource,
> +		const struct rlimit64 __user *, new_rlim,
> +		struct rlimit64 __user *, old_rlim)
> +{
> +	struct rlimit64 old64, new64;
> +	struct rlimit old, new;
> +	struct task_struct *tsk;
> +	int ret;
> +
> +	if (new_rlim) {
> +		if (copy_from_user(&new64, new_rlim, sizeof(new64)))
> +			return -EFAULT;
> +		rlim64_to_rlim(&new64, &new);
> +	}
> +
> +	/* we don't want to fail after do_rlimit */

You meant "do_prlimit".

If doesn't explain _why_ we don't want to fail.  And it shold do so,
because the __copy_to_user() can still fail.


> +	if (old_rlim && !access_ok(VERIFY_WRITE, old_rlim, sizeof(old64)))
> +		return -EFAULT;
> +
> +	rcu_read_lock();
> +	tsk = pid ? find_task_by_vpid(pid) : current;
> +	if (!tsk) {
> +		rcu_read_unlock();
> +		return -ESRCH;
> +	}
> +	ret = check_prlimit_permission(tsk);
> +	if (ret) {
> +		rcu_read_unlock();
> +		return ret;
> +	}
> +	get_task_struct(tsk);
> +	rcu_read_unlock();
> +
> +	ret = do_prlimit(tsk, resource, new_rlim ? &new : NULL,
> +			old_rlim ? &old : NULL);
> +
> +	if (!ret && old_rlim) {
> +		rlim_to_rlim64(&old, &old64);
> +		if (WARN_ON_ONCE(__copy_to_user(old_rlim, &old64,
> +						sizeof(old64))))
> +			ret = -EFAULT;
> +	}
> +
> +	put_task_struct(tsk);
> +	return ret;
> +}

