Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754739Ab1BGT3e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 14:29:34 -0500
Received: from smtp-out.google.com ([216.239.44.51]:36584 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754737Ab1BGT3b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 14:29:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=RkzKlcWii+7jSam+/F8aNFgqfTqAMq7RhGZUHRkjPZ8THNuJJLYtxo74djHJ5HqoNH
         hCEDCNMreFJm1NhqZumw==
MIME-Version: 1.0
In-Reply-To: <1296650792.26581.319.camel@laptop>
References: <4d384700.2308e30a.70bc.ffffd532@mx.google.com>
 <1295534345.28776.175.camel@laptop> <1296646160.26581.315.camel@laptop>
 <20110202115012.GA16409@balbir.in.ibm.com> <1296650792.26581.319.camel@laptop>
From: Paul Menage <menage@google.com>
Date: Mon, 7 Feb 2011 11:29:08 -0800
Message-ID: <AANLkTi=+W-BXHFG94MeOnqV82HxtqtyDwEt1RCOUMrcq@mail.gmail.com>
Subject: Re: [PATCH 1/2] perf_events: add cgroup support (v8)
To: Peter Zijlstra <peterz@infradead.org>
Cc: balbir@linux.vnet.ibm.com, eranian@google.com,
        linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
        davem@davemloft.net, fweisbec@gmail.com, perfmon2-devel@lists.sf.net,
        eranian@gmail.com, robert.richter@amd.com, acme@redhat.com,
        lizf@cn.fujitsu.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 2, 2011 at 4:46 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, 2011-02-02 at 17:20 +0530, Balbir Singh wrote:
>> * Peter Zijlstra <peterz@infradead.org> [2011-02-02 12:29:20]:
>>
>> > On Thu, 2011-01-20 at 15:39 +0100, Peter Zijlstra wrote:
>> > > On Thu, 2011-01-20 at 15:30 +0200, Stephane Eranian wrote:
>> > > > @@ -4259,8 +4261,20 @@ void cgroup_exit(struct task_struct *tsk, int run_callbacks)
>> > > >
>> > > >         /* Reassign the task to the init_css_set. */
>> > > >         task_lock(tsk);
>> > > > +       /*
>> > > > +        * we mask interrupts to prevent:
>> > > > +        * - timer tick to cause event rotation which
>> > > > +        *   could schedule back in cgroup events after
>> > > > +        *   they were switched out by perf_cgroup_sched_out()
>> > > > +        *
>> > > > +        * - preemption which could schedule back in cgroup events
>> > > > +        */
>> > > > +       local_irq_save(flags);
>> > > > +       perf_cgroup_sched_out(tsk);
>> > > >         cg = tsk->cgroups;
>> > > >         tsk->cgroups = &init_css_set;
>> > > > +       perf_cgroup_sched_in(tsk);
>> > > > +       local_irq_restore(flags);
>> > > >         task_unlock(tsk);
>> > > >         if (cg)
>> > > >                 put_css_set_taskexit(cg);
>> > >
>> > > So you too need a callback on cgroup change there.. Li, Paul, any chance
>> > > we can fix this cgroup_subsys::exit callback? The scheduler code needs
>> > > to do funny thing because its in the wrong place as well.
>> >
>> > cgroup guys? Shall I just fix this exit thing since the only user seems
>> > to be the scheduler and now perf for both of which its unfortunate at
>> > best?
>>
>> Are you suggesting that the cgroup_exit on task_exit notification should be
>> pulled out?
>
>
> No, just fixed. The callback as it exists isn't useful and leads to
> hacks like the above.
>
>
>> > Balbir, memcontrol.c uses pre_destroy(), I pose that using this method
>> > is broken per definition since it makes the cgroup empty notification
>> > void.
>> >
>>
>> We use pre_destroy() to reclaim, so that delete/rmdir() will be able
>> to clean up the node/group. I am not sure what you mean by it makes
>> the empty notification void and why pre_destroy() is broken?
>
> A quick look at the code looked like it could return -EBUSY (and other
> errors), in that case the rmdir of the empty cgroup will fail.
>
> Therefore it can happen that after the last task is removed, and we get
> the notification that the cgroup is empty, and we attempt the rmdir we
> will fail.
>
> This again means that all such notification handlers must poll state,
> which is ridiculous.
>

Not necessarily - we could make it that a failed rmdir() sets a bit
that causes a notification again once the final refcount is dropped
again on the cgroup.

Paul
