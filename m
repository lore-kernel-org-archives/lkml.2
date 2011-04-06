Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932189Ab1DFUpm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 16:45:42 -0400
Received: from smtp-out.google.com ([216.239.44.51]:15544 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049Ab1DFUpl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 16:45:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=NCIeODusomPAGrVoW2GfSQKQIFlMzFBZiA+AksUc/s6qpRFrTdfiGuejezDIWfZLg9
         mhQapZSmJhztbMSY6Q1g==
MIME-Version: 1.0
In-Reply-To: <1302010098.2225.1330.camel@twins>
References: <20110323030326.789836913@google.com> <20110323030448.950261975@google.com>
 <1302010098.2225.1330.camel@twins>
From: Paul Turner <pjt@google.com>
Date: Wed, 6 Apr 2011 13:44:55 -0700
Message-ID: <BANLkTimdxo2_44vfmG0kYNk_gn-_MBFUAw@mail.gmail.com>
Subject: Re: [patch 03/15] sched: accumulate per-cfs_rq cpu usage
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>,
        Nikhil Rao <ncrao@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 5, 2011 at 6:28 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Tue, 2011-03-22 at 20:03 -0700, Paul Turner wrote:
>> +static void request_cfs_rq_quota(struct cfs_rq *cfs_rq)
>> +{
>> +       struct task_group *tg = cfs_rq->tg;
>> +       struct cfs_bandwidth *cfs_b = tg_cfs_bandwidth(tg);
>> +       u64 amount = 0, min_amount;
>> +
>> +       min_amount = sched_cfs_bandwidth_slice() + (-cfs_rq->quota_remaining);
>> +
>> +       if (cfs_b->runtime > 0 || cfs_b->quota == RUNTIME_INF) {
>> +               raw_spin_lock(&cfs_b->lock);
>> +               if (cfs_b->quota != RUNTIME_INF) {
>> +                       amount = min(cfs_b->runtime, min_amount);
>> +                       cfs_b->runtime -= amount;
>> +               } else {
>> +                       amount = min_amount;
>> +               }
>
> So why would quota be RUNTIME_INF and quota_enabled be true? If its due
> to a race when fiddling with the cgroup filesystem setting things up
> that else branch wants a comment, if its for another reason all together
> there's also a comment missing somewhere ;-)
>

It's the first -- it's possible for global quota to transition between
infinite/finite states, but since we own the lock we may not yet have
seen our cfs_rq->quota_enabled update yet.  In this case we don't want
to perturb the global state /out/ of RUNTIME_INF (by subtracting from
it).

While making this more readable the speculative check can also be
dropped since that only ever benefits us a single time when we're out
of quota (as the next operation in that case is to throttle).

Cleaning..


>> +               raw_spin_unlock(&cfs_b->lock);
>> +       }
>> +
>> +       cfs_rq->quota_remaining += amount;
>> +}
>> +
>> +static void account_cfs_rq_quota(struct cfs_rq *cfs_rq,
>> +               unsigned long delta_exec)
>> +{
>> +       if (!cfs_rq->quota_enabled)
>> +               return;
>> +
>> +       cfs_rq->quota_remaining -= delta_exec;
>> +
>> +       if (cfs_rq->quota_remaining > 0)
>> +               return;
>> +
>> +       request_cfs_rq_quota(cfs_rq);
>> +}
>
