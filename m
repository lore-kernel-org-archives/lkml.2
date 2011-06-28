Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756451Ab1F1EjM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 00:39:12 -0400
Received: from smtp-out.google.com ([74.125.121.67]:30903 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756373Ab1F1Eir convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 00:38:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=vS5Y3FtiZ0d1nPJ7tPEyCAcJqVEX3zL4+9ypyqHjBlczBsCYyAQk8/coxK1uyWTra+
         CmbVoQtb+dhG9z20D+fQ==
MIME-Version: 1.0
In-Reply-To: <1308829759.1022.109.camel@twins>
References: <20110621071649.862846205@google.com> <20110621071700.879990875@google.com>
 <1308829759.1022.109.camel@twins>
From: Paul Turner <pjt@google.com>
Date: Mon, 27 Jun 2011 21:38:13 -0700
Message-ID: <CAPM31R+x-kABaHp6G-Q2rG2SkjAn4FFa1nBwHhwAOhdV+CNjnQ@mail.gmail.com>
Subject: Re: [patch 12/16] sched: prevent interactions with throttled entities
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 23, 2011 at 4:49 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Tue, 2011-06-21 at 00:17 -0700, Paul Turner wrote:
>> @@ -2635,8 +2704,10 @@ static int update_shares_cpu(struct task
>>
>>         raw_spin_lock_irqsave(&rq->lock, flags);
>>
>> -       update_rq_clock(rq);
>> -       update_cfs_load(cfs_rq, 1);
>> +       if (!throttled_hierarchy(cfs_rq)) {
>> +               update_rq_clock(rq);
>> +               update_cfs_load(cfs_rq, 1);
>> +       }
>>
>>         /*
>
> OK, so we can't contribute to load since we're throttled, but
> tg->load_weight might have changed meanwhile?
>

What's why we continue to update their shares (also at
enqueue/dequeue) but not their load, so that the weight will be
correct when unthrottling*

> Also, update_cfs_shares()->reweight_entity() can dequeue/enqueue the
> entity, doesn't that require an up-to-date rq->clock?
>

It shouldn't, we're only doing an account_enqueue/dequeue, and there
shouldn't be a cfs_rq->curr to lead to updates (on a throttled
entity).  I suppose we might do something interesting in the case of a
race with alb forcing something throttled to run intersecting with
update_shares()**.

The original concern here was [*] above, keeping shares current for
the unthrottle.  *However*, with the hierarchal throttle accounting in
the current version, I think this can be improved.

Instead, we should skip update_shares/update_cfs_shares for all
throttled entities and simply do a final update shares when
throttle_count goes to 0 in tg_throttle_down (which also avoids **).
I thought of doing this at the end of preparing the last patchset but
by that time it was tested and I didn't want to change things around
here at the last minute.

Will fix for this week.


>
>
