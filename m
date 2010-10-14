Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755145Ab0JNJPc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 05:15:32 -0400
Received: from smtp-out.google.com ([74.125.121.35]:7244 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753833Ab0JNJPa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 05:15:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=JVPYp3PmyR/a7ZGks3Yk7N+GS622SaR6u9KMsm5X6ukwplnzFfR5wbVE5P0FU3L89v
         ErKOnxQFpJMB0SwBEorQ==
MIME-Version: 1.0
In-Reply-To: <1287046900.29097.161.camel@twins>
References: <20101012074910.GA9893@in.ibm.com> <20101012075109.GC9893@in.ibm.com>
 <1287046900.29097.161.camel@twins>
From: Paul Turner <pjt@google.com>
Date: Thu, 14 Oct 2010 02:14:56 -0700
Message-ID: <AANLkTimj5Ft6ft8u5NxZmT4MAMai24Ke7LeZ0QaucQmM@mail.gmail.com>
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

On Thu, Oct 14, 2010 at 2:01 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, 2010-10-12 at 13:21 +0530, Bharata B Rao wrote:
>> +static void account_cfs_rq_quota(struct cfs_rq *cfs_rq,
>> +               unsigned long delta_exec)
>> +{
>> +       if (cfs_rq->quota_assigned == RUNTIME_INF)
>> +               return;
>> +
>> +       cfs_rq->quota_used += delta_exec;
>> +
>> +       if (cfs_rq->quota_used < cfs_rq->quota_assigned)
>> +               return;
>> +
>> +       cfs_rq->quota_assigned += tg_request_cfs_quota(cfs_rq->tg);
>> +}
>
> That looks iffy, quota_assigned is only ever incremented and can wrap.

This can't advance at a rate faster than ~vruntime and we can't handle
wrapping there anyway (fortunately it would take something like 35k
years?)

> Why not subtract delta_exec and replenish when <0? That keeps the
> numbers small.
>

Accounting in the opposite direction allows us to catch-up in
subsequent periods when a task exceeds its bandwidth across an
interval where we are not able to immediately throttle it (e.g. costly
syscall without config_prempt).  Since we'll continue to accrue the
execution time in this case it will be effectively pre-charged against
the next slice received.
