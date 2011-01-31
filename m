Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754437Ab1AaXjY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 18:39:24 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52280 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754269Ab1AaXjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 18:39:22 -0500
Date: Mon, 31 Jan 2011 15:38:31 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, Greg KH <greg@kroah.com>,
        Tony Lindgren <tony@atomide.com>, Benoit Cousson <b-cousson@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>, Suman Anna <s-anna@ti.com>,
        Kevin Hilman <khilman@ti.com>, Arnd Bergmann <arnd@arndb.de>,
        Paul Walmsley <paul@pwsan.com>,
        Hari Kanigeri <hari.kanigeri@gmail.com>,
        Simon Que <simonque@gmail.com>
Subject: Re: [PATCH v4 1/4] drivers: hwspinlock: add framework
Message-Id: <20110131153831.dca62146.akpm@linux-foundation.org>
In-Reply-To: <1296470024-26854-2-git-send-email-ohad@wizery.com>
References: <1296470024-26854-1-git-send-email-ohad@wizery.com>
	<1296470024-26854-2-git-send-email-ohad@wizery.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 31 Jan 2011 12:33:41 +0200
Ohad Ben-Cohen <ohad@wizery.com> wrote:

> Add a platform-independent hwspinlock framework.
> 
> Hardware spinlock devices are needed, e.g., in order to access data
> that is shared between remote processors, that otherwise have no
> alternative mechanism to accomplish synchronization and mutual exclusion
> operations.
> 
> Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
> Cc: Hari Kanigeri <h-kanigeri2@ti.com>
> Cc: Benoit Cousson <b-cousson@ti.com>
> Cc: Kevin Hilman <khilman@ti.com>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Paul Walmsley <paul@pwsan.com>
> Acked-by: Tony Lindgren <tony@atomide.com>
> ---
>  Documentation/hwspinlock.txt         |  299 ++++++++++++++++++
>  drivers/Kconfig                      |    2 +
>  drivers/Makefile                     |    2 +
>  drivers/hwspinlock/Kconfig           |   13 +
>  drivers/hwspinlock/Makefile          |    5 +
>  drivers/hwspinlock/hwspinlock.h      |   61 ++++
>  drivers/hwspinlock/hwspinlock_core.c |  557 ++++++++++++++++++++++++++++++++++
>  include/linux/hwspinlock.h           |  298 ++++++++++++++++++

It's a little irritating having two hwspinlock.h's. 
hwspinlock_internal.h wold be a conventional approach.  But it's not a
big deal.

>
> ...
>
> +/*
> + * A radix tree is used to maintain the available hwspinlock instances.
> + * The tree associates hwspinlock pointers with their integer key id,
> + * and provides easy-to-use API which makes the hwspinlock core code simple
> + * and easy to read.
> + *
> + * Radix trees are quick on lookups, and reasonably efficient in terms of
> + * storage, especially with high density usages such as this framework
> + * requires (a continuous range of integer keys, beginning with zero, is
> + * used as the ID's of the hwspinlock instances).
> + *
> + * The radix tree API supports tagging items in the tree, which this
> + * framework uses to mark unused hwspinlock instances (see the
> + * HWSPINLOCK_UNUSED tag above). As a result, the process of querying the
> + * tree, looking for an unused hwspinlock instance, is now reduced to a
> + * single radix tree API call.
> + */

Nice comment!

> +static RADIX_TREE(hwspinlock_tree, GFP_KERNEL);
> +
>
> ...
>
> +/**
> + * __hwspin_lock_timeout() - lock an hwspinlock with timeout limit
> + * @hwlock: the hwspinlock to be locked
> + * @timeout: timeout value in jiffies

hm, why in jiffies?

The problem here is that lazy programmers will use

	hwspin_lock_timeout(lock, 10, ...)

and their code will work happily with HZ=100 but will explode with HZ=1000.

IOW, this interface *requires* that all callers perform a
seconds-to-jiffies conversion before calling hwspin_lock_timeout().  So
why not reduce their effort and their ability to make mistakes by
defining the API to take seconds?


> + * @mode: mode which controls whether local interrupts are disabled or not
> + * @flags: a pointer to where the caller's interrupt state will be saved at (if
> + *         requested)
> + *
> + * This function locks the given @hwlock. If the @hwlock
> + * is already taken, the function will busy loop waiting for it to
> + * be released, but give up when @timeout jiffies have elapsed. If @timeout
> + * is %MAX_SCHEDULE_TIMEOUT, the function will never give up (therefore if a
> + * faulty remote core never releases the @hwlock, it will deadlock).
> + *
> + * Upon a successful return from this function, preemption is disabled
> + * (and possibly local interrupts, too), so the caller must not sleep,
> + * and is advised to release the hwspinlock as soon as possible.
> + * This is required in order to minimize remote cores polling on the
> + * hardware interconnect.
> + *
> + * The user decides whether local interrupts are disabled or not, and if yes,
> + * whether he wants their previous state to be saved. It is up to the user
> + * to choose the appropriate @mode of operation, exactly the same way users
> + * should decide between spin_lock, spin_lock_irq and spin_lock_irqsave.
> + *
> + * Returns 0 when the @hwlock was successfully taken, and an appropriate
> + * error code otherwise (most notably -ETIMEDOUT if the @hwlock is still
> + * busy after @timeout meets jiffies). The function will never sleep.
> + */
>
> ...
>

