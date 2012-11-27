Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755947Ab2K0XZY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 18:25:24 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:49922 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753092Ab2K0XZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 18:25:18 -0500
Date: Tue, 27 Nov 2012 15:25:16 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Lukas Czerner <lczerner@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, axboe@kernel.dk,
        jmoyer@redhat.com, Neil Brown <neilb@suse.de>,
        David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 1/2 v2] wait: add wait_event_lock_irq() interface
Message-Id: <20121127152516.ce512600.akpm@linux-foundation.org>
In-Reply-To: <1353572315-4508-1-git-send-email-lczerner@redhat.com>
References: <1353572315-4508-1-git-send-email-lczerner@redhat.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Nov 2012 09:18:34 +0100
Lukas Czerner <lczerner@redhat.com> wrote:

> New wait_event{_interruptible}_lock_irq{_cmd} macros added. This commit
> moves the private wait_event_lock_irq() macro from MD to regular wait
> includes, introduces new macro wait_event_lock_irq_cmd() instead of using
> the old method with omitting cmd parameter which is ugly and makes a use
> of new macros in the MD. It also introduces the _interruptible_ variant.
> 
> The use of new interface is when one have a special lock to protect data
> structures used in the condition, or one also needs to invoke "cmd"
> before putting it to sleep. "cmd" is always invoked before checking the
> "condition" so in case it will change the condition outcome we would not
> have to sleep unnecessarily.
> 
> All new macros are expected to be called with the lock taken. The lock
> is released before sleep and is reacquired afterwards. We will leave the
> macro with the lock held.
> 
> Note to DM: IMO this should also fix theoretical race on waitqueue while
> using simultaneously wait_event_lock_irq() and wait_event() because of
> lack of locking around current state setting and wait queue removal.
> 
> ...
>
> +#define __wait_event_lock_irq(wq, condition, lock, cmd)			\
> +do {									\
> +	DEFINE_WAIT(__wait);						\
> +									\
> +	cmd;								\
> +	for (;;) {							\
> +		prepare_to_wait(&wq, &__wait, TASK_UNINTERRUPTIBLE);	\
> +		if (condition)						\
> +			break;						\
> +		spin_unlock_irq(&lock);					\
> +		schedule();						\
> +		cmd;							\
> +		spin_lock_irq(&lock);					\
> +	}								\
> +	finish_wait(&wq, &__wait);					\
> +} while (0)
>
> ...
>
> +#define __wait_event_interruptible_lock_irq(wq, condition,		\
> +					    lock, ret, cmd)		\
> +do {									\
> +	DEFINE_WAIT(__wait);						\
> +									\
> +	cmd;								\
> +	for (;;) {							\
> +		prepare_to_wait(&wq, &__wait, TASK_INTERRUPTIBLE);	\
> +		if (condition)						\
> +			break;						\
> +		if (signal_pending(current)) {				\
> +			ret = -ERESTARTSYS;				\
> +			break;						\
> +		}							\
> +		spin_unlock_irq(&lock);					\
> +		schedule();						\
> +		cmd;							\
> +		spin_lock_irq(&lock);					\
> +	}								\
> +	finish_wait(&wq, &__wait);					\
> +} while (0)

These could be combined - use

	if (flags == TASK_INTERRUPTIBLE && signal_pending(current)) {	\
		ret = -ERESTARTSYS;					\
		break;							\
	}								\

and the compiler will fully remove that code for the
__wait_event_lock_irq() case.

But that's all a pretty small gain, IMO.


