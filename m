Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756990Ab1F1OoA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 10:44:00 -0400
Received: from relay.parallels.com ([195.214.232.42]:55458 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758170Ab1F1OnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 10:43:00 -0400
Message-ID: <4E09E871.8040600@parallels.com>
Date: Tue, 28 Jun 2011 18:42:57 +0400
From: Konstantin Khlebnikov <khlebnikov@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.18) Gecko/20110416 SeaMonkey/2.0.13
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jaxboe@fusionio.com" <jaxboe@fusionio.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        "jmoyer@redhat.com" <jmoyer@redhat.com>
Subject: Re: [RFC PATCH 0/3] block: Fix fsync slowness with CFQ cgroups
References: <1309205864-13124-1-git-send-email-vgoyal@redhat.com> <4E09B457.9050800@parallels.com> <20110628134500.GD17552@redhat.com>
In-Reply-To: <20110628134500.GD17552@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
> On Tue, Jun 28, 2011 at 03:00:39PM +0400, Konstantin Khlebnikov wrote:
>> Vivek Goyal wrote:
>>> This patch series seems to be working for me. I did testing for ext4 only.
>>> This series is based on for-3.1/core branch of Jen's block tree.
>>> Konstantin, can you please give it a try and see if it fixes your
>>> issue.
>>
>> It works for me too, for ext3 and ext4, on top 3.0-rc5, after these trivial fixes:
>>
>> --- a/block/cfq-iosched.c
>> +++ b/block/cfq-iosched.c
>> @@ -1511,7 +1519,7 @@ static void cfq_add_rq_rb(struct request *rq)
>>           * if that happens, put the alias on the dispatch list
>>           */
>>          while ((__alias = elv_rb_add(&cfqq->sort_list, rq)) != NULL)
>> -               cfq_dispatch_insert(cfqd->queue, __alias);
>> +               cfq_dispatch_insert(cfqd->queue, __alias, false);
>>
>>          if (!cfq_cfqq_on_rr(cfqq))
>>                  cfq_add_cfqq_rr(cfqd, cfqq);
>> @@ -3797,12 +3797,11 @@ cfq_set_depends_on_task(struct request_queue *q, struct task_struct *tsk)
>>           */
>>          rcu_read_lock();
>>          if (task_blkio_cgroup(current) == task_blkio_cgroup(tsk))
>> -               return;
>> -       rcu_read_unlock();
>> +               goto out_unlock_rcu;
>>
>>          cic = cfq_cic_lookup(cfqd, current->io_context);
>>          if (!cic)
>> -               return;
>> +               goto out_unlock_rcu;
>
> You have done this change because you want to keep cfq_cic_lookup() also
> in rcu read side critical section? I am assuming that it works even
> without this. Though keeping it under rcu is probably more correct as
> cic objects are freed in rcu manner.

No, your just forgot to relese rcu in case task_blkio_cgroup(current) == task_blkio_cgroup(tsk)

>
> Thanks
> Vivek

