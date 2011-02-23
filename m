Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755837Ab1BWCUk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 21:20:40 -0500
Received: from smtp-out.google.com ([216.239.44.51]:46300 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753475Ab1BWCUj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 21:20:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=MY/zVtftfAVVkSd7HLBxUm/+fAvY2IgHjaNs1lpWDXSE7ar6zYtJSYItINBVVDcpfj
         F3qnpniJD2BTuGdf9MNQ==
MIME-Version: 1.0
In-Reply-To: <4D646AC0.7030809@jp.fujitsu.com>
References: <20110216031831.571628191@google.com> <20110216031841.352204682@google.com>
 <4D646AC0.7030809@jp.fujitsu.com>
From: Paul Turner <pjt@google.com>
Date: Tue, 22 Feb 2011 18:20:05 -0800
Message-ID: <AANLkTim3P-0EbFqKpH-A8OMjc9L0+ppqtW8M-YazHVtp@mail.gmail.com>
Subject: Re: [CFS Bandwidth Control v4 6/7] sched: hierarchical task
 accounting for SCHED_OTHER
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval@linux.vnet.ibm.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Gautham R Shenoy <ego@in.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Pavel Emelyanov <xemul@openvz.org>,
        Herbert Poetzl <herbert@13thfloor.at>, Avi Kivity <avi@redhat.com>,
        Chris Friesen <cfriesen@nortel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 22, 2011 at 6:02 PM, Hidetoshi Seto
<seto.hidetoshi@jp.fujitsu.com> wrote:
> (2011/02/16 12:18), Paul Turner wrote:
>> @@ -1428,6 +1464,7 @@ enqueue_task_fair(struct rq *rq, struct
>>               update_cfs_shares(cfs_rq);
>>       }
>>
>> +     account_hier_tasks(&p->se, 1);
>>       hrtick_update(rq);
>>  }
>>
>> @@ -1461,6 +1498,7 @@ static void dequeue_task_fair(struct rq
>>               update_cfs_shares(cfs_rq);
>>       }
>>
>> +     account_hier_tasks(&p->se, -1);
>>       hrtick_update(rq);
>>  }
>>
>
> Why hrtick_update() is need to be delayed after modifying nr_running?
> You should not impact current hrtick logic without once mentioning.

There shouldn't be any impact -- hrtick_update only cares about
cfs_rq->nr_running which is independent of rq->nr_running (maintained
by hierarchal accounting)

>
>> Index: tip/kernel/sched_rt.c
>> ===================================================================
>> --- tip.orig/kernel/sched_rt.c
>> +++ tip/kernel/sched_rt.c
>> @@ -906,6 +906,8 @@ enqueue_task_rt(struct rq *rq, struct ta
>>
>>       if (!task_current(rq, p) && p->rt.nr_cpus_allowed > 1)
>>               enqueue_pushable_task(rq, p);
>> +
>> +     inc_nr_running(rq);
>>  }
>>
>>  static void dequeue_task_rt(struct rq *rq, struct task_struct *p, int flags)
>> @@ -916,6 +918,8 @@ static void dequeue_task_rt(struct rq *r
>>       dequeue_rt_entity(rt_se);
>>
>>       dequeue_pushable_task(rq, p);
>> +
>> +     dec_nr_running(rq);
>>  }
>>
>>  /*
>
> I think similar change for sched_stoptask.c is required.

Aha!

Yes, I missed this addition when re-basing.

It is needed since when something is placed into the stop-class via
set_sched it goes through an activate/deactivate.

Will add, thanks!

>
> In fact I could not boot tip/master with this v4 patchset.
> It reports rcu stall warns without applying following tweak:
>
> --- a/kernel/sched_stoptask.c
> +++ b/kernel/sched_stoptask.c
> @@ -35,11 +35,13 @@ static struct task_struct *pick_next_task_stop(struct rq *rq
>  static void
>  enqueue_task_stop(struct rq *rq, struct task_struct *p, int flags)
>  {
> +       inc_nr_running(rq);
>  }
>
>  static void
>  dequeue_task_stop(struct rq *rq, struct task_struct *p, int flags)
>  {
> +       dec_nr_running(rq);
>  }
>
>
> Thanks,
> H.Seto
>
>
