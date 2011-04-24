Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757773Ab1DXVYN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Apr 2011 17:24:13 -0400
Received: from smtp-out.google.com ([216.239.44.51]:55193 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756686Ab1DXVYL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Apr 2011 17:24:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=ZhoLwnPRh7kfoGbye22Ip2XYkpg0y1X5iy40kOKwgcKYNB0a4cVqKcKokCSFVQ1i0C
         6JS0de8lKIHnraFcWsfA==
MIME-Version: 1.0
In-Reply-To: <4DB0ECEC.7090608@jp.fujitsu.com>
References: <20110323030326.789836913@google.com> <20110323030449.828962245@google.com>
 <4DB0ECEC.7090608@jp.fujitsu.com>
From: Paul Turner <pjt@google.com>
Date: Sun, 24 Apr 2011 14:23:38 -0700
Message-ID: <BANLkTim0FZBFGzWCEWoGpCks5Yr-qFL9vw@mail.gmail.com>
Subject: Re: [patch 12/15] sched: maintain throttled rqs as a list
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 21, 2011 at 7:50 PM, Hidetoshi Seto
<seto.hidetoshi@jp.fujitsu.com> wrote:
> Hi Paul,
>
> (2011/03/23 12:03), Paul Turner wrote:
>> @@ -1434,7 +1435,11 @@ static void throttle_cfs_rq(struct cfs_r
>>       if (!se)
>>               rq->nr_running += task_delta;
>>
>> +     raw_spin_lock(&cfs_b->lock);
>>       cfs_rq->throttled = 1;
>> +     list_add_tail_rcu(&cfs_rq->throttled_list, &cfs_b->throttled_cfs_rq);
>> +     raw_spin_unlock(&cfs_b->lock);
>> +
>>       cfs_rq->throttled_timestamp = rq_of(cfs_rq)->clock;
>>  }
>>
>
> Though I'm looking forward to see your updates soon, just FYI,
> I found that somehow throttle_cfs_rq() was called with already
> throttled cfs_rq.
>
> So it breaks list throttled_cfs_rq by repeating list_add_tail_rcu()
> and results in lockups like that Bharata and Xiao already reported.
>
> There should be better fix, but following first aid to put_prev_entity()
> worked for me:
>
> -       if (!within_bandwidth(cfs_rq))
> +       if (!within_bandwidth(cfs_rq) && !cfs_rq->throttled)
>                throttle_cfs_rq(cfs_rq);
>        else
>                return_cfs_rq_quota(cfs_rq);
>
> I believe you can do better next time.
>

Aha!

Good catch -- Thanks Hidetoshi!  I've been looking for that one.

I'm figuring out exactly how this came about and I will repost.

Thanks!

>
> Thanks,
> H.Seto
>
>
