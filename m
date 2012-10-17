Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757230Ab2JQO0R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 10:26:17 -0400
Received: from relay.parallels.com ([195.214.232.42]:41580 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757069Ab2JQO0Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 10:26:16 -0400
Message-ID: <507EC005.5070301@parallels.com>
Date: Wed, 17 Oct 2012 18:26:13 +0400
From: Stanislav Kinsbursky <skinsbursky@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: "peterz@infradead.org" <peterz@infradead.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@openvz.org" <devel@openvz.org>
Subject: Re: [RFC PATCH v2] posix timers: allocate timer id per task
References: <20121017131732.8781.75295.stgit@localhost.localdomain> <1350482246.26103.487.camel@edumazet-glaptop>
In-Reply-To: <1350482246.26103.487.camel@edumazet-glaptop>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

17.10.2012 17:57, Eric Dumazet пишет:
> On Wed, 2012-10-17 at 17:18 +0400, Stanislav Kinsbursky wrote:
>
>> +static int posix_timer_add(struct k_itimer *timer)
>> +{
>> +	struct signal_struct *sig = current->signal;
>> +	int next_free_id = sig->posix_timer_id;
>> +	struct hlist_head *head;
>> +	int ret = -ENOENT;
>> +
>> +	do {
>> +		spin_lock(&hash_lock);
>> +		head = &posix_timers_hashtable[hash(sig, sig->posix_timer_id)];
>> +		if (__posix_timers_find(head, sig, sig->posix_timer_id) == NULL) {
>> +			hlist_add_head_rcu(&timer->t_hash, head);
>
> Hmm...
>
>> +			ret = sig->posix_timer_id++;
>> +		} else {
>> +			if (++sig->posix_timer_id < 0)
>> +				sig->posix_timer_id = 0;
>> +			if (sig->posix_timer_id == next_free_id)
>> +				ret = -EAGAIN;
>> +		}
>> +		spin_unlock(&hash_lock);
>> +	} while (ret == -ENOENT);
>> +	return ret;
>> +}
>> +
>
> You probably need to add a rcu_assign_pointer() or smp_wmb() before
> the :
>
> new_timer->it_signal = current->signal;
>
> in the following block :
>
>          spin_lock_irq(&current->sighand->siglock);
>          new_timer->it_signal = current->signal;
>          list_add(&new_timer->list, &current->signal->posix_timers);
>          spin_unlock_irq(&current->sighand->siglock);
>
> Or else another thread can read outdated informations...
>
>
>          spin_lock_irq(&current->sighand->siglock);
>          list_add(&new_timer->list, &current->signal->posix_timers);
>          spin_unlock_irq(&current->sighand->siglock);
> 	smp_wmb();
>          new_timer->it_signal = current->signal;
>
>

Sorry, but I don't understand what races you are talking about.
Could you specify, please?

-- 
Best regards,
Stanislav Kinsbursky
