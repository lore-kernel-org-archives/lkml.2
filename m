Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752876Ab0DKT1i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Apr 2010 15:27:38 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:17865 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752693Ab0DKT1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Apr 2010 15:27:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:references:x-url:x-pgp-fp:x-pgp:date
         :in-reply-to:message-id:user-agent:mime-version:content-type;
        b=Ok7UG2rxajoUZM3KomeJPSPq6DIWY01vbuFlL1xyDGq+urID7vlh2TpZBwqmLAaa02
         ftShOHov2Dfi2IrSkuPHHS8H3ZTzYzFRI9j1LRI/3WBbDmicLmD8W32Ym2pAq1+XeJSD
         i16h4yzb68TvmIMXHt91L87sCfieQn9++vaHI=
From: Michal Nazarewicz <mina86@mina86.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Michal Nazarewicz <m.nazarewicz@samsung.com>, linux-usb@vger.kernel.org,
       Davide Libenzi <davidel@xmailserver.org>, Greg KH <greg@kroah.com>,
       Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 1/8] wait_event_interruptible_locked() interface
References: <cover.1270835924.git.mina86@mina86.com>
	<3baf39971e1f49e98498f5d00e21df4302396252.1270835924.git.mina86@mina86.com>
	<alpine.LFD.2.00.1004111638240.32352@localhost.localdomain>
X-Url: http://mina86.com/
X-PGP-FP: 9134 06FA 7AD8 D134 9D0C  C33F 532C CB00 B7C6 DF1E
X-PGP: B7C6DF1E
Date: Sun, 11 Apr 2010 21:27:31 +0200
In-Reply-To: <alpine.LFD.2.00.1004111638240.32352@localhost.localdomain>
	(Thomas Gleixner's message of "Sun, 11 Apr 2010 17:02:24 +0200
	(CEST)")
Message-ID: <87k4sdlrh8.fsf@erwin.mina86.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (Slckware Linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, 9 Apr 2010, Michal Nazarewicz wrote:
>> New wait_event_interruptible{,_exclusive}_locked{,_irq,_irqsave}
>> macros added.  They work just like versions without _locked* suffix

Thomas Gleixner <tglx@linutronix.de> writes:
> The _irqsave variant is really not necessary. It's actively wrong.
>
> If you go to wait then the state _before_ acquiring the waitqueue head
> lock must be irqs enabled. Otherwise you would schedule with
> interrupts disabled after the unlock_irqrestore which is a BUG.
>
> So if there is code which uses spin_lock_irqsave() in the wait path
> then this code is wrong and needs to be fixed to spin_(un)lock_irq()
> first instead of adding a bogus interface.

I haven't seen the big picture here.  Thanks for pointing that out.

>> +
>> +#define __wait_event_interruptible_locked(wq, condition, ret, exclusive, lock, unlock, lock_args) \
>
> That will also simplify this to (wq, condition, exclusive, lockmode)
>
>> +do {									\
>> +	DEFINE_WAIT(__wait);						\
>> +									\
>> +	if (exclusive)							\
>> +		__wait.flags |= WQ_FLAG_EXCLUSIVE;			\
>> +	else								\
>> +		__wait.flags &= ~WQ_FLAG_EXCLUSIVE;			\
>> +	__add_wait_queue_tail(&(wq), &__wait);				\
>> +									\
>> +	do {								\
>> +		set_current_state(TASK_INTERRUPTIBLE);			\
>> +		if (signal_pending(current)) {				\
>> +			ret = -ERESTARTSYS;				\
>> +			break;						\
>> +		}							\
>> +		spin_unlock ##unlock lock_args;				\
>> +		schedule();						\
>> +		spin_lock ##lock lock_args;				\
>> +	} while (!(condition));						\
>> +	__remove_wait_queue(&(wq), &__wait);				\
>> +	__set_current_state(TASK_RUNNING);				\
>> +} while (0)
>> +
>> +
>> +/**
>> + * wait_event_interruptible_locked - sleep until a condition gets true
>> + * @wq: the waitqueue to wait on
>> + * @condition: a C expression for the event to wait for
>> + *
>> + * The process is put to sleep (TASK_INTERRUPTIBLE) until the
>> + * @condition evaluates to true or a signal is received.
>> + * The @condition is checked each time the waitqueue @wq is woken up.
>> + *
>> + * It must be called with wq.lock being held.  This spinlock is
>> + * unlocked while sleeping but @condition testing is done while lock
>> + * is held and when this macro exits the lock is held.
>> + *
>> + * The lock is locked/unlocked using spin_lock()/spin_unlock()
>> + * functions which must match the way they are locked/unlocked outside
>> + * of this macro.
>> + *
>> + * wake_up_locked() has to be called after changing any variable that could
>> + * change the result of the wait condition.
>> + *
>> + * The function will return -ERESTARTSYS if it was interrupted by a
>> + * signal and 0 if @condition evaluated to true.
>> + */
>> +#define wait_event_interruptible_locked(wq, condition)			\
>> +({									\
>> +	int __ret = 0;							\
>> +	if (!(condition))						\
>> +		__wait_event_interruptible_locked(wq, condition, __ret, 0, , , (&(wq).lock)); \
>
>   I had to look more than once to figure out how that code might
>   return anything else than 0. Can we please change that to
>
>   if (!(condition))
>      __ret = __wait_.....();
>
>   to make that less confusing ?   

That's really how the rest of the wait_event*() macros are done so I'd
prefer to stack with the rest of the code.

>> +	__ret;								\
>> +})

Again, I'll resend the patches by the end of the week.

-- 
Best regards,                                         _     _
 .o. | Liege of Serenly Enlightened Majesty of      o' \,=./ `o
 ..o | Computer Science,  Michal "mina86" Nazarewicz   (o o)
 ooo +--<mina86-tlen.pl>--<jid:mina86-jabber.org>--ooO--(_)--Ooo--
