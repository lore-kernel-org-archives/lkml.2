Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752130Ab0DKPCj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Apr 2010 11:02:39 -0400
Received: from www.tglx.de ([62.245.132.106]:33785 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751812Ab0DKPCh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Apr 2010 11:02:37 -0400
Date: Sun, 11 Apr 2010 17:02:24 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Michal Nazarewicz <m.nazarewicz@samsung.com>
cc: linux-usb@vger.kernel.org, Michal Nazarewicz <mina86@mina86.com>,
       Davide Libenzi <davidel@xmailserver.org>, Greg KH <greg@kroah.com>,
       Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 1/8] wait_event_interruptible_locked() interface
In-Reply-To: <3baf39971e1f49e98498f5d00e21df4302396252.1270835924.git.mina86@mina86.com>
Message-ID: <alpine.LFD.2.00.1004111638240.32352@localhost.localdomain>
References: <cover.1270835924.git.mina86@mina86.com> <3baf39971e1f49e98498f5d00e21df4302396252.1270835924.git.mina86@mina86.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 9 Apr 2010, Michal Nazarewicz wrote:

> New wait_event_interruptible{,_exclusive}_locked{,_irq,_irqsave}
> macros added.  They work just like versions without _locked* suffix

The _irqsave variant is really not necessary. It's actively wrong.

If you go to wait then the state _before_ acquiring the waitqueue head
lock must be irqs enabled. Otherwise you would schedule with
interrupts disabled after the unlock_irqrestore which is a BUG.

So if there is code which uses spin_lock_irqsave() in the wait path
then this code is wrong and needs to be fixed to spin_(un)lock_irq()
first instead of adding a bogus interface.

> +
> +#define __wait_event_interruptible_locked(wq, condition, ret, exclusive, lock, unlock, lock_args) \

That will also simplify this to (wq, condition, exclusive, lockmode)

> +do {									\
> +	DEFINE_WAIT(__wait);						\
> +									\
> +	if (exclusive)							\
> +		__wait.flags |= WQ_FLAG_EXCLUSIVE;			\
> +	else								\
> +		__wait.flags &= ~WQ_FLAG_EXCLUSIVE;			\
> +	__add_wait_queue_tail(&(wq), &__wait);				\
> +									\
> +	do {								\
> +		set_current_state(TASK_INTERRUPTIBLE);			\
> +		if (signal_pending(current)) {				\
> +			ret = -ERESTARTSYS;				\
> +			break;						\
> +		}							\
> +		spin_unlock ##unlock lock_args;				\
> +		schedule();						\
> +		spin_lock ##lock lock_args;				\
> +	} while (!(condition));						\
> +	__remove_wait_queue(&(wq), &__wait);				\
> +	__set_current_state(TASK_RUNNING);				\
> +} while (0)
> +
> +
> +/**
> + * wait_event_interruptible_locked - sleep until a condition gets true
> + * @wq: the waitqueue to wait on
> + * @condition: a C expression for the event to wait for
> + *
> + * The process is put to sleep (TASK_INTERRUPTIBLE) until the
> + * @condition evaluates to true or a signal is received.
> + * The @condition is checked each time the waitqueue @wq is woken up.
> + *
> + * It must be called with wq.lock being held.  This spinlock is
> + * unlocked while sleeping but @condition testing is done while lock
> + * is held and when this macro exits the lock is held.
> + *
> + * The lock is locked/unlocked using spin_lock()/spin_unlock()
> + * functions which must match the way they are locked/unlocked outside
> + * of this macro.
> + *
> + * wake_up_locked() has to be called after changing any variable that could
> + * change the result of the wait condition.
> + *
> + * The function will return -ERESTARTSYS if it was interrupted by a
> + * signal and 0 if @condition evaluated to true.
> + */
> +#define wait_event_interruptible_locked(wq, condition)			\
> +({									\
> +	int __ret = 0;							\
> +	if (!(condition))						\
> +		__wait_event_interruptible_locked(wq, condition, __ret, 0, , , (&(wq).lock)); \

  I had to look more than once to figure out how that code might
  return anything else than 0. Can we please change that to

  if (!(condition))
     __ret = __wait_.....();

  to make that less confusing ?   

> +	__ret;								\
> +})

Thanks,

	tglx
