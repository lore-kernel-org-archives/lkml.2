Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753695Ab1DLMHh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 08:07:37 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:38393 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750720Ab1DLMHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 08:07:36 -0400
Date: Tue, 12 Apr 2011 13:07:34 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikita V. Youshchenko" <nyoushchenko@mvista.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] signal: sigprocmask() should do
 retarget_shared_pending()
Message-ID: <20110412130734.40166236@mfleming-mobl1.ger.corp.intel.com>
In-Reply-To: <20110411172137.GE32469@redhat.com>
References: <20110411171957.GA32469@redhat.com>
	<20110411172137.GE32469@redhat.com>
X-Mailer: Claws Mail 3.7.8cvs52 (GTK+ 2.22.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Apr 2011 19:21:37 +0200
Oleg Nesterov <oleg@redhat.com> wrote:

> In short, almost every changing of current->blocked is wrong, or at least
> can lead to the unexpected results.
> 
> For example. Two threads T1 and T2, T1 sleeps in sigtimedwait/pause/etc.
> kill(tgid, SIG) can pick T2 for TIF_SIGPENDING. If T2 calls sigprocmask()
> and blocks SIG before it notices the pending signal, nobody else can handle
> this pending shared signal.
> 
> I am not sure this is bug, but at least this looks strange imho. T1 should
> not sleep forever, there is a signal which should wake it up.

Agreed.

> @@ -2131,6 +2131,11 @@ int sigprocmask(int how, sigset_t *set, 
>  	}
>  
>  	spin_lock_irq(&tsk->sighand->siglock);
> +	if (signal_pending(tsk) && !thread_group_empty(tsk)) {
> +		sigset_t not_newblocked;
> +		signorsets(&not_newblocked, &current->blocked, &newset);
> +		retarget_shared_pending(tsk, &not_newblocked);
> +	}
>  	tsk->blocked = newset;
>  	recalc_sigpending();
>  	spin_unlock_irq(&tsk->sighand->siglock);

Oh man, that took me a while to understand.

So we're only retargetting the signals that we just blocked? That makes
sense but would you mind adding a comment?

-- 
Matt Fleming, Intel Open Source Technology Center
