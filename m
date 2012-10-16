Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755779Ab2JPIIV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 04:08:21 -0400
Received: from relay.parallels.com ([195.214.232.42]:47333 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755696Ab2JPIIR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 04:08:17 -0400
Message-ID: <507D15EE.3020305@parallels.com>
Date: Tue, 16 Oct 2012 12:08:14 +0400
From: Stanislav Kinsbursky <skinsbursky@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: "peterz@infradead.org" <peterz@infradead.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@openvz.org" <devel@openvz.org>
Subject: Re: [RFC PATCH] posix timers: allocate timer id per task
References: <20121015161559.7806.72762.stgit@localhost.localdomain> <alpine.LFD.2.02.1210152105090.5541@ionos>
In-Reply-To: <alpine.LFD.2.02.1210152105090.5541@ionos>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

15.10.2012 23:08, Thomas Gleixner пишет:
> On Mon, 15 Oct 2012, Stanislav Kinsbursky wrote:
>
>> This patch is required CRIU project (www.criu.org).
>> To migrate processes with posix timers we have to make sure, that we can
>> restore posix timer with proper id.
>> Currently, this is not true, because timer ids are allocated globally.
>> So, this is precursor patch and it's purpose is make posix timer id to be
>> allocated per task.
>
> You can't allocate them per task. posix timers are process wide.
>

This is probably a misunderstanding.
I meant process process.

> What's the reason why you did not make the posix timer ids per name
> space instead of going down to the per process level ?
>

The reason is that CRIU have to support single processes regardless to namespaces.

>> Patch replaces global idr with global hash table for posix timers and
>> makes timer ids unique not globally, but per task. Next free timer id is type
>> of integer and stored on signal struct (posix_timer_id). If free timer id
>> reaches negative value on timer creation, it will be dropped to zero and
>> -EAGAIN will be returned to user.
>
> So you want to allow 2^31 posix timers created for a single process?
>

I don't really want it.
I just tried to preserve existent logic. I.e. currently one process can create 
2^31 posix timers (if no other processes tried to do the same).
But the amount can  be decreased, of course.

>> +static struct k_itimer *__posix_timers_find(struct hlist_head *head, struct signal_struct *sig, timer_t id)
>> +{
>> +	struct hlist_node *node;
>> +	struct k_itimer *timer;
>> +
>> +	hlist_for_each_entry(timer, node, head, t_hash) {
>> +		if ((timer->it_signal == sig) && (timer->it_id == id))
>> +			return timer;
>> +	}
>> +	return NULL;
>> +}
>> +
>> +static struct k_itimer *posix_timer_find(timer_t id, unsigned long *flags)
>> +{
>> +	struct k_itimer *timer;
>> +	struct signal_struct *sig = current->signal;
>> +	struct hlist_head *head = &posix_timers_hashtable[hash(sig, id)];
>> +
>> +	spin_lock_irqsave(&hash_lock, *flags);
>
> This is not going to fly. You just reintroduced a massive scalability
> problem. See commit 8af08871
>

Yep, Eric already pointed to it.
I'll try to fix this problem, if the idea with hash table suits in general.
Thanks.

> Thanks,
>
> 	tglx
>


-- 
Best regards,
Stanislav Kinsbursky
