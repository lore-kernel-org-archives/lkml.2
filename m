Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756486Ab1DLOcq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 10:32:46 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50454 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751078Ab1DLOcp convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 10:32:45 -0400
MIME-Version: 1.0
In-Reply-To: <20110411172137.GE32469@redhat.com>
References: <20110411171957.GA32469@redhat.com> <20110411172137.GE32469@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 12 Apr 2011 07:32:20 -0700
Message-ID: <BANLkTin6t7fSuyxw4Nipj1DGy8w9XE3+ug@mail.gmail.com>
Subject: Re: [PATCH 4/6] signal: sigprocmask() should do retarget_shared_pending()
To: Oleg Nesterov <oleg@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        "Nikita V. Youshchenko" <nyoushchenko@mvista.com>,
        Matt Fleming <matt@console-pimps.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 11, 2011 at 10:21 AM, Oleg Nesterov <oleg@redhat.com> wrote:
>
> I am not sure this is bug, but at least this looks strange imho. T1 should
> not sleep forever, there is a signal which should wake it up.

Hmm. I worry about the overhead of this, and I'm not 100% convinced we need it.

But my _biggest_ objection to the series is a purely technical one:

> --- sigprocmask/include/linux/signal.h~4_sigprocmask_retarget   2011-04-06 21:33:50.000000000 +0200
> +++ sigprocmask/include/linux/signal.h  2011-04-11 18:16:51.000000000 +0200
> @@ -2131,6 +2131,11 @@ int sigprocmask(int how, sigset_t *set,
>        }
>
>        spin_lock_irq(&tsk->sighand->siglock);
> +       if (signal_pending(tsk) && !thread_group_empty(tsk)) {
> +               sigset_t not_newblocked;
> +               signorsets(&not_newblocked, &current->blocked, &newset);
> +               retarget_shared_pending(tsk, &not_newblocked);
> +       }
>        tsk->blocked = newset;
>        recalc_sigpending();
>        spin_unlock_irq(&tsk->sighand->siglock);

I absolutely detest how you made "sigprocmask()" the main interface to
do this all, and then add new callers.

It's a horrid interface with that crazy "how" argument, and comes out
of the user-space system call interface. If we make kernel users do
this, especially critical ones like the signal handling code, please
just extract out just the actual "set new signal mask" part.

So please just introduce a "sig_set_blocked()" or something, without
the crazy "switch (how)" crud, and make sigprocmask() and everybody
else use _that_ instead.

That would make me much happier about the patch series, I suspect.

                     Linus
