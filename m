Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753445Ab1HHQQf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 12:16:35 -0400
Received: from smtp-out.google.com ([216.239.44.51]:11752 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752786Ab1HHQQe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 12:16:34 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=AxfMVsYFpP35zwW8AerPaOlueWM91zxmGFR0CYVK8I+8DsXb3u9hz2ODJqsi/g4qA
	w1t9tuPpMRjJvYem2BziA==
MIME-Version: 1.0
In-Reply-To: <1312819228.22367.0.camel@twins>
References: <20110721164325.231521704@google.com> <20110721184757.480608533@google.com>
 <CAF1ivSYuYjNXsfCfUj6+rRVQFc1m2EBP3dvtxoo8wJM_EWNtZQ@mail.gmail.com> <1312819228.22367.0.camel@twins>
From: Paul Turner <pjt@google.com>
Date: Mon, 8 Aug 2011 09:16:00 -0700
Message-ID: <CAPM31RKSiBBNeSTg=Uj+6YiknVs1YfJoVNj1PakpzFkvookWsg@mail.gmail.com>
Subject: Re: [patch 08/18] sched: add support for throttling group entities
To: Lin Ming <minggr@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <bsingharora@gmail.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>,
        Jason Baron <jbaron@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 8, 2011 at 9:00 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Mon, 2011-08-08 at 23:46 +0800, Lin Ming wrote:
>> On Fri, Jul 22, 2011 at 12:43 AM, Paul Turner <pjt@google.com> wrote:
>>
>> > +static __used void throttle_cfs_rq(struct cfs_rq *cfs_rq)
>> > +{
>> > +       struct rq *rq = rq_of(cfs_rq);
>> > +       struct cfs_bandwidth *cfs_b = tg_cfs_bandwidth(cfs_rq->tg);
>> > +       struct sched_entity *se;
>> > +       long task_delta, dequeue = 1;
>> > +
>> > +       se = cfs_rq->tg->se[cpu_of(rq_of(cfs_rq))];
>> > +
>> > +       /* account load preceding throttle */
>> > +       update_cfs_load(cfs_rq, 0);
>> > +
>> > +       task_delta = cfs_rq->h_nr_running;
>> > +       for_each_sched_entity(se) {
>> > +               struct cfs_rq *qcfs_rq = cfs_rq_of(se);
>> > +               /* throttled entity or throttle-on-deactivate */
>> > +               if (!se->on_rq)
>> > +                       break;
>>
>> Does it mean it's possible that child se is unthrottled but parent se
>> is throttled?
>
> Yep..
>
>> I thought if parent group was throttled then its children should be
>> throttled too.
>> I may misunderstood the code, please correct me then.
>
> That would be costly, as throttling a parent would require throttling
> all its children (of which there can be arbitrary many).
>

In case it is not clear, the children of a throttled entity can not be
scheduled, they are implicitly throttled by virtue of their
parent/ancestor having reached its bandwidth limit (and being
throttled).

Consider the hierarchy below:
  A
 /  \
D  B
      \
       C

If A and B both have bandwidth limits then B being on_rq depends on:

1. A being within its bandwidth limit, otherwise the entire hierarchy
would be dequeued
2. B being within its bandwidth limit, otherwise the hierarchy B-C
would be dequeued

B's throttle state is independent of whether A has reached its limit;
however it will not be runnable while A is throttled.

The per-cfs_rq throttle_count may be more directly in-line with what
your interpretation of "throttled"; it maintains explicit tracking of
whether or not an entity is throttled (including via its parent).

- Paul
