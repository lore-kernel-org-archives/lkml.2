Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754798Ab1DEUUi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 16:20:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39351 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751996Ab1DEUUg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 16:20:36 -0400
Date: Tue, 5 Apr 2011 22:19:58 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Matt Fleming <matt.fleming@linux.intel.com>
Subject: Re: [RFC][PATCH 1/5] signals: Always place SIGCONT and SIGSTOP on
	'shared_pending'
Message-ID: <20110405201958.GA1404@redhat.com>
References: <1302031310-1765-1-git-send-email-matt@console-pimps.org> <1302031310-1765-2-git-send-email-matt@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1302031310-1765-2-git-send-email-matt@console-pimps.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matt,

I'll try to study this series, but not before Friday, sorry.

Only one thing,

On 04/05, Matt Fleming wrote:
> 
> Because SIGCONT and SIGSTOP affect an entire thread group,

Yes, the effect is global, but

> we can
> place them on the 'shared_pending' queue.

I don't think we can.

 -	pending = group ? &t->signal->shared_pending : &t->pending;
> +	/*
> +	 * We always enqueue SIGSTOP or SIGCONT signals on the shared
> +	 * queue. This means that a SIGSTOP or SIGCONT signal _cannot_
> +	 * be present on a thread's private pending queue.
> +	 *
> +	 * This makes prepare_signal() more optimal as we do not have
> +	 * to remove signals from each thread's pending queue and so
> +	 * can avoid iterating over all threads in the thread group
> +	 * (and therefore avoid the locking that would be necessary to
> +	 * do that safely).
> +	 */
> +	if (group || sig_kernel_stop(sig) || sig == SIGCONT)
> +		pending = &t->signal->shared_pending;
> +	else
> +		pending = &t->pending;

How so? Suppose the process has a handler for SIGCONT. Suppose this
process is not stopped. tkill(SIGCONT) should deliver the signal to
the right thread.

SIGSTOP can't have the handler, still we shouldn't place it on the
shared list, debuggers won't be happy.

Also. This code was changed very much, please do these changes on
top of
http://git.kernel.org/?p=linux/kernel/git/tj/misc.git;a=shortlog;h=refs/heads/ptrace

Oleg.

