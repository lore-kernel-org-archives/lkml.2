Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753481Ab2AZTQu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 14:16:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61149 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753348Ab2AZTQs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 14:16:48 -0500
Date: Thu, 26 Jan 2012 18:56:12 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: + kmod-avoid-deadlock-by-recursive-kmod-call.patch added to
	-mm tree
Message-ID: <20120126175612.GA24011@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> @@ -449,6 +460,16 @@ int call_usermodehelper_exec(struct subp
>  		retval = -EBUSY;
>  		goto out;
>  	}
> +	/*
> +	 * Worker thread must not wait for khelper thread at below
> +	 * wait_for_completion() if the thread was created with CLONE_VFORK
> +	 * flag, for khelper thread is already waiting for the thread at
> +	 * wait_for_completion() in do_fork().
> +	 */
> +	if (wait != UMH_NO_WAIT && current == kmod_thread_locker) {
> +		retval = -EBUSY;
> +		goto out;
> +	}

So, this is because khelper_wq's max_active == 1.

Can't we simply kill khelper_wq and use system_unbound_wq instead?

Oleg.

