Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755170Ab0JNJIT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 05:08:19 -0400
Received: from smtp-out.google.com ([216.239.44.51]:8290 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754125Ab0JNJIR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 05:08:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=SGmb1G2qf5ymJw1QedGjGJNfPV3Ub+21i9EeewLg6qpugc9fTZimTgUeF4xrcgjpFo
         cAwxI8QgUxLMwxvCDOjg==
MIME-Version: 1.0
In-Reply-To: <1287046650.29097.159.camel@twins>
References: <20101012074910.GA9893@in.ibm.com> <20101012075109.GC9893@in.ibm.com>
 <1287046650.29097.159.camel@twins>
From: Paul Turner <pjt@google.com>
Date: Thu, 14 Oct 2010 02:07:44 -0700
Message-ID: <AANLkTin5uZdurFzJzzcHiEc6jGAt8bn9v1B0rvkUV1SB@mail.gmail.com>
Subject: Re: [PATCH v3 2/7] sched: accumulate per-cfs_rq cpu usage
To: Peter Zijlstra <peterz@infradead.org>
Cc: bharata@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>,
        Herbert Poetzl <herbert@13thfloor.at>, Avi Kivity <avi@redhat.com>,
        Chris Friesen <cfriesen@nortel.com>, Paul Menage <menage@google.com>,
        Mike Waychison <mikew@google.com>, Nikhil Rao <ncrao@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 14, 2010 at 1:57 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, 2010-10-12 at 13:21 +0530, Bharata B Rao wrote:
>> +static u64 tg_request_cfs_quota(struct task_group *tg)
>> +{
>> +       struct cfs_bandwidth *cfs_b = tg_cfs_bandwidth(tg);
>> +       u64 delta = 0;
>> +
>> +       if (cfs_b->runtime > 0 || cfs_b->quota == RUNTIME_INF) {
>> +               raw_spin_lock(&cfs_b->lock);
>> +               /*
>> +                * it's possible a bandwidth update has changed the global
>> +                * pool.
>> +                */
>> +               if (cfs_b->quota == RUNTIME_INF)
>> +                       delta = sched_cfs_bandwidth_slice();
>> +               else {
>> +                       delta = min(cfs_b->runtime,
>> +                                       sched_cfs_bandwidth_slice());
>> +                       cfs_b->runtime -= delta;
>> +               }
>> +               raw_spin_unlock(&cfs_b->lock);
>> +       }
>> +       return delta;
>> +}
>
> Since you check cfs_b->quote outside of cfs_b->lock anyway, you might as
> well avoid taking the lock in that case and directly return slice.
>

Do you mean in the RUNTIME_INF case?

I suppose we could just avoid taking the lock there (theoretically it
would be possible to slightly over-commit on a RUNTIME_INF =>
constrained transition, but this should be the supremely uncommon case
and hey, it's transitioning from unlimited bandwidth anyway).

> Also, you possibly evaluate sched_cfs_bandwidth_slice() twice.
>

Separate branch no?  Should only be one evaluation.  (fwiw the min
macro looks to cache the evaluation)
