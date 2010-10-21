Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756836Ab0JUSZj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 14:25:39 -0400
Received: from smtp-out.google.com ([74.125.121.35]:12886 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753982Ab0JUSZi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 14:25:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=p50UwHej/mNulWmy6oReYV6vyeMYGF+gE5vVgUimYs0V56xVh+9eUNOGgBVPAASQhi
         5F7/ElSYEgOTsyHzjkKQ==
MIME-Version: 1.0
In-Reply-To: <20101021095221.GC3581@in.ibm.com>
References: <20101016044349.830426011@google.com> <20101016045118.832209343@google.com>
 <20101021095221.GC3581@in.ibm.com>
From: Paul Turner <pjt@google.com>
Date: Thu, 21 Oct 2010 11:25:04 -0700
Message-ID: <AANLkTimZK2mHvHRk-iaBZpEkZ1MYooP24y6HetsJo0br@mail.gmail.com>
Subject: Re: [RFC tg_shares_up improvements - v1 05/12] sched: fix
 update_cfs_load synchronization
To: bharata@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>, Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Chris Friesen <cfriesen@nortel.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Pierre Bourdon <pbourdon@excellency.fr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 21, 2010 at 2:52 AM, Bharata B Rao
<bharata@linux.vnet.ibm.com> wrote:
> On Fri, Oct 15, 2010 at 09:43:54PM -0700, pjt@google.com wrote:
>> Using cfs_rq->nr_running is not sufficient to synchronize update_cfs_load with
>> the put path since nr_running accounting occurs at deactivation.
>>
>> It's also not safe to make the removal decision based on load_avg as this fails
>> with both high periods and low shares.  Resolve this by clipping history at 8
>> foldings.
>>
>
> Did you mean 4 foldings (and not 8) above since I see you are truncating
> the load history at 4 idle periods ?

We end up folding every period/2 (after the first fold) since after
that we start at period/2 and not 0.

Thus, if we were issuing 'continuous' load updates triggering this
condition would mean that we had folded idle periods into our load_avg
8 times.

Granted, it's possible for there to be less folds given sporadic load
updates so I'll just update the comment to reference periods.

Thanks

>
>
>> @@ -685,9 +686,19 @@ static void update_cfs_load(struct cfs_r
>>       now = rq_of(cfs_rq)->clock;
>>       delta = now - cfs_rq->load_stamp;
>>
>> +     /* truncate load history at 4 idle periods */
>> +     if (cfs_rq->load_stamp > cfs_rq->load_last &&
>> +         now - cfs_rq->load_last > 4 * period) {
>> +             cfs_rq->load_period = 0;
>> +             cfs_rq->load_avg = 0;
>> +     }
>> +
>>       cfs_rq->load_stamp = now;
>>       cfs_rq->load_period += delta;
>> -     cfs_rq->load_avg += delta * cfs_rq->load.weight;
>> +     if (load) {
>> +             cfs_rq->load_last = now;
>> +             cfs_rq->load_avg += delta * load;
>> +     }
>>
>>       while (cfs_rq->load_period > period) {
>>               /*
>> @@ -700,10 +711,8 @@ static void update_cfs_load(struct cfs_r
>>               cfs_rq->load_avg /= 2;
>>       }
>>
>> -     if (lb && !cfs_rq->nr_running) {
>> -             if (cfs_rq->load_avg < (period / 8))
>> -                     list_del_leaf_cfs_rq(cfs_rq);
>> -     }
>> +     if (!cfs_rq->curr && !cfs_rq->nr_running && !cfs_rq->load_avg)
>> +             list_del_leaf_cfs_rq(cfs_rq);
>>  }
>>
>
