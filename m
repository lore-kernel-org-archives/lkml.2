Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757086Ab2JQN5d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 09:57:33 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:39091 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757067Ab2JQN5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 09:57:32 -0400
Subject: Re: [RFC PATCH v2] posix timers: allocate timer id per task
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: peterz@infradead.org, mingo@redhat.com, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, devel@openvz.org
In-Reply-To: <20121017131732.8781.75295.stgit@localhost.localdomain>
References: <20121017131732.8781.75295.stgit@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 17 Oct 2012 15:57:26 +0200
Message-ID: <1350482246.26103.487.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-10-17 at 17:18 +0400, Stanislav Kinsbursky wrote:

> +static int posix_timer_add(struct k_itimer *timer)
> +{
> +	struct signal_struct *sig = current->signal;
> +	int next_free_id = sig->posix_timer_id;
> +	struct hlist_head *head;
> +	int ret = -ENOENT;
> +
> +	do {
> +		spin_lock(&hash_lock);
> +		head = &posix_timers_hashtable[hash(sig, sig->posix_timer_id)];
> +		if (__posix_timers_find(head, sig, sig->posix_timer_id) == NULL) {
> +			hlist_add_head_rcu(&timer->t_hash, head);

Hmm...

> +			ret = sig->posix_timer_id++;
> +		} else {
> +			if (++sig->posix_timer_id < 0)
> +				sig->posix_timer_id = 0;
> +			if (sig->posix_timer_id == next_free_id)
> +				ret = -EAGAIN;
> +		}
> +		spin_unlock(&hash_lock);
> +	} while (ret == -ENOENT);
> +	return ret;
> +}
> +

You probably need to add a rcu_assign_pointer() or smp_wmb() before
the :

new_timer->it_signal = current->signal;

in the following block :

        spin_lock_irq(&current->sighand->siglock);
        new_timer->it_signal = current->signal;
        list_add(&new_timer->list, &current->signal->posix_timers);
        spin_unlock_irq(&current->sighand->siglock);

Or else another thread can read outdated informations...


        spin_lock_irq(&current->sighand->siglock);
        list_add(&new_timer->list, &current->signal->posix_timers);
        spin_unlock_irq(&current->sighand->siglock);
	smp_wmb();
        new_timer->it_signal = current->signal;


