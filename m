Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752572Ab1HPSKK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 14:10:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36589 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751782Ab1HPSKJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 14:10:09 -0400
Date: Tue, 16 Aug 2011 20:06:44 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 41/41] exit: Use __set_task_blocked()
Message-ID: <20110816180644.GJ29190@redhat.com>
References: <1313071035-12047-1-git-send-email-matt@console-pimps.org> <1313071035-12047-42-git-send-email-matt@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313071035-12047-42-git-send-email-matt@console-pimps.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/11, Matt Fleming wrote:
>
> As described in e6fa16ab ("signal: sigprocmask() should do
> retarget_shared_pending()") the modification of current->blocked is
> incorrect as we need to check whether the signal we're about to block
> is pending in the shared queue.

Yes. but in this case the code is correct. First of all, unblocking
is always fine. Also, this should be used by kthreads only, and they
are single-threaded.

But there are other reasons why I don't like this change, even if we
ignore the fact the patched exit.c can't be compiled (__set_task_blocked
is not exported ;).

>  int allow_signal(int sig)
>  {
> +	sigset_t blocked;
> +
>  	if (!valid_signal(sig) || sig < 1)
>  		return -EINVAL;
>
>  	spin_lock_irq(&current->sighand->siglock);
>  	/* This is only needed for daemonize()'ed kthreads */

Exactly. And nowadays the daemonize()'ed kthreads should not play
with allow_signal().

And more, I think it is the time to kill daemonize(). Contrary to
what /bin/grep thinks, it has only one user.

In short: this code in allow_signal() should die. I'll try to send
the patches soon...

Oleg.

