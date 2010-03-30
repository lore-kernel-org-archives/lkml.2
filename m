Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755035Ab0C3WXd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 18:23:33 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:48769 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753673Ab0C3WXb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 18:23:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=pyRTRyirOw+bMXwIBUAlm1xEJTaFdqPCvIGD53Bi7DuNB+p4ISZ7uYi/Yhx8s1d75j
         wNjpaGDkaPSjVhVOVjOqnL1PqTs0vHp0YlwYuLvqkme9ZYB0nPp/BRdF85mljzXTUHKg
         Rzn43736DATUNVqElLGmQyIhlc6vCIgTSzgWA=
Date: Wed, 31 Mar 2010 00:23:34 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Greg KH <gregkh@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Kacur <jkacur@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
       Ingo Molnar <mingo@elte.hu>, Arnd Bergmann <arnd@relay.de.ibm.com>
Subject: Re: [RFC 1/9] tty: replace BKL with a new tty_lock
Message-ID: <20100330222333.GM5078@nowhere>
References: <1269982580-9361-1-git-send-email-arnd@arndb.de> <1269982580-9361-2-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269982580-9361-2-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 30, 2010 at 10:56:12PM +0200, Arnd Bergmann wrote:
> +/* functions for preparation of BKL removal */
> +
> +/*
> + * tty_lock_nested get the tty_lock while potentially holding it
> + *
> + * The Big TTY Mutex is a recursive lock, meaning you can take it
> + * from a thread that is already holding it.
> + * This is bad for a number of reasons, so tty_lock_nested should
> + * really be used as rarely as possible. If a code location can
> + * be shown to never get called with this held already, it should
> + * use tty_lock() instead.
> + */ 
> +static inline void __lockfunc tty_lock_nested(void) __acquires(kernel_lock)
> +{
> +	lock_kernel();
> +}
> +static inline void tty_lock(void) __acquires(kernel_lock)
> +{
> +	WARN_ON(kernel_locked());
> +	lock_kernel();
> +}
> +static inline void tty_unlock(void) __releases(kernel_lock)
> +{
> +	unlock_kernel();
> +}
> +#define tty_locked()		(kernel_locked())
> +static inline int __reacquire_tty_lock(void)
> +{
> +	return 0;
> +}
> +static inline void __release_tty_lock(void)
> +{
> +}
> +
> +#define release_tty_lock(tsk) do { } while (0)
> +#define reacquire_tty_lock(tsk) do { } while (0)
> +
> +/*
> + * mutex_lock_tty - lock a mutex without holding the BTM
> + *
> + * These three functions replace calls to mutex_lock
> + * in the tty layer, when locking on of the following
> + * mutexes:
> + *   tty->ldisc_mutex
> + *   tty->termios_mutex
> + *   tty->atomic_write_lock
> + *   port->mutex
> + *   pn->all_ppp_mutex
> + *
> + * The reason we need these is to avoid an AB-BA deadlock
> + * with tty_lock(). When it can be shown that one of the
> + * above mutexes is either never acquired with the tty_lock()
> + * held, or is never held when tty_lock() is acquired, that
> + * mutex should be converted back to the regular mutex_lock
> + * function.
> + *
> + * In order to annotate the lock order, the mutex_lock_tty_on
> + * and mutex_lock_tty_off versions should be used whereever
> + * possible, to show if the mutex is used with or without
> + * tty_lock already held.
> + */
> +#define mutex_lock_tty(mutex)			\
> +({						\
> +	if (!mutex_trylock(mutex)) {		\
> +		if (tty_locked()) {		\
> +			__release_tty_lock();	\
> +			mutex_lock(mutex);	\
> +			__reacquire_tty_lock();	\
> +		} else				\
> +			mutex_lock(mutex);	\
> +	}					\
> +})
> +
> +#define mutex_lock_tty_on(mutex)		\
> +({						\
> +	if (!mutex_trylock(mutex)) {		\
> +		if (!WARN_ON(!tty_locked())) {	\
> +			__release_tty_lock();	\
> +			mutex_lock(mutex);	\
> +			__reacquire_tty_lock();	\
> +		} else				\
> +			mutex_lock(mutex);	\
> +	}					\
> +})
> +
> +#define mutex_lock_tty_off(mutex)		\
> +({						\
> +	if (!mutex_trylock(mutex)) {		\
> +		if (WARN_ON(tty_locked())) {	\
> +			__release_tty_lock();	\
> +			mutex_lock(mutex);	\
> +			__reacquire_tty_lock();	\
> +		} else				\
> +			mutex_lock(mutex);	\
> +	}					\
> +})
> +
> +#define mutex_lock_interruptible_tty(mutex)	\
> +({						\
> +	int __ret = 0;				\
> +	if (!mutex_trylock(mutex)) {		\
> +		if (tty_locked()) {		\
> +			__release_tty_lock();	\
> +			__ret = mutex_lock_interruptible(mutex); \
> +			__reacquire_tty_lock();	\
> +		} else				\
> +			__ret = mutex_lock_interruptible(mutex); \
> +	}					\
> +	__ret;					\
> +})
> +
> +/*
> + * wait_event*_tty -- wait for a condition with the tty lock held
> + *
> + * similar to the mutex_lock_tty family, these should be used when
> + * waiting for an event in a code location that may get called
> + * while tty_lock is held.
> + *
> + * The problem is that the condition we are waiting for might
> + * only become true if another thread runs that needs the tty_lock
> + * in order to get there.
> + *
> + * None of these should be needed and all callers should be removed
> + * when either the caller or the condition it waits for can be show
> + * to not rely on the tty_lock.
> + */
> +#define wait_event_tty(wq, condition) 					\
> +do {									\
> +	if (condition)	 						\
> +		break;							\
> +	release_tty_lock(current);					\
> +	__wait_event(wq, condition);					\
> +	reacquire_tty_lock(current);					\
> +} while (0)
> +
> +#define wait_event_timeout_tty(wq, condition, timeout)			\
> +({									\
> +	long __ret = timeout;						\
> +	if (!(condition)) {						\
> +		release_tty_lock(current);				\
> +		__wait_event_timeout(wq, condition, __ret);		\
> +		reacquire_tty_lock(current);				\
> +	}								\
> +	__ret;								\
> +})
> +
> +#define wait_event_interruptible_tty(wq, condition)			\
> +({									\
> +	int __ret = 0;							\
> +	if (!(condition)) {						\
> +		release_tty_lock(current);				\
> +		__wait_event_interruptible(wq, condition, __ret);	\
> +		reacquire_tty_lock(current);				\
> +	}								\
> +	__ret;								\
> +})
> +
> +#define wait_event_interruptible_timeout_tty(wq, condition, timeout)	\
> +({									\
> +	long __ret = timeout;						\
> +	if (!(condition)) {						\
> +		release_tty_lock(current);				\
> +		__wait_event_interruptible_timeout(wq, condition, __ret); \
> +		reacquire_tty_lock(current);				\
> +	}								\
> +	__ret;								\
> +})


