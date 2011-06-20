Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754676Ab1FTUfn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 16:35:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14275 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751956Ab1FTUfm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 16:35:42 -0400
Date: Mon, 20 Jun 2011 22:33:20 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, hch@infradead.org
Subject: Re: [PATCH 5/7] ptrace: kill clone/exec tracehooks
Message-ID: <20110620203320.GC17157@redhat.com>
References: <1308322240-8247-1-git-send-email-tj@kernel.org> <1308322240-8247-6-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1308322240-8247-6-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/17, Tejun Heo wrote:
>
> At this point, tracehooks aren't useful to mainline kernel and mostly
> just add an extra layer of obfuscation.

Yes, this is true.

> @@ -1481,10 +1481,22 @@ long do_fork(unsigned long clone_flags,
>  	}
>
>  	/*
> -	 * When called from kernel_thread, don't do user tracing stuff.
> +	 * Determine whether and which event to report to ptracer.  When
> +	 * called from kernel_thread or CLONE_UNTRACED is explicitly
> +	 * requested, no event is reported; otherwise, report if the event
> +	 * for the type of forking is enabled.
>  	 */
> -	if (likely(user_mode(regs)))
> -		trace = tracehook_prepare_clone(clone_flags);
> +	if (likely(user_mode(regs)) && !(clone_flags & CLONE_UNTRACED)) {

Off-topic, but I never understood this user_mode() check... OK, a
traced task can call kernel_thread() in kernel, but this used
CLONE_UNTRACED.

> +		if (clone_flags & CLONE_VFORK)
> +			trace = PTRACE_EVENT_VFORK;
> +		else if ((clone_flags & CSIGNAL) != SIGCHLD)
> +			trace = PTRACE_EVENT_CLONE;
> +		else
> +			trace = PTRACE_EVENT_FORK;
> +
> +		if (likely(!ptrace_event_enabled(current, trace)))
> +			trace = 0;
> +	}

As I said am going to apply this all except 6/7, but imho this
deserves a trivial helper anyway.

Oleg.

