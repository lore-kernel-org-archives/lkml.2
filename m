Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753778Ab0LTHHM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 02:07:12 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:64156 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753668Ab0LTHHK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 02:07:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Ojt8uKeXrvuEehRPgyLO2bW14akrQWNLimPHwykcvg4gRMzRNPjqRxgpw0qeWQ8iks
         oHYGgESBoVI3pUKBZNFMIqUc67QLkfwrlNTR5jKrKFcOKuwQQaaKZpYXazrBh7OsL5KS
         ZeFdJMWvARp42tJBGE7lvBOniK/CCVg1KgC58=
MIME-Version: 1.0
In-Reply-To: <1292762975.2403.29.camel@localhost>
References: <1292762975.2403.29.camel@localhost>
Date: Mon, 20 Dec 2010 15:07:09 +0800
Message-ID: <AANLkTimYx2Og1BG37wb0WZ0_U8WJjLKHMKgU45qycUaM@mail.gmail.com>
Subject: Re: [PATCH] kthread_worker: Initialize dynamically allocated spinlock
 properly for lockdep
From: Yong Zhang <yong.zhang0@gmail.com>
To: Andy Walls <awalls@md.metrocast.net>
Cc: linux-kernel@vger.kernel.org, nicolas.mailhot@laposte.net,
        Tejun Heo <tj@kernel.org>, Jarod Wilson <jarod@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 19, 2010 at 8:49 PM, Andy Walls <awalls@md.metrocast.net> wrote:
> init_kthread_worker(), via KTHREAD_WORKER_INIT(), used an
> initializer for static spin_lock objects, SPIN_LOCK_UNLOCKED, on
> a dynamically allocated kthread_worker object's internal spinlock_t.
> This causes lockdep to gripe:
>
>        INFO: trying to register non-static key.
>        the code is fine but needs lockdep annotation.
>        turning off the locking correctness validator.
>
> To keep lockdep happy, use spin_lock_init() for dynamically
> allocated kthread_worker objects' internal spinlock_t.
>
> Reported-by: Nicolas <nicolas.mailhot@laposte.net>
> Signed-off-by: Andy Walls <awalls@md.metrocast.net>
>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Jarod Wilson <jarod@redhat.com>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
> Cc: Hans Verkuil <hverkuil@xs4all.nl>
>
> diff --git a/include/linux/kthread.h b/include/linux/kthread.h
> index 685ea65..e65d0b1 100644
> --- a/include/linux/kthread.h
> +++ b/include/linux/kthread.h
> @@ -83,7 +83,13 @@ struct kthread_work {
>
>  static inline void init_kthread_worker(struct kthread_worker *worker)
>  {
> -       *worker = (struct kthread_worker)KTHREAD_WORKER_INIT(*worker);
> +       /*
> +        * Lockdep complains if a dynamically allocated worker's spinlock_t
> +        * is initialzed using SPIN_LOCK_UNLOCKED.
> +        */
> +       spin_lock_init(&worker->lock);

This will make different kthead_worker->lock initialized with one same
key. You know spin_lock_init() will be like below:
# define raw_spin_lock_init(lock)				\
do {								\
	static struct lock_class_key __key;			\
								\
	__raw_spin_lock_init((lock), #lock, &__key);		\
} while (0)

So we should put the real initializer to kernel/kthread.c
and make init_kthread_worker() to be a MACRO.

BTW, init_kthread_work() should also be changed like above
because member done is a wait_queue_head.

Thanks,
Yong

-- 
Only stand for myself.