Ouch, these helpers make me living again all the insane things I had to
do in reiserfs :-)

I first had doubts about this Big Tty Mutex (or whatever german meaning :-)
Because I thought this only carries the problem forward, or even
worst: now that it's not the bkl anymore, fewer people will even care about
removing this new big lock.

But now I actually think this is a good thing as every single tricky points
is underlined explicitly with these wait_event_tty, mutex_lock_tty, and so...
It's not anymore something released under us on schedule, it's not something
that might or might not be acquired recursively.
Removing this big lock later will then be easier as we can do it with more
granularity and visibility.

This is at least the experience I had with reiserfs. Its code _looks_
crappier than ever since 2.6.33, but it's a wrong appearance.
Now it shows which points require the reiserfs lock to be released because
there is an event dependency and it shows what are these dependencies.
The fact we can use lockdep in such a scheme plays a huge role btw.
Things are much clearer now, and I have even released some small areas
from the reiserfs lock because the explicit locking made it clear enough
to prove it fine.
If reiserfs wasn't obsolete, I would have probably pushed the effort further
to turn it into a granular locking, because the current state makes it
possible.

Now here we are talking about tty, and tty is not obsolete at all, so
I expect this is going to reach the current reiserfs level, plus a
subsequent and progressive state of locking granularity work, until
a complete exorcism.

FWIW, I'm all for this patchset.

