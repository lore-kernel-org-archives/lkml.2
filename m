Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755303Ab0I2TCn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 15:02:43 -0400
Received: from smtp-out.google.com ([216.239.44.51]:39099 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754339Ab0I2TCl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 15:02:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=gRAb4/7KMJgEPn29Dj8yMXJC+EFCb/d3kjEPWhvx0Ob9KXrRRuODD4GkCEZe61kVAQ
         +nT8JYB2BZLflPlVLiyA==
MIME-Version: 1.0
In-Reply-To: <1285747995.7844.42.camel@marge.simson.net>
References: <1285742774-5013-1-git-send-email-dima@android.com>
	<1285747995.7844.42.camel@marge.simson.net>
Date: Wed, 29 Sep 2010 12:02:33 -0700
X-Google-Sender-Auth: VwIxSpj4-lD4o-MGhC-iFyk2srk
Message-ID: <AANLkTimF+_okjY7n878f_D=HKbRn=W0=RMQ_WphADL1s@mail.gmail.com>
Subject: Re: [PATCH 1/2] sched: normalize sleeper's vruntime during group change
From: Dima Zavin <dima@android.com>
To: Mike Galbraith <efault@gmx.de>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>,
        =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 29, 2010 at 1:13 AM, Mike Galbraith <efault@gmx.de> wrote:
> On Tue, 2010-09-28 at 23:46 -0700, Dima Zavin wrote:
>> This adds a new callback, prep_move_task, to struct sched_class
>> to give sched_fair the opportunity to adjust the task's vruntime
>> just before setting its new group.
>>
>> This allows us to properly normalize a sleeping task's vruntime
>> when moving it between different cgroups.
>
>
>> diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
>> index db3f674..008fe57 100644
>> --- a/kernel/sched_fair.c
>> +++ b/kernel/sched_fair.c
>> @@ -3827,10 +3827,23 @@ static void set_curr_task_fair(struct rq *rq)
>>  static void moved_group_fair(struct task_struct *p, int on_rq)
>>  {
>>       struct cfs_rq *cfs_rq = task_cfs_rq(p);
>> +     struct sched_entity *se = &p->se;
>>
>>       update_curr(cfs_rq);
>> -     if (!on_rq)
>> +     if (!on_rq) {
>> +             se->vruntime += cfs_rq->min_vruntime;
>>               place_entity(cfs_rq, &p->se, 1);
>> +     }
>> +}
>
> I'm still missing the place_entity() rationale.  Why is a sleeping task
> eligible for pain therapy that a runnable task is spared?  That state
> can change a usec from now.

I see your point, and I can't think of a reason why we'd want to
penalize the sleeper with START_DEBIT,
but now I am wondering why it was there in the first place.

--Dima
