Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753959Ab0JUIjc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 04:39:32 -0400
Received: from smtp-out.google.com ([216.239.44.51]:4328 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753262Ab0JUIja convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 04:39:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=OV8EJECXnjOKas4Lm7zJJkfsdvaBJi5MrOxsqdp6+IaZRSkc87v2gqsxcQH531JG/2
         9TXHrwbnNT54V1nPi5pw==
MIME-Version: 1.0
In-Reply-To: <20101021080844.GB3581@in.ibm.com>
References: <20101016044349.830426011@google.com> <20101016045118.529238208@google.com>
 <20101021080844.GB3581@in.ibm.com>
From: Paul Turner <pjt@google.com>
Date: Thu, 21 Oct 2010 01:38:56 -0700
Message-ID: <AANLkTimHW5Rd42ERzsPf6MsoehS8Y5M2e1CiPX3rcfYP@mail.gmail.com>
Subject: Re: [RFC tg_shares_up improvements - v1 01/12] sched: rewrite tg_shares_up
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

On Thu, Oct 21, 2010 at 1:08 AM, Bharata B Rao
<bharata@linux.vnet.ibm.com> wrote:
> On Fri, Oct 15, 2010 at 09:43:50PM -0700, pjt@google.com wrote:
>> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
>> --- kernel/sched_fair.c.orig
>> +++ kernel/sched_fair.c
>> @@ -417,7 +417,6 @@ int sched_proc_update_handler(struct ctl
>>       WRT_SYSCTL(sched_min_granularity);
>>       WRT_SYSCTL(sched_latency);
>>       WRT_SYSCTL(sched_wakeup_granularity);
>> -     WRT_SYSCTL(sched_shares_ratelimit);
>>  #undef WRT_SYSCTL
>>
>>       return 0;
>> @@ -633,7 +632,6 @@ account_entity_enqueue(struct cfs_rq *cf
>>               list_add(&se->group_node, &cfs_rq->tasks);
>>       }
>>       cfs_rq->nr_running++;
>> -     se->on_rq = 1;
>>  }
>>
>>  static void
>> @@ -647,9 +645,89 @@ account_entity_dequeue(struct cfs_rq *cf
>>               list_del_init(&se->group_node);
>>       }
>>       cfs_rq->nr_running--;
>> -     se->on_rq = 0;
>>  }
>>
> <snip>
>> @@ -771,7 +849,9 @@ enqueue_entity(struct cfs_rq *cfs_rq, st
>>        * Update run-time statistics of the 'current'.
>>        */
>>       update_curr(cfs_rq);
>> +     update_cfs_load(cfs_rq);
>>       account_entity_enqueue(cfs_rq, se);
>> +     update_cfs_shares(cfs_rq_of(se));
>>
>>       if (flags & ENQUEUE_WAKEUP) {
>>               place_entity(cfs_rq, se, 0);
>> @@ -782,6 +862,7 @@ enqueue_entity(struct cfs_rq *cfs_rq, st
>>       check_spread(cfs_rq, se);
>>       if (se != cfs_rq->curr)
>>               __enqueue_entity(cfs_rq, se);
>> +     se->on_rq = 1;
>>  }
>>
>>  static void __clear_buddies(struct cfs_rq *cfs_rq, struct sched_entity *se)
>> @@ -825,8 +906,11 @@ dequeue_entity(struct cfs_rq *cfs_rq, st
>>
>>       if (se != cfs_rq->curr)
>>               __dequeue_entity(cfs_rq, se);
>> +     se->on_rq = 0;
>
> Since setting and un-setting of se->on_rq is completely handled within
> sched_fair.c, we can remove the redundant setting and un-setting of
> se->on_rq from sched.c:[en]dequeue_task. Even w/o this patch, they were
> redundant I suppose.

Mmmm I think SCHED_RT (currently) depends on this, it could probably
cleaned up in a separate patch.

>
> Regards,
> Bharata.
>
