Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510Ab1FHFzp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 01:55:45 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:34787 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751620Ab1FHFzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 01:55:44 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DEF0EB5.1090703@jp.fujitsu.com>
Date: Wed, 08 Jun 2011 14:55:01 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; ja; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Paul Turner <pjt@google.com>
CC: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>
Subject: Re: Test for CFS Bandwidth Control V6
References: <20110323030326.789836913@google.com> <4DD5CE05.3030500@cn.fujitsu.com> <4DDB0199.6030805@jp.fujitsu.com> <BANLkTikPrs7b-QVoZZwerbHnCHpStgKj9w@mail.gmail.com>
In-Reply-To: <BANLkTikPrs7b-QVoZZwerbHnCHpStgKj9w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/06/08 11:54), Paul Turner wrote:
> On Mon, May 23, 2011 at 5:53 PM, Hidetoshi Seto
> <seto.hidetoshi@jp.fujitsu.com> wrote:
>
>> diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
>> index 3936393..544072f 100644
>> --- a/kernel/sched_fair.c
>> +++ b/kernel/sched_fair.c
>> @@ -1537,7 +1537,7 @@ static void unthrottle_cfs_rq(struct cfs_rq *cfs_rq)
>>        walk_tg_tree_from(cfs_rq->tg, tg_unthrottle_down, tg_nop,
>>                          (void *)&udd);
>>
>> -       if (!cfs_rq->load.weight)
>> +       if (!cfs_rq->h_nr_running)
>>                return;
>>
> 
> Why change here?

I've confused a bit - just curious if by any chance there is throttled
cfs_rq that have (load.weight, h_nr_running) = (0, >0).


>>        task_delta = cfs_rq->h_nr_running;
>> @@ -1843,10 +1843,9 @@ enqueue_task_fair(struct rq *rq, struct task_struct *p, int flags)
>>                cfs_rq->h_nr_running++;
>>
>>                /* end evaluation on throttled cfs_rq */
>> -               if (cfs_rq_throttled(cfs_rq)) {
>> -                       se = NULL;
> 
> Hmm..  yeah this is a casualty of moving the h_nr_running computations
> in-line as a part of the previous refactoring within the last
> releases.  This optimization (setting se = NULL to skip the second
> half) obviously won't work properly with detecting whether we made it
> to the end of the tree.
> 
(snip)
> 
> How about instead something like the following.  We can actually take
> advantage of the second loop always executing by deferring the
> accounting update on a throttle entity.  This keeps the control flow
> within dequeue_task_fair linear.
> 
> What do you think of (untested):
> 
> --- a/kernel/sched_fair.c
> +++ b/kernel/sched_fair.c
> @@ -1744,13 +1744,12 @@ enqueue_task_fair(struct rq *rq, struct
> task_struct *p, int flags)
>                         break;
>                 cfs_rq = cfs_rq_of(se);
>                 enqueue_entity(cfs_rq, se, flags);
> -               cfs_rq->h_nr_running++;
> 
> -               /* end evaluation on throttled cfs_rq */
> -               if (cfs_rq_throttled(cfs_rq)) {
> -                       se = NULL;
> +               /* note: ordering with throttle check to perform
> h_nr_running accounting on throttled entity below */
> +               if (cfs_rq_throttled(cfs_rq))
>                         break;
> -               }
> +
> +               cfs_rq->h_nr_running++;
>                 flags = ENQUEUE_WAKEUP;
>         }
> 
> @@ -1786,13 +1785,12 @@ static void dequeue_task_fair(struct rq *rq,
> struct task_struct *p, int flags)
>         for_each_sched_entity(se) {
>                 cfs_rq = cfs_rq_of(se);
>                 dequeue_entity(cfs_rq, se, flags);
> -               cfs_rq->h_nr_running--;
> 
> -               /* end evaluation on throttled cfs_rq */
> -               if (cfs_rq_throttled(cfs_rq)) {
> -                       se = NULL;
> +               /* note: ordering with throttle check to perform
> h_nr_running accounting on throttled entity below */
> +               if (cfs_rq_throttled(cfs_rq))
>                         break;
> -               }
> +
> +               cfs_rq->h_nr_running--;
>                 /* Don't dequeue parent if it has other entities besides

Looks good if it abides by the nature of scheduler codes ;-)


Thanks,
H.Seto

